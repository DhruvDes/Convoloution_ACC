# 04 — Design Efficiency

This IP was built around three linked efficiency decisions: eliminate redundant memory traffic via pixel reuse, pipeline the DSP path so every cycle produces a useful multiply, and decouple the variable-rate AXI-Stream interface from the fixed-rate compute core with FIFOs. Together these turn the theoretical peak (one output pixel per clock at 125 MHz) into the measured steady-state throughput reported in `06_results.md`.

## 1. Data reuse via a 4-lane line buffer

### The problem with the naive approach

A 3×3 convolution needs 9 input pixels per output pixel. The naive "fetch per window" approach would require the PL to read 9 pixels from DDR per output — but each pixel in the image is actually used by **nine different output windows** (except near the edges). Without reuse, the DMA bandwidth requirement would be `9 · W · H` pixels per frame instead of `W · H`.

### What the line buffer actually does

`lineBuffer.sv` keeps **four rows of the frame on-chip** in an array of flip-flops, arranged as 4 lanes × 64 pixels × 8 bits = 2048 FFs. At any instant:

- Three lanes hold the three rows currently feeding the sliding 3×3 window.
- The fourth lane is being filled in parallel with the row that will become the new "row 2" after the next `row_done`.

A `base_lane` counter rotates modulo 4 on every completed row, which **renames** which physical lane is logically row 0, 1, or 2 — no data is ever copied. This is the standard "circular line-buffer" idiom but with one extra lane so that reading and writing never contend for the same storage in the same cycle.

**Bandwidth impact.** Each input pixel enters the PL exactly once. The per-frame DMA volume is `H · W` bytes (plus 16 bytes of header), independent of kernel size. For `H = W = 28`, that is 784 bytes in and ~676 bytes out per frame — well inside a single DMA descriptor and low enough that DMA setup, not transfer time, dominates per-frame overhead.

**Window access.** The nine `p00..p22` outputs of the line buffer are purely combinational reads from the three currently-addressed lanes at `col_idx`, `col_idx+1`, `col_idx+2`. Walking the window across the row is a single-cycle increment of `col_idx`; walking to the next row is a one-cycle `row_done` pulse that rotates `base_lane`. No data movement, no addressing arithmetic beyond a 6-bit counter.

## 2. Write-side bandwidth matching

The line buffer's write port accepts **32-bit words (four pixels) per cycle**, while the read port emits **one pixel per cycle**. This asymmetry is deliberate: it gives the fill logic three cycles of slack for every word it consumes, which matters because the input FIFO sits behind a 1-cycle BRAM read latency. Without the 4:1 fill ratio, any bubble in the DMA stream would stall the MAC; with it, the line buffer stays ahead of the MAC even under sustained back-to-back operation.

When a lane fills (`next_wr_ptr >= row_width`), the write pointer resets and `wr_lane` advances. Once three lanes are full, `buf_ready` asserts and the MAC is allowed to start consuming windows — this is the one-time fill cost at the start of a frame, amortized over `(H − 2) · (W − 2)` output pixels.

## 3. Parallel MAC with a pipelined adder tree

`mac_truncate.sv` is where the compute happens, and it is structured for Vivado's DSP48E1 inference:

- **9 parallel multipliers**, marked with `(* use_dsp = "yes" *)` so the synthesizer maps them to DSP slices rather than LUT-based multipliers. Each multiplier consumes one DSP48E1.
- **3-stage register tree** around the DSPs:
  1. **Input registers** — the 9 pixels and 9 kernel coefficients are latched from the line buffer and `cf_mem` combinational outputs. This breaks the path from BRAM/LUTRAM-resident lane memory into the DSP A/B inputs.
  2. **Product register** — each of the 9 signed 18-bit products is registered in the DSP output register. This is the critical path "cut" that lets the design close 125 MHz.
  3. **Partial-sum register** — the 9 products are split into two groups (4 + 5) and summed into two signed 21-bit partial sums. Splitting the adder tree avoids a 9-input adder on a single cycle; balancing the split as 4+5 rather than 3+3+3 trades one adder stage for a shallower tree.
- **Final combinational add + saturating register** — the two partial sums are combined combinationally into the 22-bit accumulator, then tested against `[0, 255]` and the result is registered.

### Why a shallow pipeline was enough for 125 MHz

An 8 ns period is aggressive for a 9-way signed multiply-add feeding a saturating output. The reason this closes without more pipeline stages is that the DSP48E1 provides the P-register for free (stage 2 above uses it), and the 4+5 partial-sum split means no single adder on the post-DSP path sees more than five 18-bit operands. If the target had been 150 MHz or above, a fourth pipeline stage between the partial-sum register and the saturating comparator would likely have been necessary.

### Matching valid to latency

A naive approach would make `valid_out` combinational from `valid_in`, which is wrong: the result is not meaningful for 4 cycles. Instead, `valid_in` is pushed through a 4-stage shift register (`valid_s1..valid_s4`) that is exactly the same depth as the data pipeline, and `valid_out = valid_s4`. This guarantees `result` and `valid_out` are asserted on the same cycle, which is what the downstream packer relies on.

### Why this is one-pixel-per-clock

Because every pipeline stage is register-to-register, a new 3×3 window can be presented at the MAC's inputs every cycle. As long as the line buffer and control logic can supply a valid window every cycle (which they can, once `buf_ready` is high), the MAC produces a valid result every cycle after the 4-cycle fill. No stalls, no multi-cycle paths.

## 4. FIFO decoupling of variable and fixed rates

The AXI-Stream DMA rate is variable — it depends on DDR contention, AXI interconnect arbitration, and the PS's own activity. The compute core, in contrast, must run at a fixed 1 pixel/clock or throw away pipeline efficiency. Connecting them directly would either require the MAC to stall (losing throughput) or buffer arbitrary amounts of pixel data inside the compute path (expensive).

The BUI solves this with two FIFOs:

- **Input FIFO** — 512 words deep, with `almost_full` set at 8 words of remaining capacity. Almost-full (not full) is used for `s00_axis_tready` de-assertion so the AXI-Stream can finish any in-flight transfer cleanly.
- **Result FIFO** — 256 words deep, back-pressures the byte packer when the PS-side DMA is slow.

For the 28×28 benchmark frames (784 input bytes = 196 words, 676 output bytes = 169 words) both FIFOs can hold an entire frame, which is why the IP never stalls on DMA during a typical MNIST-scale frame. Larger frames rely on the FIFOs to absorb short-term rate mismatches while the steady-state rate is still matched.

## 5. On-stream configuration instead of AXI-Lite

Sending kernel coefficients and frame dimensions as the first four AXI-Stream words — rather than using a separate AXI-Lite control port — is an efficiency decision for the **per-frame overhead**, not the steady-state throughput. An AXI-Lite-based design would require at least four `write_register` calls per frame from Python, each crossing the PS–PL boundary synchronously. For a 20,000-image benchmark that is 80,000 extra synchronous register writes; at hundreds of nanoseconds each, this is a significant fraction of the total runtime.

With on-stream config, the PS writes the four words directly into the DMA buffer in memory and issues a single `sendchannel.transfer()`. The measured effect of this decision is in the benchmark's Test B line: the per-frame overhead is consistent across image sizes, indicating per-frame fixed cost is dominated by DMA descriptor setup and not by configuration plumbing.

## 6. One-hot FSM encoding

`convAcc.sv` is marked `(* fsm_encoding = "one_hot" *)`. For a 4-state FSM this costs more flip-flops than binary encoding, but the next-state logic collapses to a small set of AND gates on state bits, which was the cleanest way to keep the state-machine logic off the critical path once everything else had been tightened.

## 7. Throughput/resource summary

| Efficiency choice | Cost | Benefit |
|---|---|---|
| 4-lane line buffer | 2048 FFs | Input bandwidth cut by ~9×; no stalls during row transitions |
| DSP inference (`use_dsp = "yes"`) | 9 DSP slices | 9 multiplies per cycle; no LUT-based multipliers on the critical path |
| 4-stage MAC pipeline | 4 cycles of startup latency per frame | 1 pixel/clock steady-state throughput; 125 MHz timing closure |
| Input FIFO 512 × 33 | 1 BRAM tile | Decouples DMA variability from compute; absorbs whole MNIST frame |
| On-stream config | 4 header words per frame | Eliminates ~80,000 AXI-Lite writes over a 20k-frame benchmark |
| One-hot FSM | ~4 extra FFs | Next-state logic off the critical path |

The effect of all of these together is visible in `06_results.md`: 7.2× speedup over `scipy.signal.convolve2d` on the Arm Cortex-A9 for 16-wide and height greater than 30, images (where DMA overhead is most exposed), and 26.6× speedup for 60-wide images (where steady-state compute dominates).

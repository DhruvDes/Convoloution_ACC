# 03 — Architecture

## Block Diagram

<!-- ```
              AXI-Stream (32b + TLAST)
PS (DMA MM2S) ────────────────────────────┐
                                          ▼
                           ┌──────────────────────────────┐
                           │     busInterfaceUnit (BUI)   │
                           │  ┌────────────────────────┐  │
                           │  │   axis_fifo_s (512x33) │  │  input FIFO
                           │  └─────────────┬──────────┘  │
                           │                │             │
                           │       ┌────────┴────────┐    │
                           │       │ cfg/pixel demux │    │  (first 4 words → cfg)
                           │       └───┬─────────┬───┘    │
                           │           │         │        │
                           └───────────┼─────────┼────────┘
                          cfg_valid/   │         │   M_PX_TDATA/TVALID
                          cfg_data     ▼         ▼
                                ┌─────────────┐  ┌──────────────┐
                                │   cf_mem    │  │ line_buffer  │
                                │ (row_size,  │  │   4 lanes    │
                                │  no_rows,   │  │ × 64 × 8 bit │
                                │  K(0..2))   │  │   (BRAM/LUTRAM)│
                                └──────┬──────┘  └──────┬───────┘
                                       │                │ 3×3 window (comb.)
                                       │ 9 × K_ij        ▼ 9 × pixel
                                       └─────►┌──────────────────┐
                                              │   mac_truncate   │
                                              │  9 mul, adder    │
                                              │  tree, saturate  │
                                              │   (4-stage pipe) │
                                              └────────┬─────────┘
                                          control_logic│ 8b result + valid_out
                                         (rowsdoneCount,│
                                          col_idx,     ▼
                                          FSM)     ┌──────────────┐
                                                   │ 4:1 byte pack│
                                                   │ (32b + TLAST)│
                                                   └──────┬───────┘
                                                          ▼
                           ┌──────────────────────────────┴──┐
                           │  BUI axis_fifo_m (256×33 out)   │
                           └──────────────┬──────────────────┘
                                          ▼
                              AXI-Stream (32b + TLAST)
                                 → PS (DMA S2MM)
``` -->
![Alt text](https://github.com/DhruvDes/Convoloution_ACC/blob/main/docs/images/arch/top_block_diagram.png)

Block diagram source: `https://github.com/DhruvDes/Convoloution_ACC/blob/main/docs/images/arch/top_block_diagram.png`.

## Partitioning Rationale

The design is partitioned by **data rate and clock boundary**, not by function alone:

- Everything that touches the AXI-Stream DMA interface and handles variable-rate traffic sits in the **BUI** with FIFOs as the decoupling layer.
- Everything that runs at a fixed one-pixel-per-clock rate (once primed) sits in the **compute core**: `line_buffer → mac_truncate → packer`.
- **`cf_mem`** is a tiny per-frame parameter register, deliberately separated from the BUI so the compute core never has to decode headers.

This keeps the BUI's FIFO backpressure logic away from the DSP timing path, which is where `Fmax` gets limited.

## Module Descriptions

### `convAcc.sv` — top level and control FSM

- Instantiates all submodules and owns the inter-module wiring.
- Implements a 4-state frame FSM: `Cleanup → Idle → Operational → preCleanup → Cleanup`.
- Generates `softReset` between frames so the BUI FIFOs survive but the per-frame counters do not.
- Drives `mainToLbIdx` (column index into the line buffer) and `mainToLbRowDone` (row-boundary pulse) that together walk the 3×3 window across the stored rows.
- Hosts the output byte packer: four 8-bit MAC results are shifted into a 32-bit register; on the 4th valid result a word is emitted; at frame end (`preCleanup`, `preCleanupCnt == 3`) a partial word is padded with zeros and emitted with `TLAST` signal to the BUI indicating its the last of the frame.

### `busInterfaceUnit.sv` (BUI) — AXI-Stream plumbing

- Wraps one **input FIFO** (`axis_fifo_s`, 512×33) and one **result FIFO** (`axis_fifo_m`, 256×33).
- Contains the **config/pixel demultiplexer**: a `txn_cnt` counts the first `CFG_PKTS = 4` reads and routes them to `cf_mem`, after which all remaining reads are routed to the line buffer.
- Handles the 1-cycle BRAM read latency of the input FIFO with an `rd_pending` shadow register so `M_PX_TVALID` can rise one cycle earlier than the trivial two-stage pipeline would allow.
- Emits a single-cycle `frame_start` pulse the cycle the first pixel appears on `M_PX_*`, which kicks the line buffer into `LDARR`.
- Applies `stop_input` (from `tlast_received`) to stall writes into the input FIFO after the last pixel of a frame, so the BUI cannot swallow the next frame's header before the current one finishes. This allows the DMA to do back to back transfers from its point of view but the design correctly accepts one frame per computation. 

### `cf_mem.sv` — configuration register file

- 4 × 32-bit memory, written sequentially by the first 4 words of each frame.
- Decodes `row_size`, `no_of_rows`, and the nine 9-bit signed kernel coefficients as combinational outputs.
- Raises `valid` on the 4th write so the control FSM knows configuration is complete.

### `lineBuffer.sv` — sliding-window memory

- **4 lanes × 64 pixels × 8 bits**, implemented as flip-flops for single-cycle random access from all three read rows simultaneously. Three of the four lanes at any moment hold the three rows feeding the 3×3 window; the fourth is being filled with the next row (this is the "prefetch" lane).
- `base_lane` rotates modulo 4 once per row (`row_done`), which renames which physical lane is logically "row 0/1/2/3" — no data is copied.
- The write lane is always `(base_lane + 3) mod 4`, the lane not currently being read.
- Write port accepts 32-bit words (4 pixels) from the BUI and writes them at `wr_ptr`, `wr_ptr+1`, `wr_ptr+2`, `wr_ptr+3` in one clock — matching the 4-pixels-per-clock fill rate to the 1-pixel-per-clock read rate gives the MAC 3 cycles of headroom per fetched word.
- `buf_ready` asserts once 3 lanes have been filled; from that point the 3×3 window is meaningful and the MAC can be clocked.
- 3×3 window outputs (`p00..p22`) are purely combinational on `col_idx` and `base_lane`, so walking the window is a single-cycle address change.

### `mac_truncate.sv` — MAC core

- 9 parallel multipliers, mapped to DSP48E1 slices (`(* use_dsp = "yes" *)`).
- Registered in 4 pipeline stages:
  1. **Input registers** — pixels and kernel coefficients latched on `valid_in`.
  2. **Product register** — 9 signed 18-bit products.
  3. **Partial-sum register** — two signed 21-bit sums (4+5 split adder tree) balanced for timing.
  4. **Saturating output register** — accumulator is tested against `[0, 255]` and the 8-bit result is latched.
- `valid_in` is propagated through a matching 4-stage valid-pipeline so `valid_out` is asserted exactly on the cycle `result` is valid.

### `axis_fifo_s.sv` / `axis_fifo_m.sv` — FIFOs

- Shared ring-buffer design parameterized on depth and almost-full threshold.
- Input FIFO uses `almost_full` to decouple the PS-side DMA from line-buffer stalls; output FIFO uses `full` to back-pressure the MAC's byte-packer when the PS-side DMA is slow to drain.

## Pipeline Latency

Total latency from the first valid pixel entering `line_buffer` to the first valid result word leaving the result FIFO (ignoring FIFO queueing, assuming `row_size = W`):

- Line-buffer fill (3 rows): `3 · ceil(W/4)` cycles
- MAC pipeline: 4 cycles
- Packer: 4 cycles (first word requires 4 accepted MAC results)
- Result FIFO: 1 cycle

Steady-state throughput is **1 output pixel per cycle**. At the post-implementation 125 MHz clock this corresponds to a theoretical peak of 125 megapixels per second, which matches the measured performance reported in `06_results.md`.

### Transaction Example

![Alt text](https://github.com/DhruvDes/Convoloution_ACC/blob/main/docs/images/sim/waveform_axi_handshake.png)

here is an example of a `width` = 36 and `height` = 24 image. where the transaction is started at `45ns` and first valid output is at `644ns` followed by `6596ns` when Tlast is asserted ending the frame. Totalling `6551ns` for this transfer.
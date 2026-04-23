# 02 — Interfaces

The IP presents two AXI4-Stream interfaces to the rest of the system: one slave for the inbound configuration + pixel stream, and one master for the outbound result stream. There is no AXI-Lite control port — configuration is sent as the first four words of each frame on the same AXI-Stream channel as the pixels. This keeps the PS-side driver simple (one DMA send, one DMA receive) and eliminates cross-clock AXI-Lite stalls in the inner benchmark loop.

## Top-Level Port List (`convAcc.sv`)

| Port | Direction | Width | Description |
|---|---|---|---|
| `axis_aclk` | in | 1 | AXI-Stream clock (**125 MHz** in the current build). |
| `axis_aresetn` | in | 1 | Active-low synchronous reset. |
| `s00_axis_tdata` | in | 32 | Slave stream data — config words or 4 packed pixels. |
| `s00_axis_tvalid` | in | 1 | Slave stream valid. |
| `s00_axis_tlast` | in | 1 | End-of-frame marker. Must be asserted on the final pixel word. |
| `s00_axis_tready` | out | 1 | Backpressure — deasserted when the input FIFO is almost full. |
| `m00_axis_tdata` | out | 32 | Master stream data — 4 packed output pixels per word. |
| `m00_axis_tvalid` | out | 1 | Master stream valid. |
| `m00_axis_tlast` | out | 1 | Asserted on the last result word of the frame. |
| `m00_axis_tready` | in | 1 | Downstream backpressure from the S2MM DMA. |

Handshake follows the AXI4-Stream rules: transfer occurs on the rising edge when both `TVALID` and `TREADY` are high. `TVALID` never depends combinationally on `TREADY`.

## Inbound Frame Format (Slave — PS → IP)

Every frame is four header words followed by `ceil(H·W / 4)` pixel words. Fields are listed LSB-first.

### Word 0 — Frame dimensions

| Bits | Field | Notes |
|---|---|---|
| `[5:0]` | `row_size` | Image width `W`, 1–63 pixels. |
| `[15:6]` | `no_of_rows` | Image height `H`, 1–1023 pixels. |
| `[31:16]` | reserved | Write as 0. |

### Words 1–3 — Kernel coefficients

Each word carries one row of the 3×3 kernel as three 9-bit signed values:

| Word | `[8:0]` | `[17:9]` | `[26:18]` | `[31:27]` |
|---|---|---|---|---|
| 1 | `K(0,0)` | `K(0,1)` | `K(0,2)` | reserved |
| 2 | `K(1,0)` | `K(1,1)` | `K(1,2)` | reserved |
| 3 | `K(2,0)` | `K(2,1)` | `K(2,2)` | reserved |

Coefficients are two's-complement 9-bit signed integers in the range `[−256, +255]`. Any value outside that range is silently truncated — the PS-side driver (`_to_s9` in the PYNQ notebook) clamps before packing.

### Words 4 .. N — Pixel payload

Pixels are packed four-per-word, LSB-first:

| Bits | Pixel |
|---|---|
| `[7:0]`   | pixel `k`     |
| `[15:8]`  | pixel `k+1`   |
| `[23:16]` | pixel `k+2`   |
| `[31:24]` | pixel `k+3`   |

Row-major order. The PS pads the final word with zero bytes if `H·W` is not a multiple of four. `TLAST` is asserted on the final pixel word.

## Outbound Frame Format (Master — IP → PS)

Result pixels are packed identically to the input: four 8-bit pixels per 32-bit word, row-major, valid-mode output dimensions `(H − 2) × (W − 2)`. The final word is zero-padded if the output pixel count is not a multiple of four, and `TLAST` is asserted on that word. The PS-side driver strips the padding when reshaping the result.

## Internal Handshakes (for reference)

Within the IP, the same valid/ready discipline is used at every module boundary:

| Producer → Consumer | Data | Notes |
|---|---|---|
| DMA MM2S → `busInterfaceUnit` input FIFO | 32-bit + `TLAST` | AXI-Stream slave. Input FIFO is 512 deep with an almost-full threshold of 8. |
| `busInterfaceUnit` → `cf_mem` | 32-bit config word | `cfg_valid` / `cfg_ready`. First 4 words of every frame are routed here. |
| `busInterfaceUnit` → `line_buffer` | 32-bit pixel word + `TLAST` | AXI-Stream-style `M_PX_TVALID` / `M_PX_TREADY`. |
| `line_buffer` → `mac_truncate` | 9 × 8-bit pixel window | Combinational window output, qualified by `buf_ready` + `pullMacValidLow`. |
| `mac_truncate` → result packer | 8-bit result + `valid_out` | 4-cycle pipeline latency. |
| Result packer → `busInterfaceUnit` result FIFO | 32-bit + `TLAST` | Packs 4 output bytes per word, flushes partial word at frame end. |
| `busInterfaceUnit` result FIFO → DMA S2MM | 32-bit + `TLAST` | AXI-Stream master, 256-word result FIFO. |

## Reset Behaviour

There are two reset domains:

- **Hard reset** (`axis_aresetn = 0`): clears the top-level FSM, empties FIFOs, and returns the IP to `Cleanup`. Required once at power-on.
- **Soft reset** (`softReset`, internal): asserted by the top-level FSM between frames to clear per-frame state (config counter, row counters, write pointer, pixel packer) without touching the AXI-Stream FIFO interfaces. This is what allows the PS to send 20,000 frames back-to-back without PL-side intervention.

## PS-Side Software Contract

The minimal PYNQ driver flow per frame (as used in the benchmark notebook) is:

```python
send_buf[0] = (no_of_rows << 6) | row_size          # word 0
send_buf[1] = pack_row(k[0])                        # word 1
send_buf[2] = pack_row(k[1])                        # word 2
send_buf[3] = pack_row(k[2])                        # word 3
send_buf.view(np.uint8)[16:16 + H*W] = image        # pixel payload
dma.sendchannel.transfer(send_buf[:4 + (H*W + 3)//4])
dma.recvchannel.transfer(recv_buf[:((H-2)*(W-2) + 3)//4])
dma.sendchannel.wait()
dma.recvchannel.wait()
result = recv_buf.view(np.uint8)[:(H-2)*(W-2)].reshape(H-2, W-2)
```

The `sendchannel.transfer` call carries everything the IP needs — dimensions, kernel, and pixels — in a single DMA descriptor, which is why the measured per-frame overhead is dominated by DMA setup rather than AXI-Lite register writes.

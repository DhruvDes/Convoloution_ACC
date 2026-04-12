# Convolution Accelerator — RTL Design Specification

**Version:** 1.0  
**Bus standard:** AXI4-Stream, 32-bit data, `TLAST` only (no `TKEEP`, no `TUSER`, no `TSTRB`)  
**Target:** FPGA (Xilinx/AMD), single clock domain  
**Compute cores:** 4 parallel MAC units  
**Line buffer width:** 64 pixels (fixed), register-based (no BRAM)  
**Kernel:** 3×3, 9-bit signed coefficients  

---

## 1. System Overview

The accelerator receives image data and configuration over a single AXI-S slave port from an AXI DMA MM2S channel. The first **4 AXI-S packets** (delineated by `TLAST`) are treated as configuration. All subsequent packets are pixel row data. Results are returned to the host via an AXI-S master port connected to the DMA S2MM channel.

```
AXI DMA MM2S ──► bui (S_TDATA / S_TVALID / S_TREADY / S_TLAST)
                  │
                  ├─ txn 0-3 ──► ctrl_reg  (kernel coefficients + row width)
                  └─ txn 4+  ──► line_buffer (pixel rows)

line_buffer ──► mux ──► mac_truncate (×4 cores) ──► bui result packer
                                                         │
AXI DMA S2MM ◄──────────────────────────────────────────┘
```

### 1.1 Simplified AXI-S Rules (this design)

| Signal | Direction | Notes |
|--------|-----------|-------|
| `TDATA [31:0]` | in/out | 32-bit payload |
| `TVALID` | in/out | standard handshake |
| `TREADY` | in/out | backpressure supported |
| `TLAST` | in/out | end of packet only |
| `TKEEP` | — | **not used** |
| `TUSER` | — | **not used** |
| `TSTRB` | — | **not used** |

---

## 2. Module List

| Module | Function |
|--------|----------|
| `bui` | Bus Interface Unit — FIFOs, demux, result packer |
| `axis_fifo` | Generic 32-bit AXI-S FIFO (used inside `bui`) |
| `ctrl_reg` | Kernel coefficient and row-width register bank |
| `line_buffer` | 4-lane × 64-entry register array, 3×3 window output |
| `mac_truncate` | Single 3×3 MAC + clamp unit (instantiated ×4) |
| `control_logic` | FSM, column sequencer, 4-core dispatcher, result collector |

---

## 3. Module: `axis_fifo`

### Purpose
General-purpose 32-bit AXI-S FIFO used as the building block inside `bui`. Supports full backpressure on both slave and master ports. Depth must be a power of 2.

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `DEPTH` | `16` | Number of entries, must be power of 2 |
| `AFULL_THRESH` | `2` | `almost_full` asserts when free slots ≤ this value |

### Port List

```systemverilog
module axis_fifo #(
    parameter DEPTH        = 16,
    parameter AFULL_THRESH = 2
)(
    input  logic        clk,
    input  logic        arstn,

    // Slave (write) port
    input  logic [31:0] S_TDATA,
    input  logic        S_TVALID,
    input  logic        S_TLAST,
    output logic        S_TREADY,     // backpressure: low when full

    // Master (read) port
    output logic [31:0] M_TDATA,
    output logic        M_TVALID,
    output logic        M_TLAST,
    input  logic        M_TREADY,

    // Status
    output logic        full,
    output logic        empty,
    output logic        almost_full,
    output logic [$clog2(DEPTH):0] fill_level
);
```

### Storage Format

Each entry is **33 bits**: `{TLAST, TDATA[31:0]}`.  
`TKEEP`, `TUSER`, `TSTRB` are not stored.

### Behaviour

- `S_TREADY = ~full` — combinational, zero-latency backpressure.
- `M_TVALID = ~empty` — data available immediately when not empty.
- Read data is registered (one-cycle latency from write to read on an empty FIFO).
- Full/empty detection uses the extra MSB pointer trick (no separate counter needed).
- `almost_full` asserts when `fill_level >= DEPTH - AFULL_THRESH`.

### Full/Empty Detection

```
Pointers are (log2(DEPTH)+1) bits wide.
full  = (wr_ptr[MSB] != rd_ptr[MSB]) && (wr_ptr[LSBs] == rd_ptr[LSBs])
empty = (wr_ptr == rd_ptr)
```

---

## 4. Module: `bui`

### Purpose
Single AXI-S slave entry point for the IP. Counts incoming packets using `TLAST` to demultiplex the first `CFG_PKTS` packets to the config path and all subsequent packets to the pixel path. Packs 8-bit result bytes from `control_logic` into 32-bit words and outputs them on the AXI-S master result port.

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CFG_PKTS` | `4` | Number of leading packets routed to config |
| `IN_DEPTH` | `512` | Pixel input FIFO depth (words) |
| `CFG_DEPTH` | `16` | Config FIFO depth (words) |
| `RES_DEPTH` | `256` | Result output FIFO depth (words) |
| `AFULL_THRESH` | `8` | `almost_full` threshold for input and result FIFOs |

### Port List

```systemverilog
module bui #(
    parameter CFG_PKTS     = 4,
    parameter IN_DEPTH     = 512,
    parameter CFG_DEPTH    = 16,
    parameter RES_DEPTH    = 256,
    parameter AFULL_THRESH = 8
)(
    input  logic        clk,
    input  logic        arstn,

    // AXI-S slave in (from AXI DMA MM2S)
    input  logic [31:0] S_TDATA,
    input  logic        S_TVALID,
    input  logic        S_TLAST,
    output logic        S_TREADY,      // backpressure to DMA

    // AXI-S master out — pixel data → line_buffer
    output logic [31:0] M_PX_TDATA,
    output logic        M_PX_TVALID,
    output logic        M_PX_TLAST,
    input  logic        M_PX_TREADY,   // tie high if no backpressure needed

    // Result write port (from control_logic, byte-wide)
    input  logic [7:0]  res_wdata,
    input  logic        res_wvalid,
    input  logic        res_wlast,     // end of output row

    // AXI-S master out — results → AXI DMA S2MM
    output logic [31:0] M_RES_TDATA,
    output logic        M_RES_TVALID,
    output logic        M_RES_TLAST,
    input  logic        M_RES_TREADY,  // backpressure from DMA S2MM

    // Config decoded outputs → ctrl_reg
    output logic [31:0] cfg_data,
    output logic        cfg_valid,
    output logic        cfg_last,

    // Status
    output logic        px_almost_full,
    output logic        res_almost_full,
    output logic        frame_start     // pulses on first pixel packet beat
);
```

### Internal Structure

```
S_TDATA/TVALID/TLAST
        │
        ▼
  ┌─────────────┐
  │  txn_cnt    │  counts TLAST edges
  │  is_cfg =   │  txn_cnt < CFG_PKTS
  └──────┬──────┘
         │
    is_cfg?
    ├─ YES ──► axis_fifo (CFG_DEPTH=16)  ──► cfg_data/cfg_valid/cfg_last
    └─ NO  ──► axis_fifo (IN_DEPTH=512)  ──► M_PX_*

res_wdata/res_wvalid/res_wlast
        │
        ▼
  byte packer (4 bytes → 32-bit word)
        │
        ▼
  axis_fifo (RES_DEPTH=256) ──► M_RES_*
```

### Packet Routing Rules

- `txn_cnt` resets to 0 on `arstn`.
- On every `TLAST` handshake where `is_cfg` is true, `txn_cnt` increments.
- Once `txn_cnt == CFG_PKTS`, it saturates and all data routes to the pixel FIFO until next reset.
- `S_TREADY` is muxed from `cfg_fifo_ready` or `px_fifo_ready` based on `is_cfg`. The switch only occurs at a `TLAST` boundary, which is AXI-S compliant.
- The driver must reset the BUI (assert `arstn` or a soft reset) before each new frame, and must queue the 4 config DMA descriptors before the pixel row descriptors.

### Result Byte Packer

Accumulates `res_wdata` bytes into a 32-bit shift register. Emits a word to the result FIFO when either 4 bytes have accumulated or `res_wlast` is asserted (whichever comes first). On `res_wlast` with a partial word, `TLAST` is set on the emitted word. Output row width of 62 pixels (border-stripped 64-wide image) means 62 bytes = 15 full words + 1 two-byte partial word per row.

---

## 5. Module: `ctrl_reg`

### Purpose
Holds all configuration written by the first 4 AXI-S packets. Presents kernel coefficients and row width combinationally to the rest of the design. Asserts `cfg_loaded` once the full configuration has been received.

### Port List

```systemverilog
module ctrl_reg (
    input  logic        clk,
    input  logic        arstn,

    // Write port from bui
    input  logic [31:0] cfg_data,
    input  logic        cfg_valid,
    input  logic        cfg_last,

    // Kernel coefficients (9-bit signed, 3×3)
    output logic signed [8:0] k0, k1, k2,
                               k3, k4, k5,
                               k6, k7, k8,

    // Row configuration
    output logic [5:0]  row_width,   // pixels per row, max 64

    // Status
    output logic        cfg_loaded   // stays high after all 4 packets received
);
```

### Config Packet Format

The driver sends exactly 4 AXI-S packets (`TLAST` after each). Each packet is a single 32-bit word:

| Packet | `TDATA` bits | Contents |
|--------|-------------|----------|
| 0 | `[5:0]` = row_width, `[14:6]` = k0, `[31:15]` = reserved | Row size + first kernel tap |
| 1 | `[8:0]` = k1, `[17:9]` = k2, `[26:18]` = k3, `[31:27]` = reserved | Taps 1–3 |
| 2 | `[8:0]` = k4, `[17:9]` = k5, `[26:18]` = k6, `[31:27]` = reserved | Taps 4–6 |
| 3 | `[8:0]` = k7, `[17:9]` = k8, `[31:18]` = reserved | Taps 7–8 |

- `row_width` is the actual pixel count per row (1–64).
- Kernel taps are 9-bit two's-complement signed values.
- `cfg_loaded` asserts after `cfg_last` of packet 3 is received and holds until reset.

---

## 6. Module: `line_buffer`

### Purpose
Stores 4 rows of pixel data in a register array (not BRAM). Three lanes form the compute window; the fourth is the active prefetch target. The 3×3 pixel window is read out combinationally with zero latency. Write lane rotates mod 4 on each completed row.

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `WIDTH` | `64` | Pixels per row (fixed) |

### Port List

```systemverilog
module line_buffer #(
    parameter WIDTH = 64
)(
    input  logic        clk,
    input  logic        arstn,

    // Pixel write port (from bui M_PX_*)
    input  logic [31:0] px_data,
    input  logic        px_valid,
    input  logic        px_last,     // end of row → advance write lane

    // Frame control
    input  logic        frame_start, // resets all pointers

    // Read control (from control_logic)
    input  logic [5:0]  col_idx,     // current column, 1 to WIDTH-2 (border skip)
    input  logic        row_done,    // pulse → base_lane advances

    // Status
    output logic        buf_ready,   // 3 lanes loaded, compute may begin
    output logic [1:0]  write_lane,  // which lane is currently prefetching
    output logic [1:0]  base_lane,   // oldest row of the compute window

    // 3×3 pixel window — purely combinational
    output logic [7:0]  p00, p01, p02,   // row 0: col-1, col, col+1
    output logic [7:0]  p10, p11, p12,   // row 1
    output logic [7:0]  p20, p21, p22    // row 2
);
```

### Lane Organisation

```
base_lane     → compute row 0  (oldest)
base_lane+1   → compute row 1
base_lane+2   → compute row 2
base_lane+3   → prefetch lane  (AXI-S filling, write_lane = base_lane+3 mod 4)
```

All modulo arithmetic is mod 4. `write_lane` is always `(base_lane + 3) % 4` — this is purely combinational.

### Storage

```systemverilog
logic [7:0] lane [0:3][0:WIDTH-1];   // 4 × 64 × 8 = 2048 bits, pure flip-flops
```

The synthesiser infers this as a register file. No BRAM primitives are used.

### Write Path

Incoming 32-bit `px_data` words are unpacked into 4 consecutive byte slots. `wr_ptr` is a 6-bit counter that increments by 4 each valid beat (or by the number of valid bytes on the last beat). `px_last` resets `wr_ptr` to 0 and triggers `write_lane` advancement after `base_lane` is updated.

### Read Path (combinational)

```systemverilog
assign p00 = lane[(base_lane)     % 4][col_idx - 1];
assign p01 = lane[(base_lane)     % 4][col_idx    ];
assign p02 = lane[(base_lane)     % 4][col_idx + 1];

assign p10 = lane[(base_lane + 1) % 4][col_idx - 1];
assign p11 = lane[(base_lane + 1) % 4][col_idx    ];
assign p12 = lane[(base_lane + 1) % 4][col_idx + 1];

assign p20 = lane[(base_lane + 2) % 4][col_idx - 1];
assign p21 = lane[(base_lane + 2) % 4][col_idx    ];
assign p22 = lane[(base_lane + 2) % 4][col_idx + 1];
```

`col_idx` is driven by `control_logic` and must remain stable for one cycle per MAC dispatch. Border columns (0 and 63) are never read — `control_logic` constrains `col_idx` to the range `[1, row_width-2]`.

### `buf_ready` Assertion

`buf_ready` goes high after 3 consecutive rows have been written (3 × `px_last` seen). It stays high until `frame_start`. `control_logic` must not begin dispatching MAC work until `buf_ready` is asserted.

---

## 7. Module: `mac_truncate`

### Purpose
Single 3×3 convolution compute unit. Multiplies each of the 9 pixel values by the corresponding 9-bit signed kernel coefficient, accumulates the results, and clamps the output to 8-bit unsigned `[0, 255]`. Fully pipelined with a fixed latency of `MAC_LATENCY` cycles.

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `MAC_LATENCY` | `3` | Pipeline depth in clock cycles |

### Port List

```systemverilog
module mac_truncate #(
    parameter MAC_LATENCY = 3
)(
    input  logic        clk,
    input  logic        arstn,

    // 3×3 pixel window (8-bit unsigned)
    input  logic [7:0]  p00, p01, p02,
                        p10, p11, p12,
                        p20, p21, p22,

    // Kernel coefficients (9-bit signed)
    input  logic signed [8:0] k0, k1, k2,
                               k3, k4, k5,
                               k6, k7, k8,

    // Handshake
    input  logic        valid_in,    // window and coefficients are stable
    output logic        valid_out,   // result is valid (MAC_LATENCY cycles later)

    // Result
    output logic [7:0]  result       // clamped 0–255
);
```

### Accumulator Width

```
8-bit pixel × 9-bit kernel  = 17-bit signed product (per tap)
9 products summed            → needs ceil(log2(9)) = 4 extra bits
Total accumulator            = 17 + 4 = 21 bits signed → use 22-bit signed
```

### Pipeline Stages

| Stage | Operation |
|-------|-----------|
| 1 | 9 parallel signed multiplies: `product[i] = pixel[i] * kernel[i]` |
| 2 | Add products in two groups of 4+5, partial sums |
| 3 | Final add + clamp to `[0, 255]` |

`valid_out` is `valid_in` delayed by `MAC_LATENCY` cycles through a shift register.

### Clamp Logic

```systemverilog
always_ff @(posedge clk) begin
    if (acc[21])           // negative
        result <= 8'd0;
    else if (|acc[20:8])   // > 255
        result <= 8'd255;
    else
        result <= acc[7:0];
end
```

---

## 8. Module: `control_logic`

### Purpose
Top-level FSM and sequencer. Manages the sliding window across each row, dispatches pixel windows to 4 parallel `mac_truncate` cores in round-robin, collects results in order, and forwards them to `bui` for packing and DMA return.

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `NUM_CORES` | `4` | Number of parallel MAC units |
| `MAC_LATENCY` | `3` | Must match `mac_truncate` parameter |

### Port List

```systemverilog
module control_logic #(
    parameter NUM_CORES   = 4,
    parameter MAC_LATENCY = 3
)(
    input  logic        clk,
    input  logic        arstn,

    // Config
    input  logic [5:0]  row_width,
    input  logic        cfg_loaded,
    input  logic        buf_ready,

    // Line buffer control
    output logic [5:0]  col_idx,
    output logic        row_done,    // pulse → line_buffer advances base_lane

    // MAC core interfaces (×4, indexed 0–3)
    output logic [7:0]  mac_p00 [0:NUM_CORES-1],
    output logic [7:0]  mac_p01 [0:NUM_CORES-1],
    // … (all 9 pixel ports per core, same pattern)
    output logic        mac_valid_in  [0:NUM_CORES-1],
    input  logic        mac_valid_out [0:NUM_CORES-1],
    input  logic [7:0]  mac_result   [0:NUM_CORES-1],

    // Kernel coefficients (broadcast to all cores)
    input  logic signed [8:0] k0, k1, k2, k3, k4, k5, k6, k7, k8,

    // Result output → bui
    output logic [7:0]  res_wdata,
    output logic        res_wvalid,
    output logic        res_wlast,

    // Frame done
    output logic        frame_done
);
```

### FSM States

```
IDLE
  │  cfg_loaded && buf_ready
  ▼
SCAN_ROW
  │  col_idx: 1 → row_width-2
  │  dispatch to core[col_idx % NUM_CORES]
  │  collect results in column order
  │
  │  col_idx == row_width-2
  ▼
END_ROW
  │  pulse row_done → line_buffer advances
  │  wait MAC_LATENCY cycles for last result
  ▼
WAIT_PREFETCH
  │  check buf_ready (new prefetch lane complete)
  │  (should never stall: 4 cores × MAC_LATENCY << 64-pixel fill time)
  ▼
SCAN_ROW  (next row)
  │
  │  all rows processed
  ▼
FRAME_DONE
  │  pulse frame_done
  ▼
IDLE
```

### 4-Core Round-Robin Dispatch

Each cycle in `SCAN_ROW`, `col_idx` advances by 1. The active core is `col_idx % NUM_CORES`. `mac_valid_in[core]` is asserted for exactly one cycle. Each core sees a unique column window because `col_idx` drives `line_buffer.col_idx` combinationally — the window updates in the same cycle the dispatch fires.

```
col 1  → core 0
col 2  → core 1
col 3  → core 2
col 4  → core 3
col 5  → core 0
…
```

Results arrive `MAC_LATENCY` cycles after dispatch. A result collector tracks which core produced each column result and writes them out in ascending column order to maintain pixel order in the output stream.

### Prefetch Timing Guarantee

With `NUM_CORES=4` and `MAC_LATENCY=3`:
- Time to compute one row of 62 pixels = 62 cycles dispatch + 3 cycles drain = 65 cycles.
- Time to fill one 64-pixel lane from AXI-S at 32-bit = 16 beats minimum.
- At any reasonable AXI-S clock rate the prefetch lane completes well before `WAIT_PREFETCH` is reached. `WAIT_PREFETCH` is a safety state only.

---

## 9. Top-Level: `conv_accel`

### Port List

```systemverilog
module conv_accel (
    input  logic        clk,
    input  logic        arstn,

    // AXI-S slave (from AXI DMA MM2S)
    input  logic [31:0] S_TDATA,
    input  logic        S_TVALID,
    input  logic        S_TLAST,
    output logic        S_TREADY,

    // AXI-S master (to AXI DMA S2MM)
    output logic [31:0] M_TDATA,
    output logic        M_TVALID,
    output logic        M_TLAST,
    input  logic        M_TREADY
);
```

All internal wiring is done in this wrapper. `ctrl_reg`, `bui`, `line_buffer`, `control_logic`, and 4× `mac_truncate` are instantiated here. Kernel coefficients are broadcast from `ctrl_reg` to all 4 MAC cores.

---

## 10. Design Constants Summary

| Constant | Value | Notes |
|----------|-------|-------|
| AXI-S data width | 32 bits | |
| AXI-S sideband | `TLAST` only | No `TKEEP`, `TUSER`, `TSTRB` |
| Config packets | 4 | First 4 `TLAST`-terminated packets |
| Kernel size | 3×3 | 9 taps, 9-bit signed |
| Accumulator width | 22 bits signed | Sufficient for 9× (8-bit × 9-bit) |
| Line width | 64 pixels | Fixed, register-based storage |
| Active compute columns | 1–62 | Border pixels skipped |
| Output pixels per row | 62 | |
| Lane count | 4 | 3 compute + 1 prefetch |
| MAC cores | 4 | Round-robin dispatch |
| MAC pipeline latency | 3 cycles | Parameterised |
| Input FIFO depth | 512 words | Absorbs DMA bursts |
| Config FIFO depth | 16 words | Config is small |
| Result FIFO depth | 256 words | Handles DMA S2MM latency |
| Total register storage | 2048 bits | 4 × 64 × 8-bit lanes |

---

## 11. Driver Sequence (Per Frame)

```
1. Assert arstn (or soft reset) on conv_accel
2. Queue 4 DMA MM2S descriptors (config packets, one word each, TLAST set)
   - Descriptor 0: row_width packed with k0
   - Descriptor 1: k1, k2, k3
   - Descriptor 2: k4, k5, k6
   - Descriptor 3: k7, k8
3. Queue N DMA MM2S descriptors (pixel rows, 16 words each at 64px, TLAST per row)
4. Queue 1 DMA S2MM descriptor (result buffer, N × 16 words)
5. Start MM2S and S2MM channels simultaneously
6. Wait for S2MM transfer complete interrupt
```

---

## 12. Notes and Constraints

- `col_idx` must never be 0 or `row_width-1` when `mac_valid_in` is asserted. The FSM enforces this by starting the scan at column 1 and stopping at `row_width-2`.
- The soft reset between frames must be deasserted before the DMA MM2S channel begins sending. A minimum of 4 clock cycles of reset is sufficient.
- The result packer in `bui` handles partial last words. If `row_width` is not a multiple of 4, the final word of each output row will have fewer than 4 valid bytes. The DMA S2MM descriptor must be sized to the exact byte count: `(row_width - 2)` bytes per row.
- All modulo-4 arithmetic on lane indices should be implemented as 2-bit truncation (and-mask with `2'b11`) rather than a general modulo operator to avoid unwanted logic.
- Kernel coefficients are static per frame. There is no mid-frame reconfiguration support.

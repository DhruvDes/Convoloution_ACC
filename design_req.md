# Hardware Architecture Specification: 2D Convolution Accelerator

---

# 1. System Overview & Global Constraints

- **Target Clock Frequency:** 100 MHz (ACLK)  
  - Single synchronous clock domain across all AXI interfaces and internal datapath.

- **Reset Strategy:**  
  - Synchronous, active-LOW (`ARESETN`).  
  - Applies to FSMs, valid flags, and pointers.  
  - Datapath pipeline flops are NOT reset.

- **Throughput:**  
  - 1 pixel processed per clock cycle (native).  
  - Theoretical maximum: 100 Mpixels/sec.

- **Kernel Size:**  
  - Hardware-fixed to 3×3.

- **Native Datapath Width:**  
  - 9-bit signed 2’s complement logic throughout.

---

# 2. Interface Contracts & Data Formats

## 2.1 AXI4-Stream Input (S00_AXIS)

Data is ingested from the DMA in a custom packed format to maximize bandwidth.

### 32-bit `TDATA` Mapping

| Bits      | Field   | Description |
|------------|----------|-------------|
| [31]       | SOF      | Start of Frame — hard-resets pointers and line buffers |
| [30]       | Bypass   | Routes center pixel directly to output, bypassing MAC |
| [29:27]    | Reserved | Tie to `000` |
| [26:18]    | Pixel 2  | 9-bit signed |
| [17:9]     | Pixel 1  | 9-bit signed |
| [8:0]      | Pixel 0  | 9-bit signed |

### Control Signals

- `TVALID`
- `TREADY`
- `TLAST` (End of Line/Row)

---

## 2.2 AXI4-Stream Output (M00_AXIS)

Data is packed back into the exact same format before returning to the DMA.

### 32-bit `TDATA` Mapping

| Bits      | Field       | Description |
|------------|--------------|-------------|
| [31]       | SOF_OUT      | Propagated from input |
| [30]       | Bypass_OUT   | Propagated from input |
| [29:27]    | Reserved     | `000` |
| [26:18]    | Computed P2  | 9-bit signed |
| [17:9]     | Computed P1  | 9-bit signed |
| [8:0]      | Computed P0  | 9-bit signed |

### Control Signals

- `TVALID`
- `TREADY`
- `TLAST` (End of Line/Row)

---

# 3. Subsystem Microarchitecture

---

## Subsystem 1: AXI4-Lite Control & Weight Buffer (WB)

### Responsibility

- Provide CPU/Python access to configuration registers.
- Ensure safe, tear-free kernel updates.

### Protocol

- Standard AXI4-Lite slave.
- Non-blocking 1-cycle write-through.

### Memory Map

| Address | Register | Description |
|----------|----------|-------------|
| 0x00 | CTRL | Bit 0: Enable<br>Bit 1: Soft Reset<br>Bit 2: Update Pending |
| 0x04 | NORM | Bits [3:0]: Arithmetic Right Shift Amount<br>Bits [5:4]: Activation Mode<br> 00 = Clamp<br> 01 = Absolute Value<br> 10 = Raw |
| 0x08–0x28 | WEIGHTS | Nine 32-bit registers storing 3×3 kernel weights as 9-bit signed values |

### Shadow Update FSM

- Software writes update shadow registers.
- When `Update Pending` is set:
  - Hardware swaps shadow weights into active datapath weights
  - Swap occurs strictly on next `TLAST` or `SOF`
  - Prevents image tearing

---

## Subsystem 2: Streaming Input, Gearbox & Line Buffer Array

### Responsibility

- Unpack 3-pixel AXI beat.
- Convert 1D stream to 2D spatial structure.
- Handle hardware safety triggers.

---

### 3-to-1 Unpacker FSM (Gearbox)

- **Cycle 0**
  - Assert `TREADY`
  - Latch 32-bit word
  - Feed Pixel 0 into Line Buffer

- **Cycle 1**
  - Deassert `TREADY`
  - Feed Pixel 1 into Line Buffer

- **Cycle 2**
  - Keep `TREADY` low
  - Feed Pixel 2 into Line Buffer
  - Handle `TLAST` logic
  - Return to Cycle 0

---

### In-Band Telemetry

- If `SOF` (Bit 31) detected on Cycle 0:
  - Generate 1-cycle `sync_flush`
  - Instantly clear:
    - BRAM pointers
    - X/Y counters

---

### Line Buffer Array

- Two True-Dual Port BRAMs  
  - Width: 9-bit  
  - Depth: `MAX_IMAGE_WIDTH`

- 3×3 shift register array  
  - Nine 9-bit flops

---

### Padding Logic

- Tracks X/Y coordinates using:
  - `TLAST`
  - Internal width counter
- Injects `9'b0` into shift registers when sliding window crosses image boundary.

---

### Backpressure Handling

- If `ALMOST_FULL` from Subsystem 4 asserts:
  - Gearbox FSM freezes in place
  - Holds current pixel valid to Line Buffer

---

## Subsystem 3: MAC & Truncation Engine

### Responsibility

- Compute spatial dot product.
- Fully signed 2’s complement.
- No stalling.

### Protocol

- Free-running valid pipeline.
- No clock-enable or stall logic (to ease 100 MHz timing closure).

---

### Flattened Pipeline (3 Stages)

#### Stage 1 — Multiply & L1 Add

- 9× DSP48 slices
- Each performs:
  - 9-bit pixel × 9-bit weight
  - 18-bit signed product
- Immediate pairwise accumulation using DSP pre/post adders
- Outputs 5 intermediate values

#### Stage 2 — Accumulate

- Cascaded adders
- Sum 5 intermediate values
- Output: 22-bit signed result

#### Stage 3 — Truncate / Activate

- Barrel shift by `Shift Amount` from Subsystem 1
- Apply Activation Mode:
  - Clamp to 255/0
  - Absolute value
  - Raw 9-bit truncation
- Bypass Mux:
  - If `Bypass` flag active
  - Output overridden with raw center pixel

---

## Subsystem 4: Output BUI & 1-to-3 Packer

### Responsibility

- Pack computed pixels into 32-bit format.
- Absorb AXI-Stream backpressure.

---

### 1-to-3 Packer FSM

- Collect 3 consecutive valid 9-bit pixels from MAC.
- Assemble 32-bit word:

  `{SOF, Bypass, 3'b0, P2, P1, P0}`

- Push word into Output FIFO.

#### Corner Case

- If `TLAST` arrives but only 1 or 2 pixels collected:
  - Force remaining bits to zero
  - Flush word to close row properly

---

### Decoupling FIFO

- 16-deep
- 33-bit wide:
  - 32-bit Data
  - 1-bit `TLAST`
- Synchronous FIFO
- Drives M_AXIS based on downstream `TREADY`

---

### Deadlock Avoidance

- Asserts `ALMOST_FULL` when FIFO depth reaches 11.
- Guarantees 5 empty slots remain.
- Safely absorbs:
  - 3-stage MAC pipeline
  - Gearbox inflight pixels
- Prevents overflow when Line Buffer halts.

---

# 4. Software & Integration Contract

## Integration

- Packaged as Vivado IP.
- Inserted into Block Design:
  - Between AXI DMA IP
  - And Zynq Processing System

---

## Software (PYNQ)

- ARM Cortex-A9:
  - Never moves pixels manually.

- Python (NumPy):
  - Vectorizes image into 3-pixel-per-32-bit format.
  - Writes AXI-Lite registers for weights.
  - Asserts Start bit.

- PYNQ `allocate()` buffers:
  - Passed to AXI DMA.
  - Entire image streams continuously through hardware.

- Hardware interrupt:
  - Signals completion.
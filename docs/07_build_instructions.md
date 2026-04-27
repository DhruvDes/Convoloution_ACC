# 07 — Build Instructions

This document covers three reproducible flows: running the UVM simulation, rebuilding the Vivado project and bitstream, and running the IP on the PYNQ-Z2 board. The entire Vivado flow — simulation, IP packaging, block design assembly, synthesis, implementation, and bitstream generation — is driven by a single Tcl script ([`run.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/run.tcl)). A companion [`cleanup.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/cleanup.tcl) removes all generated artifacts for a clean rebuild.

The full repository is at <https://github.com/DhruvDes/Convoloution_ACC>.

Look at `doc/sw/demo` for a `devicedemo.ipynb` if you only want to run it on the device. All necessary files and instructions are provided there. Upload the `sw` folder onto your Jupyter notebook directory.

## Prerequisites

| Tool | Version used | Notes |
|---|---|---|
| Vivado | 2025.2 | Vivado Simulator (`xsim`) is used for UVM; [`recreate_bd.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/recreate_bd.tcl) checks version on entry |
| Python | 3.8+ | For the PYNQ driver and notebook |
| PYNQ image | v3.0.1 | Pre-installed on the PYNQ-Z2 SD card |
| Target board | PYNQ-Z2 (xc7z020clg400-1) | — |

No Xilinx-specific environment setup is required beyond sourcing `settings64.sh` (Linux) or running the Vivado command prompt (Windows) so `vivado` is on `PATH`.

The PYNQ-Z2 board files must be available to Vivado. [`run.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/run.tcl) looks for a local `boards/` folder next to the script and registers it automatically; if the folder is missing it prints a warning and falls back to the system-installed board definition.

## 1. Run the Full Build (Simulation → Bitstream)

Everything is driven by a single command:

```bash
vivado -mode batch -source run.tcl
```

[`run.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/run.tcl) executes five phases in order:

1. **UVM Simulation** — creates a temporary `sim_only` project, compiles all RTL from `RTL/` and the UVM TB top from `TB/top.sv`, runs the test to completion, and parses the simulator log for `UVM_FATAL` / `UVM_ERROR`. If either count is non-zero the script exits with code 1 and deletes the temporary project; no bitstream is produced.

2. **IP Packaging** — creates a temporary `ip_pack` project, adds the RTL sources, and packages the design as `convAcc2d` (vendor `xilinx.com`, library `user`, version `3.0`) into a local `ip_repo/` directory.

3. **Block Design** — creates the `convAccTop` project, registers `ip_repo/` in the project's IP catalog, and sources [`recreate_bd.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/recreate_bd.tcl) to build the `convacc` block design from scratch.

4. **Synthesis & Implementation** — launches synthesis and implementation (8 parallel jobs each), including bitstream generation. The script checks `PROGRESS` after each run and exits with code 1 on failure.

5. **Output Copy** — copies the bitstream and hardware handoff file to the `OverlayFiles/` directory as `convAcc.bit` and `convAcc.hwh`.

On success the final console output is:

```
INFO: ====== DONE — overlay files at OverlayFiles/convAcc.bit/.hwh ======
```

Build time on a modern laptop: **20–30 minutes**. The last five minutes is bitstream generation; everything before is synthesis and place-and-route.

### What `run.tcl` produces

| Output | Path |
|---|---|
| Bitstream | `OverlayFiles/convAcc.bit` |
| Hardware handoff | `OverlayFiles/convAcc.hwh` |
| Vivado project | `convAccTop/convAccTop.xpr` |
| Packaged IP | `ip_repo/` |
| Simulation log | `sim_only/sim_only.sim/sim_1/behav/xsim/simulate.log` (deleted on success) |

### Simulation-only pass/fail

If you only want to verify the RTL without building a bitstream, you can still run the full [`run.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/run.tcl); it will exit early on simulation failure. The temporary `sim_only/` project is deleted after the simulation phase regardless of outcome.

Expected simulation output on success:

```
UVM_INFO … MATRIX SIZE COVERAGE: 100.00% (12 / 12 sizes hit)
UVM_INFO … ** UVM TEST PASSED ** : 0 UVM_ERROR reports, 0 UVM_FATAL reports
```

### What `recreate_bd.tcl` does

[`recreate_bd.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/recreate_bd.tcl) is a Vivado-generated block design Tcl script (produced by `write_bd_tcl` in the GUI). It is sourced by [`run.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/run.tcl) — never run standalone. It recreates the `convacc` block design containing:

- **PS7** (`processing_system7_0`) — Zynq PS configured for the PYNQ-Z2 with FCLK_CLK0 at 125 MHz, S_AXI_HP0 and S_AXI_HP2 enabled.
- **AXI DMA** — scatter-gather disabled, 64-bit memory-mapped data widths, 32-bit stream data width, 256-beat bursts, 26-bit transfer length.
- **Two AXI Interconnects** — one for the MM2S read path (HP2) and one for the S2MM write path (HP0).
- **convAcc2d_0** — the packaged convolution accelerator IP, connected AXI-Stream-to-Stream through the DMA.
- **Processor System Reset** — driven by FCLK_RESET0_N.

The script checks that all required IPs are present in the catalog (`axi_dma:7.1`, `processing_system7:5.5`, `proc_sys_reset:5.0`, `convAcc2d:3.0`) and aborts if any are missing.

### Why the block design is a Tcl script, not a `.bd` file

`.bd` files are binary-ish XML, tool-version-locked, and not reviewable in a diff. [`recreate_bd.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/recreate_bd.tcl) recreates the BD from scratch on every build, so the repo carries a text-only, reviewable, version-stable description of the platform integration. If a change to the BD is needed, the workflow is:

1. Open the project in the GUI.
2. Make the change in the BD editor.
3. Re-run `write_bd_tcl` to overwrite [`recreate_bd.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/recreate_bd.tcl).
4. Commit the diff.

### Why the IP is re-packaged from RTL, not committed as a packaged IP directory

The packaged IP contains auto-generated `component.xml` and `xgui/` files that are redundant with the RTL and the IP-packaging Tcl in [`run.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/run.tcl). Re-packaging from RTL on every build means the IP-catalog entry and the RTL can never drift out of sync.

## 2. Run on the PYNQ-Z2 Board

### Step 1 — Copy the overlay to the board

After [`run.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/run.tcl) finishes, the bitstream and HWH are in `OverlayFiles/`. Copy them (plus the notebook) to the PYNQ board:

```bash
scp OverlayFiles/convAcc.bit \
    xilinx@<pynq-ip>:/home/xilinx/jupyter_notebooks/conv_acc/
scp OverlayFiles/convAcc.hwh \
    xilinx@<pynq-ip>:/home/xilinx/jupyter_notebooks/conv_acc/
scp sw/Benchmark_Arm_and_Acclerator_after_implimentation.ipynb \
    xilinx@<pynq-ip>:/home/xilinx/jupyter_notebooks/conv_acc/
```

Default PYNQ password is `xilinx`.

### Step 2 — Open the notebook

From a browser: `http://<pynq-ip>:9090` → `conv_acc/Benchmark_Arm_and_Acclerator_after_implimentation.ipynb`.

### Step 3 — Run the notebook

Kernel → Restart & Run All. The notebook:

1. Loads the overlay (`Overlay('convAcc.bit')`).
2. Allocates CMA DMA buffers.
3. Runs the 20,000-image CPU pass for Test A, then the FPGA pass, and prints a summary.
4. Repeats for Test B.
5. Produces the latency-vs-height comparison plot and the summary stats table.
6. Frees the CMA buffers.

**Expected runtime on the PYNQ-Z2:**

- Test A (W=16): ~135 seconds total (118 s CPU + 16 s FPGA + overhead)
- Test B (W=60): ~620 seconds total (594 s CPU + 22 s FPGA + overhead)

Total end-to-end: **~12–13 minutes**.

**Expected output:**

```
Test A summary:
  CPU  avg :    5.913 ms   total: 118.25s
  FPGA avg :    0.820 ms   total: 16.40s
  Speedup  : 7.21x

Test B summary:
  CPU  avg :   29.730 ms   total: 594.61s
  FPGA avg :    1.116 ms   total: 22.33s
  Speedup  : 26.63x
```

Exact numbers will vary by a few percent depending on PYNQ image version, DDR contention, and background processes.

## 3. Run Only the Benchmarks (Pre-Bitstream)

The [`[2]_Benchmarking`](https://github.com/DhruvDes/Convoloution_ACC/tree/main/%5B2%5D_Benchmarking) directory contains the original x86 and Arm scipy benchmarks used to motivate the project (see `docs/01_operations.md`). These do not require the FPGA:

```bash
cd [2]_Benchmarking
jupyter notebook benchmark_x86.ipynb     # run on an x86 workstation
jupyter notebook benchmark_arm.ipynb     # run on the PYNQ Arm (no overlay needed)
```

Each writes a PNG of its results into the same directory.

## 4. Clean Builds

To remove all generated artifacts and start fresh:

```bash
vivado -mode batch -source cleanup.tcl
```

Or, if Vivado is not available (pure Tcl):

```bash
tclsh cleanup.tcl
```

[`cleanup.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/cleanup.tcl) deletes the following directories and loose files:

| Directories removed | Loose file patterns removed |
|---|---|
| `.done`, `ip_repo`, `ip_pack`, `sim_only`, `convAccTop`, `OverlayFiles` | `*.jou`, `*.log`, `*.str`, `*.xsa`, `*.jou.bak`, `.Xil`, `dfx_runtime.txt` |

The [`.gitignore`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/.gitignore) at the repo root is configured to ignore these directories and patterns, so they will never be accidentally committed.

## Directory Map for This Document

Every path is relative to the repo root.

| Path | Used by |
|---|---|
| [`run.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/run.tcl) | Section 1 (full build) |
| [`recreate_bd.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/recreate_bd.tcl) | Section 1 (sourced by `run.tcl`) |
| [`cleanup.tcl`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/cleanup.tcl) | Section 4 (clean builds) |
| `RTL/*.sv`, `RTL/*.v` | Section 1 (design sources) |
| `TB/top.sv` | Section 1 (UVM testbench top) |
| `boards/` | Section 1 (local PYNQ-Z2 board files, optional) |
| `ip_repo/` | Section 1 (generated, packaged IP) |
| `OverlayFiles/` | Section 1 output → Section 2 input |
| `sw/Benchmark_Arm_and_Acclerator_after_implimentation.ipynb` | Section 2 |
| [`[2]_Benchmarking/`](https://github.com/DhruvDes/Convoloution_ACC/tree/main/%5B2%5D_Benchmarking) | Section 3 |
| [`[1]_Python_Experiments/`](https://github.com/DhruvDes/Convoloution_ACC/tree/main/%5B1%5D_Python_Experiments) | Reference (early Python prototypes) |
| [`[3]_Data_wb_test/`](https://github.com/DhruvDes/Convoloution_ACC/tree/main/%5B3%5D_Data_wb_test) | Reference (data path testing) |
| [`[4]_Design/`](https://github.com/DhruvDes/Convoloution_ACC/tree/main/%5B4%5D_Design) | Reference (design assets) |
| [`design_req.md`](https://github.com/DhruvDes/Convoloution_ACC/blob/main/design_req.md) | Reference (design requirements spec) |

If any of these paths is missing from the repo, the build infrastructure is incomplete — this is the checklist to verify against before tagging a release.

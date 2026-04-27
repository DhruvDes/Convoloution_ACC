# 07 — Build Instructions

This document covers three reproducible flows: running the UVM simulation, rebuilding the Vivado project and bitstream, and running the IP on the PYNQ-Z2 board. Each flow is automated to the extent that is practical using Vivado shell.
Look at `doc/sw/demo`  for a devicedemo.ipynb if only interested in running a demo on the device. All the necessary files and instructions are provided there. Do upload the `sw` folder on to your jupyter notebook directory

## Prerequisites

| Tool | Version used | Notes |
|---|---|---|
| Vivado | 2025.2 | Vivado Simulator (`xsim`) is used for UVM |
| Python | 3.8+ | For the PYNQ driver and notebook |
| PYNQ image | v3.0.1 | Pre-installed on the PYNQ-Z2 SD card |
| Target board | PYNQ-Z2 (xc7z020clg400-1) | — |

No Xilinx-specific environment setup is required beyond sourcing `settings64.sh` (Linux) or running the Vivado command prompt (Windows) so `vivado` is on `PATH`.

There are two methods of building: [manually](#manual-build-instructions), or by using the [tcl build script](#tcl-automatic-build-script-instructions---runtcl) which automates the manual build process.

## *Manual Build Instructions:*

### 1. Run the UVM Simulation

The simulation is fully automated and requires no GUI interaction.

```bash
cd sim
./run_sim.sh
```

`run_sim.sh` compiles the RTL under `rtl/`, the TB under `tb/`, elaborates `top`, and runs the UVM test to completion. Expected output on success:

```
UVM_INFO … MATRIX SIZE COVERAGE: 100.00% (12 / 12 sizes hit)
UVM_INFO … ** UVM TEST PASSED ** : 0 UVM_ERROR reports, 0 UVM_FATAL reports
```

Optional flags:

```bash
./run_sim.sh --gui          # open xsim GUI with the waveform config pre-loaded
./run_sim.sh --coverage     # enable functional coverage database export
./run_sim.sh --clean        # delete the xsim work directory and rebuild from scratch
```

Artifacts are written to `sim/reports/`:

- `sim_log.txt` — full simulator transcript
- `coverage.html` — functional coverage report (if `--coverage`)
- `waves.wdb` — waveform database (if `--gui` or explicitly requested)

#### What `run_sim.sh` does internally

```bash
xvlog -sv -f compile.f              # compile RTL + TB from compile.f file list
xelab -L uvm top -s top_sim         # elaborate with UVM precompiled library
xsim top_sim -R -testplusarg "UVM_TESTNAME=test" | tee reports/sim_log.txt
```

The file list `compile.f` lists every `.sv` in dependency order and is the single source of truth for "which files are part of the design and TB".

### 2. Rebuild the Vivado Project and Bitstream

The entire Vivado flow — project creation, IP packaging, block design assembly, synthesis, implementation, bitstream generation, and report export — is scripted.

```bash
cd synth
vivado -mode batch -source build.tcl
```

This produces:

- `synth/build/conv_acc.xpr` — the reproducible Vivado project
- `synth/build/conv_acc.runs/impl_1/design_1_wrapper.bit` — the bitstream
- `synth/build/conv_acc.runs/impl_1/design_1_wrapper.hwh` — the hardware handoff file PYNQ needs
- `synth/reports/utilization.rpt` — post-implementation utilization
- `synth/reports/timing_summary.rpt` — post-implementation timing
- `synth/reports/power.rpt` — power estimate
- `synth/reports/drc.rpt` — design rule check output

Build time on a modern laptop: **20–30 minutes**. The last 5 minutes is bitstream generation; everything before is synthesis and place-and-route.

#### What `build.tcl` does

```tcl
# 1. Create a fresh project
create_project conv_acc ./build -part xc7z020clg400-1 -force

# 2. Add RTL sources
add_files [glob ../rtl/*.sv]

# 3. Package the RTL as an IP and add it to the catalog
source ../ip/package_ip.tcl

# 4. Recreate the block design from its Tcl script
source ../bd/system_bd.tcl
make_wrapper -files [get_files system.bd] -top -import

# 5. Add the timing constraints
add_files -fileset constrs_1 ../synth/constraints.xdc

# 6. Run synthesis and implementation
launch_runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

# 7. Export reports
open_run impl_1
report_utilization     -file ../synth/reports/utilization.rpt
report_timing_summary  -file ../synth/reports/timing_summary.rpt
report_power           -file ../synth/reports/power.rpt
report_drc             -file ../synth/reports/drc.rpt

# 8. Copy the bitstream + HWH to sw/overlay for board deployment
file copy -force ./build/conv_acc.runs/impl_1/design_1_wrapper.bit ../sw/overlay/conv_acc.bit
file copy -force ./build/conv_acc.gen/sources_1/bd/design_1/hw_handoff/design_1.hwh ../sw/overlay/conv_acc.hwh
```

#### Why the block design is a Tcl script, not a `.bd` file

`.bd` files are binary-ish XML, tool-version-locked, and not reviewable in a diff. The block design is therefore stored as `bd/system_bd.tcl`, generated once via the Vivado GUI command:

```tcl
write_bd_tcl ../bd/system_bd.tcl
```

The Tcl script recreates the BD from scratch on every build, so the repo carries a text-only, reviewable, version-stable description of the platform integration. If a change to the BD is needed, the workflow is:

1. Open the project in the GUI.
2. Make the change in the BD editor.
3. Re-run `write_bd_tcl` to overwrite `bd/system_bd.tcl`.
4. Commit the diff.

#### Why the IP is re-packaged from RTL, not committed as a packaged IP directory

Same reasoning: the packaged IP contains auto-generated `component.xml` and `xgui/` files that are redundant with the RTL and the IP-packaging Tcl. Committing just `ip/package_ip.tcl` means the IP is regenerated from its RTL on every build, so the RTL and the IP-catalog entry can never drift out of sync.

## *Tcl (Automatic) Build Script Instructions* - run.tcl

The run.tcl script handles the Vivado build pipeline and provides the overlay file necessary for running it on the Pynq hardware. 
What run.tcl does:
- Creates/recreates the Vivado project
- Packages the RTL as a custom IP
- Runs synthesis and implementation
- Generates the .bit bitstream and .hwh hardware description file

### 1. Run the build script

Run in batch mode with:
```sh
vivado -mode batch -source run.tcl -notrace
```
The -notrace flag suppresses command echoing for cleaner output.

### 2. Copy the overlay files

After running the tcl file, Vivado exits, you see: 
```
INFO: ====== SUCCESS: Bitstream Generated ======
INFO: Copied convAcc.bit and convAcc.hwh to /home/user/Convoloution_ACC/OverlayFiles
INFO: ====== DONE — overlay files at OverlayFiles/convAcc.bit/.hwh ======
```
The ```.bit``` and ```.hmh``` files will be located in a newly created directory called `/OverlayFiles`

Move these files: (assuming that you are currently in `~/Convolution_ACC`)
```sh 
mkdir sw/overlay
cp -r OverlayFiles/* sw/overlay/
```

### 3. (Optional) Clean up the workspace

This will remove **ALL** files created by the script. Make sure that desired files (Overlay files) are moved outside of it's original directory before running.
Run: 
```sh 
tclsh cleanup.tcl 
```


## 3. Run on the PYNQ-Z2 Board

### Step 1: Copy the overlay to the board
After `build.tcl` or `run.tcl` finishes, the bitstream and HWH are in `sw/overlay/`. 


#### Copy them (plus the notebook) to the PYNQ board:

```bash
# From a workstation on the same network as the PYNQ
scp sw/overlay/conv_acc.bit       xilinx@<pynq-ip>:/home/xilinx/jupyter_notebooks/conv_acc/
scp sw/overlay/conv_acc.hwh       xilinx@<pynq-ip>:/home/xilinx/jupyter_notebooks/conv_acc/
scp sw/Benchmark_Arm_and_Acclerator_after_implimentation.ipynb \
    xilinx@<pynq-ip>:/home/xilinx/jupyter_notebooks/conv_acc/
```

Default PYNQ password is `xilinx`.

> **Note on the bitstream filename:** the notebook currently loads `conv100m.bit` — this is a legacy name from an earlier 100 MHz build. The submitted bitstream actually runs at 125 MHz. Either rename `conv_acc.bit` → `conv100m.bit` before copying (simplest, keeps the notebook unchanged) or edit the `BITSTREAM_PATH` variable in the notebook to match the new filename.

### Step 2: Open the notebook

From a browser: `http://<pynq-ip>:9090` → `conv_acc/Benchmark_Arm_and_Acclerator_after_implimentation.ipynb`.

### Step 3: Run the notebook

Kernel → Restart & Run All. The notebook:

1. Loads the overlay (`Overlay('conv_acc.bit')`).
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

## 4. Run Only the Benchmarks (Pre-Bitstream)

The `benchmarks/` directory contains the original x86 and Arm scipy benchmarks used to motivate the project (see `docs/01_operations.md`). These do not require the FPGA:

```bash
cd benchmarks
jupyter notebook benchmark_x86.ipynb     # run on an x86 workstation
jupyter notebook benchmark_arm.ipynb     # run on the PYNQ Arm (no overlay needed)
```

Each writes a PNG of its results into `benchmarks/results/`.

## Clean Builds

To remove all generated artifacts and start fresh:

```bash
cd synth && rm -rf build/ reports/*.rpt
cd ../sim && rm -rf xsim.dir/ *.log *.jou reports/*
```

The `.gitignore` at the repo root is configured to ignore these directories, so they will never be accidentally committed.

## Directory Map for This Document

Every path in this document is relative to the repo root.

| Path | Used by |
|---|---|
| `sim/run_sim.sh` | Step 1 |
| `sim/compile.f` | Step 1 (file list) |
| `sim/reports/` | Step 1 output |
| `synth/build.tcl` | Step 2 |
| `synth/constraints.xdc` | Step 2 (timing constraints) |
| `synth/reports/` | Step 2 output |
| `ip/package_ip.tcl` | Step 2 (sourced by build.tcl) |
| `bd/system_bd.tcl` | Step 2 (sourced by build.tcl) |
| `rtl/*.sv` | Step 2 source |
| `tb/*.sv` | Step 1 source |
| `sw/overlay/` | Step 2 output → Step 3 input |
| `sw/Benchmark_Arm_and_Acclerator_after_implimentation.ipynb` | Step 3 |
| `benchmarks/*.ipynb` | Step 4 |

If any of these paths is missing from the repo, the build infrastructure is incomplete — this is the checklist to verify against before tagging a release.

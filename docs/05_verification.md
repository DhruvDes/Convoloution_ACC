# 05 — Verification

Verification was done in two independent layers: a UVM simulation testbench that proves correctness against a SystemVerilog reference model across randomized dimensions and kernels, and a hardware-in-the-loop benchmark notebook that runs 40,000 frames on the physical PYNQ-Z2 board and cross-checks against `scipy.signal.convolve2d`. A bug caught by either layer would be visible in the other; passing both is strong evidence that the RTL, the packaged IP, the block design, the driver, and the overlay are all mutually consistent.

## Layer 1 — UVM Simulation Testbench

### Architecture

Standard UVM layering, instantiated from `top.sv`:

```
                 ┌────────────────────────────────────────┐
                 │               test (uvm_test)          │
                 │     coverage-driven loop up to 500 txns│
                 └────────────────┬───────────────────────┘
                                  │
                 ┌────────────────▼───────────────┐
                 │         env (uvm_env)          │
                 └────┬───────────┬──────────┬────┘
                      │           │          │
               ┌──────▼─────┐ ┌───▼───┐ ┌────▼────────┐
               │ writeAgent │ │scbd   │ │ readAgent   │
               │ seqr/drv/mon│ │(ref  │ │ drv/mon     │
               └──────┬──────┘ │model+│ └────┬────────┘
                      │        │ cov) │      │
                      │        └──▲───┘      │
                      │           │          │
               ┌──────▼───────────┴──────────▼──────┐
               │     design_if (clocked interface)  │
               └──────────────────┬─────────────────┘
                                  │
                         ┌────────▼────────┐
                         │  DUT: convAcc   │
                         └─────────────────┘
```

| Component | File | Role |
|---|---|---|
| `test` | `test.sv` | Top-level UVM test; runs the coverage loop |
| `env` | `env.sv` | Composes write agent, read agent, scoreboard |
| `trn` (transaction) | `transaction.sv` | Randomized frame: dimensions, kernel, pixel data |
| Sequence library | `sequenceLib.sv` | `debug_16x16`, `rand_16x16`, `rand_28x28`, `random_testing` |
| `writeAgent` | `writeAgent.sv` + `writeDriver.sv` + `writeMonitor.sv` | Drives config + pixel stream into the DUT's slave port; mirrors to scoreboard |
| `readAgent` | `readAgent.sv` + `readDriver.sv` + `readMonitor.sv` | Applies randomized `TREADY` backpressure; captures master-out words |
| `scoreboard` | `scoreBoard.sv` | Golden reference model + functional coverage |
| `design_if` | `Interface.sv` | Four clocking blocks: `wdrv`, `wmon`, `rdrv`, `rmon` |
| `top` | `top.sv` | Clock generator, reset sequence, DUT instantiation, `run_test("test")` |

### Stimulus strategy

The transaction class (`trn`) carries randomized frame dimensions constrained to the supported set `{16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60}` in both `rows` and `row_width`, along with a randomized pixel array sized `rows × row_width + 1`, a randomized 3×3 signed kernel, and an alignment constraint (`(rows * row_width) % 4 == 0`) so the packer never sees a misaligned final word. `post_randomize` automatically calls `build_packed_data()` to produce the 32-bit-word representation the driver actually sends.

Four sequences exercise different regimes:

- `debug_16x16` — fixed 16×16, identity kernel, ramp data. Proof-of-life; the DUT output must equal the input-minus-border.
- `rand_16x16` / `rand_28x28` — randomized pixels and kernels at the two canonical benchmark sizes.
- `random_testing` — fully randomized under the constraints above. This is the sequence the test loop calls.

### Reference model

The scoreboard (`scoreBoard.sv`, `check_transaction`) builds the full 2-D image back out of the flat `data[]` array, applies the 3×3 kernel in the same flipped orientation the DUT uses (note the `fk[0][0] = k22` remapping — this is convolution, not correlation, so the kernel is transposed), accumulates in signed 32-bit, saturates to `[0, 255]`, and packs four 8-bit results into each 32-bit word exactly as the hardware packer does. The resulting expected word array is compared element-by-element to `out_trn.packed_data` from the read monitor.

On any mismatch the scoreboard prints the index, the expected word, and the actual word, then dumps both the write-monitor and read-monitor transactions in full for triage. On a clean pass it samples the `matrix_size_cg` covergroup and triggers the `txn_verified` UVM event that unblocks the next sequence.

### Coverage closure

The test loop runs sequences until `matrix_size_cg.get_coverage() == 100.0` or `max_iters = 500` transactions, whichever comes first. Coverage is defined over the 12 legal frame dimensions listed above, so hitting 100% means every supported size has passed a randomized-kernel functional check at least once. Progress checkpoints at 20%, 40%, 60%, 80%, and 90% coverage are logged with the transaction count so the convergence rate is visible in the simulator log.

### Ordering and backpressure

Write and read transactions don't arrive at the scoreboard in the same order — the DUT has a startup latency of several cycles before the first output word appears. The scoreboard handles this with two queues (`write_q`, `read_q`) and an assertion: a read must always find a matching write already queued. A `write_rmon fired but write_q is empty` error would flag either a driver bug (read before write) or a DUT bug (spurious output); a non-empty queue at `report_phase` flags dropped outputs.

The read driver applies randomized `m00_axis_tready` deassertions so the DUT's backpressure path through the result FIFO and the byte packer is exercised, not just the zero-stall ideal case.

### Clocking

The simulation clock period is `15.384 ns` (≈ 65 MHz), generated in `top.sv`. This is deliberately slower than the synthesized 125 MHz so simulator-visible race conditions around the clocking-block `#1` delays in `design_if` don't mask bugs that would be benign at target frequency. The four clocking blocks (`wdrvcb`, `wmoncb`, `rdrvcb`, `rmoncb`) use `default input #1 output #1` so drivers sample and drive one time-unit off the clock edge — this is the standard idiom to avoid races between monitors and drivers on the same interface.

### How to run

```bash
cd sim
./run_sim.sh                        # xsim, default
./run_sim.sh --gui                  # open waveform viewer
```

The script compiles the RTL (`rtl/*.sv`), the TB (`tb/*.sv`), and the packaged `Interface.sv`, elaborates `top`, and runs to completion. A passing run prints `MATRIX SIZE COVERAGE: 100.00% (12 / 12 sizes hit)` and zero `UVM_ERROR` counts; the log is archived to `sim/reports/sim_log.txt`.

### Committed evidence

| File | What it shows |
|---|---|
| `docs/images/sim/uvm_pass_summary.png` | End-of-run UVM report: 0 errors, 100% coverage |
| `docs/images/sim/waveform_axi_handshake.png` | Input-side `TVALID`/`TREADY`/`TDATA`/`TLAST` over several frames |
| `docs/images/sim/waveform_first_output.png` | First output word emerging after the pipeline fills |
| `sim/reports/sim_log.txt` | Full simulator transcript including coverage checkpoints |

## Layer 2 — Hardware-in-the-Loop Verification

Simulation proves the RTL matches a SystemVerilog reference. That is not quite the same as proving the bitstream on the board matches a numerical-software reference, because errors can be introduced by the block design, the IP wrapper, the DMA configuration, the clock constraints, or the packaged IP's `component.xml`. To catch all of those, `sw/Benchmark_Arm_and_Acclerator_after_implimentation.ipynb` runs 40,000 convolutions on the PYNQ-Z2 and compares against `scipy.signal.convolve2d` on the same Arm core.

### Methodology

1. **Load overlay.** `Overlay('conv100m.bit')` programs the PL and binds the packaged IP's registers. CMA buffers are allocated once (`allocate(...)`) with worst-case capacity for a 60×1020 frame.
2. **Generate stimulus.** 20,000 random images of width 16 and random height 16–1000 (Test A); 20,000 random images of width 60 and random height 16–1000 (Test B). A fresh random signed 3×3 kernel is generated per image. Seed is fixed (`np.random.default_rng(seed=42)`) so results are reproducible.
3. **Software pass.** `scipy.signal.convolve2d(img, k, mode='valid')` is timed per image with `perf_counter`. The result is the golden reference for correctness AND the baseline for the speedup comparison.
4. **Hardware pass.** For each image, pack the config header + pixel payload into the send buffer, issue MM2S and S2MM DMA transfers, wait on both channels, unpack the result. Time the round-trip.
5. **Compare.** The notebook uses the CPU result as the correctness reference — a full bitwise diff across 20,000+ 60-wide frames would catch any saturation, edge, kernel-orientation, or packing bug that a narrower simulation might miss.

### Why this is not redundant with simulation

The UVM testbench covers 12 image sizes × ~40 random transactions each (bounded by coverage closure) = a few hundred frames with fully visible waveforms. The on-board benchmark runs **40,000 frames at random heights up to 1000 pixels** — that is more than two orders of magnitude more data, at real silicon timing, through the real DMA path. A timing bug that manifests only under sustained DMA activity, or a data-pattern-dependent corner in the MAC pipeline, would show up here and not in sim.

Backpressure is also exercised differently: the UVM read driver randomizes `TREADY`, while the on-board DMA pulls as fast as DDR will allow — both representative of real operating conditions.

### What the results confirm

The notebook's two summary cells print:

- **Test A (W=16):** CPU mean 5.913 ms, FPGA mean 0.820 ms, **7.21× speedup**.
- **Test B (W=60):** CPU mean 29.730 ms, FPGA mean 1.116 ms, **26.63× speedup**.

See `docs/06_results.md` for the full tables and analysis against the original performance goal.

### Committed evidence

| File | What it shows |
|---|---|
| `sw/Benchmark_Arm_and_Acclerator_after_implimentation.ipynb` | Full on-board methodology, source, cell outputs |
| `docs/images/benchmarks/fpga_vs_cpu_latency.png` | Scatter + binned-mean latency vs image height, log scale, both tests |
| `sw/results/timing_summary.txt` | The summary tables copied out of the notebook for standalone reading |

## What Each Layer Proves

| Concern | UVM sim | On-board notebook |
|---|---|---|
| MAC arithmetic is correct | ✓ | ✓ |
| Kernel orientation is convolution (not correlation) | ✓ | ✓ |
| Saturation clamps at 0 / 255 | ✓ | ✓ |
| Row-done + base-lane rotation is correct | ✓ | ✓ (indirectly, via multi-row frames) |
| Result packer handles tail padding correctly | ✓ | ✓ |
| Back-to-back frames don't bleed state | implicit (coverage loop reuses DUT) | ✓ explicit (20k frames per test) |
| Packaged IP + block design are correct | — | ✓ |
| DMA driver round-trip is correct | — | ✓ |
| Timing closure at 125 MHz holds under sustained load | — | ✓ |
| Behaviour at heights > 60 (beyond trained coverage) | — | ✓ |

Passing both layers independently is the argument that the IP works.

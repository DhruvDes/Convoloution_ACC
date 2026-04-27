# Convolution Accelerator for PYNQ-Z2
A 3×3 kernel 2D convolution accelerator targeting the Zynq-7000.
Streams pixels via AXI4-Stream, achieves 1 image/~8ms on supported inputs.
- Check document backlinks for more indepth information
- Check [sw/Demo/DeviceDemo.ipynb](sw/Demo/DeviceDemo.ipynb) to watch the design in action.

## Team members  
- Dhruv Deshmukh(dad10090)
- Faiza Zahin Tasfia(ft2335)
- Luka Kitamura (lk3283)
  
<!-- ## IP Description: Hardware Convolution Accelerator

The intended functionality of this IP is to perform high-speed, deterministic 2-dimensional convolution operations on image data. Unlike a general-purpose CPU that executes instructions sequentially, this IP is a dedicated data-path designed to ingest pixel streams and apply a 3 × 3 filter kernel in a single pass. It is designed to offload the most mathematically expensive layer of convolutional from the host processor to a specialized hardware.

### Mathematical Operation

At its core, the IP performs a series of Multiply-Accumulate (MAC) operations. For an input image I, and a kernel K, the value of an output pixel S at position (i,j) is defined by:
$$S(i, j) = \sum_{m} \sum_{n} I(i+m, j+n) \cdot K(m, n)$$
<br>This means that it takes a 3x3 matrix multiplication of the matrix wih the kernel and sums up the results to create one pixel. 
<img width="750" height="353" alt="image" src="https://github.com/user-attachments/assets/d3cddaeb-37a1-4812-89fe-6175a7b3d078" />
<br>*Credit:* https://www.researchgate.net/figure/An-example-of-convolution-operation-in-2D-2_fig3_324165524 

For a standard 3×3 kernel, this requires 9 multiplications and 8 additions per single output pixel. To process the 28,000 images in the benchmark, the system must perform over 197 million of these operations.

#### The MAC Structure:
To process one pixel per clock cycle, the design utilizes a Parallel Multiply-Accumulate (MAC) Tree:

-    9 Parallel Multipliers: Each of the 9 pixels in the current 3×3 window is multiplied by its corresponding kernel weight simultaneously.

-    Pipelined Adder Tree: A 3-stage adder tree sums the 9 products. Pipelining is used here to ensure the design meets the 100MHz+ timing requirements on the Zynq-7000 fabric.
    
### The Inefficiency of General-Purpose Fetching

Standard processors follow the Von Neumann architecture, where every single operation requires fetching an instruction and data from memory. For a 3×3 convolution on a 28x28 image:
- The CPU approach: To calculate 1 output pixel, the CPU may fetch 9 input pixels. As the window slides, it fetches those same pixels again for the next output. This creates a massive redundant traffic on the memory bus. additionally, the cache memory is also being used by other processes. 
- The Benchmark Reality: Looking at the ARM results (103.5s), the program is likely "stalled," waiting for data to arrive from the SD card or slower memory.
  
### Specialized Data Reuse (The Accelerator Advantage)

A dedicated Convolution Accelerator (ACC) eliminates this "memory Tax" by implementing line buffers. Instead of hitting the SD card for every sliding window, this project chooses to impliment:
- The ACC reads a line of pixel once.
- It stores it in a local hardware buffer (BRAM) implimended as line buffer.
- It reuses that pixel for every overlapping convolution window simultaneously, and only needs slow reads to fill in a line while its alreay working on data.
- Result we theoretically reduce the memory bandwidth requirement, allowing for the computation as the data is streaming.

### Comparing the Benchmarks

The disparity in the benchmarks calls for optimization:
Platform Total Time (28k 28x28 greyscale Images)	Inference
x86 Platform	4.5s	high-speed caches hide the memory latency, but at the cost of massive power consumption and complex out-of-order execution.
ARM Platform	103.5s	Represents the "edge" reality. Without high-end caches, the processor is strangled by memory access times.
Below are the benchmarks taken from the devices originally and using SciPy library for best performance.
- x86    
<img width="100%" alt="Convolution performance on x86 architecture" src="https://github.com/DhruvDes/Convoloution_ACC/blob/main/Benchmarking/convolution_benchmark_x86.png?raw=true" />
- ARM
<img width="100%" alt="Convolution performance on ARM architecture" src="https://github.com/DhruvDes/Convoloution_ACC/blob/main/[2]_Benchmarking/convolution_benchmark_ARM.png?raw=true" />

### Conclusion: Efficiency over Brute Force

The motivation for this project is not just to be faster than ARM, but to use data smarter. By designing hardware that is aware of the convolution's sliding-window nature, this project can:

   - Minimize SD/RAM reads.
   - Potentially minimize time by keeping data local to the math units.
   - Allow for a 28×28 grayscale operation (and eventually much larger models with colors) to run in milliseconds on the ZYNQ.

## IP architecture
The overall high level architecture of the design is shown below.<br>
<img width="960" height="540" alt="overall_design" src="https://github.com/user-attachments/assets/e26d2a51-3b23-477f-8925-64f3b7d72c3b" />
In detail requirements of the design is provided in; **design_req.md** -->
![Imp_img](https://github.com/DhruvDes/Convoloution_ACC/blob/main/docs/images/impl/implimented_floorplan.png)





## Documentation
| Topic | File |
|---|---|
| What it does (operations, math) | [docs/01_operations.md](docs/01_operations.md) |
| Interfaces (AXI signals, register map) | [docs/02_interfaces.md](docs/02_interfaces.md) |
| Architecture (block diagram, modules) | [docs/03_architecture.md](docs/03_architecture.md) |
| Design efficiency (pipelining, reuse) | [docs/04_efficiency.md](docs/04_efficiency.md) |
| Verification (sim + on-board) | [docs/05_verification.md](docs/05_verification.md) |
| Results (utilization, timing, throughput) | [docs/06_results.md](docs/06_results.md) |
| How to reproduce | [docs/07_build_instructions.md](docs/07_build_instructions.md) |

## Headline Results
- **Throughput:** 1 image /~8ms on PYNQ-Z2 @ 125 MHz
- **Speedup vs ARM:** [26.63]× on the benchmark
- **Resource use:** [17%], [5%], [6%] of xc7z020clg400-1
- **Functional accuracy:** [1458880]/[1458880] images match scipy.signal.convolve2d reference

 ## Quick Start
- Reproduce simulation and bitstream: run `vivado -mode batch -source run.tcl -notrace` in main directory
- Cleanup after simulation and bitstream : `tlcsh cleanup.tcl`
- Run on board: open `sw/Demo/DeviceDemo.ipynb` in PYNQ Jupyter

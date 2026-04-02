# Convoloution Acc For ZYNQ 

## GitHub repo provided 
- https://github.com/DhruvDes/Convoloution_ACC

## Team members  
- Dhruv Deshmukh(dad10090)
- Faiza Zahin Tasfia(ft2335)
  
## IP Description: Hardware Convolution Accelerator

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
<img width="100%" alt="Convolution performance on ARM architecture" src="https://github.com/DhruvDes/Convoloution_ACC/blob/main/Benchmarking/convolution_benchmark_ARM.png?raw=true" />

### Conclusion: Efficiency over Brute Force

The motivation for this project is not just to be faster than ARM, but to use data smarter. By designing hardware that is aware of the convolution's sliding-window nature, this project can:

   - Minimize SD/RAM reads.
   - Potentially minimize time by keeping data local to the math units.
   - Allow for a 28×28 grayscale operation (and eventually much larger models with colors) to run in milliseconds on the ZYNQ.

## IP architecture
The overall high level architecture of the design is shown below.<br>
<img width="960" height="540" alt="overall_design" src="https://github.com/user-attachments/assets/e26d2a51-3b23-477f-8925-64f3b7d72c3b" />
#### IP Interfaces & System Integration

The IP is designed to sit on the AXI High-Performance (HP) Bus of the Zynq-7000.

  - Data Interface (AXI4-Stream): * S_AXIS: Ingests raw 8-bit pixel data from the PS (via DMA).

   -   M_AXIS: Streams the processed 8-bit (truncated) pixels back to DDR memory.

  - Configuration Interface (AXI4-Lite): Allows the ARM processor to write 3×3 kernel weights and start/stop the accelerator via memory-mapped I/O.

   - Interrupts: A dedicated *_introut line signals the PS when an image frame has been fully processed.

   To ensure system stability and performance, this project integrates the following standard Xilinx IP cores:

   - AXI Direct Memory Access (DMA): Used to offload pixel transfers from the CPU, allowing the ARM core to perform other tasks while the FPGA processes the image.

  - AXI-Stream Infrastructure: Utilizes AXI-Stream Data FIFOs to handle clock domain crossing and buffering between the high-speed PS and the IP core.

  - Zynq7 Processing System: Configured to expose the M_AXI_GP (for control) and S_AXI_HP (for data) ports.

### IP sub-modules 
#### BUI(Bus Interface)
This will be the top most module. Which will be connected and interfaced with the AMD's DDR DMA access as shown, and encompassing all the other modules described.<br>
<img width="1334" height="664" alt="Screenshot 2026-04-01 181131" src="https://github.com/user-attachments/assets/fd111ae6-1fe3-4a6c-8ad5-27f6199b0fe7" />
This will be largely consisting of AXI4-stream to communicate with the host, and interrupt signals to inform the stop of pixel data and not nessirarraly the completion of the image. 
The primary data path uses the AXI4-Stream (AXIS) protocol. This is a point-to-point interface designed for high-throughput data without the overhead of addresses.

  ##### Interface Type: AXI4-Stream (Master and Slave).

  Transaction Flow: The AXI DMA (an AMD IP) acts as the bridge. It reads pixels from DDR memory via AXI4-Memory Mapped (MM) and "pushes" them into our IP via the S_AXIS interface.
    Key Signals:
  
-  TDATA [64:0]: Carries the 8, 8-bit grayscale pixel value.
  
 -  TVALID: Asserted by the source when data is ready.
  -  TREADY: Asserted by our IP when it is ready to consume a pixel (Backpressure).
  
 -   TLAST: Asserted on the last pixel of an image row/frame to signal packet completion.

2. Control Plane: PS ↔ IP (Configuration & Status)

For non-streaming data like kernel coefficients and start/stop commands, the IP implements an AXI4-Lite interface. This allows the ARM processor to treat the IP like a set of memory addresses.

   ##### Interface Type: AXI4-Lite (Slave).

  Register Map (32-bit offset):

  - 0x00: Control Reg (Bit 0: Start, Bit 1: Reset, Bit 2: Interrupt Enable).

- 0x04: Status Reg (Bit 0: Idle, Bit 1: Done).
 - [0:8]: Kernel Coefficients (9 registers storing K0,0​ through K2,2​).

    - 0x30: Image Width (Number of pixels per row).

    Key Signals: AWADDR, WDATA, WSTRB, BRESP (Standard AXI-Lite handshaking).

#### Control Logic
This module will be in charge of orchestrating the intire flow of the system namley handelling the interrupts for the BUI and activating rest of the modules. 

#### Cntrl Reg
This module will be used for writing the kernel data and a few control signals roughly a 8x10 memory.  

#### Line Buffer 
A line buffer to recieve nebhouring pixel data and making the computation to not fetch same row data multiple times. There will be 4 of these rows. 4 rows are used specifically to be loading in data while other 3 are being used. 

#### MUX
This module will be in charge of choosing the line buffer to use according to the instructions form the Control Logic module. 

#### MAC and Truncate Unit
This module will be responsible for carrying out the actual computation for given data by the muxes. It will not have any knowledge on other devices or positioning of the matrix.
It may be implimented in 2 diffrent ways depending on the timing analysis. 
1. Taking advantage of the 220 DSP slices which can multiply in one clk cycle. We will only need 18 of them.
   <img width="930" height="154" alt="image" src="https://github.com/user-attachments/assets/177b1aea-bb18-4aa8-8fd4-7234f82e24ce" />
  - It is possible as according to timing report there is  a lot more head room to complete computation in a single cycle.

2. Taking advantage of 3x3 systollic array. Increasign latency but negating any timing violations. 

#### Write-Back Memory
This module will store the data from the MAC and Truncate unit, and send back the using the BUI. A 8x64 buffer memory to be read by the main device through the BUI.

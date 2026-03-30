# Convoloution Acc For ZYNQ 

## GitHub repo provided 
- The student has provided a GitHub repository link: https://github.com/DhruvDes/FPGA-ACC-MAC, which contains the project outline with all required information.

## Team members  
- Dhruv Deshmukh(dad10090)
- Fiaza
  
## IP motivation & functionality 
The primary bottleneck in image processing isn't just the speed of the processor, but of moving data. In general-purpose architectures (x86 and ARM), the CPU spends time fetching pixels from memory (RAM or SD card) compared to the time it spends actually calculating the convolution.

1. The Inefficiency of General-Purpose Fetching

Standard processors follow the von Neumann architecture, where every single operation requires fetching an instruction and data from memory. For a 3×3 convolution on a 28×28 image:
- The CPU approach: To calculate one output pixel, the CPU may fetch 9 input pixels. As the window slides, it fetches those same pixels again for the next output. This creates massive redundant traffic on the memory bus. Not to mention the Cache memory aslo being used by other processes. 
- The Benchmark Reality: Looking at the ARM results (103.5s), the processor is likely "stalled" waiting for data to arrive from the SD card or slow memory. Even though the CPU load is at ~45%, it isn't being productive, it is idling while waiting for the next byte.

2. Specialized Data Reuse (The Accelerator Advantage)

A dedicated Convolution Accelerator (ACC) eliminates this "Memory Tax" by implementing Line Buffers. Instead of hitting the SD card for every sliding window:
With the way this project chooses to impliment. 
- The ACC reads a line of pixel once.
- It stores it in a local hardware buffer (BRAM) implimended as line Buffer.
- It reuses that pixel for every overlapping convolution window simultaneously and only needs slow reads to fill in a line while its alreay working on data.
*Result*: We therotically reduce the memory bandwidth requirement, allowing the math to happen as this project have data coming in.

3. Comparing the Benchmarks

The disparity in the benchmarks calls for this optimization:
Platform	Total Time (28k Images)	Inference
x86 Platform	4.5s	High-speed caches hide the memory latency, but at the cost of massive pothis projectr consumption and complex out-of-order execution.
ARM Platform	103.5s	Represents the "Edge" reality. Without high-end caches, the processor is strangled by memory access times, making real-time CV impossible.
These benchmarks this projectre taken from platform that will be used in the final implimentation and librarie(scipy).
- x86    
<img width="100%" alt="Convolution performance on x86 architecture" src="https://github.com/DhruvDes/Convoloution_ACC/blob/main/Benchmarking/convolution_benchmark_x86.png?raw=true" />
- ARM
<img width="100%" alt="Convolution performance on ARM architecture" src="https://github.com/DhruvDes/Convoloution_ACC/blob/main/Benchmarking/convolution_benchmark_ARM.png?raw=true" />
4. Conclusion: Efficiency over Brute Force

The motivation for this project is not just to be faster than ARM, but to use data smarter. By designing hardware that is aware of the convolution's sliding-window nature, this project can:

   - Minimize SD/RAM Reads. energy and time by keeping data local to the math units.
   - Allow a 28×28 grayscale operation (and eventually much larger models with colors) to run in millisecondso on the ZYNQ.

## Part d: IP sub-modules 

- 0.0 / 5.0 	The student's solution does not describe the hardware modules in the IP and what they do. The student is encouraged to include this information to meet the requirements.
## Part d: Use of large monolithic module
- 0.0 / -2.0 	The student's solution does not provide information about the use of a large monolithic module. The student is encouraged to consider breaking the module into smaller sub-modules to improve parallelism and modularity.
## Part d: IP interfaces 
- 0.0 / 5.0 	The student's solution does not describe the interfaces betthis projecten the modules and betthis projecten the host/PS and the IP. The student is encouraged to include this information to meet the requirements.
## Part d: Use of existing AMD IPs 	
- 0.0 / -1.0 	The student's solution does not indicate the use of existing AMD IPs. The student is encouraged to consider using existing AMD IPs if applicable.

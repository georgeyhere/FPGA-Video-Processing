# Video Filtering on Artix-7 FPGA

- This project implements a video processing pipeline that captures video data from an OV7670 camera and applies a Gaussian lowpass filter and a Sobel edge detection filter.


__High-level Overview__
- High level system design
- Will be made more readable once project is complete, apologies for poor handwriting
![top]https://github.com/georgeyhere/Edge-Detection/tree/master/docs/images/sys_top.jpg)


- Kernel Processor high-level design
![top]https://github.com/georgeyhere/Edge-Detection/tree/master/docs/images/kp_top.jpg)

- Each block has a 'flush' control signal that's driven by a top-level control module (sys_control) that is not pictured. FIFOs are cleared and memory pointers where applicable are cleared.

- The flush signal is held until the next start of frame indicated by the OV7670 camera.

- The pipeline is flushed whenever a filter is enabled/disabled. 

# Edge Detection

The objective of this project is to take 640x480 VGA data from an OV7670 camera and show a filtered image on a VGA monitor using a Gaussian Blur and a Sobel Operator. Coded in Vivado and implemented on Zynq-7000 SoC. Logic runs on 120Mhz clock (tentaive), camera runs on 24Mhz clock. 

https://georgeyhere.wixsite.com/fpga

Pardon the many git atrocities.

Desired Functionality:

SCCB_config (meets timing)

- Input: start signal from control module

- Output: OV7670 camera instruction register data

- Status: Meets timing. Cleaned up. Needs to be tested with not-yet-written control module.

- Description: transmits preset register values from ROM in accordance to SCCB protocol

camera_interface (meets timing)

- Input: RGB555 data from OV7670, 8-bits wide

- Output: 8-bit R value, 8-bit G value, 8-bit B value

- Status: Meets timing. Cleaned up.

- Description: buffers input data in FIFO and decodes to RGB values

greyscale_fixed_point (meets timing)

- Input: 8-bit RGB from camera_interface

- Output: 8-bit greyscale value

- Status: Meets timing. Cleaned up.

- Description: uses RGB values and the function y = 0.3R + 0.6G + 0.1B where y is the magnitude of grey. This version avoids floating-point: y = (3R + 6G + B) / 10


test-phase1 (meets timing)

- Description: compiles SCCB_config, camera_interface, and greyscale_fixed_point under one project. Timing verified. testcases.xlsx contains sample input data as well as results. ![testbench](https://i.imgur.com/LZ8iQls.png)



As of 1/4/2021: test-phase1 has a testbench and is fully functional. It takes an RGB555 input from the camera and converts each pixel to 8-bit greyscale. 

## Topics Covered:

SCCB (Serial Camera Control Bus) Protocol

- i2c compliant 2-wire protocol used for configuration of the OV7670 camera

Xilinx FIFO Generator

- dual-port FIFO configuration used as buffer

- first-word-fall-through

Image Filtering Algorithms

- Gaussian Blur using 3x3 kernel

- Sobel Edge Detection in x and y directions using two 3x3 kernels

Misc

- Xilinx FIFO Generator IP

- multiple clock domains

Will be updated as I go.

## Timeline:

- 12/20: Complete greyscale block

- 12/25: Complete RTL blocks (byte_combine and byte_convert)

- 1/10: Complete memory configuration

Will be updated as I go.

## Documentation:
OneNote here: 

https://livecsupomona-my.sharepoint.com/:o:/g/personal/georgeyu_cpp_edu/EsdrZqUCATlOs_IW7uZltlMBf9s61p3XAIeNPWgkGv5AwA?e=ZoctIG


More documentation on project completion.

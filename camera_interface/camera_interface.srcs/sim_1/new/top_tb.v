`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2020 08:37:23 PM
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb();

reg clk = 0;
reg pclk = 0;
reg reset_n = 1;
reg href = 1;
reg [7:0] camera_data;
reg greyscaler_ready = 1;
wire byte_converted_valid;
wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;
wire read_fail;

camera_interface_top UUT(
.clk(clk),
.reset_n(reset_n),
.href(href),
.pclk(pclk),
.dout_camera(dout_camera),
.greyscaler_ready(greyscaler_ready),
.byte_converted_valid(byte_converted_valid),
.red(red),
.green(green),
.blue(blue),
.read_fail(read_fail)
);

always begin
#1 clk = ~clk;
#4 pclk = ~pclk;
end
initial begin
href = 1; camera_data = 8'b11110000; 
#4
camera_data <= 8'b11110100;
#20 href = 0; camera_data = 8'b11110000; 
#20 href = 1; camera_data = 8'b11110100; 
end
    
endmodule

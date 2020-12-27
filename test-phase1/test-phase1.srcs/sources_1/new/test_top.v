`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/25/2020 06:29:22 PM
// Design Name: 
// Module Name: test_top
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


module test_top(
input clk, //96 MHz clock
input reset_n, //asynchronous active low reset 
input pclk, //camera pixel clock 
input [7:0] dout_camera, //camera data out
input href, //camera output


output wire [31:0] M_AXIS_RESULT_0_tdata, //output, 32-bit fixed-point greyscale value
output wire M_AXIS_RESULT_0_tvalid //used as feedback to the input module

    );
    
wire valid_0;
wire byte_convert_valid;
wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;
wire read_fail;
wire wr_ack_0;
wire valid_0;
wire M_AXIS_RESULT_0_tready;
wire M_AXIS_RESULT_0_tdata;
wire greyscale_ready;

camera_interface_top UUT1 (
.clk(clk),
.reset_n(reset_n),
.pclk(pclk),
.dout_camera(dout_camera),
.href(href),
.greyscale_ready(greyscale_ready),
.byte_convert_valid(byte_convert_valid),
.red(red),
.green(green),
.blue(blue),
.read_fail(read_fail),
.wr_ack_0(wr_ack_0),
.valid_0(valid_0)
); 

greyscale_top UUT2 (
.clk(clk),
.reset_n(reset_n),
.red(red),
.green(green),
.blue(blue),
.byte_convert_valid(byte_convert_valid),
.greyscale_ready(greyscale_ready),
.M_AXIS_RESULT_0_tready(M_AXIS_RESULT_0_tready),
.M_AXIS_RESULT_0_tdata(M_AXIS_RESULT_0_tdata),
.M_AXIS_RESULT_0_tvalid(M_AXIS_RESULT_0_tvalid)
);
   
    
endmodule

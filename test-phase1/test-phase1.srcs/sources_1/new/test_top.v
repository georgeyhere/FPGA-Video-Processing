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
input vsync,
input pclk, //camera pixel clock 
input [7:0] dout_camera, //camera data out
input href, //camera output
output [7:0] gssn_minion0_out,
output gssn_minion0_valid
    );
    
wire valid_0;
wire byte_convert_valid;
wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;
wire read_fail;
wire wr_ack_0;
wire valid_0;
wire M_AXIS_RESULT_0_tdata;
wire greyscale_ready;
wire [7:0] greyscale_value; 
wire greyscale_valid; //used as feedback to the input module

camera_interface_top UUT_1 (
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

greyscale UUT_2 (
.clk(clk),
.reset_n(reset_n)
,.red(red),
.green(green),
.blue(blue),
.byte_convert_valid(byte_convert_valid),
.greyscale_value(greyscale_value),
.greyscale_valid(greyscale_valid),
.greyscale_ready(greyscale_ready)
);

gaussian_top UUT_3 (
.clk(clk),
.reset_n(reset_n),
.vsync(vsync),
.greyscale_value(greyscale_value),
.greyscale_valid(greyscale_valid),
.greyscale_ready(greyscale_ready),
.gssn_minion0_out(gssn_minion0_out),
.gssn_minion0_valid(gssn_minion0_valid)
);   
    
endmodule

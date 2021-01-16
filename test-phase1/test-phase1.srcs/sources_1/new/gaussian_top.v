`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2021 01:13:08 PM
// Design Name: 
// Module Name: gaussian_top
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


module gaussian_top(
input clk,
input reset_n,
input vsync,
input [7:0] greyscale_value,
input greyscale_valid,
input greyscale_ready,

output gssn_minion0_out,
output gssn_minion0_valid
    );
wire gssn_minion0_ready;
wire gssn_minion1_ready;
wire gssn_minion2_ready;
wire [13:0] pixel_address;
wire [7:0] pixel_value;
wire pixel_valid;
wire minion0_select;
wire minion1_select;
wire minion2_select;
wire [10:0] minion0_target;
wire [10:0] minion1_target;
wire [10:0] minion2_target;
    
gaussian_control UUT_3A (
.clk(clk),
.reset_n(reset_n),
.vsync(vsync),
.greyscale_value(greyscale_value),
.greyscale_valid(greyscale_valid),
.minion0_ready(gssn_minion0_ready),
.minion1_ready(gssn_minion1_ready),
.minion2_ready(gssn_minion2_ready),
.pixel_address(pixel_address),
.pixel_value(pixel_value),
.pixel_valid(pixel_valid),
.minion0_select(minion0_select),
.minion1_select(minion1_select),
.minion2_select(minion2_select),
.minion0_target(minion0_target),
.minion1_target(minion1_target),
.minion2_target(minion2_target)
);    
    
gssn_minion0 UUT_3_0 (
.clk(clk),
.reset_n(reset_n),
.pixel_value(pixel_value),
.pixel_address(pixel_address),
.pixel_valid(pixel_valid),
.minion0_select(minion0_select),
.minion0_target(minion0_target),
.gssn_minion0_out(gssn_minion0_out),
.gssn_minion0_valid(gssn_minion0_valid),
.gssn_minion0_ready(gssn_minion0_ready)
);    
    
  
endmodule

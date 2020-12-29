`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2020 03:47:10 PM
// Design Name: 
// Module Name: greyscale_top
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


module greyscale_top(

input clk,
input reset_n,

input [7:0] red,
input [7:0] green,
input [7:0] blue,
input byte_convert_valid,
input M_AXIS_RESULT_0_tready, //output AXI ready


output wire greyscale_ready,
output wire [31:0] M_AXIS_RESULT_0_tdata, //output, 32-bit fixed-point greyscale value
output wire M_AXIS_RESULT_0_tvalid //used as feedback to the input module
    );

wire S_AXIS_A_0_tready; //AXI protocol 
wire S_AXIS_A_1_tready;
wire S_AXIS_A_2_tready;
wire S_AXIS_B_0_tready;
wire S_AXIS_B_1_tready;
wire S_AXIS_B_2_tready;
wire [31:0] S_AXIS_A_0_tdata;
wire [31:0] S_AXIS_A_1_tdata;
wire [31:0] S_AXIS_A_2_tdata;
wire [31:0] S_AXIS_B_0_tdata;
wire [31:0] S_AXIS_B_1_tdata;
wire [31:0] S_AXIS_B_2_tdata;
wire S_AXIS_A_0_tvalid;
wire S_AXIS_A_1_tvalid;
wire S_AXIS_A_2_tvalid;
wire S_AXIS_B_0_tvalid;
wire S_AXIS_B_1_tvalid;
wire S_AXIS_B_2_tvalid;

     
greyscale_input UUT1 (
.clk(clk),
.reset_n(reset_n),
.red(red),
.green(green),
.blue(blue),
.byte_convert_valid(byte_convert_valid),
.greyscale_ready(greyscale_ready),
.M_AXIS_RESULT_0_tvalid(M_AXIS_RESULT_0_tvalid),
.S_AXIS_A_0_tready(S_AXIS_A_0_tready),
.S_AXIS_A_1_tready(S_AXIS_A_1_tready),
.S_AXIS_A_2_tready(S_AXIS_A_2_tready),
.S_AXIS_B_0_tready(S_AXIS_B_0_tready),
.S_AXIS_B_1_tready(S_AXIS_B_1_tready),
.S_AXIS_B_2_tready(S_AXIS_B_2_tready),
.S_AXIS_A_0_tdata(S_AXIS_A_0_tdata),
.S_AXIS_A_1_tdata(S_AXIS_A_1_tdata),
.S_AXIS_A_2_tdata(S_AXIS_A_2_tdata),
.S_AXIS_B_0_tdata(S_AXIS_B_0_tdata),
.S_AXIS_B_1_tdata(S_AXIS_B_1_tdata),
.S_AXIS_B_2_tdata(S_AXIS_B_2_tdata),
.S_AXIS_A_0_tvalid(S_AXIS_A_0_tvalid),
.S_AXIS_A_1_tvalid(S_AXIS_A_1_tvalid),
.S_AXIS_A_2_tvalid(S_AXIS_A_2_tvalid),
.S_AXIS_B_0_tvalid(S_AXIS_B_0_tvalid),
.S_AXIS_B_1_tvalid(S_AXIS_B_1_tvalid),
.S_AXIS_B_2_tvalid(S_AXIS_B_2_tvalid)
);

greyscale_algorithm UUT2 (
.aclk_0(clk),
.aresetn_0(reset_n),
.M_AXIS_RESULT_0_tdata(M_AXIS_RESULT_0_tdata),
.M_AXIS_RESULT_0_tready(M_AXIS_RESULT_0_tready),
.M_AXIS_RESULT_0_tvalid(M_AXIS_RESULT_0_tvalid),
.S_AXIS_A_0_tdata(S_AXIS_A_0_tdata),
.S_AXIS_A_0_tready(S_AXIS_A_0_tready),
.S_AXIS_A_0_tvalid(S_AXIS_A_0_tvalid),
.S_AXIS_A_1_tdata(S_AXIS_A_1_tdata),
.S_AXIS_A_1_tready(S_AXIS_A_1_tready),
.S_AXIS_A_1_tvalid(S_AXIS_A_1_tvalid),
.S_AXIS_A_2_tdata(S_AXIS_A_2_tdata),
.S_AXIS_A_2_tready(S_AXIS_A_2_tready),
.S_AXIS_A_2_tvalid(S_AXIS_A_2_tvalid),
.S_AXIS_B_0_tdata(S_AXIS_B_0_tdata),
.S_AXIS_B_0_tready(S_AXIS_B_0_tready),
.S_AXIS_B_0_tvalid(S_AXIS_B_0_tvalid),
.S_AXIS_B_1_tdata(S_AXIS_B_1_tdata),
.S_AXIS_B_1_tready(S_AXIS_B_1_tready),
.S_AXIS_B_1_tvalid(S_AXIS_B_1_tvalid),
.S_AXIS_B_2_tdata(S_AXIS_B_2_tdata),
.S_AXIS_B_2_tready(S_AXIS_B_2_tready),
.S_AXIS_B_2_tvalid(S_AXIS_B_2_tvalid)
); 
    
endmodule

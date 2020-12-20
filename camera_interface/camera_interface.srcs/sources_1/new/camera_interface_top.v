`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/19/2020 06:58:49 PM
// Design Name: 
// Module Name: camera_fifo_topProject Name: 
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


module camera_fifo_top(
input clk,
input reset_n,

input href,
input [7:0] camera_data,
input greyscaler_ready,

output reg byte_convert_valid,
output [7:0] red,
output [7:0] green,
output [7:0] blue
);

wire FIFO_WRITE_0_full;
wire wr_rst_busy_0;
wire [7:0] FIFO_WRITE_0_wr_data;
wire FIFO_WRITE_0_wr_en;
wire FIFO_READ_0_empty;
wire [7:0] FIFO_READ_0_rd_data;
wire FIFO_WRITE_0_wr_en;
wire rd_rst_busy_0;
wire FIFO_READ_0_rd_en;
wire byte_convert_valid;
wire FIFO_READ_0_empty;



camera_read_input UUT1 (
.clk(clk),
.reset_n(reset_n),
.href(href),
.camera_data(camera_data),
.FIFO_WRITE_0_full(FIFO_WRITE_0_full),
.wr_rst_busy_0(wr_rst_busy_0),
.FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en)
);

BRAM_1_FIFO UUT2 (
.clk_0(clk),
.rst_0(reset_n),
.wr_rst_busy_0(wr_rst_busy_0),
.rd_rst_busy_0(rd_rst_busy_0),
.FIFO_READ_0_empty(FIFO_READ_0_empty),
.FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
.FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
.FIFO_WRITE_0_full(FIFO_WRITE_0_full),
.FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en)
);

camera_fifo_output UUT3 (
.clk(clk),
.reset_n(reset_n),
.FIFO_READ_0_empty(FIFO_READ_0_empty),
.FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
.rd_rst_busy_0(rd_rst_busy_0),
.greyscaler_ready(greyscaler_ready),
.FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
.byte_convert_valid(byte_convert_valid),
.red(red),
.green(green),
.blue(blue)
);



endmodule

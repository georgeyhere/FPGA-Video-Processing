`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2020 03:52:33 PM
// Design Name: 
// Module Name: camera_interface_top
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


module camera_interface_top(
input clk, //96 MHz clock
input reset_n, //asynchronous active low reset 
input pclk, //camera pixel clock 
input [7:0] dout_camera, //camera data out
input href, //camera output
input greyscale_ready,

output byte_convert_valid,

output [7:0] red,
output [7:0] green,
output [7:0] blue,

output read_fail,
output wr_ack_0,
output valid_0
    );
    
wire FIFO_READ_0_empty;
wire [7:0] FIFO_READ_0_rd_data;
wire FIFO_READ_0_rd_en;
wire FIFO_WRITE_0_full;
wire [7:0] FIFO_WRITE_0_wr_data;
wire FIFO_WRITE_0_wr_en;
wire clk_0;
wire rd_rst_busy_0;
wire wr_rst_busy_0;


    
camera_interface_input UUT_1A (
.clk(clk),
.reset_n(reset_n),
.pclk(pclk),
.dout_camera(dout_camera),
.href(href),
.wr_rst_busy_0(wr_rst_busy_0),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
.FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data)
);

BRAM_1_FIFO UUT_1B (
.rd_clk_0(clk),
.wr_clk_0(clk),
.FIFO_READ_0_empty(FIFO_READ_0_empty),
.FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
.FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
.FIFO_WRITE_0_full(FIFO_WRITE_0_full),
.FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
.rd_rst_busy_0(rd_rst_busy_0),
.rst_0(~reset_n),
.wr_rst_busy_0(wr_rst_busy_0),
.valid_0(valid_0),
.wr_ack_0(wr_ack_0)
);

camera_interface_output UUT_1C (
.clk(clk),
.reset_n(reset_n),
.FIFO_READ_0_empty(FIFO_READ_0_empty),
.FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
.rd_rst_busy_0(rd_rst_busy_0),
.greyscale_ready(greyscale_ready),
.FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
.red(red),
.green(green),
.blue(blue),
.valid_0(valid_0),
.byte_convert_valid(byte_convert_valid),
.href(href),
.wr_ack_0(wr_ack_0),
.pclk(pclk)
);

    
endmodule

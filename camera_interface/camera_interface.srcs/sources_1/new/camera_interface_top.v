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

output reg byte_converted_valid,
output reg [7:0] red,
output reg [7:0] green,
output reg [7:0] blue,

output reg read_fail
    );
    
wire FIFO_READ_0_empty;
wire [7:0] FIFO_READ_0_rd_data;
wire FIFO_READ_0_rd_en;
wire FIFO_WRITE_0_full;
wire FIFO_WRITE_0_wr_data;
wire FIFO_WRITE_0_wr_en;
wire clk_0;
wire rd_rst_busy_0;
wire rst_0;
wire wr_rst_busy_0;
    
camera_interface_input UUT1 (
.clk(clk),
.reset_n(reset_n),
.pclk(pclk),
.dout_camera(dout_camera),
.href(href),
.FIFO_WRITE_0_full(FIFO_WRITE_0_full),
.wr_rst_busy_0(wr_rst_busy_0),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
.FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data)
);

BRAM_1_FIFO UUT2 (
.FIFO_READ_0_empty(FIFO_READ_0_empty),
.FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
.FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
.FIFO_WRITE_0_full(FIFO_WRITE_0_full),
.FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
.clk_0(clk_0),
.rd_rst_busy_0(rd_rst_busy_0),
.rst_0(rst_0),
.wr_rst_busy_0(wr_rst_busy_0)
);

camera_interface_output UUT3 (
.clk(clk),
.reset_n(reset_n),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
.FIFO_READ_0_empty(FIFO_READ_0_empty),
.FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
.rd_rst_busy_0(rd_rst_busy_0),
.greyscale_ready(greyscale_ready),
.FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
.byte_converted_valid(byte_converted_valid),
.red(red),
.green(green),
.blue(blue),
.read_fail(read_fail)
);

    
endmodule

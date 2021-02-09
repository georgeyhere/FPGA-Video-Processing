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
//The camera interface writes incoming data on the negative edge of pclk to a FIFO buffer

module camera_interface_top(
input clk, //125 MHz clock
input reset_n, //asynchronous active low reset 
input system_start,
input pclk, //camera pixel clock 
input href, //camera output
input vsync, //camera output
input [7:0] camera_dout, //camera data out

input greyscale_ready,

output frame_done,
output rgb_valid,
output [7:0] red,
output [7:0] green,
output [7:0] blue
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


    
camera_interface_input UUT_3A_INPUT (
.clk(clk),
.reset_n(reset_n),
.system_start(system_start),
.pclk(pclk),
.camera_dout(camera_dout),
.href(href),
.wr_rst_busy_0(wr_rst_busy_0),
.FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
.FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
.frame_done(frame_done)
);

BRAM_1_FIFO_wrapper UUT_3B_BRAM (
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

camera_interface_output UUT_3C_OUTPUT (
.clk(clk),
.reset_n(reset_n),
.system_start(system_start),
.FIFO_READ_0_empty(FIFO_READ_0_empty),
.FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
.rd_rst_busy_0(rd_rst_busy_0),
.greyscale_ready(greyscale_ready),
.FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
.red(red),
.green(green),
.blue(blue),
.valid_0(valid_0),
.rgb_valid(rgb_valid),
.href(href),
.wr_ack_0(wr_ack_0),
.pclk(pclk)
);

    
endmodule

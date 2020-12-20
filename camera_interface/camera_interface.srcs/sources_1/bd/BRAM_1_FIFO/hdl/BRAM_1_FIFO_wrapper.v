//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Sat Dec 19 14:49:14 2020
//Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
//Command     : generate_target BRAM_1_FIFO_wrapper.bd
//Design      : BRAM_1_FIFO_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BRAM_1_FIFO_wrapper
   (FIFO_READ_0_empty,
    FIFO_READ_0_rd_data,
    FIFO_READ_0_rd_en,
    FIFO_WRITE_0_full,
    FIFO_WRITE_0_wr_data,
    FIFO_WRITE_0_wr_en,
    clk_0,
    rd_rst_busy_0,
    rst_0,
    wr_rst_busy_0);
  output FIFO_READ_0_empty;
  output [7:0]FIFO_READ_0_rd_data;
  input FIFO_READ_0_rd_en;
  output FIFO_WRITE_0_full;
  input [7:0]FIFO_WRITE_0_wr_data;
  input FIFO_WRITE_0_wr_en;
  input clk_0;
  output rd_rst_busy_0;
  input rst_0;
  output wr_rst_busy_0;

  wire FIFO_READ_0_empty;
  wire [7:0]FIFO_READ_0_rd_data;
  wire FIFO_READ_0_rd_en;
  wire FIFO_WRITE_0_full;
  wire [7:0]FIFO_WRITE_0_wr_data;
  wire FIFO_WRITE_0_wr_en;
  wire clk_0;
  wire rd_rst_busy_0;
  wire rst_0;
  wire wr_rst_busy_0;

  BRAM_1_FIFO BRAM_1_FIFO_i
       (.FIFO_READ_0_empty(FIFO_READ_0_empty),
        .FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
        .FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
        .FIFO_WRITE_0_full(FIFO_WRITE_0_full),
        .FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
        .FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
        .clk_0(clk_0),
        .rd_rst_busy_0(rd_rst_busy_0),
        .rst_0(rst_0),
        .wr_rst_busy_0(wr_rst_busy_0));
endmodule

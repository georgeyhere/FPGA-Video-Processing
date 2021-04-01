//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Wed Mar 31 19:03:44 2021
//Host        : LAPTOP-H7O8ATU0 running 64-bit major release  (build 9200)
//Command     : generate_target CamRead_FIFO_wrapper.bd
//Design      : CamRead_FIFO_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module CamRead_FIFO_wrapper
   (FIFO_READ_0_empty,
    FIFO_READ_0_rd_data,
    FIFO_READ_0_rd_en,
    FIFO_WRITE_0_full,
    FIFO_WRITE_0_wr_data,
    FIFO_WRITE_0_wr_en,
    rd_clk_0,
    rst_0,
    valid_0,
    wr_ack_0,
    wr_clk_0);
  output FIFO_READ_0_empty;
  output [7:0]FIFO_READ_0_rd_data;
  input FIFO_READ_0_rd_en;
  output FIFO_WRITE_0_full;
  input [7:0]FIFO_WRITE_0_wr_data;
  input FIFO_WRITE_0_wr_en;
  input rd_clk_0;
  input rst_0;
  output valid_0;
  output wr_ack_0;
  input wr_clk_0;

  wire FIFO_READ_0_empty;
  wire [7:0]FIFO_READ_0_rd_data;
  wire FIFO_READ_0_rd_en;
  wire FIFO_WRITE_0_full;
  wire [7:0]FIFO_WRITE_0_wr_data;
  wire FIFO_WRITE_0_wr_en;
  wire rd_clk_0;
  wire rst_0;
  wire valid_0;
  wire wr_ack_0;
  wire wr_clk_0;

  CamRead_FIFO CamRead_FIFO_i
       (.FIFO_READ_0_empty(FIFO_READ_0_empty),
        .FIFO_READ_0_rd_data(FIFO_READ_0_rd_data),
        .FIFO_READ_0_rd_en(FIFO_READ_0_rd_en),
        .FIFO_WRITE_0_full(FIFO_WRITE_0_full),
        .FIFO_WRITE_0_wr_data(FIFO_WRITE_0_wr_data),
        .FIFO_WRITE_0_wr_en(FIFO_WRITE_0_wr_en),
        .rd_clk_0(rd_clk_0),
        .rst_0(rst_0),
        .valid_0(valid_0),
        .wr_ack_0(wr_ack_0),
        .wr_clk_0(wr_clk_0));
endmodule

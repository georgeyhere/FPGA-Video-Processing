//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Mon Jan 11 13:45:32 2021
//Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
//Command     : generate_target BRAM_gssn_0_wrapper.bd
//Design      : BRAM_gssn_0_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module BRAM_gssn_0_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_we,
    BRAM_PORTB_0_addr,
    BRAM_PORTB_0_clk,
    BRAM_PORTB_0_dout,
    BRAM_PORTB_0_en,
    BRAM_PORTB_0_rst,
    rsta_busy_0,
    rstb_busy_0);
  input [13:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [7:0]BRAM_PORTA_0_din;
  input [0:0]BRAM_PORTA_0_we;
  input [13:0]BRAM_PORTB_0_addr;
  input BRAM_PORTB_0_clk;
  output [7:0]BRAM_PORTB_0_dout;
  input BRAM_PORTB_0_en;
  input BRAM_PORTB_0_rst;
  output rsta_busy_0;
  output rstb_busy_0;

  wire [13:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [7:0]BRAM_PORTA_0_din;
  wire [0:0]BRAM_PORTA_0_we;
  wire [13:0]BRAM_PORTB_0_addr;
  wire BRAM_PORTB_0_clk;
  wire [7:0]BRAM_PORTB_0_dout;
  wire BRAM_PORTB_0_en;
  wire BRAM_PORTB_0_rst;
  wire rsta_busy_0;
  wire rstb_busy_0;

  BRAM_gssn_0 BRAM_gssn_0_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we),
        .BRAM_PORTB_0_addr(BRAM_PORTB_0_addr),
        .BRAM_PORTB_0_clk(BRAM_PORTB_0_clk),
        .BRAM_PORTB_0_dout(BRAM_PORTB_0_dout),
        .BRAM_PORTB_0_en(BRAM_PORTB_0_en),
        .BRAM_PORTB_0_rst(BRAM_PORTB_0_rst),
        .rsta_busy_0(rsta_busy_0),
        .rstb_busy_0(rstb_busy_0));
endmodule

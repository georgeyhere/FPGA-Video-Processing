//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Thu Dec 24 17:53:25 2020
//Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
//Command     : generate_target BRAM_1_FIFO.bd
//Design      : BRAM_1_FIFO
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "BRAM_1_FIFO,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=BRAM_1_FIFO,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "BRAM_1_FIFO.hwdef" *) 
module BRAM_1_FIFO
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
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 EMPTY" *) output FIFO_READ_0_empty;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_DATA" *) output [7:0]FIFO_READ_0_rd_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_EN" *) input FIFO_READ_0_rd_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 FULL" *) output FIFO_WRITE_0_full;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_DATA" *) input [7:0]FIFO_WRITE_0_wr_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_EN" *) input FIFO_WRITE_0_wr_en;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN BRAM_1_FIFO_clk_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_0;
  output rd_rst_busy_0;
  input rst_0;
  output wr_rst_busy_0;

  wire FIFO_READ_0_1_EMPTY;
  wire [7:0]FIFO_READ_0_1_RD_DATA;
  wire FIFO_READ_0_1_RD_EN;
  wire FIFO_WRITE_0_1_FULL;
  wire [7:0]FIFO_WRITE_0_1_WR_DATA;
  wire FIFO_WRITE_0_1_WR_EN;
  wire clk_0_1;
  wire fifo_generator_0_rd_rst_busy;
  wire fifo_generator_0_wr_rst_busy;
  wire rst_0_1;

  assign FIFO_READ_0_1_RD_EN = FIFO_READ_0_rd_en;
  assign FIFO_READ_0_empty = FIFO_READ_0_1_EMPTY;
  assign FIFO_READ_0_rd_data[7:0] = FIFO_READ_0_1_RD_DATA;
  assign FIFO_WRITE_0_1_WR_DATA = FIFO_WRITE_0_wr_data[7:0];
  assign FIFO_WRITE_0_1_WR_EN = FIFO_WRITE_0_wr_en;
  assign FIFO_WRITE_0_full = FIFO_WRITE_0_1_FULL;
  assign clk_0_1 = clk_0;
  assign rd_rst_busy_0 = fifo_generator_0_rd_rst_busy;
  assign rst_0_1 = rst_0;
  assign wr_rst_busy_0 = fifo_generator_0_wr_rst_busy;
  BRAM_1_FIFO_fifo_generator_0_0 fifo_generator_0
       (.clk(clk_0_1),
        .din(FIFO_WRITE_0_1_WR_DATA),
        .dout(FIFO_READ_0_1_RD_DATA),
        .empty(FIFO_READ_0_1_EMPTY),
        .full(FIFO_WRITE_0_1_FULL),
        .rd_en(FIFO_READ_0_1_RD_EN),
        .rd_rst_busy(fifo_generator_0_rd_rst_busy),
        .rst(rst_0_1),
        .wr_en(FIFO_WRITE_0_1_WR_EN),
        .wr_rst_busy(fifo_generator_0_wr_rst_busy));
endmodule

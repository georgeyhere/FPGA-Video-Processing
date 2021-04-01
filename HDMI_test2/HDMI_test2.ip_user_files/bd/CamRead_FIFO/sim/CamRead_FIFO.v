//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Wed Mar 31 19:03:44 2021
//Host        : LAPTOP-H7O8ATU0 running 64-bit major release  (build 9200)
//Command     : generate_target CamRead_FIFO.bd
//Design      : CamRead_FIFO
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "CamRead_FIFO,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=CamRead_FIFO,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=2,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "CamRead_FIFO.hwdef" *) 
module CamRead_FIFO
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
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 EMPTY" *) output FIFO_READ_0_empty;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_DATA" *) output [7:0]FIFO_READ_0_rd_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_read:1.0 FIFO_READ_0 RD_EN" *) input FIFO_READ_0_rd_en;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 FULL" *) output FIFO_WRITE_0_full;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_DATA" *) input [7:0]FIFO_WRITE_0_wr_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE_0 WR_EN" *) input FIFO_WRITE_0_wr_en;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.RD_CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.RD_CLK_0, CLK_DOMAIN CamRead_FIFO_rd_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input rd_clk_0;
  input rst_0;
  output valid_0;
  output wr_ack_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.WR_CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.WR_CLK_0, CLK_DOMAIN CamRead_FIFO_wr_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input wr_clk_0;

  wire FIFO_READ_0_1_EMPTY;
  wire [7:0]FIFO_READ_0_1_RD_DATA;
  wire FIFO_READ_0_1_RD_EN;
  wire FIFO_WRITE_0_1_FULL;
  wire [7:0]FIFO_WRITE_0_1_WR_DATA;
  wire FIFO_WRITE_0_1_WR_EN;
  wire fifo_generator_0_valid;
  wire fifo_generator_0_wr_ack;
  wire rd_clk_0_1;
  wire rst_0_1;
  wire wr_clk_0_1;

  assign FIFO_READ_0_1_RD_EN = FIFO_READ_0_rd_en;
  assign FIFO_READ_0_empty = FIFO_READ_0_1_EMPTY;
  assign FIFO_READ_0_rd_data[7:0] = FIFO_READ_0_1_RD_DATA;
  assign FIFO_WRITE_0_1_WR_DATA = FIFO_WRITE_0_wr_data[7:0];
  assign FIFO_WRITE_0_1_WR_EN = FIFO_WRITE_0_wr_en;
  assign FIFO_WRITE_0_full = FIFO_WRITE_0_1_FULL;
  assign rd_clk_0_1 = rd_clk_0;
  assign rst_0_1 = rst_0;
  assign valid_0 = fifo_generator_0_valid;
  assign wr_ack_0 = fifo_generator_0_wr_ack;
  assign wr_clk_0_1 = wr_clk_0;
  CamRead_FIFO_fifo_generator_0_0 fifo_generator_0
       (.din(FIFO_WRITE_0_1_WR_DATA),
        .dout(FIFO_READ_0_1_RD_DATA),
        .empty(FIFO_READ_0_1_EMPTY),
        .full(FIFO_WRITE_0_1_FULL),
        .rd_clk(rd_clk_0_1),
        .rd_en(FIFO_READ_0_1_RD_EN),
        .rst(rst_0_1),
        .valid(fifo_generator_0_valid),
        .wr_ack(fifo_generator_0_wr_ack),
        .wr_clk(wr_clk_0_1),
        .wr_en(FIFO_WRITE_0_1_WR_EN));
endmodule

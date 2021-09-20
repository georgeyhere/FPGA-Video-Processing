// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sun Sep 19 19:53:33 2021
// Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/work/Documents/repos/Edge-Detection/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_24MHz, clk_25MHz, clk_250MHz, clk_PS, reset, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_24MHz,clk_25MHz,clk_250MHz,clk_PS,reset,clk_in1" */;
  output clk_24MHz;
  output clk_25MHz;
  output clk_250MHz;
  output clk_PS;
  input reset;
  input clk_in1;
endmodule

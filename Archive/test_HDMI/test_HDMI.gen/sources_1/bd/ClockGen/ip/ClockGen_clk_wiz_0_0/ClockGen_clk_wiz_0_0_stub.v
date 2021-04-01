// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Mar 26 20:27:28 2021
// Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/George/Edge-Detection/test_HDMI/test_HDMI.gen/sources_1/bd/ClockGen/ip/ClockGen_clk_wiz_0_0/ClockGen_clk_wiz_0_0_stub.v
// Design      : ClockGen_clk_wiz_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ClockGen_clk_wiz_0_0(SCCB_Clk, xclk, reset, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="SCCB_Clk,xclk,reset,clk_in1" */;
  output SCCB_Clk;
  output xclk;
  input reset;
  input clk_in1;
endmodule

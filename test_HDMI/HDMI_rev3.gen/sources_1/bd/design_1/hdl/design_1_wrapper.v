//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Fri Mar 26 18:40:41 2021
//Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (PClk_0,
    TMDS_Clk_0,
    clk_100MHz,
    reset_rtl_0);
  output PClk_0;
  output TMDS_Clk_0;
  input clk_100MHz;
  input reset_rtl_0;

  wire PClk_0;
  wire TMDS_Clk_0;
  wire clk_100MHz;
  wire reset_rtl_0;

  design_1 design_1_i
       (.PClk_0(PClk_0),
        .TMDS_Clk_0(TMDS_Clk_0),
        .clk_100MHz(clk_100MHz),
        .reset_rtl_0(reset_rtl_0));
endmodule

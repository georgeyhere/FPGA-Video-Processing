// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sun Sep 19 19:57:30 2021
// Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top mem_bram -prefix
//               mem_bram_ mem_bram_stub.v
// Design      : mem_bram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module mem_bram(clka, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[18:0],dina[11:0],clkb,addrb[18:0],doutb[11:0]" */;
  input clka;
  input [0:0]wea;
  input [18:0]addra;
  input [11:0]dina;
  input clkb;
  input [18:0]addrb;
  output [11:0]doutb;
endmodule

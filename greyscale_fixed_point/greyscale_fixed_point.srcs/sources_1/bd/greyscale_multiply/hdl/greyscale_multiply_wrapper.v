//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Tue Dec 29 15:37:45 2020
//Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
//Command     : generate_target greyscale_multiply_wrapper.bd
//Design      : greyscale_multiply_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module greyscale_multiply_wrapper
   (A_0,
    A_1,
    A_2,
    B_0,
    B_1,
    B_2,
    CE_0,
    CLK_0,
    P_0,
    P_1,
    P_2);
  input [7:0]A_0;
  input [7:0]A_1;
  input [7:0]A_2;
  input [7:0]B_0;
  input [7:0]B_1;
  input [7:0]B_2;
  input CE_0;
  input CLK_0;
  output [15:0]P_0;
  output [15:0]P_1;
  output [15:0]P_2;

  wire [7:0]A_0;
  wire [7:0]A_1;
  wire [7:0]A_2;
  wire [7:0]B_0;
  wire [7:0]B_1;
  wire [7:0]B_2;
  wire CE_0;
  wire CLK_0;
  wire [15:0]P_0;
  wire [15:0]P_1;
  wire [15:0]P_2;

  greyscale_multiply greyscale_multiply_i
       (.A_0(A_0),
        .A_1(A_1),
        .A_2(A_2),
        .B_0(B_0),
        .B_1(B_1),
        .B_2(B_2),
        .CE_0(CE_0),
        .CLK_0(CLK_0),
        .P_0(P_0),
        .P_1(P_1),
        .P_2(P_2));
endmodule

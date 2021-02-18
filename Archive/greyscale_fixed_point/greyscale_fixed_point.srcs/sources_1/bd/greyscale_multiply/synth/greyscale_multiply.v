//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Tue Dec 29 15:37:45 2020
//Host        : DESKTOP-MB5IJCE running 64-bit major release  (build 9200)
//Command     : generate_target greyscale_multiply.bd
//Design      : greyscale_multiply
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "greyscale_multiply,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=greyscale_multiply,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "greyscale_multiply.hwdef" *) 
module greyscale_multiply
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.A_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.A_0, LAYERED_METADATA undef" *) input [7:0]A_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.A_1 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.A_1, LAYERED_METADATA undef" *) input [7:0]A_1;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.A_2 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.A_2, LAYERED_METADATA undef" *) input [7:0]A_2;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.B_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.B_0, LAYERED_METADATA undef" *) input [7:0]B_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.B_1 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.B_1, LAYERED_METADATA undef" *) input [7:0]B_1;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.B_2 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.B_2, LAYERED_METADATA undef" *) input [7:0]B_2;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 CE.CE_0 CE" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CE.CE_0, POLARITY ACTIVE_LOW" *) input CE_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN greyscale_multiply_CLK_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input CLK_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.P_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.P_0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency width format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type generated dependency fractwidth format long minimum {} maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}} DATA_WIDTH 16}" *) output [15:0]P_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.P_1 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.P_1, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency width format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type generated dependency fractwidth format long minimum {} maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}} DATA_WIDTH 16}" *) output [15:0]P_1;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.P_2 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.P_2, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency width format long minimum {} maximum {}} value 16} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type generated dependency fractwidth format long minimum {} maximum {}} value 0} signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true}}}}} DATA_WIDTH 16}" *) output [15:0]P_2;

  wire [7:0]A_0_1;
  wire [7:0]A_1_1;
  wire [7:0]A_2_1;
  wire [7:0]B_0_1;
  wire [7:0]B_1_1;
  wire [7:0]B_2_1;
  wire CE_0_1;
  wire CLK_0_1;
  wire [15:0]xbip_dsp48_macro_0_P;
  wire [15:0]xbip_dsp48_macro_1_P;
  wire [15:0]xbip_dsp48_macro_2_P;

  assign A_0_1 = A_0[7:0];
  assign A_1_1 = A_1[7:0];
  assign A_2_1 = A_2[7:0];
  assign B_0_1 = B_0[7:0];
  assign B_1_1 = B_1[7:0];
  assign B_2_1 = B_2[7:0];
  assign CE_0_1 = CE_0;
  assign CLK_0_1 = CLK_0;
  assign P_0[15:0] = xbip_dsp48_macro_0_P;
  assign P_1[15:0] = xbip_dsp48_macro_1_P;
  assign P_2[15:0] = xbip_dsp48_macro_2_P;
  greyscale_multiply_xbip_dsp48_macro_0_0 xbip_dsp48_macro_0
       (.A(A_0_1),
        .B(B_0_1),
        .CE(CE_0_1),
        .CLK(CLK_0_1),
        .P(xbip_dsp48_macro_0_P));
  greyscale_multiply_xbip_dsp48_macro_1_0 xbip_dsp48_macro_1
       (.A(A_1_1),
        .B(B_1_1),
        .CE(CE_0_1),
        .CLK(CLK_0_1),
        .P(xbip_dsp48_macro_1_P));
  greyscale_multiply_xbip_dsp48_macro_2_0 xbip_dsp48_macro_2
       (.A(A_2_1),
        .B(B_2_1),
        .CE(CE_0_1),
        .CLK(CLK_0_1),
        .P(xbip_dsp48_macro_2_P));
endmodule

// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Wed Mar 31 19:02:13 2021
// Host        : LAPTOP-H7O8ATU0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ CamRead_FIFO_fifo_generator_0_0_sim_netlist.v
// Design      : CamRead_FIFO_fifo_generator_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "CamRead_FIFO_fifo_generator_0_0,fifo_generator_v13_2_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (rst,
    wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    wr_ack,
    empty);
  input rst;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN CamRead_FIFO_wr_clk_0, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN CamRead_FIFO_rd_clk_0, INSERT_VIP 0" *) input rd_clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [7:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [7:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  output wr_ack;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;

  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire rst;
  wire wr_ack;
  wire wr_clk;
  wire wr_en;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_rd_rst_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_rst_busy_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [8:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [8:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [8:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "9" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "8" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "8" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "1" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "1" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "6" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "4" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "1" *) 
  (* C_PRELOAD_REGS = "0" *) 
  (* C_PRIM_FIFO_TYPE = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "5" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "6" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "505" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "504" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "9" *) 
  (* C_RD_DEPTH = "512" *) 
  (* C_RD_FREQ = "100" *) 
  (* C_RD_PNTR_WIDTH = "9" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "9" *) 
  (* C_WR_DEPTH = "512" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "25" *) 
  (* C_WR_PNTR_WIDTH = "9" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_fifo_generator_v13_2_5 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(1'b0),
        .data_count(NLW_U0_data_count_UNCONNECTED[8:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[8:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(NLW_U0_rd_rst_busy_UNCONNECTED),
        .rst(rst),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(wr_ack),
        .wr_clk(wr_clk),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[8:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(NLW_U0_wr_rst_busy_UNCONNECTED));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
SFoQ2tXDMrL2nCJbfpmHXuteJlKaWDWl3o9OY1miFvmYb8EDywmDpLUHQktJ/VoW+17fK5WHgFVI
FZV1B91GDQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
mxGWDRjEAsKmBqldxevT1RKZvqK7vn0KlTODVXNGlRcGf9zOAmj0Z7Ppu79POBDb8oNQyCY+2q1q
BddzhQfh5WLIVX9BNUMIF6M6IF0elM4GMSLHGeYEwqSaMPC+thuR8FGj1J7z6rH+43gDYhtIeyY+
ZuZUz/Pqg8Lu63Xwe+0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HLwPjQzkuqv5FEDBriEJS2DikBeIHB/bWuVWooHY5ChdoHatcmqCHpSvnGxVzLwObZWHFys2nR9y
P3zxywjtgtOWq/n3cYVa5li6eyiUmGXv2OE8nw1nLnAY1kzBvGd6VwQ45t6l4Hx5+oqpIfuU2KI2
7/Qpj2atiTN3Y+q5He/BMXLIxF9vWuU6XL/+HsxriGAumcZDuESdidlxOztbW1bFhYr1/qWwou2q
wynnRVKYHL41aWycgFdkDoDEFFxv8ft8+F5Ux+J5Hg5XdgRULJc6uUQE/lDG3zOqzPftlODB52zU
d0cm8gFOvSZ2nO8ZB8THnxoAGe33iIZJfMcefA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
jlR0iZ4fp9QXiFgaT07DMAK1YFLyBpsOGOOR9j2PWImFEh8oTBt4cvmGo+2z1Umbt9OMQwOhyepO
QIsKLFzUXYUba+SFFLBoCiaww24KICecbUfd3VV5sg2bEJjAdtYTT6mJqyc3vQRvBlONeBFdIGy2
AXqdK7QtXGLsLAIF/z4FG8cfG6nSD6e16gccBC6+kl5MoShdnmebKLyoo6UKFdMbDK88sHvTcD9S
LNCau6RK7FkTZg23FV0tf6cTP9Rray9YEcowm2AAh51Wldo2lGJ2W5iiDatRKH/W1bu7FGWZG+OT
+VZE+Ckiuf4T6cuu+G5IbrtMv6a4U93R0gtxXQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
p/kq+JjPPJbOTWT2SRiPJ99/iH6kkVGEiluRRXpuRN+j+cVPgJD1v4QVjw3zMWLlvTGB7OOqC+JG
Lc62Wiizd/BFfGj2JYkTZMatcOWok7A87HK+vRTjr4nZMApD2jKaneJdU1279KsIEeRfImCQ2uRl
QRNMH3PPdNGYCnOGgNk=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kyyI/O29YYc5VBwhz19i7AV7MC75r43hHVKAOTBiGBhRu8zZxCwGGcNFqc2HgHcWC6nq4jCIbIXf
S3FDzPdasegnERlWvoob9/SXM88zKsyeTbUf+DRu5lB8SPROBMaIhnj375C5XLowL17MXZdmB6fV
X5ukCg7cNhCjssKt/bIJibWkfna7hvj4ye+CLWmi3LdEiix8KTwRoBS3ZJrjM4/N6FfZkXerVxs+
txkhdsmG9ga1g/xErhTRilhqrV2WetlpX86qH/64sRGVxrWeEfNoHhMZsqEK0jWDx4WavKt8XY7W
NDzMXLZ2m5Dv5HMiJWgFG+ntPwgiYYtBuwu7Eg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tv6UL1ZWqo3dAIlhN5UTNGzJyqzdHpCqh217JPvIvHiWJgcFh2tw1n7HWnOPcK3VhCt31AGnCEFe
HpTiinXvHna65L2X2HhtNUrsgvZlUuh/oQR273wp5JPFDPD97NQ4ELkGI+w26HTYLgZ70K5rQo87
D4AkQNRuzTRS5G12yb4RU7ZYgmkYLuq1UyqjlxyN62Del4XoqZyivOGw5H+7wlfkNRu98iQwqq12
jthZbH/ue5wxZJUcb7NmEwL+3abpyDNmWs1qORHOFoE3t97/9XMmeSCpM2+KnSKJvsV5VbuoTCOT
964fsEh7ey4IVb4aum095gQjLCqTmDm8DWFmaw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Oxo3AgNmVWgrXtMKDIThYfXr0YJfyFr7Bsjn2ge/G72mb25MA8Dbkd9ZZPtwqU1poazNnTng5Cx5
s8C1zMNEoo38jNY8zEUBjCCuasJgeMo5xsiha+3ZIBiuHS0KLrjLaPFIQZdsYevb44fg6J5YQLn5
jd1M6YdNMd1VwSezDxtbk9sN8ExPrmtwum/6L1ia9j9UlIzPTEaJ60Xz7tloPsgsbkborO2JLiIk
kIAY2q1b8tuhHzJ5DoXlvIo49wSDj75ncLrkwbAd26huob7aOmX1bS34pJLF17JzqYH0MoPJbHxb
RPdD+qUawXFsMSs2fOLnZrNxeG8L+TyAT0N8tQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
CIR/vwxo0IBrPr5+bMp2YuBCQTNBRIIbqgEB18Oewkc8CuHzGCAgPyQUBUKaUG3bBy+KDOPVxBP5
cE/d3QYZAT11fyB1OMMTrjmEIZcr0Vk3nVTAnivoxxxkmdzPjkj0OcGcU9fMArPi3dfTgIsKdtCq
94+mV/70WeprgijzuZFWD7uH+gVioY/+rq/Wc1O6x1n949w8YGgSCTurUvhsobx2bonoC317J0Wm
IX17XRkSBIFgzqA8iC+GV5oCfxIGkihKmXxjIJbMamlOdCOycEkjkh3JYmm7TLNxmI65iffsabR0
t5+iI0l8eJxFhElzWeREqE43cnJYLaKZBUA+DA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 54992)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif

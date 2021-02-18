-makelib ies_lib/xpm -sv \
  "D:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "D:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_4 \
  "../../../../test-phase1.srcs/sources_1/bd/BRAM_gssn_1/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/BRAM_gssn_1/ip/BRAM_gssn_1_blk_mem_gen_0_0/sim/BRAM_gssn_1_blk_mem_gen_0_0.v" \
  "../../../bd/BRAM_gssn_1/sim/BRAM_gssn_1.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib


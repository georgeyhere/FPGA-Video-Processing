-makelib ies_lib/xpm -sv \
  "G:/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "G:/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_5 \
  "../../../../test_HDMI.srcs/sources_1/bd/BRAM_1_FIFO/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_5 \
  "../../../../test_HDMI.srcs/sources_1/bd/BRAM_1_FIFO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib ies_lib/fifo_generator_v13_2_5 \
  "../../../../test_HDMI.srcs/sources_1/bd/BRAM_1_FIFO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../bd/BRAM_1_FIFO/ip/BRAM_1_FIFO_fifo_generator_0_0/sim/BRAM_1_FIFO_fifo_generator_0_0.v" \
  "../../../bd/BRAM_1_FIFO/sim/BRAM_1_FIFO.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib


vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/fifo_generator_v13_2_5
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap fifo_generator_v13_2_5 modelsim_lib/msim/fifo_generator_v13_2_5
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -sv \
"G:/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93 \
"G:/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work fifo_generator_v13_2_5  -incr \
"../../../../test_HDMI.srcs/sources_1/bd/BRAM_1_FIFO/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5  -93 \
"../../../../test_HDMI.srcs/sources_1/bd/BRAM_1_FIFO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -incr \
"../../../../test_HDMI.srcs/sources_1/bd/BRAM_1_FIFO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work xil_defaultlib  -incr \
"../../../bd/BRAM_1_FIFO/ip/BRAM_1_FIFO_fifo_generator_0_0/sim/BRAM_1_FIFO_fifo_generator_0_0.v" \
"../../../bd/BRAM_1_FIFO/sim/BRAM_1_FIFO.v" \

vlog -work xil_defaultlib \
"glbl.v"


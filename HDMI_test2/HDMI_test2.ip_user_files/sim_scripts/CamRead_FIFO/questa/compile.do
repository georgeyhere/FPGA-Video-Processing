vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/fifo_generator_v13_2_5
vlib questa_lib/msim/xil_defaultlib

vmap fifo_generator_v13_2_5 questa_lib/msim/fifo_generator_v13_2_5
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work fifo_generator_v13_2_5  \
"../../../../HDMI_test2.gen/sources_1/bd/CamRead_FIFO/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5  -93 \
"../../../../HDMI_test2.gen/sources_1/bd/CamRead_FIFO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  \
"../../../../HDMI_test2.gen/sources_1/bd/CamRead_FIFO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work xil_defaultlib  \
"../../../bd/CamRead_FIFO/ip/CamRead_FIFO_fifo_generator_0_0/sim/CamRead_FIFO_fifo_generator_0_0.v" \
"../../../bd/CamRead_FIFO/sim/CamRead_FIFO.v" \

vlog -work xil_defaultlib \
"glbl.v"


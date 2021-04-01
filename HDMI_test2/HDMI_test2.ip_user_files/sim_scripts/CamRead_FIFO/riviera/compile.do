vlib work
vlib riviera

vlib riviera/fifo_generator_v13_2_5
vlib riviera/xil_defaultlib

vmap fifo_generator_v13_2_5 riviera/fifo_generator_v13_2_5
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work fifo_generator_v13_2_5  -v2k5 \
"../../../../HDMI_test2.gen/sources_1/bd/CamRead_FIFO/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5 -93 \
"../../../../HDMI_test2.gen/sources_1/bd/CamRead_FIFO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -v2k5 \
"../../../../HDMI_test2.gen/sources_1/bd/CamRead_FIFO/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/CamRead_FIFO/ip/CamRead_FIFO_fifo_generator_0_0/sim/CamRead_FIFO_fifo_generator_0_0.v" \
"../../../bd/CamRead_FIFO/sim/CamRead_FIFO.v" \

vlog -work xil_defaultlib \
"glbl.v"


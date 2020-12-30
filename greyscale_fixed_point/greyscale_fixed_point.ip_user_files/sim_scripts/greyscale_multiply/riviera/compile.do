vlib work
vlib riviera

vlib riviera/xbip_dsp48_wrapper_v3_0_4
vlib riviera/xbip_utils_v3_0_10
vlib riviera/xbip_pipe_v3_0_6
vlib riviera/xbip_dsp48_macro_v3_0_17
vlib riviera/xil_defaultlib

vmap xbip_dsp48_wrapper_v3_0_4 riviera/xbip_dsp48_wrapper_v3_0_4
vmap xbip_utils_v3_0_10 riviera/xbip_utils_v3_0_10
vmap xbip_pipe_v3_0_6 riviera/xbip_pipe_v3_0_6
vmap xbip_dsp48_macro_v3_0_17 riviera/xbip_dsp48_macro_v3_0_17
vmap xil_defaultlib riviera/xil_defaultlib

vcom -work xbip_dsp48_wrapper_v3_0_4 -93 \
"../../../../greyscale_fixed_point.srcs/sources_1/bd/greyscale_multiply/ipshared/cdbf/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_utils_v3_0_10 -93 \
"../../../../greyscale_fixed_point.srcs/sources_1/bd/greyscale_multiply/ipshared/b795/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_6 -93 \
"../../../../greyscale_fixed_point.srcs/sources_1/bd/greyscale_multiply/ipshared/7468/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_macro_v3_0_17 -93 \
"../../../../greyscale_fixed_point.srcs/sources_1/bd/greyscale_multiply/ipshared/e64f/hdl/xbip_dsp48_macro_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/greyscale_multiply/ip/greyscale_multiply_xbip_dsp48_macro_0_0/sim/greyscale_multiply_xbip_dsp48_macro_0_0.vhd" \
"../../../bd/greyscale_multiply/ip/greyscale_multiply_xbip_dsp48_macro_1_0/sim/greyscale_multiply_xbip_dsp48_macro_1_0.vhd" \
"../../../bd/greyscale_multiply/ip/greyscale_multiply_xbip_dsp48_macro_2_0/sim/greyscale_multiply_xbip_dsp48_macro_2_0.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../bd/greyscale_multiply/sim/greyscale_multiply.v" \

vlog -work xil_defaultlib \
"glbl.v"


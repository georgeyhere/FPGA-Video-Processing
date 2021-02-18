onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+BRAM_1_FIFO -L xpm -L fifo_generator_v13_2_5 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.BRAM_1_FIFO xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {BRAM_1_FIFO.udo}

run -all

endsim

quit -force

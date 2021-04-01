onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+CamRead_FIFO -L fifo_generator_v13_2_5 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.CamRead_FIFO xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {CamRead_FIFO.udo}

run -all

endsim

quit -force

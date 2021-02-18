onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib BRAM_2_greyscale_opt

do {wave.do}

view wave
view structure
view signals

do {BRAM_2_greyscale.udo}

run -all

quit -force

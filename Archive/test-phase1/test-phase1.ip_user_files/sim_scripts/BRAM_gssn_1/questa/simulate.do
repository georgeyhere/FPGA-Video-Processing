onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib BRAM_gssn_1_opt

do {wave.do}

view wave
view structure
view signals

do {BRAM_gssn_1.udo}

run -all

quit -force

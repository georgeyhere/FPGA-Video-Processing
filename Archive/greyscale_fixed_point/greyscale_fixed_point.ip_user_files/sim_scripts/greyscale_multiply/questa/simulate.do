onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib greyscale_multiply_opt

do {wave.do}

view wave
view structure
view signals

do {greyscale_multiply.udo}

run -all

quit -force

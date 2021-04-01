onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib CamRead_FIFO_opt

do {wave.do}

view wave
view structure
view signals

do {CamRead_FIFO.udo}

run -all

quit -force

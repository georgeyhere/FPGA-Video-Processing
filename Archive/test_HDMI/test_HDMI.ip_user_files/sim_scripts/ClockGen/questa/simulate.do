onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib ClockGen_opt

do {wave.do}

view wave
view structure
view signals

do {ClockGen.udo}

run -all

quit -force

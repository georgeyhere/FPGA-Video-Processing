onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+ClockGen -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ClockGen xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {ClockGen.udo}

run -all

endsim

quit -force

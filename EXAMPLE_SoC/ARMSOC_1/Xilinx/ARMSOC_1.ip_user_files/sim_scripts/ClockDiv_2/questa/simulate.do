onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ClockDiv_opt

do {wave.do}

view wave
view structure
view signals

do {ClockDiv.udo}

run -all

quit -force

onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib xvr_opt

do {wave.do}

view wave
view structure
view signals

do {xvr.udo}

run -all

quit -force

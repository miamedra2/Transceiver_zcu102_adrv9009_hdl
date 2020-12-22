onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib xvr_refclk_out_opt

do {wave.do}

view wave
view structure
view signals

do {xvr_refclk_out.udo}

run -all

quit -force

onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xilinx_vip -L xil_defaultlib -L xpm -L gtwizard_ultrascale_v1_7_5 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.xvr_refclk_out xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {xvr_refclk_out.udo}

run -all

quit -force

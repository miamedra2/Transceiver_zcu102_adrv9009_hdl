onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+xvr_refclk_out -L xilinx_vip -L xil_defaultlib -L xpm -L gtwizard_ultrascale_v1_7_5 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.xvr_refclk_out xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {xvr_refclk_out.udo}

run -all

endsim

quit -force

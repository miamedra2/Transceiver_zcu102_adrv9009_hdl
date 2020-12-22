onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+xvr -L xilinx_vip -L xil_defaultlib -L xpm -L gtwizard_ultrascale_v1_7_5 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.xvr xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {xvr.udo}

run -all

endsim

quit -force

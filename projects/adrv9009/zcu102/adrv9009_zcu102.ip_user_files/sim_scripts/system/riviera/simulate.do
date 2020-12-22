onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+system -L xilinx_vip -L xil_defaultlib -L xpm -L axi_infrastructure_v1_1_0 -L axi_vip_v1_1_4 -L zynq_ultra_ps_e_vip_v1_0_4 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_13 -L xlconcat_v2_1_1 -L xlconstant_v1_1_5 -L generic_baseblocks_v2_1_0 -L axi_register_slice_v2_1_18 -L fifo_generator_v13_2_3 -L axi_data_fifo_v2_1_17 -L axi_crossbar_v2_1_19 -L smartconnect_v1_0 -L xbip_utils_v3_0_9 -L axi_utils_v2_0_5 -L fir_compiler_v7_2_11 -L util_vector_logic_v2_0_1 -L xlslice_v1_0_1 -L jtag_axi -L axi_protocol_converter_v2_1_18 -L axi_mmu_v2_1_16 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.system xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {system.udo}

run -all

endsim

quit -force

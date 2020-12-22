#create_clock -period 6.400 -name xvr_refclk_p -waveform {0.000 3.200} [get_ports xvr_refclk_p]
#set_property PACKAGE_PIN L27 [get_ports xvr_refclk_p]

#set_clock_groups -group [get_clocks xvr_refclk_p -include_generated_clocks] -asynchronous

create_clock -period 6.510 -name xvr_refclk_in_p [get_ports xvr_refclk_in_p]
set_property PACKAGE_PIN L27 [get_ports xvr_refclk_in_p]
set_clock_groups -asynchronous -group [get_clocks xvr_refclk_in_p -include_generated_clocks]

set_property PACKAGE_PIN J27 [get_ports xvr_refclk_out_p]


set_property PACKAGE_PIN M33 [get_ports xvr_rx_p]
set_property PACKAGE_PIN M29 [get_ports xvr_tx_p]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets axi_clk]

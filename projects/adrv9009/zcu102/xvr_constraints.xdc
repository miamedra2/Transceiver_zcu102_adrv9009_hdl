create_clock -period 6.400 -name xvr_refclk_p -waveform {0.000 3.200} [get_ports xvr_refclk_p]
set_property PACKAGE_PIN L27 [get_ports xvr_refclk_p]
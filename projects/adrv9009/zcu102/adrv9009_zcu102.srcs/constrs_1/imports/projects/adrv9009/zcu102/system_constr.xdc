
# adrv9009

set_property -dict {PACKAGE_PIN G27} [get_ports ref_clk0_p]
set_property -dict {PACKAGE_PIN G28} [get_ports ref_clk0_n]
set_property -dict {PACKAGE_PIN E27} [get_ports ref_clk1_p]
set_property -dict {PACKAGE_PIN E28} [get_ports ref_clk1_n]
set_property -dict {PACKAGE_PIN D33} [get_ports {rx_data_p[0]}]
set_property -dict {PACKAGE_PIN D34} [get_ports {rx_data_n[0]}]
set_property -dict {PACKAGE_PIN C31} [get_ports {rx_data_p[1]}]
set_property -dict {PACKAGE_PIN C32} [get_ports {rx_data_n[1]}]
set_property -dict {PACKAGE_PIN E31} [get_ports {rx_data_p[2]}]
set_property -dict {PACKAGE_PIN E32} [get_ports {rx_data_n[2]}]
set_property -dict {PACKAGE_PIN B33} [get_ports {rx_data_p[3]}]
set_property -dict {PACKAGE_PIN B34} [get_ports {rx_data_n[3]}]
set_property -dict {PACKAGE_PIN D29} [get_ports {tx_data_p[0]}]
set_property -dict {PACKAGE_PIN D30} [get_ports {tx_data_n[0]}]
set_property -dict {PACKAGE_PIN B29} [get_ports {tx_data_p[1]}]
set_property -dict {PACKAGE_PIN B30} [get_ports {tx_data_n[1]}]
set_property -dict {PACKAGE_PIN F29} [get_ports {tx_data_p[2]}]
set_property -dict {PACKAGE_PIN F30} [get_ports {tx_data_n[2]}]
set_property -dict {PACKAGE_PIN A31} [get_ports {tx_data_p[3]}]
set_property -dict {PACKAGE_PIN A32} [get_ports {tx_data_n[3]}]
set_property -dict {PACKAGE_PIN AH1 IOSTANDARD LVDS} [get_ports rx_sync_p]
set_property -dict {PACKAGE_PIN AJ1 IOSTANDARD LVDS} [get_ports rx_sync_n]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVDS} [get_ports rx_os_sync_p]
set_property -dict {PACKAGE_PIN AF10 IOSTANDARD LVDS} [get_ports rx_os_sync_n]
set_property -dict {PACKAGE_PIN AD2 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]
set_property -dict {PACKAGE_PIN AD1 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]
set_property -dict {PACKAGE_PIN AE5 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_p]
set_property -dict {PACKAGE_PIN AF5 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports sysref_n]
set_property -dict {PACKAGE_PIN AH12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_p]
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_1_n]
set_property -dict {PACKAGE_PIN AJ6 IOSTANDARD LVDS} [get_ports sysref_out_p]
set_property -dict {PACKAGE_PIN AJ5 IOSTANDARD LVDS} [get_ports sysref_out_n]

set_property -dict {PACKAGE_PIN AE1 IOSTANDARD LVCMOS18} [get_ports spi_csn_ad9528]
set_property -dict {PACKAGE_PIN AE2 IOSTANDARD LVCMOS18} [get_ports spi_csn_adrv9009]
set_property -dict {PACKAGE_PIN AD4 IOSTANDARD LVCMOS18} [get_ports spi_clk]
set_property -dict {PACKAGE_PIN AE4 IOSTANDARD LVCMOS18} [get_ports spi_mosi]
set_property -dict {PACKAGE_PIN AE3 IOSTANDARD LVCMOS18} [get_ports spi_miso]

set_property -dict {PACKAGE_PIN T12 IOSTANDARD LVCMOS18} [get_ports ad9528_reset_b]
set_property -dict {PACKAGE_PIN R12 IOSTANDARD LVCMOS18} [get_ports ad9528_sysref_req]
set_property -dict {PACKAGE_PIN AG8 IOSTANDARD LVCMOS18} [get_ports adrv9009_tx1_enable]
set_property -dict {PACKAGE_PIN AH7 IOSTANDARD LVCMOS18} [get_ports adrv9009_tx2_enable]
set_property -dict {PACKAGE_PIN AH8 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx1_enable]
set_property -dict {PACKAGE_PIN AH6 IOSTANDARD LVCMOS18} [get_ports adrv9009_rx2_enable]
set_property -dict {PACKAGE_PIN AE8 IOSTANDARD LVCMOS18} [get_ports adrv9009_test]
#set_property  -dict {PACKAGE_PIN  AG3  IOSTANDARD LVCMOS18} [get_ports adrv9009_test]                  ; ## D11  FMC_HPC1_LA05_P
set_property -dict {PACKAGE_PIN AF2 IOSTANDARD LVCMOS18} [get_ports adrv9009_reset_b]
set_property -dict {PACKAGE_PIN AF1 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpint]

set_property -dict {PACKAGE_PIN AD10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_00]
set_property -dict {PACKAGE_PIN AE9 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_01]
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_02]
set_property -dict {PACKAGE_PIN AG9 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_03]
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_04]
set_property -dict {PACKAGE_PIN AC11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_05]
set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_06]
set_property -dict {PACKAGE_PIN Y7 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_07]
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_08]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_09]
set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_10]
set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_11]
set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_12]
set_property -dict {PACKAGE_PIN AD6 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_13]
set_property -dict {PACKAGE_PIN AD7 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_14]
#set_property  -dict {PACKAGE_PIN  W11  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_13]               ; ## G31  FMC_HPC1_LA29_N     (LVDS Pairs?)
#set_property  -dict {PACKAGE_PIN  W12  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_14]               ; ## G30  FMC_HPC1_LA29_P     (LVDS Pairs?)
set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_15]
set_property -dict {PACKAGE_PIN AJ2 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_16]
set_property -dict {PACKAGE_PIN AH2 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_17]
set_property -dict {PACKAGE_PIN AF8 IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_18]
#set_property  -dict {PACKAGE_PIN  P9   IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_16]               ; ## G03  FMC_HPC1_CLK1_M2C_N (LVDS Pairs?)
#set_property  -dict {PACKAGE_PIN  P10  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_17]               ; ## G02  FMC_HPC1_CLK1_M2C_P (LVDS Pairs?)
#set_property  -dict {PACKAGE_PIN  AH3  IOSTANDARD LVCMOS18} [get_ports adrv9009_gpio_18]               ; ## D12  FMC_HPC1_LA05_N

# clocks

create_clock -period 4.000 -name tx_ref_clk [get_ports ref_clk0_p]
create_clock -period 4.000 -name rx_ref_clk [get_ports ref_clk1_p]
create_clock -period 4.000 -name tx_div_clk [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_0/i_gthe4_channel/TXOUTCLK]
create_clock -period 4.000 -name rx_div_clk [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_0/i_gthe4_channel/RXOUTCLK]
create_clock -period 4.000 -name rx_os_div_clk [get_pins i_system_wrapper/system_i/util_adrv9009_xcvr/inst/i_xch_2/i_gthe4_channel/RXOUTCLK]



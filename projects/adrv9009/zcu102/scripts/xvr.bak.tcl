# -----------------------------------------------------------------------------
# xvr.tcl
#
# 9/20/2020 D. W. Hawkins (David.W.Hawkins@pl.nasa.gov)
#
# Script to re-create the ZCU102 component 'xvr.xci'.
#
# -----------------------------------------------------------------------------
# IP Creation Procedure
# ---------------------
#
# Vivado IP catalog: start the 'UltraScale FPGAs Transceivers Wizard'
#
# IP Configuration
#
# Component Name: xvr
#
# Basic Tab
# ---------
# Configure the lane rate, reference clock, and parallel data width.
#
# Set the 'System' option to 'Start from scratch'.
#
# Set the 'Transmitter' and 'Receiver' settings to
#
# Line rate:      6.25Gbps  (this is equal to 40 x 156.25MHz)
# PLL type:       QPLL0     (default)
# Ref clk:        156.25MHz
# Encoding:       raw
# User width:     40
# Internal width: 40
#
# Use the defaults for the other settings.
#
# Physical Resources Tab
# ----------------------
# The DRP clock frequency cannot exceed the REFCLK frequency. The ZCU102 has
# 74.25MHz, 125MHz, and 300MHz global clocks that can be used.
#
# DRP clock frequency: 125MHz
#
# Configure the design to use the SMA transmit/receive pair, and the Si570
# REFCLK. The GUI defaults with GTHE4_CHANNEL_X0Y4 selected, and it cannot
# be unselected until another channel is selected.
#
#  * Select Quad X0Y1, GTHE4_CHANNEL_X0Y7
#    ---> Bank 128; Data pins M34, M33, M30, M29
#  * Set the REFCLKs to MGTREFCLK0 of Quad X0Y2 (+1)
#  * Deselect Quad X0Y1, GTHE4_CHANNEL_X0Y4
#
# Optional Features Tab
# ---------------------
# No changes required.
#
# Structural Options Tab
# ----------------------
# Change the helper blocks to 'Core', so that they are internal to the
# component. This saves having to create the example design to generate
# components that are needed to synthesize the design.
#
# Expand "Transceiver-based IP Debug Ports" and check:
#  * loopback_in         (it is in the right column)
#  * txdiffctrl_in       (it is in the left column)
#  * txpostcursor_in     (it is in the right column)
#  * txprecursor_in      (it is in the right column)
#
# -----------------------------------------------------------------------------

# Check the IP directory has been set
if {![info exist ip_dir]} {
	error "Error: set ip_dir before calling this script!"
}

# Instance name
set instance_name xvr

# Vivado 2019.2 Transceiver IP
create_ip \
	-name gtwizard_ultrascale -vendor xilinx.com -library ip -version 1.7 \
	-module_name $instance_name -dir $ip_dir

# Reference clock frequency
# * 156.25MHz is a fairly standard communications reference frequency
# * 153.60MHz is used to generate the ADRV9009 30.72MHz reference
#set ref_freq_MHz 156.25
set ref_freq_MHz 153.6

# Data width
#  * 40 x 156.25 = 6.25Gbps
#  * 40 x 153.60 = 6.144Gbps
set data_width 40

# Lane rate
set lane_rate_Gbps \
	[format "%.3f" [expr {double($data_width)*$ref_freq_MHz/1000.0}]]

# IP Properties
set_property -dict [list \
	CONFIG.TX_LINE_RATE            $lane_rate_Gbps \
	CONFIG.TX_REFCLK_FREQUENCY     $ref_freq_MHz   \
	CONFIG.TX_USER_DATA_WIDTH      $data_width     \
	CONFIG.TX_INT_DATA_WIDTH       $data_width     \
	CONFIG.TXPROGDIV_FREQ_VAL      $ref_freq_MHz   \
	CONFIG.RX_LINE_RATE            $lane_rate_Gbps \
	CONFIG.RX_REFCLK_FREQUENCY     $ref_freq_MHz   \
	CONFIG.RX_USER_DATA_WIDTH      $data_width     \
	CONFIG.RX_INT_DATA_WIDTH       $data_width     \
	CONFIG.FREERUN_FREQUENCY       {100}           \
	CONFIG.CHANNEL_ENABLE          {X0Y7}          \
	CONFIG.TX_MASTER_CHANNEL       {X0Y7}          \
	CONFIG.RX_MASTER_CHANNEL       {X0Y7}          \
	CONFIG.RX_JTOL_FC              {3.7492501}     \
	CONFIG.RX_CB_VAL_0_0           {0000000000}    \
	CONFIG.RX_CB_VAL_0_1           {0000000000}    \
	CONFIG.RX_CB_VAL_0_2           {0000000000}    \
	CONFIG.RX_CB_VAL_0_3           {0000000000}    \
	CONFIG.RX_CB_VAL_1_0           {0000000000}    \
	CONFIG.RX_CB_VAL_1_1           {0000000000}    \
	CONFIG.RX_CB_VAL_1_2           {0000000000}    \
	CONFIG.RX_CB_VAL_1_3           {0000000000}    \
	CONFIG.RX_CC_VAL_0_0           {0000000000}    \
	CONFIG.RX_CC_VAL_0_1           {0000000000}    \
	CONFIG.RX_CC_VAL_0_2           {0000000000}    \
	CONFIG.RX_CC_VAL_0_3           {0000000000}    \
	CONFIG.RX_CC_VAL_1_0           {0000000000}    \
	CONFIG.RX_CC_VAL_1_1           {0000000000}    \
	CONFIG.RX_CC_VAL_1_2           {0000000000}    \
	CONFIG.RX_CC_VAL_1_3           {0000000000}    \
	CONFIG.TX_REFCLK_SOURCE        {X0Y7 clk0+1}   \
	CONFIG.RX_REFCLK_SOURCE        {X0Y7 clk0+1}   \
	CONFIG.LOCATE_TX_USER_CLOCKING {CORE}          \
	CONFIG.LOCATE_RX_USER_CLOCKING {CORE}          \
	CONFIG.ENABLE_OPTIONAL_PORTS {
		loopback_in
		txdiffctrl_in
		txpostcursor_in
		txprecursor_in
	}
] [get_ips $instance_name]

set_property -dict [list CONFIG.TX_LINE_RATE $lane_rate_Gbps] [get_ips $instance_name]

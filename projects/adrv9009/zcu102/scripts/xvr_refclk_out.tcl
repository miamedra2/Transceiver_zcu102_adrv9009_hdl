# -----------------------------------------------------------------------------
# xvr_refclk_out.tcl
#
# 9/20/2020 D. W. Hawkins (David.W.Hawkins@pl.nasa.gov)
#
# Script to re-create the ZCU102 component 'xvr_refclk_out.xci'.
#
# -----------------------------------------------------------------------------
# IP Creation Procedure
# ---------------------
#
# Vivado IP catalog: start the 'UltraScale FPGAs Transceivers Wizard'
#
# IP Configuration
#
# Component Name: xvr_refclk_out
#
# Basic Tab
# ---------
# Configure the lane rate, reference clock, and parallel data width.
#
# Set the 'System' option to 'Start from scratch'.
#
# Set the 'Transmitter' and 'Receiver' settings to
#
# Line rate:      3.125Gbps  (this is equal to 20 x 156.25MHz)
# PLL type:       CPLL
# Ref clk:        156.25MHz
# Encoding:       raw
# User width:     20
# Internal width: 20
# TX/RXOUTCLK:    TX/RXPROGDIVCLK  (programmable output clock)
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
# The Si570 REFCLK input is MGTREFCLK1 on Bank 129.
# The SMA REFCLK output is MGTREFCLK1 on Bank 129.
# The SMA TX/RX pair are on Bank 128.
# The FMC-HPC lanes are on Bank 129, and any one of those can be used for the
# REFCLK output generation, eg., use the first lane.
#
#  * Select Quad X0Y2, GTHE4_CHANNEL_X0Y8
#    ---> Bank 129; Data pins L32, L31, K30, K29
#  * Set the REFCLKs to MGTREFCLK0
#  * Set the RXRECCLKOUT buffer to MGTREFCLK1
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
# Expand "All ports", search for and enable (check):
#
#  * The receiver CDR lock-to-reference ports
#    - rxcdrhold_in
#    - rxcdrovrden_in
#
#  * The DRP ports
#    - drpclk_in
#    - drpaddr_in
#    - drpen_in
#    - drpwe_in
#    - drpdi_in
#    - drpdo_out
#    - drprdy_out
#
# -----------------------------------------------------------------------------
# CPLL Calibration Block
# ----------------------
#
# UG576 and PG182 discuss the CPLL calibration block. This component is
# included within the xvr_refclk_out component. The INCLUDE_CPLL_CAL
# property can be examined (along with all other properties) using
#
# tcl> report_property -all [get_ips xvr_refclk_out]
#
# The value of CONFIG.INCLUDE_CPLL_CAL = 2 (Vivado 2018.3).
#
# PG182 p66 has the comments:
#
#    If you set the value of INCLUDE_CPLL_CAL to 2, the HDL logic inside the
#    wizard drives the relevant ports internally for configuration during
#    IP customization.
#
# So that is the default for the xvr_refclk_out instance.
#
# PG182 p66 goes on to say:
#
#    Xilinx recommends that the INCLUDE_CPLL_CAL parameter be set to 1 and
#    appropriate values be driven on the ports shown in Table 3-1 when the GT
#    parent IP intends to perform dynamic line rate switching.
#
# This design will use the DRP interface to change the RXCLKOUT, and it can
# use the DRP to change TXCLKOUT. Hardware tests will be used to determine
# whether the additional ports are required. For additional details, see
#
# https://www.xilinx.com/support/answers/70485.html
# Xilinx AR#70485: UltraScale+ GTH/GTY - how to update CPLL calibration
# settings during a rate change
#
# This AR describes how to change INCLUDE_CPLL_CAL. This script can make that
# same change by adding the property to the list below.
#
# The AR example uses:
#
# wire [17:0] hb0_gtwiz_gthe4_cpll_cal_txoutclk_period_int = 18'hFA0;
# wire [17:0] hb0_gtwiz_gthe4_cpll_cal_cnt_tol_int = 18'h28;
# wire [0:0] hb0_gtwiz_gthe4_cpll_cal_bufg_ce_int = 1'b1;
#
# 'hFA0 = 4000, so a count of 4000 on the clock counter.
#
# Near the end of the AR, the REFCLK is 156.25MHz (6400ps period) and
#        cpll_cal_txoutclk_period         cpll_cal_cnt_tol
#        ------------------------    ------------------------------
# 1.0G:      18'h2710 = 10,000       18'h64 = 100ps = 0.01 x period
# 2.5G:      18'b30D4 = 12,500       18'h7D = 125ps = 0.01 x period
#
# PG182 Table 3-1 p66 has the equation for these two parameters.
#
# For xvr_refclk_out, TXCLKOUT is 156.25MHz (6400ps) or 153.6MHz (6510ps),
# and the free-running clock is 125MHz.
#
# TXCLKOUT_PERIOD_IN = (CPLL_VCO_RATE / 20) x 16,000 / (4 x FREQ_CLKIN)
#                    =    156.25MHz x 4,000 / 125MHz
#                    = 5,000
#
# So when the TXOUTCLK counter has a count of close to 5,000, the calibration
# logic will consider it correct, and allow the reset controllers to complete.
# The error in the count can be 50, i.e., 5000 +/- 50 = 4950 to 5050.
#
# With a 153.6MHz reference, the count range is 4915 +/- 49 = 4866 to 4964.
#
# That means that the REFCLK and the free-running clock used to generate the
# IP must be accurate, i.e., the Si570 has to be programmed to the correct
# value. The CPLL will not lock if the IP was configured for 153.6MHz and the
# REFCLK is programmed for 156.25MHz.
#
# -----------------------------------------------------------------------------

# Check the IP directory has been set
if {![info exist ip_dir]} {
	error "Error: set ip_dir before calling this script!"
}

# Instance name
set instance_name xvr_refclk_out

# Vivado 2019.2 Transceiver IP
create_ip \
	-name gtwizard_ultrascale -vendor xilinx.com -library ip -version 1.7 \
	-module_name $instance_name -dir $ip_dir

# Reference clock frequency
# * 156.25MHz is a fairly standard communications reference frequency
# * The ADRV9009 requires a 30.72MHz reference clock, and with a programmable
#   divider setting of 100, the lane rate is 3.072MHz, so with a data width
#   of 20, the reference frequency is 5*30.72MHz = 156.3MHz
#set ref_freq_MHz 156.25
set ref_freq_MHz 153.6

# Data width
set data_width 20

# Lane rate
set lane_rate_Gbps \
	[format "%.3f" [expr {double($data_width)*$ref_freq_MHz/1000.0}]]

# IP Properties
set_property -dict [list \
	CONFIG.TX_LINE_RATE            $lane_rate_Gbps \
	CONFIG.TX_PLL_TYPE             {CPLL}          \
	CONFIG.TX_REFCLK_FREQUENCY     $ref_freq_MHz   \
	CONFIG.TX_USER_DATA_WIDTH      $data_width     \
	CONFIG.TX_INT_DATA_WIDTH       $data_width     \
	CONFIG.TX_OUTCLK_SOURCE        {TXPROGDIVCLK}  \
	CONFIG.TXPROGDIV_FREQ_SOURCE   {CPLL}          \
	CONFIG.TXPROGDIV_FREQ_VAL      $ref_freq_MHz   \
	CONFIG.RX_LINE_RATE            $lane_rate_Gbps \
	CONFIG.RX_PLL_TYPE             {CPLL}          \
	CONFIG.RX_REFCLK_FREQUENCY     $ref_freq_MHz   \
	CONFIG.RX_USER_DATA_WIDTH      $data_width     \
	CONFIG.RX_INT_DATA_WIDTH       $data_width     \
	CONFIG.RX_OUTCLK_SOURCE        {RXPROGDIVCLK}  \
	CONFIG.FREERUN_FREQUENCY       {100}           \
	CONFIG.CHANNEL_ENABLE          {X0Y8}          \
	CONFIG.TX_MASTER_CHANNEL       {X0Y8}          \
	CONFIG.RX_MASTER_CHANNEL       {X0Y8}          \
	CONFIG.TX_REFCLK_SOURCE        {}              \
	CONFIG.RX_REFCLK_SOURCE        {}              \
	CONFIG.RX_RECCLK_OUTPUT        {X0Y8 clk1}     \
	CONFIG.RX_JTOL_FC              {1.8746251}     \
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
	CONFIG.LOCATE_TX_USER_CLOCKING {CORE}          \
	CONFIG.LOCATE_RX_USER_CLOCKING {CORE}          \
	CONFIG.ENABLE_OPTIONAL_PORTS {
		rxcdrhold_in
		rxcdrovrden_in
		drpaddr_in
		drpclk_in
		drpdi_in
		drpen_in
		drpwe_in
		drpdo_out
		drprdy_out
	}
] [get_ips $instance_name]

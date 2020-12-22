// ----------------------------------------------------------------------------
// xvr_refclk_out_interface.sv
//
// 9/28/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Transceiver REFCLK output interface.
//
// The transceiver instance was created using the UltraScale Transceivers
// Wizard (1.7) per the procedure described in scripts/xvr_refclk_out.tcl.
//
// ----------------------------------------------------------------------------

module xvr_refclk_out_interface (

		// --------------------------------------------------------------------
		// Transceiver REFCLK and lanes
		// --------------------------------------------------------------------
		// 
		input         refclk_in,
		output        refclk_out_p,
		output        refclk_out_n,
		output        tx_p,
		output        tx_n,
		input         rx_p,
		input         rx_n,

		// --------------------------------------------------------------------
		// Control/status
		// --------------------------------------------------------------------
		//
		// AXI, DRP, and free-running clock
		input         clk,
		
		// Transceiver clocks (to clock counters)
		output        tx_clk,
		output        rx_clk,

		// Transceiver status	
		input         reset_all,
		output        power_good,
		output        reset_tx_done,
		output        reset_rx_done,

		// --------------------------------------------------------------------
		// DRP interface
		// --------------------------------------------------------------------
		//
		input         drp_en,
		input         drp_we,
		output        drp_rdy,
		input   [9:0] drp_addr,
		input  [15:0] drp_wdata,
		output [15:0] drp_rdata
	);

	// ------------------------------------------------------------------------
	// Local Signals
	// ------------------------------------------------------------------------
	//
	// Transmitter parallel clock and data
	logic        tx_pma_reset_done;
	logic        tx_reset;
	logic        tx_outclk;
	logic        tx_usrclk;
	logic        tx_usrclk2;
	logic        tx_active;
	logic [19:0] userdata_tx;
	//
	// Receiver parallel clock and data
	logic        rx_pma_reset_done;
	logic        rx_reset;
	logic        rx_outclk;
	logic        rx_usrclk;
	logic        rx_usrclk2;
	logic        rx_active;
	logic [19:0] userdata_rx;
	//
	// RXRECCLK output
	logic        rx_recclkout;

	// ------------------------------------------------------------------------
	// User clock resets
	// ------------------------------------------------------------------------
	//
	// Asynchronous reset for tx_active and BUFG_GT CLR control
	assign tx_reset = ~tx_pma_reset_done;

	// Asynchronous reset for rx_active and BUFG_GT CLR control
	assign rx_reset = ~rx_pma_reset_done;

	// ------------------------------------------------------------------------
	// Transceiver 
	// ------------------------------------------------------------------------
	//
	xvr_refclk_out u1 (															 
		// Powergood status
		.gtpowergood_out                    (power_good       ),
		//
		// CPLL ports
		.gtrefclk0_in                       (refclk_in        ),		
		// 
		// Transceiver lanes
		.gthtxp_out                         (tx_p             ),
		.gthtxn_out                         (tx_n             ),
		.gthrxp_in                          (rx_p             ),
		.gthrxn_in                          (rx_n             ),
		//
		// Free-running clock and resets
		.gtwiz_reset_clk_freerun_in         (clk              ),
		.gtwiz_reset_all_in                 (reset_all        ),
		.gtwiz_reset_tx_pll_and_datapath_in (1'b0             ),
		.gtwiz_reset_tx_datapath_in         (1'b0             ),
		.gtwiz_reset_rx_pll_and_datapath_in (1'b0             ),
		.gtwiz_reset_rx_datapath_in         (1'b0             ),
		.gtwiz_reset_rx_cdr_stable_out      (                 ),
		.gtwiz_reset_tx_done_out            (reset_tx_done    ),
		.gtwiz_reset_rx_done_out            (reset_rx_done    ),
		//
		// RX CDR ports
		.rxcdrhold_in                       (1'b1             ), // Lock-to-reference mode
		.rxcdrovrden_in                     (1'b0             ), // Lock-to-reference mode
		//
		// TX and RX programmable divider status
		.rxprgdivresetdone_out              (                 ),
		.txprgdivresetdone_out              (                 ),
		//
		// Transmit parallel clock and data
		.txpmaresetdone_out                 (tx_pma_reset_done),
		.gtwiz_userclk_tx_reset_in          (tx_reset         ),
		.gtwiz_userclk_tx_srcclk_out        (tx_outclk        ),
		.gtwiz_userclk_tx_usrclk_out        (tx_usrclk        ),
		.gtwiz_userclk_tx_usrclk2_out       (tx_usrclk2       ),
		.gtwiz_userclk_tx_active_out        (tx_active        ),
		.gtwiz_userdata_tx_in               (userdata_tx      ),
		//
		// Receive parallel clock and data
		.rxpmaresetdone_out                 (rx_pma_reset_done),
		.gtwiz_userclk_rx_reset_in          (rx_reset         ),
		.gtwiz_userclk_rx_srcclk_out        (rx_outclk        ),
		.gtwiz_userclk_rx_usrclk_out        (rx_usrclk        ),
		.gtwiz_userclk_rx_usrclk2_out       (rx_usrclk2       ),
		.gtwiz_userclk_rx_active_out        (rx_active        ),
		.gtwiz_userdata_rx_out              (userdata_rx      ),  // Unused
		//
		// Receiver clock
		.rxrecclkout_out                    (rx_recclkout     ),
		//
		// DRP Interface
		.drpclk_in                          (clk              ),
		.drpen_in                           (drp_en           ),
		.drpwe_in                           (drp_we           ),
		.drprdy_out                         (drp_rdy          ),
		.drpaddr_in                         (drp_addr         ),
		.drpdi_in                           (drp_wdata        ),
		.drpdo_out                          (drp_rdata        )
	);

	// Clocks to top-level
	assign tx_clk = tx_usrclk2;
	assign rx_clk = rx_usrclk2;

	// Transmitter parallel interface
	// * 20-bit static pattern = 0000_0000_0011_1111_1111b
	// * TX output will be 3125MHz/20 = 156.25MHz
	assign userdata_tx = 20'h003FF;
		
	// ------------------------------------------------------------------------
	// REFCLK output
	// ------------------------------------------------------------------------
	//
	// UltraScale+ REFCLK output buffer with parameters from the
	// IP Example Design. The parameters were identical to the UltraScale
	// design. The only change was from OBUFDS_GTE3 to OBUFDS_GTE4.
	//
	OBUFDS_GTE4 #(
		.REFCLK_EN_TX_PATH (1'b1),
		.REFCLK_ICNTL_TX   (5'b00111)
	) u2 (
		.I     (rx_recclkout),
		.CEB   (1'b0        ),
		.O     (refclk_out_p),
		.OB    (refclk_out_n)
	);

endmodule


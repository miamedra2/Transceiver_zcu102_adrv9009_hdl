// ----------------------------------------------------------------------------
// xvr_interface.sv
//
// 9/6/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Transceiver interface for Xilinx Zynq UltraScale+ ZCU102.
//
// The ZCU102 transceiver instance has one small difference relative to
// that of the Kintex UltraScale KCU102; the tx_diffctrl port is 5-bit
// on the transceiver instance, but only the 4 MSBs of the 5-bit input
// are used (p168 [1]).
//
// The top-level ports of xvr_interface are identical for the KCU105 and
// ZCU102. The internal implementation differs in the connection of
// the 4-bit tx_diffctrl to the 'xvr' component tx_diffctrl port.
//
// ----------------------------------------------------------------------------
// References
// ----------
//
// [1] Xilinx, "UG576: UltraScale Architecture GTH Transceivers User Guide",
//     v1.6, August 26, 2019.
//
// ----------------------------------------------------------------------------

module xvr_interface #(
		parameter int DATA_WIDTH = 128,
		parameter int XVR_WIDTH  = 40
	) (

		// --------------------------------------------------------------------
		// Transceiver REFCLK and lanes
		// --------------------------------------------------------------------
		//
		input                   refclk,
		output                  tx_p,
		output                  tx_n,
		input                   rx_p,
		input                   rx_n,

		// --------------------------------------------------------------------
		// Transmitter parallel interface
		// --------------------------------------------------------------------
		//
		output                  tx_rst_n,
		output                  tx_clk,
		input  [DATA_WIDTH-1:0] tx_data,

		// --------------------------------------------------------------------
		// Receiver parallel interface
		// --------------------------------------------------------------------
		//
		output                  rx_rst_n,
		output                  rx_clk,
		output [DATA_WIDTH-1:0] rx_data,

		// --------------------------------------------------------------------
		// Control/status
		// --------------------------------------------------------------------
		//
		// Free-running clock
		input                   clk,

		// Transceiver control/status
		input             [2:0] loopback,
		input             [3:0] tx_diffctrl,
		input             [4:0] tx_postcursor,
		input             [4:0] tx_precursor,
		input                   reset_all,
		output                  power_good,
		output                  reset_tx_done,
		output                  reset_rx_done
	);

	// ------------------------------------------------------------------------
	// Local Signals
	// ------------------------------------------------------------------------
	//
	// Transmitter parallel clock and data
	logic                 tx_pma_reset_done;
	logic                 tx_reset;
	logic                 tx_active;
	logic [XVR_WIDTH-1:0] userdata_tx;
	//
	// Receiver parallel clock and data
	logic                 rx_pma_reset_done;
	logic                 rx_reset;
	logic                 rx_active;
	logic [XVR_WIDTH-1:0] userdata_rx;

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
	xvr u4 (
		// Powergood status
		.gtpowergood_out                    (power_good   ),
		//
		// Controls
		.loopback_in                        (loopback          ),
		.txdiffctrl_in                      ({tx_diffctrl,1'b0}),
		.txpostcursor_in                    (tx_postcursor     ),
		.txprecursor_in                     (tx_precursor      ),
		//
		// REFCLK input and QPLL clock outputs
		.gtrefclk00_in                      (refclk    ),
		.qpll0outclk_out                    (          ),
		.qpll0outrefclk_out                 (          ),
		//
		// Transceiver lanes
		.gthtxp_out                         (tx_p      ),
		.gthtxn_out                         (tx_n      ),
		.gthrxp_in                          (rx_p      ),
		.gthrxn_in                          (rx_n      ),
		//
		// Free-running clock and resets
		.gtwiz_reset_clk_freerun_in         (clk          ),
		.gtwiz_reset_all_in                 (reset_all    ),
		.gtwiz_reset_tx_pll_and_datapath_in (1'b0         ),
		.gtwiz_reset_tx_datapath_in         (1'b0         ),
		.gtwiz_reset_rx_pll_and_datapath_in (1'b0         ),
		.gtwiz_reset_rx_datapath_in         (1'b0         ),
		.gtwiz_reset_rx_cdr_stable_out      (             ), // Unused
		.gtwiz_reset_tx_done_out            (reset_tx_done),
		.gtwiz_reset_rx_done_out            (reset_rx_done),
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
		.gtwiz_userdata_rx_out              (userdata_rx      )
	);

	// Transmitter parallel interface
	assign userdata_tx = tx_data[XVR_WIDTH-1:0];
	assign tx_clk      = tx_usrclk2;
	assign tx_rst_n    = reset_tx_done;

	// Receiver parallel interface
	assign rx_data  = DATA_WIDTH'(userdata_rx);
	assign rx_clk   = rx_usrclk2;
	assign rx_rst_n = reset_rx_done;

endmodule


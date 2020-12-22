// ----------------------------------------------------------------------------
// zcu102.sv
//
// 9/20/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Xilinx Zynq UltraScale ZCU102 'xvr_example' example design.
//
// ----------------------------------------------------------------------------

module zcu102 (

		// --------------------------------------------------------------------
		// Reset
		// --------------------------------------------------------------------
		//
		input        cpu_reset,

		// ----------------------------------------------------------------------
		// Clocks
		// ----------------------------------------------------------------------
		//
		input        clk_300mhz_p,
		input        clk_300mhz_n,
		input        clk_125mhz_p,
		input        clk_125mhz_n,

		// --------------------------------------------------------------------
		// Transceiver Interface
		// --------------------------------------------------------------------
		//
		// REFCLK from SiLabs Si570
		input  [0:0] si570_refclk_p,
		input  [0:0] si570_refclk_n,
		
		// SMA REFCLK (configured for output)
		output       sma_clk_p,
		output       sma_clk_n,

		// SMA transceiver lanes
		input        sma_rx_p,
		input        sma_rx_n,
		output       sma_tx_p,
		output       sma_tx_n,

		// ----------------------------------------------------------------------
		// User I/O
		// ----------------------------------------------------------------------
		//
		// Push buttons
		input  [4:0] pb,
		//
		// LEDs
		output [7:0] led
	);

	// ------------------------------------------------------------------------
	// Local parameters
	// ------------------------------------------------------------------------
	//
	// Clock frequencies
	localparam real CLK_300MHZ_FREQUENCY = 300.0e6;
	localparam real CLK_125MHZ_FREQUENCY = 125.0e6;

	// LED blink rate
	localparam real BLINK_PERIOD = 0.5;

	// Counter widths
	//
	// Note: the integer'() casts are important, without them Vivado
	// generates incorrect counter widths (much wider than expected)
	//
	// 4 LEDs driven by 300MHz
	localparam integer WIDTH_300MHZ =
		$clog2(integer'(CLK_300MHZ_FREQUENCY*BLINK_PERIOD))+3;
	//
	// 4 LEDs driven by 125MHz
	localparam integer WIDTH_125MHZ =
		$clog2(integer'(CLK_125MHZ_FREQUENCY*BLINK_PERIOD))+3;

	// ------------------------------------------------------------------------
	// Local signals
	// ------------------------------------------------------------------------
	//
	// Differential clock buffer outputs
	logic                    clk_300mhz_in;
	logic                    clk_300mhz;
	logic                    clk_125mhz_in;
	logic                    clk_125mhz;

	// Counters
	logic [WIDTH_300MHZ-1:0] count_300mhz;
	logic [WIDTH_125MHZ-1:0] count_125mhz;

	// LED inversion mask
	logic              [3:0] mask;

	// AXI reset and clock
	logic axi_rst_n;
	logic axi_clk;

	// ------------------------------------------------------------------------
	// Differential clock receivers
	// ------------------------------------------------------------------------
	//
	// 300MHz differential input
	IBUFDS u1 (
		.I  (clk_300mhz_p),
		.IB (clk_300mhz_n),
		.O  (clk_300mhz_in)
	);

	// 300MHz global clock buffer
	BUFG u2 (
		.I(clk_300mhz_in),
		.O(clk_300mhz)
	);

	// 125MHz differential input
	IBUFDS u3 (
		.I  (clk_125mhz_p),
		.IB (clk_125mhz_n),
		.O  (clk_125mhz_in)
	);

	// 125MHz global clock buffer
	BUFG u4 (
		.I(clk_125mhz_in),
		.O(clk_125mhz)
	);

	// ------------------------------------------------------------------------
	// AXI clock
	// ------------------------------------------------------------------------
	//
	assign axi_clk = clk_125mhz;
	
	// ------------------------------------------------------------------------
	// AXI reset synchronizer
	// ------------------------------------------------------------------------
	//
	// See XPM_CDC_ASYNC_RESET in [1] for details. The source code is:
	// C:\software\Xilinx\Vivado\2019.2\data\ip\xpm\xpm_cdc\hdl\xpm_cdc.sv
	//
	xpm_cdc_async_rst #(
		.DEST_SYNC_FF    (2), // Number of synchronization registers
		.INIT_SYNC_FF    (1), // Enable simulation init values
		.RST_ACTIVE_HIGH (0)  // Active low reset
	) u5 (

		// Async reset input
		.src_arst (~cpu_reset),

		// Async assert, synchronous deassert reset output
		.dest_clk (axi_clk   ),
		.dest_arst(axi_rst_n )
	);
	
	// ------------------------------------------------------------------------
	// Counters
	// ------------------------------------------------------------------------
	//
	always_ff @(posedge clk_300mhz) begin
		count_300mhz <= count_300mhz + 1;
	end

	always_ff @(posedge clk_125mhz) begin
		count_125mhz <= count_125mhz + 1;
	end

	// ------------------------------------------------------------------------
	// LED outputs
	// ------------------------------------------------------------------------
	//
	// LED inversion mask
	// * make a 4-bit mask from the 5 push button inputs
	// * pb[4] is the center button, toggle all LEDs when it is pressed,
	//   otherwise use pb[3:0] as the mask
	assign mask = pb[4] ? 4'hF : pb[3:0];

	// 300MHz clock outputs
	assign led[4 +: 4] = count_300mhz[WIDTH_300MHZ-1 -: 4] ^ mask;
	//
	// 125MHz clock outputs
	assign led[0 +: 4] = count_125mhz[WIDTH_125MHZ-1 -: 4] ^ mask;

	// ------------------------------------------------------------------------
	// Transceiver system
	// ------------------------------------------------------------------------
	//	
	// Note: if the instance name is changed, ila.xdc needs to be updated.
	xvr_system u8 (
		.axi_rst_n        (axi_rst_n        ),
		.axi_clk          (axi_clk          ),
		.xvr_refclk_in_p  (si570_refclk_p[0]),
		.xvr_refclk_in_n  (si570_refclk_n[0]),
		.xvr_refclk_out_p (sma_clk_p        ),
		.xvr_refclk_out_n (sma_clk_n        ),
		.xvr_rx_p         (sma_rx_p         ),
		.xvr_rx_n         (sma_rx_n         ),
		.xvr_tx_p         (sma_tx_p         ),
		.xvr_tx_n         (sma_tx_n         )
	);

endmodule


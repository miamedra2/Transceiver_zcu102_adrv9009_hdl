// ----------------------------------------------------------------------------
// xvr_rx_bram.sv
//
// 9/6/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Transceiver receiver BRAM control.
//
// ----------------------------------------------------------------------------

module xvr_rx_bram #(
		// BRAM parameters
		// *  8k x  64-bits = 2^13 x  64-bits
		// * 32k x 128-bits = 2^15 x 128-bits
		parameter int ADDR_WIDTH = 15,
		parameter int DATA_WIDTH = 128
	) (

		// --------------------------------------------------------------------
		// Reset and Clock
		// --------------------------------------------------------------------
		//
		input                     rst_n,
		input                     clk,

		// --------------------------------------------------------------------
		// Control/Status Interface
		// --------------------------------------------------------------------
		//
		input                     enable,
		output                    done,

		// --------------------------------------------------------------------
		// BRAM Interface
		// --------------------------------------------------------------------
		//
		output                    bram_en,
		output [DATA_WIDTH/8-1:0] bram_we,
		output   [ADDR_WIDTH-1:0] bram_addr,
		output   [DATA_WIDTH-1:0] bram_wdata,
		input    [DATA_WIDTH-1:0] bram_rdata,

		// --------------------------------------------------------------------
		// Transceiver Data
		// --------------------------------------------------------------------
		//
		input    [DATA_WIDTH-1:0] rx_data
	);

	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	// Address counter
	logic                  addr_load;
	logic                  addr_en;
	logic                  addr_done;
	logic [ADDR_WIDTH-1:0] addr_d;
	logic [ADDR_WIDTH-1:0] addr_q;
	//
	// BRAM enable/write-enable
	logic                  bram_en_o;

	// ------------------------------------------------------------------------
	// Control FSM
	// ------------------------------------------------------------------------
	//
	xvr_rx_bram_fsm u1 (
		.rst_n     (rst_n    ),
		.clk       (clk      ),
		.enable    (enable   ),
		.done      (done     ),
		.bram_en   (bram_en_o),
		.addr_load (addr_load),
		.addr_en   (addr_en  ),
		.addr_done (addr_done)
	);

	// ------------------------------------------------------------------------
	// Address counter
	// ------------------------------------------------------------------------
	//
	counter #(
		.WIDTH (ADDR_WIDTH),
		.INIT  ('0        )
	) u2 (
		.rst_n (rst_n    ),
		.clk   (clk      ),
		.load  (addr_load),
		.en    (addr_en  ),
		.dir   (1'b1     ), // up counter
		.cin   (1'b1     ), // carry in
		.d     (addr_d   ),
		.q     (addr_q   ),
		.cout  (addr_done)
	);

	// Address load value
	assign addr_d = '0;

	// ------------------------------------------------------------------------
	// BRAM interface
	// ------------------------------------------------------------------------
	//
	// BRAM enable
	assign bram_en = bram_en_o;

	// Transmit BRAM is write-only
	assign bram_we = {(DATA_WIDTH/8){bram_en_o}};

	// BRAM address
	assign bram_addr = addr_q;

	// ------------------------------------------------------------------------
	// Transceiver data (to BRAM)
	// ------------------------------------------------------------------------
	//
	assign bram_wdata = rx_data;

endmodule


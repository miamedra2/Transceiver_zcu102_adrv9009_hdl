// ----------------------------------------------------------------------------
// xvr_tx_bram.sv
//
// 9/6/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Transceiver transmit BRAM control.
//
// ----------------------------------------------------------------------------

module xvr_tx_bram #(
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
		// Control/status Interface
		// --------------------------------------------------------------------
		//
		input                     enable,
		output                    done,
		input                     mode,

		// --------------------------------------------------------------------
		// Static Pattern
		// --------------------------------------------------------------------
		//
		input    [DATA_WIDTH-1:0] pattern,

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
		output   [DATA_WIDTH-1:0] tx_data
	);

	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	// Data multiplexer
	logic                  data_sel;

	// Address counter
	logic                  addr_load;
	logic                  addr_en;
	logic                  addr_done;
	logic [ADDR_WIDTH-1:0] addr_d;
	logic [ADDR_WIDTH-1:0] addr_q;

	// ------------------------------------------------------------------------
	// Control FSM
	// ------------------------------------------------------------------------
	//
	xvr_tx_bram_fsm u1 (
		.rst_n     (rst_n    ),
		.clk       (clk      ),
		.enable    (enable   ),
		.done      (done     ),
		.mode      (mode     ),
		.bram_en   (bram_en  ),
		.data_sel  (data_sel ),
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
	// Transmit BRAM is read-only
	assign bram_we = '0;

	// BRAM address
	assign bram_addr = addr_q;

	// Unused write data
	assign bram_wdata = '0;

	// ------------------------------------------------------------------------
	// Transceiver data
	// ------------------------------------------------------------------------
	//
	assign tx_data = data_sel ? bram_rdata : pattern;

endmodule


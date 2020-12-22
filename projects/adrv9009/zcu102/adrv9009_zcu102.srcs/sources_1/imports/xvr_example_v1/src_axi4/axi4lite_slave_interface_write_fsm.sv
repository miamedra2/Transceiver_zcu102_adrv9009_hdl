// ----------------------------------------------------------------------------
// axi4lite_slave_interface_write_fsm.sv
//
// 7/18/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4-Lite slave interface write control FSM.
//
// ----------------------------------------------------------------------------

module axi4lite_slave_interface_write_fsm (

		// Reset and Clock
		input  rst_n,
		input  clk,

		// Write address
		input  awvalid,
		output awready,

		// Write data
		input  wvalid,
		output wready,

		// Write response
		output bvalid,
		input  bready,

		// Datapath
		output wr_addr_en,
		output wr_en
	);
	
	// ------------------------------------------------------------------------
	// FSM states
	// ------------------------------------------------------------------------
	//
	// * S_IDLE:
	//   - wait for awvalid and wvalid asserted
	//
	// * S_RDY:
	//   - assert awready and wready and perform the write
	//
	// * S_RSP:
	//   - assert bvalid and wait for bready
	//
	enum {
		S_IDLE,
		S_RDY,
		S_RSP
	} state = S_IDLE;
	
	// ------------------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------------------
	//
	// Combinatorial signals
	logic c_awready    = 1'b0;
	logic c_wready     = 1'b0;
	logic c_bvalid     = 1'b0;
	logic c_wr_addr_en = 1'b0;
	logic c_wr_en      = 1'b0;
	
	// Registers
	logic r_awready = 1'b0;
	logic r_wready  = 1'b0;
	logic r_bvalid  = 1'b0;
	logic r_wr_en   = 1'b0;

	// ------------------------------------------------------------------------
	// FSM state transitions
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge rst_n or posedge clk) begin
		if (~rst_n) begin
			state <= S_IDLE;
		end
		else begin
			// State transitions
			case (state)

				// Wait for valid address and data
				S_IDLE:
					if (awvalid && wvalid) begin
						state <= S_RDY;
					end

				// Write address and data ready asserted
				S_RDY:
					state <= S_RSP;

				// Response valid asserted wait for ready
				S_RSP:
					if (bready) begin
						// Check for next write
						if (awvalid && wvalid) begin
							state <= S_RDY;
						end
						else begin
							state <= S_IDLE;						
						end
					end
			endcase
		end
	end

	// ------------------------------------------------------------------------
	// Control signals derived from FSM state
	// ------------------------------------------------------------------------
	//
	always_comb
	begin
		// Default outputs
		c_awready    = 1'b0;
		c_wready     = 1'b0;
		c_bvalid     = 1'b0;
		c_wr_addr_en = 1'b0;
		c_wr_en      = 1'b0;

		// Override outputs for specific states
		case (state)

			// Wait for valid address and data
			S_IDLE:
				if (awvalid && wvalid) begin
					// Ready
					c_awready = 1'b1;
					c_wready  = 1'b1;

					// Write
					c_wr_addr_en = 1'b1;
					c_wr_en      = 1'b1;
				end

			// Write address and data ready asserted
			S_RDY:
				// Response is valid
				c_bvalid = 1'b1;

			// Response valid asserted wait for ready
			S_RSP:
				if (~bready) begin
					// Response is valid
					c_bvalid = 1'b1;
				end
				else begin
					// Check for next write
					if (awvalid && wvalid) begin
						// Ready
						c_awready = 1'b1;
						c_wready  = 1'b1;

						// Write
						c_wr_addr_en = 1'b1;
						c_wr_en      = 1'b1;
					end
				end

		endcase
	end

	// ------------------------------------------------------------------------
	// Outputs
	// ------------------------------------------------------------------------
	//
	// Registered outputs
	always_ff @(negedge rst_n or posedge clk)
	begin
		if (~rst_n) begin
			r_awready <= 1'b0;  // Not ready during reset
			r_wready  <= 1'b0;  // Not ready during reset
			r_bvalid  <= 1'b0;  // Not valid during reset
			r_wr_en   <= 1'b0;
		end
		else begin
			r_awready <= c_awready;
			r_wready  <= c_wready;
			r_bvalid  <= c_bvalid;
			r_wr_en   <= c_wr_en;
		end
	end
	assign awready = r_awready;
	assign wready  = r_wready;
	assign bvalid  = r_bvalid;
	assign wr_en   = r_wr_en;

	// Combinatorial outputs
	assign wr_addr_en = c_wr_addr_en;

endmodule

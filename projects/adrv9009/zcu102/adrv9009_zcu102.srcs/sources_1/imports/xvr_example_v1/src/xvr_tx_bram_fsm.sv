// ----------------------------------------------------------------------------
// xvr_tx_bram_fsm.sv
//
// 9/6/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Transceiver transmit BRAM control FSM.
//
// The control FSM reads the BRAM and streams data to the transmitter.
//
// ----------------------------------------------------------------------------

module xvr_tx_bram_fsm (

		// --------------------------------------------------------------------
		// Reset and Clock
		// --------------------------------------------------------------------
		//
		input  rst_n,
		input  clk,

		// --------------------------------------------------------------------
		// Control/status Interface
		// --------------------------------------------------------------------
		//
		input  enable,
		output done,

		// --------------------------------------------------------------------
		// Datapath
		// --------------------------------------------------------------------
		//
		output bram_en,
		output data_sel,
		output addr_load,
		output addr_en,
		input  addr_done
	);
	
	// ------------------------------------------------------------------------
	// FSM states
	// ------------------------------------------------------------------------
	//
	// * S_IDLE:
	//   - wait for enable
	//
	// * S_BUSY:
	//   - stream data to transmitter
	//
	// * S_LAST:
	//   - enable the BRAM one more clock, so that the last read is valid
	//
	// * S_DONE:
	//   - assert done and wait to be disabled
	//
	enum {
		S_IDLE,
		S_BUSY,
		S_LAST,
		S_DONE
	} state = S_IDLE;
	
	// ------------------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------------------
	//
	// Combinatorial signals
	logic c_done         = 1'b0;
	logic c_bram_en      = 1'b0;
	logic c_data_sel     = 1'b0;
	logic c_addr_load    = 1'b0;
	logic c_addr_en      = 1'b0;

	// Registered signals
	logic r_done         = 1'b0;
	logic r_bram_en      = 1'b0;
	logic r_data_sel     = 1'b0;
	
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

				// Wait for enable
				S_IDLE:
					if (enable) begin
						state <= S_BUSY;
					end

				// Wait for address done
				S_BUSY:
					if (enable) begin
						if (addr_done) begin
							state <= S_LAST;
						end
					end
					else begin
						state <= S_IDLE;
					end
					
				// Last read phase
				S_LAST:
					state <= S_DONE;

				// Wait for disable
				S_DONE:
					if (~enable) begin
						state <= S_IDLE;
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
		c_done         = 1'b0;
		c_bram_en      = 1'b0;
		c_data_sel     = 1'b0;  // Static pattern
		c_addr_load    = 1'b0;
		c_addr_en      = 1'b0;

		// Override outputs for specific states
		case (state)

			// Wait for enable
			S_IDLE:
				if (enable) begin
					// BRAM enable
					c_bram_en   = 1'b1;

					// Load the address counter
					c_addr_load = 1'b1;
				end

			// Wait for address done
			S_BUSY:
				if (enable) begin
					// BRAM enable
					c_bram_en   = 1'b1;

					// Select the BRAM output
					c_data_sel = 1'b1;

					if (~addr_done) begin
						// Enable the counter
						c_addr_en = 1'b1;
					end
				end

			// Last read phase
			S_LAST:
				begin
					// BRAM enable
					c_bram_en   = 1'b1;

					// Select the BRAM output
					c_data_sel = 1'b1;
				end

			// Wait for disable
			S_DONE:
				if (enable) begin
					// Done
					c_done = 1'b1;
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
			r_done     <= 1'b0;
			r_bram_en  <= 1'b0;
			r_data_sel <= 1'b0;
		end
		else begin
			r_done     <= c_done;
			r_bram_en  <= c_bram_en;
			r_data_sel <= c_data_sel;
		end
	end
	assign done     = r_done;
	assign bram_en  = r_bram_en;
	assign data_sel = r_data_sel;

	// Combinatorial outputs
	assign addr_load = c_addr_load;
	assign addr_en   = c_addr_en;

endmodule

// ----------------------------------------------------------------------------
// axi4lite_slave_interface_read_fsm.sv
//
// 7/18/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4-Lite slave interface read control FSM.
//
// ----------------------------------------------------------------------------

module axi4lite_slave_interface_read_fsm (

		// Reset and Clock
		input  rst_n,
		input  clk,

		// Read address
		input  arvalid,
		output arready,

		// Read data and response
		output rvalid,
		input  rready,

		// Datapath
		output rd_addr_en
	);
	
	// ------------------------------------------------------------------------
	// FSM states
	// ------------------------------------------------------------------------
	//
	// * S_IDLE:
	//   - wait for arvalid
	//
	// * S_RDY:
	//   - assert arready and perform the read
	//
	// * S_RSP:
	//   - assert rvalid and wait for rready
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
	logic c_arready    = 1'b0;
	logic c_rvalid     = 1'b0;
	logic c_rd_addr_en = 1'b0;
	
	// Registers
	logic r_arready = 1'b0;
	logic r_rvalid  = 1'b0;

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

				// Wait for valid address
				S_IDLE:
					if (arvalid) begin
						state <= S_RDY;
					end

				// Read address ready asserted
				S_RDY:
					state <= S_RSP;

				// Read valid asserted, wait for ready
				S_RSP:
					if (rready) begin
						// Check for next read
						if (arvalid) begin
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
		c_arready    = 1'b0;
		c_rvalid     = 1'b0;
		c_rd_addr_en = 1'b0;

		// Override outputs for specific states
		case (state)

			// Wait for valid address
			S_IDLE:
				if (arvalid) begin
					// Ready
					c_arready = 1'b1;

					// Read
					c_rd_addr_en = 1'b1;
				end

			// Read address ready asserted
			S_RDY:
				// Data is valid
				c_rvalid = 1'b1;

			// Read valid asserted, wait for ready
			S_RSP:
				if (~rready) begin
					// Read data is valid
					c_rvalid = 1'b1;
				end
				else begin
					// Check for next read
					if (arvalid) begin
						// Ready
						c_arready = 1'b1;

						// Read
						c_rd_addr_en = 1'b1;
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
			r_arready <= 1'b0;  // Not ready during reset
			r_rvalid  <= 1'b0;  // Not valid during reset
		end
		else begin
			r_arready <= c_arready;
			r_rvalid  <= c_rvalid;
		end
	end
	assign arready = r_arready;
	assign rvalid  = r_rvalid;

	// Combinatorial outputs
	assign rd_addr_en = c_rd_addr_en;

endmodule

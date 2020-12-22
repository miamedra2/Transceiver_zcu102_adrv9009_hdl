// ----------------------------------------------------------------------------
// axi4lite_to_drp_bridge_fsm.sv
//
// 7/28/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4-Lite to DRP bridge control FSM.
//
// The DRP bridge has a common address port, so this FSM multiplexes the
// AXI4-Lite write and read address onto the DRP interface.
//
// ----------------------------------------------------------------------------

module axi4lite_to_drp_bridge_fsm (

		// Reset and Clock
		input  axi_rst_n,
		input  axi_clk,

		// --------------------------------------------------------------------
		// AXI4-Lite Interface
		// --------------------------------------------------------------------
		//
		// Write address
		input  axi_awvalid,
		output axi_awready,

		// Write data
		input  axi_wvalid,
		output axi_wready,

		// Write response
		output axi_bvalid,
		input  axi_bready,

		// Read address
		input  axi_arvalid,
		output axi_arready,

		// Read data and response
		output axi_rvalid,
		input  axi_rready,

		// --------------------------------------------------------------------
		// DRP Interface
		// --------------------------------------------------------------------
		//
		output drp_en,
		output drp_we,
		input  drp_rdy,

		// --------------------------------------------------------------------
		// Datapath
		// --------------------------------------------------------------------
		//
		output addr_sel, // Write or read address
		output addr_en,
		output wdata_en,
		output rdata_en,
		output resp_sel,  // OKAY or SLVERR
		output resp_en,
		output timeout_load,
		output timeout_en,
		input  timeout_done
	);
	
	// ------------------------------------------------------------------------
	// FSM states
	// ------------------------------------------------------------------------
	//
	// * S_IDLE:
	//   - wait for awvalid and wvalid asserted
	//
	// * S_WRITE:
	//   - assert awready and wready, and perform the DRP write
	//
	// * S_WRSP:
	//   - assert bvalid and wait for bready
	//
	// * S_READ:
	//   - assert arready and perform the DRP read
	//
	// * S_RRSP:
	//   - assert rvalid and wait for rready
	//
	enum {
		S_IDLE,
		S_WRITE,
		S_WRSP,
		S_READ,
		S_RRSP
	} state = S_IDLE;
	
	// ------------------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------------------
	//
	// Combinatorial signals
	logic c_axi_awready  = 1'b0;
	logic c_axi_wready   = 1'b0;
	logic c_axi_bvalid   = 1'b0;
	logic c_axi_arready  = 1'b0;
	logic c_axi_rvalid   = 1'b0;
	logic c_drp_en       = 1'b0;
	logic c_drp_we       = 1'b0;
	logic c_addr_sel     = 1'b0;
	logic c_addr_en      = 1'b0;
	logic c_wdata_en     = 1'b0;
	logic c_rdata_en     = 1'b0;
	logic c_resp_sel     = 1'b0;
	logic c_resp_en      = 1'b0;
	logic c_timeout_load = 1'b0;
	logic c_timeout_en   = 1'b0;
	
	// Registers
	logic r_axi_awready = 1'b0;
	logic r_axi_wready  = 1'b0;
	logic r_axi_bvalid  = 1'b0;
	logic r_axi_arready = 1'b0;
	logic r_axi_rvalid  = 1'b0;
	logic r_drp_en      = 1'b0;
	logic r_drp_we      = 1'b0;

	// ------------------------------------------------------------------------
	// FSM state transitions
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			state <= S_IDLE;
		end
		else begin
			// State transitions
			case (state)

				// Wait for valid write or read
				S_IDLE:
					// Write has priority over read
					if (axi_awvalid && axi_wvalid) begin
						state <= S_WRITE;
					end
					else if (axi_arvalid) begin
						state <= S_READ;
					end

				// Wait for DRP ready or timeout
				S_WRITE:
					if (drp_rdy || timeout_done) begin
						state <= S_WRSP;
					end

				// Wait for AXI write response ready
				S_WRSP:
					if (axi_bready) begin
						// Check for blocked read or write
						if (axi_arvalid) begin
							state <= S_READ;
						end
						else if (axi_awvalid && axi_wvalid) begin
							state <= S_WRITE;
						end
						else begin
							state <= S_IDLE;						
						end
					end

				// Wait for read ready
				S_READ:
					if (drp_rdy || timeout_done) begin
						state <= S_RRSP;
					end

				// Read completed, send AXI response
				S_RRSP:
					if (axi_rready) begin
						// Check for blocked write or read
						if (axi_awvalid && axi_wvalid) begin
							state <= S_WRITE;
						end
						else if (axi_arvalid) begin
							state <= S_READ;
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
		c_axi_awready  = 1'b0;
		c_axi_wready   = 1'b0;
		c_axi_bvalid   = 1'b0;
		c_axi_arready  = 1'b0;
		c_axi_rvalid   = 1'b0;
		c_drp_en       = 1'b0;
		c_drp_we       = 1'b0;
		c_addr_sel     = 1'b0;  // Write address
		c_addr_en      = 1'b0;
		c_wdata_en     = 1'b0;
		c_rdata_en     = 1'b0;
		c_resp_sel     = 1'b0;  // Response is OKAY
		c_resp_en      = 1'b0;
		c_timeout_load = 1'b0;
		c_timeout_en   = 1'b0;

		// Override outputs for specific states
		case (state)

			// Wait for valid write or read
			S_IDLE:
				if (axi_awvalid && axi_wvalid) begin
					// AXI4-Lite Ready
					c_axi_awready = 1'b1;
					c_axi_wready  = 1'b1;

					// DRP write
					c_drp_en = 1'b1;
					c_drp_we = 1'b1;

					// Capture the write address and data
					c_addr_en  = 1'b1;
					c_wdata_en = 1'b1;

					// Timeout load
					c_timeout_load = 1'b1;				
				end
				else if (axi_arvalid) begin
					// AXI4-Lite Ready
					c_axi_arready = 1'b1;

					// DRP read
					c_drp_en = 1'b1;

					// Capture the read address
					c_addr_sel = 1'b1;
					c_addr_en  = 1'b1;

					// Timeout load
					c_timeout_load = 1'b1;				
				end

			// Wait for DRP ready or timeout
			S_WRITE:
				if (drp_rdy) begin
					// AXI4-Lite Response valid
					c_axi_bvalid = 1'b1;					

					// OKAY
					c_resp_en  = 1'b1;				
				end				
				else if (timeout_done) begin
					// AXI4-Lite Response valid
					c_axi_bvalid = 1'b1;					

					// SLVERR
					c_resp_en  = 1'b1;				
					c_resp_sel = 1'b1;				
				end
				else begin
					// Timeout enable
					c_timeout_en = 1'b1;				
				end

			// Wait for AXI write response ready
			S_WRSP:
				if (~axi_bready) begin
					// Response is valid
					c_axi_bvalid = 1'b1;
				end
				else begin
					// Check for blocked read or write
					if (axi_arvalid) begin
						// AXI4-Lite Ready
						c_axi_arready = 1'b1;

						// DRP read
						c_drp_en = 1'b1;

						// Capture the read address
						c_addr_sel = 1'b1;
						c_addr_en  = 1'b1;

						// Timeout load
						c_timeout_load = 1'b1;				
					end
					else if (axi_awvalid && axi_wvalid) begin
						// AXI4-Lite Ready
						c_axi_awready = 1'b1;
						c_axi_wready  = 1'b1;

						// DRP write
						c_drp_en = 1'b1;
						c_drp_we = 1'b1;

						// Capture the write address and data
						c_addr_en  = 1'b1;
						c_wdata_en = 1'b1;

						// Timeout load
						c_timeout_load = 1'b1;				
					end
				end

			// Wait for DRP ready or timeout
			S_READ:
				if (drp_rdy) begin
					// AXI4-Lite Response valid
					c_axi_rvalid = 1'b1;					

					// Capture the read data
					c_rdata_en  = 1'b1;				

					// OKAY
					c_resp_en  = 1'b1;				
				end				
				else if (timeout_done) begin
					// AXI4-Lite Response valid
					c_axi_rvalid = 1'b1;					

					// Capture the state of the data bus
					// (incase the value is useful)
					c_rdata_en  = 1'b1;				

					// SLVERR
					c_resp_en  = 1'b1;				
					c_resp_sel = 1'b1;				
				end
				else begin
					// Timeout enable
					c_timeout_en = 1'b1;				
				end

			// Wait for AXI read response ready
			S_RRSP:
				if (~axi_rready) begin
					// Response is valid
					c_axi_rvalid = 1'b1;
				end
				else begin
					// Check for blocked write or read
					if (axi_awvalid && axi_wvalid) begin
						// AXI4-Lite Ready
						c_axi_awready = 1'b1;
						c_axi_wready  = 1'b1;

						// Capture the write address and data
						c_addr_en  = 1'b1;
						c_wdata_en = 1'b1;

						// Timeout load
						c_timeout_load = 1'b1;				
					end
					else if (axi_arvalid) begin
						// AXI4-Lite Ready
						c_axi_arready = 1'b1;

						// Capture the read address
						c_addr_sel = 1'b1;
						c_addr_en  = 1'b1;

						// Timeout load
						c_timeout_load = 1'b1;				
					end
				end
		endcase
	end

	// ------------------------------------------------------------------------
	// Outputs
	// ------------------------------------------------------------------------
	//
	// Registered outputs
	always_ff @(negedge axi_rst_n or posedge axi_clk)
	begin
		if (~axi_rst_n) begin
			r_axi_awready <= 1'b0;  // Not ready during reset
			r_axi_wready  <= 1'b0;  // Not ready during reset
			r_axi_bvalid  <= 1'b0;  // Not valid during reset
			r_axi_arready <= 1'b0;  // Not ready during reset
			r_axi_rvalid  <= 1'b0;  // Not valid during reset
			r_drp_en      <= 1'b0;
			r_drp_we      <= 1'b0;
		end
		else begin
			r_axi_awready <= c_axi_awready;
			r_axi_wready  <= c_axi_wready;
			r_axi_bvalid  <= c_axi_bvalid;
			r_axi_arready <= c_axi_arready; 
			r_axi_rvalid  <= c_axi_rvalid; 
			r_drp_en      <= c_drp_en;
			r_drp_we      <= c_drp_we;
		end
	end
	assign axi_awready = r_axi_awready;
	assign axi_wready  = r_axi_wready;
	assign axi_bvalid  = r_axi_bvalid;
	assign axi_arready = r_axi_arready;
	assign axi_rvalid  = r_axi_rvalid;
	assign drp_en      = r_drp_en;
	assign drp_we      = r_drp_we;

	// Combinatorial outputs
	assign addr_sel     = c_addr_sel;
	assign addr_en      = c_addr_en;
	assign wdata_en     = c_wdata_en;
	assign rdata_en     = c_rdata_en;
	assign resp_sel     = c_resp_sel;
	assign resp_en      = c_resp_en;
	assign timeout_load = c_timeout_load;
	assign timeout_en   = c_timeout_en;

endmodule

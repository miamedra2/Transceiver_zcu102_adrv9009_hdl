// ----------------------------------------------------------------------------
// axi4_bram_common_address_fsm.sv
//
// 9/12/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4 BRAM with common read/write address control FSM.
//
// ----------------------------------------------------------------------------

module axi4_bram_common_address_fsm (
		// AXI Reset and Clock
		input  logic axi_rst_n,
		input  logic axi_clk,

		// AXI Write Address Channel
		input  logic axi_awvalid,
		output logic axi_awready,

		// AXI Write Data Channel
		input  logic axi_wlast,
		input  logic axi_wvalid,
		output logic axi_wready,

		// AXI Write Response Channel
		output logic axi_bvalid,
		input  logic axi_bready,

		// AXI Read Address Channel
		input  logic axi_arvalid,
		output logic axi_arready,

		// AXI Read Data Channel
		input  logic axi_rready,
		input  logic axi_rlast,   // Pipeline output
		input  logic axi_rvalid,

		// BRAM Interface
		output logic bram_en,

		// Datapath control
		output logic bid_en,
		output logic rid_en,
		output logic addr_sel,
		output logic addr_load,
		output logic addr_en,
		output logic strb_sel,
		output logic burst_load,
		output logic burst_en,
		input  logic burst_done,
		output logic pipeline_en,
		output logic pipeline_rvalid,
		output logic pipeline_rlast
	);

	// ------------------------------------------------------------------------
	// FSM enumeration
	// ------------------------------------------------------------------------
	//
	// The address is common to write and read, so the control FSM implements
	// both write and read states to enforce exclusive access to the BRAM
	// address.
	//
	enum {
		S_IDLE,
		//
		// Write states
		S_WR_WRITE,
		S_WR_RESP,
		//
		// Read states
		S_RD_FILL,
		S_RD_WAIT,
		S_RD_READ,
		S_RD_DRAIN
	} state = S_IDLE;

	// ------------------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------------------
	//
	// Combinatorial signals
	logic c_axi_awready     = 1'b0;
	logic c_axi_wready      = 1'b0;
	logic c_axi_bvalid      = 1'b0;
	logic c_axi_arready     = 1'b0;
	logic c_bram_en         = 1'b0;
	logic c_bid_en          = 1'b0;
	logic c_rid_en          = 1'b0;
	logic c_addr_sel        = 1'b0;
	logic c_addr_load       = 1'b0;
	logic c_addr_en         = 1'b0;
	logic c_strb_sel        = 1'b0;
	logic c_burst_load      = 1'b0;
	logic c_burst_en        = 1'b0;
	logic c_pipeline_en     = 1'b0;
	logic c_pipeline_rvalid = 1'b0;
	logic c_pipeline_rlast  = 1'b0;

	// ------------------------------------------------------------------------
	// FSM state transitions
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk)
	begin
		if (~axi_rst_n) begin
			state <= S_IDLE;
		end else begin
			case (state)

				// Wait for a valid write address and data
				S_IDLE:
					if (axi_awvalid) begin
						if (axi_wvalid) begin
							state <= S_WR_WRITE;
						end
					end
					else if (axi_arvalid) begin
						state <= S_RD_FILL;
					end
					
				// ------------------------------------------------------------
				// Write states
				// ------------------------------------------------------------
				//				
				// Write data phases
				S_WR_WRITE:
					if (axi_wvalid) begin
						if (axi_wlast) begin
							state <= S_WR_RESP;
						end
					end

				// Wait for the write response to be acknowledged
				S_WR_RESP:
					if (axi_bready) begin
						state <= S_IDLE;
					end

				// ------------------------------------------------------------
				// Read states
				// ------------------------------------------------------------
				//				
				// Issue reads
				S_RD_FILL:				
					if (~axi_rvalid) begin				
						if (burst_done) begin
							// All reads have been issued, but the output is
							// not valid, so wait for pipelined data
							state <= S_RD_WAIT;						
						end
					end
					else begin
						// The pipeline output is valid
						if (axi_rready) begin
							// Data was accepted
							if (burst_done) begin					
								// All reads have been issued.
								// No need to check axi_rlast here, as it cannot
								// be asserted, since it is generated based
								// on burst_done (which has just asserted)
								state <= S_RD_DRAIN;
							end
							else begin
								// Continue issuing reads
								state <= S_RD_READ;
							end					
						end					
						else begin
							// Continue issuing reads
							state <= S_RD_READ;						
						end
					end

				// Wait for pipeline data
				S_RD_WAIT:
					if (axi_rvalid) begin
						if (axi_rready) begin
							// Single read
							if (axi_rlast) begin
								state <= S_IDLE;
							end
							else begin
								state <= S_RD_DRAIN;
							end
						end
						else begin
							// Continue waiting for ready
							state <= S_RD_DRAIN;						
						end
					end

				// Issue reads (until burst done asserts)
				S_RD_READ:
					if (axi_rready) begin
						if (burst_done) begin
							state <= S_RD_DRAIN;
						end
					end

				// Wait for pipelined data to drain
				S_RD_DRAIN:
					if (axi_rready) begin
						if (axi_rlast) begin
							state <= S_IDLE;
						end
					end

			endcase
		end
	end

	// ------------------------------------------------------------------------
	// FSM combinatorial output generation
	// ------------------------------------------------------------------------
	//
	always_comb
	begin
		// Defaults
		c_axi_awready     = 1'b0; // Not ready
		c_axi_wready      = 1'b0;
		c_axi_bvalid      = 1'b0;
		c_axi_arready     = 1'b0;
		c_bram_en         = 1'b0;
		c_bid_en          = 1'b0;
		c_rid_en          = 1'b0;
		c_addr_sel        = 1'b0;
		c_addr_load       = 1'b0;
		c_addr_en         = 1'b0;
		c_strb_sel        = 1'b0;
		c_burst_load      = 1'b0;
		c_burst_en        = 1'b0;
		c_pipeline_en     = 1'b0;
		c_pipeline_rvalid = 1'b0;
		c_pipeline_rlast  = 1'b0;

		// Output generation
		case (state)
			// Wait for a valid write address
			S_IDLE:
				if (axi_awvalid) begin
					if (axi_wvalid) begin
						// Accept the write address
						c_axi_awready = 1'b1;

						// Ready for write data
						c_axi_wready  = 1'b1;

						// Capture the write ID
						c_bid_en       = 1'b1;
						
						// Load the address counter
						c_addr_sel    = 1'b1;
						c_addr_load   = 1'b1;
					end
				end
				else if (axi_arvalid) begin
					// Accept the read address
					c_axi_arready = 1'b1;

					// Capture the read ID
					c_rid_en       = 1'b1;

					// Load the address counter
					c_addr_load   = 1'b1;

					// Load the burst counter
					c_burst_load  = 1'b1;
				end

			// ----------------------------------------------------------------
			// Write states
			// ----------------------------------------------------------------
			//				
			// Write data phases
			S_WR_WRITE:
				if (axi_wvalid) begin
					// Enable BRAM
					c_bram_en = 1'b1;
					
					// Select the write strobes
					c_strb_sel = 1'b1;

					// Last write?
					if (~axi_wlast) begin
						// Ready for write data
						c_axi_wready  = 1'b1;

						// Increment the write address
						c_addr_en     = 1'b1;
					end
					else begin
						// Write response is valid
						c_axi_bvalid  = 1'b1;
					end
				end
				else begin
					// Ready for write data
					c_axi_wready  = 1'b1;
				end

			// Wait for the response to be acknowledged
			S_WR_RESP:
				if (~axi_bready) begin
					// Write response is valid
					c_axi_bvalid  = 1'b1;
				end

			// ----------------------------------------------------------------
			// Read states
			// ----------------------------------------------------------------
			//				
			// Issue reads
			S_RD_FILL:
				if (~axi_rvalid) begin
					// The pipeline output is not valid

					// Enable BRAM
					c_bram_en = 1'b1;

					// Enable the pipeline
					c_pipeline_en     = 1'b1;
					c_pipeline_rvalid = 1'b1;
				
					if (~burst_done) begin
						// Enable the address counter
						c_addr_en = 1'b1;

						// Enable the burst counter
						c_burst_en = 1'b1;
					end
					else begin
						// Pipeline the last phase
						c_pipeline_rlast = 1'b1;
					end
				end
				else begin
					// The pipeline output is valid
					if (axi_rready) begin
						// The valid output was acknowledged

						// Enable BRAM
						c_bram_en = 1'b1;
					
						// Enable the pipeline
						c_pipeline_en     = 1'b1;
						c_pipeline_rvalid = 1'b1;

						if (~burst_done) begin
							// Enable the address counter
							c_addr_en = 1'b1;

							// Enable the burst counter
							c_burst_en = 1'b1;
						end
						else begin
							// Pipeline the last phase
							c_pipeline_rlast = 1'b1;
						end
					end
				end					

			// Wait for pipeline data
			S_RD_WAIT:
				if (~axi_rvalid) begin
					// Enable BRAM
					c_bram_en = 1'b1;

					// Enable the pipeline
					c_pipeline_en    = 1'b1;
				end
				else begin
					// The pipeline output is valid
					if (axi_rready) begin
						// Enable BRAM
						c_bram_en = 1'b1;

						// Enable the pipeline
						c_pipeline_en    = 1'b1;
					end
				end

			// Issue reads
			S_RD_READ:
				if (axi_rready) begin
					// Enable BRAM
					c_bram_en = 1'b1;

					// Enable the pipeline
					c_pipeline_en     = 1'b1;
					c_pipeline_rvalid = 1'b1;

					if (~burst_done) begin
						// Enable the address counter
						c_addr_en = 1'b1;

						// Enable the burst counter
						c_burst_en = 1'b1;
					end
					else begin
						// Pipeline the last phase
						c_pipeline_rlast = 1'b1;
					end
				end

			// Wait for pipelined data to drain
			S_RD_DRAIN:
				if (axi_rready) begin
					// Enable BRAM
					c_bram_en = 1'b1;

					// Enable the pipeline
					c_pipeline_en = 1'b1;
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
			axi_awready <= 1'b0; // Not ready during reset
			axi_wready  <= 1'b0;
			axi_bvalid  <= 1'b0;
			axi_arready <= 1'b0;
		end
		else begin
			axi_awready <= c_axi_awready;
			axi_wready  <= c_axi_wready;
			axi_bvalid  <= c_axi_bvalid;
			axi_arready <= c_axi_arready;
		end
	end

	// Combinatorial outputs
	assign bram_en         = c_bram_en;
	assign bid_en          = c_bid_en;
	assign rid_en          = c_rid_en;
	assign addr_sel        = c_addr_sel;
	assign addr_load       = c_addr_load;
	assign addr_en         = c_addr_en;
	assign strb_sel        = c_strb_sel;
	assign burst_load      = c_burst_load;
	assign burst_en        = c_burst_en;
	assign pipeline_en     = c_pipeline_en;
	assign pipeline_rvalid = c_pipeline_rvalid;
	assign pipeline_rlast  = c_pipeline_rlast;

endmodule
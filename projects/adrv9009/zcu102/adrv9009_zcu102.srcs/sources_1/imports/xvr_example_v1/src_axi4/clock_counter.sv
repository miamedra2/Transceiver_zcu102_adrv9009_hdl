// ----------------------------------------------------------------------------
// clock_counter.sv
//
// 7/6/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Clock counter component.
//
// ----------------------------------------------------------------------------

module clock_counter #(
		parameter int WIDTH = 32
	) (

		// --------------------------------------------------------------------
		// System control clock-domain
		// --------------------------------------------------------------------
		//
		// Reset and Clock
		input              sys_rst_n,
		input              sys_clk,

		// Controller enable
		input              sys_en,

		// Clock counter
		output [WIDTH-1:0] sys_count,

		// --------------------------------------------------------------------
		// External/other clock-domain
		// --------------------------------------------------------------------
		//
		input              ext_clk
	);

	// ------------------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------------------
	//
	// System clock domain
	logic             sys_cnt_en;
	logic [WIDTH-1:0] sys_cnt;
	
	// Synchronized enable
	logic             ext_en;
	logic             ext_dly;
	
	// Counter clear and enable
	logic             ext_cnt_clr;
	logic             ext_cnt_en;
	logic [WIDTH-1:0] ext_cnt;


	// ========================================================================
	// System clock domain
	// ========================================================================
	//
	// ------------------------------------------------------------------------
	// Enable Synchronizer
	// ------------------------------------------------------------------------
	//
	// The enable from the external clock domain is sent back to the system
	// clock domain and used as the count register capture enable.
	xpm_cdc_single #(
		.DEST_SYNC_FF   (2), // Number of synchronizer registers
		.INIT_SYNC_FF   (1), // Simulate init values
		.SIM_ASSERT_CHK (1), // Enable simulation messages
		.SRC_INPUT_REG  (0)  // No additional input register
	) u1 (
		// External control clock domain
		.src_clk (1'b0      ),  // Unused when no input register
		.src_in  (ext_cnt_en),  // Input signal
		
		// System clock source domain
		.dest_clk(sys_clk   ),  // Destination clock domain.
		.dest_out(sys_cnt_en)   // Synchronized output
	);

	// ------------------------------------------------------------------------
	// Counter Capture
	// ------------------------------------------------------------------------
	//
	// The ext_cnt counter is disabled when sys_en and sys_cnt_en are both
	// low. The static counter value can be transferred into the sys_clk
	// domain.
	//
	always_ff @(negedge sys_rst_n or posedge sys_clk) begin
		if (~sys_rst_n) begin
			sys_cnt <= '0;
		end
		else begin
			if (~sys_en & ~sys_cnt_en) begin
				sys_cnt <= ext_cnt;
			end
		end
	end
	
	// Counter output
	assign sys_count = sys_cnt;
//	assign sys_count = ext_cnt;
	
	// ========================================================================
	// External/other clock domain
	// ========================================================================
	//
	// ------------------------------------------------------------------------
	// Enable Synchronizer
	// ------------------------------------------------------------------------
	//
	xpm_cdc_single #(
		.DEST_SYNC_FF   (2), // Number of synchronizer registers
		.INIT_SYNC_FF   (1), // Simulate init values
		.SIM_ASSERT_CHK (1), // Enable simulation messages
		.SRC_INPUT_REG  (0)  // No additional input register
	) u2 (
		// System control clock domain
		.src_clk (1'b0   ),  // Unused when no input register
		.src_in  (sys_en ),  // Input signal
		
		// External clock source domain
		.dest_clk(ext_clk),  // Destination clock domain.
		.dest_out(ext_en )   // Synchronized output
	);

	// ------------------------------------------------------------------------
	// Delay register
	// ------------------------------------------------------------------------
	//
	// The counter is cleared when the counter is first enabled. The count
	// value is held when enable is deasserted, so that it can be read in
	// the system clock domain.
	//
	always_ff @(posedge ext_clk) begin
		ext_dly <= ext_en;
	end

	// ------------------------------------------------------------------------
	// Counter
	// ------------------------------------------------------------------------
	//
	always_ff @(posedge ext_clk) begin
		if (ext_cnt_clr) begin
			ext_cnt <= '0;
		end
		else if (ext_cnt_en) begin
			ext_cnt <= ext_cnt + 1;
		end
	end
	
	// Clear during the first clock of the enable
	assign ext_cnt_clr = ext_en & ~ext_dly;

	// Enable the counter	
	assign ext_cnt_en = ext_dly;
		
endmodule


// ----------------------------------------------------------------
// axi4_burst_counter.sv
//
// 5/3/2017 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4 burst counter.
//
// The burst counter is a down-counter loaded with the AXI4
// AxLEN[7:0] value at the beginning of a write or read
// transaction. The carry (done) output of the down-counter
// is used by the write/read datapath FSMs to generate the
// AXI4 last output.
//
// ----------------------------------------------------------------
// References
// ----------
//
// [1] ARM, "AMBA 4 AXI4, AXI4-Lite, and AXI4-Stream Protocol
//     Assertions User Guide", Rev. r0p1, 2012.
//     DUI0534B_amba_4_axi4_protocol_assertions_ug.pdf
//
// ----------------------------------------------------------------

module axi4_burst_counter (
		// --------------------------------------------------------
		// AXI Reset and Clock
		// --------------------------------------------------------
		//
		input  logic       axi_aresetn,
		input  logic       axi_aclk,

		// --------------------------------------------------------
		// AXI Length
		// --------------------------------------------------------
		//
		input  logic [7:0] axi_len,

		// --------------------------------------------------------
		// Counter Controls
		// --------------------------------------------------------
		//
		input  logic       burst_load,
		input  logic       burst_en,
		output logic       burst_done
	);

	// ------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------
	//
	// Combinatorial sum (used to generate the carry out)
	logic [8:0] sum;
	//
	// Registered burst count
	logic [7:0] count = '0;

	// ------------------------------------------------------------
	// Combinatorial sum
	// ------------------------------------------------------------
	//
	// Down counter
	always_comb begin
		sum = count - 1;
	end

	// Carry output
	assign burst_done = sum[8];

	// ------------------------------------------------------------
	// Registered address
	// ------------------------------------------------------------
	//
	always_ff @(negedge axi_aresetn, posedge axi_aclk) begin
		if (~axi_aresetn) begin
			count <= '0;
		end
		else begin
			if (burst_load) begin
				count <= axi_len;
			end
			else if (burst_en) begin
				count <= sum;
			end
		end
	end

endmodule


// ----------------------------------------------------------------------------
// bram_128k_x_32_and_32k_x_128.sv
//
// 9/6/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Xilinx UltraScale 32kbit Block RAMs configured as dual port, with
//  - Port A = 128k x  32-bit
//  - Port B =  32k x 128-bit
//
// The RAM is constructed from 4 x 32k x 32-bit instances. The 2-LSBs of
// the address on the 32-bit interface multiplexes 1:4 32-bit words of the
// 128-bit interface (little-endian format).
//
// This arrangement allows the BRAM to be written as 32-bit memory and
// read as 128-bit memory
//
// ----------------------------------------------------------------------------

module bram_128k_x_32_and_32k_x_128  #(
		// BRAM output registers
		parameter integer DOA_REG = 1,
		parameter integer DOB_REG = 1,

		// Port A mux register
		parameter integer MUXA_REG = 1
	) (
		// Port A
		input          a_ram_rst,
		input          a_clk,
		input   [16:0] a_addr,        // 2^17 = 128k
		input          a_addr_en,
		input          a_en,
		input    [3:0] a_we,
		input   [31:0] a_wdata,
		output  [31:0] a_rdata,
		input          a_reg_rst,
		input          a_reg_en,

		// Port B
		input          b_ram_rst,
		input          b_clk,
		input   [14:0] b_addr,        // 2^15 = 32k
		input          b_addr_en,
		input          b_en,
		input   [15:0] b_we,
		input  [127:0] b_wdata,
		output [127:0] b_rdata,
		input          b_reg_rst,
		input          b_reg_en
	);
	// -------------------------------------------------------------------------
	// Internal Signals
	// -------------------------------------------------------------------------
	//
	// 4 x 32k x 32-bit block RAM enables
	logic [3:0] en;

	// 4:1 32-bit read data multiplexer
	// - rddata_sel pipelined to account for DO_REG
	logic  [1:0] rdata_sel[2] = '{default:'0};
	logic [31:0] rdata[4];
	logic [31:0] rdata_mux;

	// -------------------------------------------------------------------------
	// Address Decoding
	// -------------------------------------------------------------------------
	//
	// Enable even/odd address access
	always_comb begin
		// Defaults
		en = '0;

		// Address decode
		for (int unsigned i = 0; i < 4; i++) begin
			en[i] = a_en & (a_addr[1:0] == i);
		end
	end

	// Address LSB pipeline to select read data
	// * address to data latency is two clocks
	always_ff @(posedge a_reg_rst or posedge a_clk) begin
		if (a_reg_rst) begin
			rdata_sel <= '{default:'0};
		end
		else begin
			// Address pipeline register
			if (a_en) begin
				if (a_addr_en) begin
					rdata_sel[0] <= a_addr[1:0];
				end
			end
			// DO_REG = 1 pipeline register
			if (a_reg_en) begin
				rdata_sel[1] <= rdata_sel[0];
			end
		end
	end

	// -------------------------------------------------------------------------
	// BRAM
	// -------------------------------------------------------------------------
	//
	// Port A  32-bit: addr[1:0] = 00b, 01b, 10b, 11b
	// Port B 128-bit: 32-bit data index 0, 1, 2, 3
	for (genvar i = 0; i < 4; i++) begin: g1
		bram_32k_x_32 #(
			.DOA_REG(DOA_REG),
			.DOB_REG(DOB_REG)
		) u1 (
			// Port A
			.a_ram_rst (a_ram_rst          ),
			.a_clk     (a_clk              ),
			.a_addr    (a_addr[16:2]       ),
			.a_addr_en (a_addr_en          ),
			.a_en      (en[i]              ),
			.a_we      (a_we               ),
			.a_wdata   (a_wdata            ),
			.a_rdata   (rdata[i]           ),
			.a_reg_rst (a_reg_rst          ),
			.a_reg_en  (a_reg_en           ),

			// Port B
			.b_ram_rst (b_ram_rst          ),
			.b_clk     (b_clk              ),
			.b_addr    (b_addr             ),
			.b_addr_en (b_addr_en          ),
			.b_en      (b_en               ),
			.b_we      (b_we[i*4 +: 4]     ),
			.b_wdata   (b_wdata[i*32 +: 32]),
			.b_rdata   (b_rdata[i*32 +: 32]),
			.b_reg_rst (b_reg_rst          ),
			.b_reg_en  (b_reg_en           )
		);
	end

	// -------------------------------------------------------------------------
	// Port A read multiplexer
	// -------------------------------------------------------------------------
	//
	if (MUXA_REG == 0) begin: g2
		// Combinatorial multiplexer
		//  * The multiplexer select pipeline depends on whether
		//    whether DOA_REG has been enabled
		assign rdata_mux = rdata[rdata_sel[DOA_REG]];
	end
	else begin: g3
		// Registered multiplexer
		always_ff @(posedge a_reg_rst or posedge a_clk) begin
			if (a_reg_rst) begin
				rdata_mux <= '0;
			end
			else begin
				if (a_reg_en) begin
					// The multiplexer select pipeline depends on whether
					// whether DOA_REG has been enabled
					rdata_mux <= rdata[rdata_sel[DOA_REG]];
				end
			end
		end
	end

	// Output
	assign a_rdata = rdata_mux;
endmodule


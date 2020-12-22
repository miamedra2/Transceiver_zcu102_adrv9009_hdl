// ----------------------------------------------------------------------------
// bram_32k_x_32.sv
//
// 9/6/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Xilinx UltraScale 32kbit Block RAMs configured as 32k x 32-bit.
//
// ----------------------------------------------------------------------------

module bram_32k_x_32 #(
		// Output registers
		parameter integer DOA_REG = 1,
		parameter integer DOB_REG = 1
	) (
		// Port A
		input         a_ram_rst,
		input         a_clk,
		input  [14:0] a_addr,       // 2^15 = 32k
		input         a_addr_en,
		input         a_en,
		input   [3:0] a_we,
		input  [31:0] a_wdata,
		output [31:0] a_rdata,
		input         a_reg_rst,
		input         a_reg_en,

		// Port B
		input         b_ram_rst,
		input         b_clk,
		input  [14:0] b_addr,
		input         b_addr_en,
		input         b_en,
		input   [3:0] b_we,
		input  [31:0] b_wdata,
		output [31:0] b_rdata,
		input         b_reg_rst,
		input         b_reg_en
	);

	// 32 instances of 32k x 1-bit BRAM
	for (genvar i = 0; i < 32; i++) begin: g1
		bram_32k_x_1 #(
			.DOA_REG(DOA_REG),
			.DOB_REG(DOB_REG)
		) u1 (
			// Port A
			.a_ram_rst (a_ram_rst),
			.a_clk     (a_clk    ),
			.a_addr    (a_addr   ),
			.a_addr_en (a_addr_en),
			.a_en      (a_en     ),
			.a_we      (a_we[i/8]),
			.a_wdata   (a_wdata[i]),
			.a_rdata   (a_rdata[i]),
			.a_reg_rst (a_reg_rst),
			.a_reg_en  (a_reg_en ),

			// Port B
			.b_ram_rst (b_ram_rst),
			.b_clk     (b_clk    ),
			.b_addr    (b_addr   ),
			.b_addr_en (b_addr_en),
			.b_en      (b_en     ),
			.b_we      (b_we[i/8]),
			.b_wdata   (b_wdata[i]),
			.b_rdata   (b_rdata[i]),
			.b_reg_rst (b_reg_rst),
			.b_reg_en  (b_reg_en )
		);
	end

endmodule


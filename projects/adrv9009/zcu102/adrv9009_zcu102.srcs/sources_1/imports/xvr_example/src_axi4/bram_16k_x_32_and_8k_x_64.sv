// ----------------------------------------------------------------------------
// bram_16k_x_32_and_8k_x_64.sv
//
// 9/6/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Xilinx UltraScale 32kbit Block RAMs configured as dual port, with 
//  - Port A = 16k x 32-bit
//  - Port B =  8k x 64-bit
//
// The RAM is constructed from two 8k x 32-bit instances. The LSB of
// the 32-bit interface selects the LSB or MSB 32-bit word of the
// 64-bit interface (little-endian format).
//
// This arrangement allows the BRAM to be written as 32-bit memory and
// read as 64-bit memory
//
// ----------------------------------------------------------------------------

module bram_16k_x_32_and_8k_x_64  #(
		// BRAM output registers
		parameter integer DOA_REG = 1,
		parameter integer DOB_REG = 1,
		
		// Port A mux register
		parameter integer MUXA_REG = 1		
	) (
		// Port A
		input         a_ram_rst,
		input         a_clk,
		input  [13:0] a_addr,
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
		input  [12:0] b_addr,
		input         b_addr_en,
		input         b_en,
		input   [7:0] b_we,
		input  [63:0] b_wdata,
		output [63:0] b_rdata,
		input         b_reg_rst,
		input         b_reg_en
	);
	// -------------------------------------------------------------------------
	// Internal Signals
	// -------------------------------------------------------------------------
	//
	// 32-bit block RAM enables
	logic       a_en_e; // even addresses
	logic       a_en_o; // odd addresses
	
	// 32-bit read data
	logic  [1:0] a_rdata_sel = '0;
	logic [31:0] a_rdata_e;
	logic [31:0] a_rdata_o;
	logic [31:0] a_rdata_mux;

	// -------------------------------------------------------------------------
	// Address Decoding
	// -------------------------------------------------------------------------
	//
	// Enable even/odd address access
	assign a_en_e = a_en & ~a_addr[0];
	assign a_en_o = a_en &  a_addr[0];
	
	// Address LSB pipeline to select read data
	// * address to data latency is two clocks
	always_ff @(posedge a_reg_rst or posedge a_clk) begin
		if (a_reg_rst) begin
			a_rdata_sel <= '0;
		end
		else begin
			// Address pipeline register
			if (a_en) begin
				if (a_addr_en) begin
					a_rdata_sel[0] <= a_addr[0];
				end
			end
			// DO_REG = 1 pipeline register
			if (a_reg_en) begin
				a_rdata_sel[1] <= a_rdata_sel[0];
			end
		end
	end

	// -------------------------------------------------------------------------
	// BRAM
	// -------------------------------------------------------------------------
	//
	// Port A 32-bit: even addresses
	// Port B 64-bit: low 32-bit data
	bram_8k_x_32 #(
		.DOA_REG(DOA_REG),
		.DOB_REG(DOB_REG)
	) u1 (
		// Port A
		.a_ram_rst (a_ram_rst),
		.a_clk     (a_clk    ),
		.a_addr    (a_addr[13:1]),
		.a_addr_en (a_addr_en),
		.a_en      (a_en_e   ),
		.a_we      (a_we     ),
		.a_wdata   (a_wdata  ),
		.a_rdata   (a_rdata_e),
		.a_reg_rst (a_reg_rst),
		.a_reg_en  (a_reg_en ),

		// Port B
		.b_ram_rst (b_ram_rst),
		.b_clk     (b_clk    ),
		.b_addr    (b_addr   ),
		.b_addr_en (b_addr_en),
		.b_en      (b_en     ),
		.b_we      (b_we[3:0]),
		.b_wdata   (b_wdata[31:0]),
		.b_rdata   (b_rdata[31:0]),
		.b_reg_rst (b_reg_rst),
		.b_reg_en  (b_reg_en )
	);

	// Port A 32-bit: odd addresses
	// Port B 64-bit: high 32-bit data
	bram_8k_x_32 #(
		.DOA_REG(DOA_REG),
		.DOB_REG(DOB_REG)
	) u2 (
		// Port A
		.a_ram_rst (a_ram_rst),
		.a_clk     (a_clk    ),
		.a_addr    (a_addr[13:1]),
		.a_addr_en (a_addr_en),
		.a_en      (a_en_o   ),
		.a_we      (a_we     ),
		.a_wdata   (a_wdata  ),
		.a_rdata   (a_rdata_o),
		.a_reg_rst (a_reg_rst),
		.a_reg_en  (a_reg_en ),

		// Port B
		.b_ram_rst (b_ram_rst),
		.b_clk     (b_clk    ),
		.b_addr    (b_addr   ),
		.b_addr_en (b_addr_en),
		.b_en      (b_en     ),
		.b_we      (b_we[7:4]),
		.b_wdata   (b_wdata[63:32]),
		.b_rdata   (b_rdata[63:32]),
		.b_reg_rst (b_reg_rst),
		.b_reg_en  (b_reg_en )
	);

	// -------------------------------------------------------------------------
	// Port A read multiplexer
	// -------------------------------------------------------------------------
	//
	if (MUXA_REG == 0) begin: g1
		// Combinatorial multiplexer
		//  * The multiplexer select pipeline depends on whether
		//    whether DOA_REG has been enabled
		assign a_rdata_mux = a_rdata_sel[DOA_REG] ? a_rdata_o : a_rdata_e;
	end 
	else begin: g2
		// Registered multiplexer
		always_ff @(posedge a_reg_rst or posedge a_clk) begin
			if (a_reg_rst) begin
				a_rdata_mux <= '0;
			end
			else begin
				if (a_reg_en) begin
					// The multiplexer select pipeline depends on whether
					// whether DOA_REG has been enabled
					a_rdata_mux <= a_rdata_sel[DOA_REG] ? a_rdata_o : a_rdata_e;
				end
			end
		end	
	end
	
	// Output	
	assign a_rdata = a_rdata_mux;
endmodule


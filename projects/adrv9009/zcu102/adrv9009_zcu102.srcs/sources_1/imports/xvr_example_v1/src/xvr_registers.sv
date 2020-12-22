// ----------------------------------------------------------------------------
// xvr_registers.sv
//
// 7/17/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov
//
// Transceiver design registers.
//
// ----------------------------------------------------------------------------

module xvr_registers (
		// --------------------------------------------------------------------
		// AXI4-Lite Interface
		// --------------------------------------------------------------------

		// AXI4 reset and clock
		input         axi_rst_n,
		input         axi_clk,

		// Write address
		output        axi_awready,
		input         axi_awvalid,
		input  [31:0] axi_awaddr,

		// Write data
		output        axi_wready,
		input         axi_wvalid,
		input   [3:0] axi_wstrb,
		input  [31:0] axi_wdata,

		// Write response
		input         axi_bready,
		output        axi_bvalid,
		output  [1:0] axi_bresp,

		// Read address
		output        axi_arready,
		input         axi_arvalid,
		input  [31:0] axi_araddr,

		// Read data
		input         axi_rready,
		output        axi_rvalid,
		output  [1:0] axi_rresp,
		output [31:0] axi_rdata,

		// --------------------------------------------------------------------
		// Registers Interface
		// --------------------------------------------------------------------
		//
		output  [31:0] control0,
		output  [31:0] control1,
		output  [31:0] control2,
		output  [31:0] control3,
		output  [31:0] control4,
		output  [31:0] control5,
		output  [31:0] control6,
		output  [31:0] control7,
		input   [31:0] status0,
		input   [31:0] status1,
		input   [31:0] status2,
		input   [31:0] status3,
		input   [31:0] status4,
		input   [31:0] status5,
		input   [31:0] status6,
		input   [31:0] status7
	);

	// ------------------------------------------------------------------------
	// Local Parameters
	// ------------------------------------------------------------------------
	//
	localparam int AXI_ID_WIDTH   = 1;
	localparam int AXI_ADDR_WIDTH = 32;
	localparam int AXI_STRB_WIDTH = 4;
	localparam int AXI_DATA_WIDTH = 32;

	// Number of address bits decoded by the component region
	localparam ADDR_WIDTH = 16;

	// Number of address bits decoded by the used location
	localparam ADDR_DEC_WIDTH = 4;

	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	// Memory/registers Interface
	logic                      mem_wren;
	logic [AXI_STRB_WIDTH-1:0] mem_wstrb;
	logic [AXI_ADDR_WIDTH-1:0] mem_waddr;
	logic [AXI_DATA_WIDTH-1:0] mem_wdata;
	//
	// Read
	logic [AXI_ADDR_WIDTH-1:0] mem_raddr;
	logic [AXI_DATA_WIDTH-1:0] mem_rdata;

	// Write decode
	// * only the bits associrated with writeable registers are used
	logic [2**ADDR_DEC_WIDTH-1:0] wr_en;

	// Registers
	logic [31:0] control0_reg;
	logic [31:0] control1_reg;
	logic [31:0] control2_reg;
	logic [31:0] control3_reg;
	logic [31:0] control4_reg;
	logic [31:0] control5_reg;
	logic [31:0] control6_reg;
	logic [31:0] control7_reg;

	// Register decoder
	logic [31:0] mux[2**ADDR_DEC_WIDTH];

	// ========================================================================
	// AXI4-Lite Slave Interface
	// ========================================================================
	//
	axi4lite_slave_interface #(
		.AXI_ID_WIDTH   (AXI_ID_WIDTH  ),
		.AXI_ADDR_WIDTH (AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH (AXI_DATA_WIDTH)
	) u1 (
		// --------------------------
		// AXI4-Lite Interface
		// --------------------------
		//
		// Reset and clock
		.axi_rst_n    (axi_rst_n   ),
		.axi_clk      (axi_clk     ),

		// Write address
		.axi_awid     ('0          ),
		.axi_awaddr   (axi_awaddr  ),
		.axi_awvalid  (axi_awvalid ),
		.axi_awready  (axi_awready ),

		// Write data
		.axi_wvalid   (axi_wvalid  ),
		.axi_wready   (axi_wready  ),
		.axi_wdata    (axi_wdata   ),
		.axi_wstrb    (axi_wstrb   ),

		// Write response
		.axi_bvalid   (axi_bvalid  ),
		.axi_bready   (axi_bready  ),
		.axi_bid      (            ),
		.axi_bresp    (axi_bresp   ),

		// Read address
		.axi_arvalid  (axi_arvalid ),
		.axi_arready  (axi_arready ),
		.axi_arid     ('0          ),
		.axi_araddr   (axi_araddr  ),

		// Read data
		.axi_rvalid   (axi_rvalid  ),
		.axi_rready   (axi_rready  ),
		.axi_rid      (            ),
		.axi_rdata    (axi_rdata   ),
		.axi_rresp    (axi_rresp   ),

		// --------------------------
		// Memory Interface
		// --------------------------
		//
		// Write
		.mem_wren     (mem_wren    ),
		.mem_wstrb    (mem_wstrb   ),
		.mem_waddr    (mem_waddr   ),
		.mem_wdata    (mem_wdata   ),

		// Read
		.mem_raddr    (mem_raddr   ),
		.mem_rdata    (mem_rdata   )
	);

	// ========================================================================
	// Memory/registers
	// ========================================================================
	//
	// ------------------------------------------------------------------------
	// Write decode
	// ------------------------------------------------------------------------
	//
	always_comb begin
		wr_en = '0;

		// The address is byte-based
		if (mem_waddr[ADDR_WIDTH-1:2] < 2**ADDR_DEC_WIDTH) begin
			if (mem_wren) begin
				for (int i = 0; i < 2**ADDR_DEC_WIDTH; i++) begin
					if (mem_waddr[2 +: ADDR_DEC_WIDTH] == i) begin
						wr_en[i] = 1'b1;
					end
				end
			end
		end
	end

	// ------------------------------------------------------------------------
	// Control#0 register
	// ------------------------------------------------------------------------
	//
	// Write
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			control0_reg <= '0;
		end
		else begin
			if (wr_en[0]) begin
				for (int i = 0; i < 4; i++) begin
					if (mem_wstrb[i]) begin
						control0_reg[8*i +: 8] <= mem_wdata[8*i +: 8];
					end
				end
			end
		end
	end

	// Read
	assign mux[0] = control0_reg;

	// Output
	assign control0 = control0_reg;

	// ------------------------------------------------------------------------
	// Control#1 register
	// ------------------------------------------------------------------------
	//
	// Write
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			control1_reg <= '0;
		end
		else begin
			if (wr_en[1]) begin
				for (int i = 0; i < 4; i++) begin
					if (mem_wstrb[i]) begin
						control1_reg[8*i +: 8] <= mem_wdata[8*i +: 8];
					end
				end
			end
		end
	end

	// Read
	assign mux[1] = control1_reg;

	// Output
	assign control1 = control1_reg;

	// ------------------------------------------------------------------------
	// Control#2 register
	// ------------------------------------------------------------------------
	//
	// Write
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			control2_reg <= '0;
		end
		else begin
			if (wr_en[2]) begin
				for (int i = 0; i < 4; i++) begin
					if (mem_wstrb[i]) begin
						control2_reg[8*i +: 8] <= mem_wdata[8*i +: 8];
					end
				end
			end
		end
	end

	// Read
	assign mux[2] = control2_reg;

	// Output
	assign control2 = control2_reg;

	// ------------------------------------------------------------------------
	// Control#3 register
	// ------------------------------------------------------------------------
	//
	// Write
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			control3_reg <= '0;
		end
		else begin
			if (wr_en[3]) begin
				for (int i = 0; i < 4; i++) begin
					if (mem_wstrb[i]) begin
						control3_reg[8*i +: 8] <= mem_wdata[8*i +: 8];
					end
				end
			end
		end
	end

	// Read
	assign mux[3] = control3_reg;

	// Output
	assign control3 = control3_reg;

	// ------------------------------------------------------------------------
	// Control#4 register
	// ------------------------------------------------------------------------
	//
	// Write
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			control4_reg <= '0;
		end
		else begin
			if (wr_en[4]) begin
				for (int i = 0; i < 4; i++) begin
					if (mem_wstrb[i]) begin
						control4_reg[8*i +: 8] <= mem_wdata[8*i +: 8];
					end
				end
			end
		end
	end

	// Read
	assign mux[4] = control4_reg;

	// Output
	assign control4 = control4_reg;

	// ------------------------------------------------------------------------
	// Control#5 register
	// ------------------------------------------------------------------------
	//
	// Write
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			control5_reg <= '0;
		end
		else begin
			if (wr_en[5]) begin
				for (int i = 0; i < 4; i++) begin
					if (mem_wstrb[i]) begin
						control5_reg[8*i +: 8] <= mem_wdata[8*i +: 8];
					end
				end
			end
		end
	end

	// Read
	assign mux[5] = control5_reg;

	// Output
	assign control5 = control5_reg;

	// ------------------------------------------------------------------------
	// Control#6 register
	// ------------------------------------------------------------------------
	//
	// Write
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			control6_reg <= '0;
		end
		else begin
			if (wr_en[6]) begin
				for (int i = 0; i < 4; i++) begin
					if (mem_wstrb[i]) begin
						control6_reg[8*i +: 8] <= mem_wdata[8*i +: 8];
					end
				end
			end
		end
	end

	// Read
	assign mux[6] = control6_reg;

	// Output
	assign control6 = control6_reg;

	// ------------------------------------------------------------------------
	// Control#7 register
	// ------------------------------------------------------------------------
	//
	// Write
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			control7_reg <= '0;
		end
		else begin
			if (wr_en[7]) begin
				for (int i = 0; i < 4; i++) begin
					if (mem_wstrb[i]) begin
						control7_reg[8*i +: 8] <= mem_wdata[8*i +: 8];
					end
				end
			end
		end
	end

	// Read
	assign mux[7] = control7_reg;

	// Output
	assign control7 = control7_reg;

	// ------------------------------------------------------------------------
	// Status registers
	// ------------------------------------------------------------------------
	//
	// Status read
	assign mux[8]  = status0;
	assign mux[9]  = status1;
	assign mux[10] = status2;
	assign mux[11] = status3;
	assign mux[12] = status4;
	assign mux[13] = status5;
	assign mux[14] = status6;
	assign mux[15] = status7;

	// Unused locations within the decode region
	if (16 < 2**ADDR_DEC_WIDTH) begin: g1
		for (genvar i = 16; i < 2**ADDR_DEC_WIDTH; i++) begin: g2
			assign mux[i] = '0;
		end
	end

	// ------------------------------------------------------------------------
	// Read multiplexer
	// ------------------------------------------------------------------------
	//
	always_comb begin
		// Default read value
		mem_rdata = 32'hDEADC0DE;

		// The address is byte-based
		if (mem_raddr[ADDR_WIDTH-1:2] < 2**ADDR_DEC_WIDTH) begin
			mem_rdata = mux[mem_raddr[2 +: ADDR_DEC_WIDTH]];
		end
	end

endmodule


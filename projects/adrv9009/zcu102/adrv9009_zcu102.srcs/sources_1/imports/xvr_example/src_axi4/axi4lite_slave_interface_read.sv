// ----------------------------------------------------------------------------
// axi4lite_slave_interface_read.sv
//
// 7/18/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4-Lite slave interface read interface.
//
// ----------------------------------------------------------------------------

module axi4lite_slave_interface_read #(
		parameter int AXI_ID_WIDTH   = 1,
		parameter int AXI_ADDR_WIDTH = 32,
		parameter int AXI_DATA_WIDTH = 32
	) (

		// --------------------------------------------------------------------
		// AXI4-Lite Reset and Clock
		// --------------------------------------------------------------------
		//
		// Reset and Clock
		input                       axi_rst_n,
		input                       axi_clk,

		// --------------------------------------------------------------------
		// AXI4-Lite Read Channels
		// --------------------------------------------------------------------
		//
		// Read address
		input                       axi_arvalid,
		output                      axi_arready,
		input    [AXI_ID_WIDTH-1:0] axi_arid,
		input  [AXI_ADDR_WIDTH-1:0] axi_araddr,

		// Read data
		output                      axi_rvalid,
		input                       axi_rready,
		output   [AXI_ID_WIDTH-1:0] axi_rid,
		output                [1:0] axi_rresp,
		output [AXI_DATA_WIDTH-1:0] axi_rdata,

		// --------------------------------------------------------------------
		// Memory/registers Interface
		// --------------------------------------------------------------------
		//
		// Read
		output [AXI_ADDR_WIDTH-1:0] mem_raddr,
		input  [AXI_DATA_WIDTH-1:0] mem_rdata
	);

	// ------------------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------------------
	//
	// Read data path
	logic                      raddr_en;
	logic   [AXI_ID_WIDTH-1:0] rid;
	logic [AXI_ADDR_WIDTH-1:0] raddr;
	logic [AXI_DATA_WIDTH-1:0] rdata;

	// ------------------------------------------------------------------------
	// Read control FSM
	// ------------------------------------------------------------------------
	//
	axi4lite_slave_interface_read_fsm u1 (
		.rst_n      (axi_rst_n  ),
		.clk        (axi_clk    ),
		.arvalid    (axi_arvalid),
		.arready    (axi_arready),
		.rvalid     (axi_rvalid ),
		.rready     (axi_rready ),
		.rd_addr_en (raddr_en   )
	);
	
	// ------------------------------------------------------------------------
	// Read address register
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			rid   <= '0;
			raddr <= '0;
		end
		else begin
			if (raddr_en) begin
				rid   <= axi_arid;
				raddr <= axi_araddr;
			end
		end
	end
	assign mem_raddr = raddr;

	// ------------------------------------------------------------------------
	// Read data register
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			rdata <= '0;
		end
		else begin
			rdata <= mem_rdata;
		end
	end
	assign axi_rdata = rdata;

	// ------------------------------------------------------------------------
	// Read response
	// ------------------------------------------------------------------------
	//
	// Read response is always OKAY
	assign axi_rresp = '0;
	
	// Reflect the read ID
	assign axi_rid = rid;

endmodule

				
			
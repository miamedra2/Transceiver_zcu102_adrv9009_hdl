// ----------------------------------------------------------------------------
// axi4lite_slave_interface_write.sv
//
// 7/18/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4-Lite slave interface write interface.
//
// ----------------------------------------------------------------------------

module axi4lite_slave_interface_write #(
		parameter int AXI_ID_WIDTH   = 1,
		parameter int AXI_ADDR_WIDTH = 32,
		parameter int AXI_STRB_WIDTH = 4,
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
		// AXI4-Lite Write Channels
		// --------------------------------------------------------------------
		//
		// Write address
		input                       axi_awvalid,
		output                      axi_awready,
		input    [AXI_ID_WIDTH-1:0] axi_awid,
		input  [AXI_ADDR_WIDTH-1:0] axi_awaddr,

		// Write data
		input                       axi_wvalid,
		output                      axi_wready,
		input  [AXI_STRB_WIDTH-1:0] axi_wstrb,
		input  [AXI_DATA_WIDTH-1:0] axi_wdata,

		// Write response
		output                      axi_bvalid,
		input                       axi_bready,
		output   [AXI_ID_WIDTH-1:0] axi_bid,
		output                [1:0] axi_bresp,

		// --------------------------------------------------------------------
		// Memory/registers Interface
		// --------------------------------------------------------------------
		//
		// Write
		output                      mem_wren,
		output [AXI_STRB_WIDTH-1:0] mem_wstrb,
		output [AXI_ADDR_WIDTH-1:0] mem_waddr,
		output [AXI_DATA_WIDTH-1:0] mem_wdata
	);

	// ------------------------------------------------------------------------
	// Internal signals
	// ------------------------------------------------------------------------
	//
	// Write data path
	logic                      waddr_en;
	logic                      wren;
	logic   [AXI_ID_WIDTH-1:0] wid;
	logic [AXI_ADDR_WIDTH-1:0] waddr;
	logic [AXI_STRB_WIDTH-1:0] wstrb;
	logic [AXI_DATA_WIDTH-1:0] wdata;

	// ------------------------------------------------------------------------
	// Write control FSM
	// ------------------------------------------------------------------------
	//
	axi4lite_slave_interface_write_fsm u1 (
		.rst_n      (axi_rst_n  ),
		.clk        (axi_clk    ),
		.awvalid    (axi_awvalid),
		.awready    (axi_awready),
		.wvalid     (axi_wvalid ),
		.wready     (axi_wready ),
		.bvalid     (axi_bvalid ),
		.bready     (axi_bready ),
		.wr_addr_en (waddr_en   ),
		.wr_en      (wren       )
	);
	assign mem_wren = wren;

	// ------------------------------------------------------------------------
	// Write registers
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			wid   <= '0;
			waddr <= '0;
			wstrb <= '0;
			wdata <= '0;
		end
		else begin
			if (waddr_en) begin
				wid   <= axi_awid;
				waddr <= axi_awaddr;
				wstrb <= axi_wstrb;
				wdata <= axi_wdata;
			end
		end
	end
	assign mem_waddr = waddr;
	assign mem_wstrb = wstrb;
	assign mem_wdata = wdata;
	
	// ------------------------------------------------------------------------
	// Write response
	// ------------------------------------------------------------------------
	//
	// Write response is always OKAY
	assign axi_bresp = '0;
	
	// Reflect the write ID
	assign axi_bid = wid;

endmodule

				
			
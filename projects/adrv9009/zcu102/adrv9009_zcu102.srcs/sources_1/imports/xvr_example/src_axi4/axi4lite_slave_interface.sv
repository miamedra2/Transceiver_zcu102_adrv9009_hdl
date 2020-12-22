// ----------------------------------------------------------------------------
// axi4lite_slave_interface.sv
//
// 7/18/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4-Lite slave interface interface.
//
// ----------------------------------------------------------------------------

module axi4lite_slave_interface #(
		// AXI Parameters
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
		// Write
		output                      mem_wren,
		output [AXI_STRB_WIDTH-1:0] mem_wstrb,
		output [AXI_ADDR_WIDTH-1:0] mem_waddr,
		output [AXI_DATA_WIDTH-1:0] mem_wdata,

		// Read
		output [AXI_ADDR_WIDTH-1:0] mem_raddr,
		input  [AXI_DATA_WIDTH-1:0] mem_rdata
	);

	// ------------------------------------------------------------------------
	// Write 
	// ------------------------------------------------------------------------
	//
	axi4lite_slave_interface_write #(
		.AXI_ID_WIDTH   (AXI_ID_WIDTH  ),
		.AXI_ADDR_WIDTH (AXI_ADDR_WIDTH),
		.AXI_STRB_WIDTH (AXI_STRB_WIDTH),
		.AXI_DATA_WIDTH (AXI_DATA_WIDTH)
	) u1 (

		// --------------------------------------------------------------------
		// AXI4-Lite Interface
		// --------------------------------------------------------------------
		//
		// Reset and Clock
		.axi_rst_n   (axi_rst_n  ),
		.axi_clk     (axi_clk    ),

		// Write address
		.axi_awvalid (axi_awvalid),
		.axi_awready (axi_awready),
		.axi_awid    (axi_awid   ),
		.axi_awaddr  (axi_awaddr ),

		// Write data
		.axi_wvalid  (axi_wvalid ),
		.axi_wready  (axi_wready ),
		.axi_wstrb   (axi_wstrb  ),
		.axi_wdata   (axi_wdata  ),

		// Write response
		.axi_bvalid  (axi_bvalid ),
		.axi_bready  (axi_bready ),
		.axi_bid     (axi_bid    ),
		.axi_bresp   (axi_bresp  ),

		// --------------------------------------------------------------------
		// Memory Interface
		// --------------------------------------------------------------------
		//
		.mem_wren    (mem_wren   ),
		.mem_wstrb   (mem_wstrb  ),
		.mem_waddr   (mem_waddr  ),
		.mem_wdata   (mem_wdata  )
	);

	// ------------------------------------------------------------------------
	// Read 
	// ------------------------------------------------------------------------
	//
	axi4lite_slave_interface_read #(
		.AXI_ID_WIDTH   (AXI_ID_WIDTH  ),
		.AXI_ADDR_WIDTH (AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH (AXI_DATA_WIDTH)
	) u2 (
		// -------------------------
		// AXI4-Lite Interface
		// -------------------------
		//
		// Reset and clock
		.axi_rst_n   (axi_rst_n  ),
		.axi_clk     (axi_clk    ),
				     
		// Read address
		.axi_arvalid (axi_arvalid),
		.axi_arready (axi_arready),
		.axi_arid    (axi_arid   ),
		.axi_araddr  (axi_araddr ),

		// Read data
		.axi_rvalid  (axi_rvalid ),
		.axi_rready  (axi_rready ),
		.axi_rid     (axi_rid    ),
		.axi_rresp   (axi_rresp  ),
		.axi_rdata   (axi_rdata  ),

		// -------------------------
		// Memory Interface
		// -------------------------
		//
		// Read
		.mem_raddr   (mem_raddr  ),
		.mem_rdata   (mem_rdata  )
	);
	
endmodule

				
			
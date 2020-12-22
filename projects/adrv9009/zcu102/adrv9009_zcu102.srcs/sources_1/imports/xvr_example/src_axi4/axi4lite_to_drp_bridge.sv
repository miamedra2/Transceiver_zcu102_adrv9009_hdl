// ----------------------------------------------------------------------------
// axi4lite_to_drp_bridge.sv
//
// 7/28/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4-Lite to DRP bridge.
//
// ----------------------------------------------------------------------------
// Notes
// -----
//
// 1. AXI and DRP parameters
//
//    The component parameters do not currently support being changed.
//    The AXI interface is assumed to be 32-bit with byte-aligned addresses,
//    while the DRP interface is assumed to be 16-bit with word-aligned
//    addresses. The current design maps the 32-bit aligned AXI address to
//    the DRP address. DRP reads and write data maps to the 16-bit LSBs
//    of the 32-bit AXI data bus.
//
// ----------------------------------------------------------------------------

module axi4lite_to_drp_bridge #(
		// AXI Parameters
		parameter int AXI_ID_WIDTH   = 1,
		parameter int AXI_ADDR_WIDTH = 8,
		parameter int AXI_STRB_WIDTH = 4,
		parameter int AXI_DATA_WIDTH = 32,

		// DRP Parameters
		parameter int DRP_ADDR_WIDTH = 8,
		parameter int DRP_DATA_WIDTH = 16
	)(

		// Reset and Clock
		input                       axi_rst_n,
		input                       axi_clk,

		// --------------------------------------------------------------------
		// AXI4-Lite Interface
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

		// Read address
		input                       axi_arvalid,
		output                      axi_arready,
		input    [AXI_ID_WIDTH-1:0] axi_arid,
		input  [AXI_ADDR_WIDTH-1:0] axi_araddr,

		// Read data and response
		output                      axi_rvalid,
		input                       axi_rready,
		output   [AXI_ID_WIDTH-1:0] axi_rid,
		output                [1:0] axi_rresp,
		output [AXI_DATA_WIDTH-1:0] axi_rdata,

		// --------------------------------------------------------------------
		// DRP Interface
		// --------------------------------------------------------------------
		//
		output                       drp_en,
		output                       drp_we,
		input                        drp_rdy,
		output  [DRP_ADDR_WIDTH-1:0] drp_addr,
		output  [DRP_DATA_WIDTH-1:0] drp_wdata,
		input   [DRP_DATA_WIDTH-1:0] drp_rdata
	);
	
	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	// Interface registers
	logic   [AXI_ID_WIDTH-1:0] id;
	logic                      addr_sel;
	logic                      addr_en;
	logic [DRP_ADDR_WIDTH-1:0] addr;
	logic                      wdata_en;
	logic [DRP_DATA_WIDTH-1:0] wdata;
	logic                      rdata_en;
	logic [DRP_DATA_WIDTH-1:0] rdata;
	logic                      resp_sel;
	logic                      resp_en;
	logic                [1:0] resp;
	
	// Timeout counter
	logic                      timeout_load;
	logic                      timeout_en;
	logic                      timeout_done;
	logic                [7:0] timeout_d;
	logic                [7:0] timeout_q;
	
	// ------------------------------------------------------------------------
	// Control FSM
	// ------------------------------------------------------------------------
	//
	axi4lite_to_drp_bridge_fsm u1 (
		.axi_rst_n    (axi_rst_n   ),
		.axi_clk      (axi_clk     ),
		.axi_awvalid  (axi_awvalid ),
		.axi_awready  (axi_awready ),
		.axi_wvalid   (axi_wvalid  ),
		.axi_wready   (axi_wready  ),
		.axi_bvalid   (axi_bvalid  ),
		.axi_bready   (axi_bready  ),
		.axi_arvalid  (axi_arvalid ),
		.axi_arready  (axi_arready ),
		.axi_rvalid   (axi_rvalid  ),
		.axi_rready   (axi_rready  ),
		.drp_en       (drp_en      ),
		.drp_we       (drp_we      ),
		.drp_rdy      (drp_rdy     ),
		.addr_sel     (addr_sel    ),
		.addr_en      (addr_en     ),
		.wdata_en     (wdata_en    ),
		.rdata_en     (rdata_en    ),
		.resp_sel     (resp_sel    ),
		.resp_en      (resp_en     ),
		.timeout_load (timeout_load),	
		.timeout_en   (timeout_en  ),
		.timeout_done (timeout_done)
	);
	
	// ------------------------------------------------------------------------
	// DRP address register/mux
	// ------------------------------------------------------------------------
	//
	// There is no address decoding. It would be possible to decode only
	// DRP_ADDR_WIDTH bits within the AXI_ADDR_WIDTH byte-span, and return
	// DECERR for unsupported addresses.
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			id   <= '0;
			addr <= '0;
		end
		else begin
			if (addr_en) begin
				id   <= addr_sel ? axi_awid: axi_arid;
				addr <= addr_sel ? axi_araddr[DRP_ADDR_WIDTH+1:2] : 
			                       axi_awaddr[DRP_ADDR_WIDTH+1:2];
			end
		end
	end

	// Reflected IDs
	assign axi_bid = id;
	assign axi_rid = id;

	// DRP address
	assign drp_addr = addr;
	
	// ------------------------------------------------------------------------
	// DRP write data
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			wdata <= '0;
		end
		else begin
			if (wdata_en) begin
				wdata <= axi_wdata[DRP_DATA_WIDTH-1:0];
			end
		end
	end
	assign drp_wdata = wdata;
	
	// ------------------------------------------------------------------------
	// DRP read data
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			rdata <= '0;
		end
		else begin
			if (rdata_en) begin
				rdata <= drp_rdata;
			end
		end
	end
	assign axi_rdata = AXI_DATA_WIDTH'(rdata);
	
	// ------------------------------------------------------------------------
	// AXI response
	// ------------------------------------------------------------------------
	//
	always_ff @(negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			resp <= '0;
		end
		else begin
			if (resp_en) begin
				// OKAY (00b) or SLVERR (10b) 
				resp <= resp_sel ? 2'b10 : 2'b00;
			end
		end
	end
	assign axi_bresp = resp;
	assign axi_rresp = resp;

	// ------------------------------------------------------------------------
	// Timeout counter
	// ------------------------------------------------------------------------
	//
	axi4lite_to_drp_bridge_counter #(
		.WIDTH (8 ),
		.INIT  ('0)
	) u2 (
		.rst_n (axi_rst_n   ),
		.clk   (axi_clk     ),
		.load  (timeout_load),
		.en    (timeout_en  ),
		.dir   (1'b0        ), // down counter
		.cin   (1'b1        ), // carry in
		.d     (timeout_d   ),
		.q     (timeout_q   ),
		.cout  (timeout_done)
	);

	// Timeout counter load value
	assign timeout_d = '1;
	
endmodule


// ----------------------------------------------------------------------------
// axi4_bram_common_address.sv
//
// 9/12/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// AXI4 BRAM with common read/write address.
//
// ----------------------------------------------------------------------------

module axi4_bram_common_address #(
		// AXI parameters
		parameter integer AXI_ID_WIDTH   = 1,
		parameter integer AXI_ADDR_WIDTH = 32,
		parameter integer AXI_DATA_WIDTH = 32,
		
		// BRAM read address-to-data pipeline
		// * BRAM_PIPELINE >= 1 required
		parameter integer BRAM_PIPELINE = 2

	) (
		// --------------------------------------------------------------------
		// AXI Reset and Clock
		// --------------------------------------------------------------------
		//
		input  logic                          axi_rst_n,
		input  logic                          axi_clk,

		// --------------------------------------------------------------------
		// AXI Write Channels
		// --------------------------------------------------------------------
		//
		// Write address
		input  logic       [AXI_ID_WIDTH-1:0] axi_awid,
		input  logic     [AXI_ADDR_WIDTH-1:0] axi_awaddr,
		input  logic                    [7:0] axi_awlen,
		input  logic                    [2:0] axi_awsize,
		input  logic                    [1:0] axi_awburst,
		input  logic                          axi_awvalid,
		output logic                          axi_awready,
		//
		// Write data
		input  logic     [AXI_DATA_WIDTH-1:0] axi_wdata,
		input  logic [(AXI_DATA_WIDTH/8)-1:0] axi_wstrb,
		input  logic                          axi_wlast,
		input  logic                          axi_wvalid,
		output logic                          axi_wready,
		//
		// Write response
		output logic       [AXI_ID_WIDTH-1:0] axi_bid,
		output logic                    [1:0] axi_bresp,
		output logic                          axi_bvalid,
		input  logic                          axi_bready,
		//
		// --------------------------------------------------------------------
		// AXI Read Channels
		// --------------------------------------------------------------------
		//
		// Read address
		input  logic       [AXI_ID_WIDTH-1:0] axi_arid,
		input  logic     [AXI_ADDR_WIDTH-1:0] axi_araddr,
		input  logic                    [7:0] axi_arlen,
		input  logic                    [2:0] axi_arsize,
		input  logic                    [1:0] axi_arburst,
		input  logic                          axi_arvalid,
		output logic                          axi_arready,
		//
		// Read data
		output logic       [AXI_ID_WIDTH-1:0] axi_rid,
		output logic     [AXI_DATA_WIDTH-1:0] axi_rdata,
		output logic                    [1:0] axi_rresp,
		output logic                          axi_rlast,
		output logic                          axi_rvalid,
		input  logic                          axi_rready,

		// --------------------------------------------------------------------
		// BRAM Interface
		// --------------------------------------------------------------------
		//
		// Common enable and address
		output logic                          bram_en,
		output logic     [AXI_ADDR_WIDTH-1:0] bram_addr,
		//
		// Write interface
		output logic     [AXI_DATA_WIDTH-1:0] bram_wdata,
		output logic [(AXI_DATA_WIDTH/8)-1:0] bram_wstrb,
		//
		// Read interface
		input  logic     [AXI_DATA_WIDTH-1:0] bram_rdata
	);

	// -----------------------------------------------------------------------
	// Internal Signals
	// -----------------------------------------------------------------------
	//
	// Write/read multiplexed values
	logic [AXI_ADDR_WIDTH-1:0] axi_addr;
	logic                [7:0] axi_len;
	logic                [2:0] axi_size;
	logic                [1:0] axi_burst;
	//
	// Address multiplexer and counter
	logic                      addr_sel;
	logic                      addr_load;
	logic                      addr_en;
	//
	// Write strobe multiplexer
	logic                      strb_sel;
	//
	// Write and read ID enables
	logic                      bid_en;
	logic                      rid_en;
	//
	// Read burst counter
	logic                      burst_load;
	logic                      burst_en;
	logic                      burst_done;
	//
	// Read valid/last pipeline
	logic                      pipeline_en;
	logic  [BRAM_PIPELINE-1:0] pipeline_rvalid;
	logic  [BRAM_PIPELINE-1:0] pipeline_rlast;
	logic                      pipeline_rvalid_i;
	logic                      pipeline_rlast_i;
	logic                      pipeline_rvalid_o;
	logic                      pipeline_rlast_o;
	
	// -----------------------------------------------------------------------
	// Control FSM
	// -----------------------------------------------------------------------
	//
	axi4_bram_common_address_fsm u1 (
		// AXI Reset and Clock
		.axi_rst_n       (axi_rst_n  ),
		.axi_clk         (axi_clk    ),

		// AXI Write Address Channel
		.axi_awvalid     (axi_awvalid),
		.axi_awready     (axi_awready),

		// AXI Write Data Channel
		.axi_wlast       (axi_wlast  ),
		.axi_wvalid      (axi_wvalid ),
		.axi_wready      (axi_wready ),

		// AXI Write Response Channel
		.axi_bvalid      (axi_bvalid ),
		.axi_bready      (axi_bready ),

		// AXI Read Address Channel
		.axi_arvalid     (axi_arvalid),
		.axi_arready     (axi_arready),

		// AXI Read Data Channel
		.axi_rready      (axi_rready       ),
		.axi_rvalid      (pipeline_rvalid_o),
		.axi_rlast       (pipeline_rlast_o ),

		// BRAM Interface
		.bram_en         (bram_en          ),

		// Datapath control
		.bid_en          (bid_en           ),
		.rid_en          (rid_en           ),
		.addr_sel        (addr_sel         ),
		.addr_load       (addr_load        ),
		.addr_en         (addr_en          ),
		.strb_sel        (strb_sel         ),
		.burst_load      (burst_load       ),
		.burst_en        (burst_en         ),
		.burst_done      (burst_done       ),
		.pipeline_en     (pipeline_en      ),
		.pipeline_rvalid (pipeline_rvalid_i),
		.pipeline_rlast  (pipeline_rlast_i )

	);

	// ------------------------------------------------------------------------
	// Write/read address counter
	// ------------------------------------------------------------------------
	//
	axi4_address_counter #(
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH)
	) u2 (
		.axi_aresetn (axi_rst_n),
		.axi_aclk    (axi_clk  ),
		.axi_addr    (axi_addr ),
		.axi_len     (axi_len  ),
		.axi_size    (axi_size ),
		.axi_burst   (axi_burst),
		.addr_load   (addr_load),
		.addr_en     (addr_en  ),
		.addr		 (bram_addr)
	);

	assign axi_addr  = addr_sel ? axi_awaddr  : axi_araddr;
	assign axi_len   = addr_sel ? axi_awlen   : axi_arlen;
	assign axi_size  = addr_sel ? axi_awsize  : axi_arsize;
	assign axi_burst = addr_sel ? axi_awburst : axi_arburst;

	// ------------------------------------------------------------------------
	// Read burst counter
	// ------------------------------------------------------------------------
	//
	axi4_burst_counter u3 (
		.axi_aresetn (axi_rst_n ),
		.axi_aclk    (axi_clk   ),
		.axi_len     (axi_arlen ),
		.burst_load  (burst_load),
		.burst_en    (burst_en  ),
		.burst_done  (burst_done)
	);

	// ------------------------------------------------------------------------
	// AXI write response
	// ------------------------------------------------------------------------
	//
	// Write response ID
	always_ff @ (negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			axi_bid <= '0;
		end
		else if (bid_en) begin
			axi_bid <= axi_awid;
		end
	end

	// Write response = OKAY
	assign axi_bresp   = 2'b00;

	// ------------------------------------------------------------------------
	// AXI read response
	// ------------------------------------------------------------------------
	//
	// Read response ID register
	always_ff @ (negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			axi_rid <= '0;
		end
		else if (rid_en) begin
			axi_rid <= axi_arid;
		end
	end

	// Read response = OKAY
	assign axi_rresp = 2'b00;
	
	// AXI read data
	assign axi_rdata = bram_rdata;

	// ------------------------------------------------------------------------
	// AXI read pipeline
	// ------------------------------------------------------------------------
	//
	always_ff @ (negedge axi_rst_n or posedge axi_clk) begin
		if (~axi_rst_n) begin
			pipeline_rvalid <= '0;
			pipeline_rlast  <= '0;
		end
		else begin
			if (pipeline_en) begin
				pipeline_rvalid[0] <= pipeline_rvalid_i;
				pipeline_rlast[0]  <= pipeline_rlast_i;
				for (int unsigned i = 1; i < BRAM_PIPELINE; i++) begin
					pipeline_rvalid[i] <= pipeline_rvalid[i-1];
					pipeline_rlast[i]  <= pipeline_rlast[i-1];
				end
			end
		end
	end

	// Pipeline outputs (feedback the control FSM)
	assign pipeline_rvalid_o = pipeline_rvalid[BRAM_PIPELINE-1];
	assign pipeline_rlast_o  = pipeline_rlast[BRAM_PIPELINE-1];
	
	// AXI outputs
	assign axi_rvalid = pipeline_rvalid_o;
	assign axi_rlast  = pipeline_rlast_o;
	
	// ------------------------------------------------------------------------
	// BRAM write data and strobes
	// ------------------------------------------------------------------------
	//
	// BRAM write data
	assign bram_wdata = axi_wdata;
	
	// BRAM write strobes
	// - zeroed when performing read accesses
	assign bram_wstrb = strb_sel ? axi_wstrb : '0;

endmodule

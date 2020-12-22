// ----------------------------------------------------------------------------
// xvr_system.sv
//
// 4/26/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Transceiver system
//   - Vivado IP block design
//   - Transceiver interface
//
// ----------------------------------------------------------------------------

module xvr_system (
		// --------------------------------------------------------------------
		// AXI Reset and Clock
		// --------------------------------------------------------------------
		//
		input        axi_rst_n,
		input        axi_clk,

		// --------------------------------------------------------------------
		// Transceiver Interface
		// --------------------------------------------------------------------
		//
		// REFCLK input (from Si570)
		input        xvr_refclk_in_p,
		input        xvr_refclk_in_n,
		
		// REFCLK output (to SMA connector)
		output       xvr_refclk_out_p,
		output       xvr_refclk_out_n,
		
		// SMA transceiver lanes
		input        xvr_rx_p,
		input        xvr_rx_n,
		output       xvr_tx_p,
		output       xvr_tx_n
	);

	// ------------------------------------------------------------------------
	// Local signals
	// ------------------------------------------------------------------------
	//
	// AXI registers
	//
	// Write address
	logic [31:0] axi_regs_awaddr;
	logic        axi_regs_awvalid;
	logic        axi_regs_awready;
	//
	// Write data
	logic  [3:0] axi_regs_wstrb;
	logic [31:0] axi_regs_wdata;
	logic        axi_regs_wvalid;
	logic        axi_regs_wready;
	//
	// Write response
	logic [1:0]  axi_regs_bresp;
	logic        axi_regs_bvalid;
	logic        axi_regs_bready;
	//
	// Read address
	logic [31:0] axi_regs_araddr;
	logic        axi_regs_arvalid;
	logic        axi_regs_arready;
	//
	// Read data and response
	logic [31:0] axi_regs_rdata;
	logic  [1:0] axi_regs_rresp;
	logic        axi_regs_rvalid;
	logic        axi_regs_rready;

	// AXI TX BRAM
	//
	// Write address
	logic  [0:0] axi_tx_awid;
	logic [31:0] axi_tx_awaddr;
	logic  [7:0] axi_tx_awlen;
	logic  [2:0] axi_tx_awsize;
	logic  [1:0] axi_tx_awburst;
	logic        axi_tx_awvalid;
	logic        axi_tx_awready;
	//
	// Write data
	logic [31:0] axi_tx_wdata;
	logic  [3:0] axi_tx_wstrb;
	logic        axi_tx_wlast;
	logic        axi_tx_wvalid;
	logic        axi_tx_wready;
	//
	// Write response
	logic  [0:0] axi_tx_bid;
	logic  [1:0] axi_tx_bresp;
	logic        axi_tx_bvalid;
	logic        axi_tx_bready;
	//
	// Read address
	logic  [0:0] axi_tx_arid;
	logic [31:0] axi_tx_araddr;
	logic  [7:0] axi_tx_arlen;
	logic  [2:0] axi_tx_arsize;
	logic  [1:0] axi_tx_arburst;
	logic        axi_tx_arvalid;
	logic        axi_tx_arready;
	//
	// Read data
	logic  [0:0] axi_tx_rid;
	logic [31:0] axi_tx_rdata;
	logic  [1:0] axi_tx_rresp;
	logic        axi_tx_rlast;
	logic        axi_tx_rvalid;
	logic        axi_tx_rready;

	// AXI RX BRAM
	//
	// Write address
	logic  [0:0] axi_rx_awid;
	logic [31:0] axi_rx_awaddr;
	logic  [7:0] axi_rx_awlen;
	logic  [2:0] axi_rx_awsize;
	logic  [1:0] axi_rx_awburst;
	logic        axi_rx_awvalid;
	logic        axi_rx_awready;
	//
	// Write data
	logic [31:0] axi_rx_wdata;
	logic  [3:0] axi_rx_wstrb;
	logic        axi_rx_wlast;
	logic        axi_rx_wvalid;
	logic        axi_rx_wready;
	//
	// Write response
	logic  [0:0] axi_rx_bid;
	logic  [1:0] axi_rx_bresp;
	logic        axi_rx_bvalid;
	logic        axi_rx_bready;
	//
	// Read address
	logic  [0:0] axi_rx_arid;
	logic [31:0] axi_rx_araddr;
	logic  [7:0] axi_rx_arlen;
	logic  [2:0] axi_rx_arsize;
	logic  [1:0] axi_rx_arburst;
	logic        axi_rx_arvalid;
	logic        axi_rx_arready;
	//
	// Read data
	logic  [0:0] axi_rx_rid;
	logic [31:0] axi_rx_rdata;
	logic  [1:0] axi_rx_rresp;
	logic        axi_rx_rlast;
	logic        axi_rx_rvalid;
	logic        axi_rx_rready;

	// AXI DRP
	//
	// Write address
	logic [31:0] axi_drp_awaddr;
	logic        axi_drp_awvalid;
	logic        axi_drp_awready;
	//
	// Write data
	logic  [3:0] axi_drp_wstrb;
	logic [31:0] axi_drp_wdata;
	logic        axi_drp_wvalid;
	logic        axi_drp_wready;
	//
	// Write response
	logic [1:0]  axi_drp_bresp;
	logic        axi_drp_bvalid;
	logic        axi_drp_bready;
	//
	// Read address
	logic [31:0] axi_drp_araddr;
	logic        axi_drp_arvalid;
	logic        axi_drp_arready;
	//
	// Read data and response
	logic [31:0] axi_drp_rdata;
	logic  [1:0] axi_drp_rresp;
	logic        axi_drp_rvalid;
	logic        axi_drp_rready;

	// ------------------------------------------------------------------------
	// Vivado Block Design
	// ------------------------------------------------------------------------
	//
	system u1 (
		.rst_n        (axi_rst_n         ),
		.clk          (axi_clk           ),
		
		// AXI registers
		// -------------
		//
		// Write address
		.axi_regs_awaddr  (axi_regs_awaddr ),
		.axi_regs_awprot  (                ),
		.axi_regs_awvalid (axi_regs_awvalid),
		.axi_regs_awready (axi_regs_awready),
		//
		// Write data
		.axi_regs_wstrb   (axi_regs_wstrb  ),
		.axi_regs_wdata   (axi_regs_wdata  ),
		.axi_regs_wvalid  (axi_regs_wvalid ),
		.axi_regs_wready  (axi_regs_wready ),
		//
		// Write response
		.axi_regs_bresp   (axi_regs_bresp  ),
		.axi_regs_bvalid  (axi_regs_bvalid ),
		.axi_regs_bready  (axi_regs_bready ),
		//
		// Read address
		.axi_regs_araddr  (axi_regs_araddr ),
		.axi_regs_arprot  (                ),
		.axi_regs_arvalid (axi_regs_arvalid),
		.axi_regs_arready (axi_regs_arready),
		//
		// Read data and response
		.axi_regs_rdata   (axi_regs_rdata  ),
		.axi_regs_rresp	  (axi_regs_rresp  ),
		.axi_regs_rvalid  (axi_regs_rvalid ),
		.axi_regs_rready  (axi_regs_rready ),

		// AXI Interface for transmit BRAM
		// -------------------------------
		//
		// Write address
		.axi_tx_bram_awid     (axi_tx_awid   ),
		.axi_tx_bram_awaddr   (axi_tx_awaddr ),
		.axi_tx_bram_awlen    (axi_tx_awlen  ),
		.axi_tx_bram_awsize   (axi_tx_awsize ),
		.axi_tx_bram_awburst  (axi_tx_awburst),
		.axi_tx_bram_awlock   (              ),
		.axi_tx_bram_awcache  (              ),
		.axi_tx_bram_awprot   (              ),
		.axi_tx_bram_awqos    (              ),
		.axi_tx_bram_awregion (              ),
		.axi_tx_bram_awready  (axi_tx_awready),
		.axi_tx_bram_awvalid  (axi_tx_awvalid),
		//
		// Write data
		.axi_tx_bram_wdata    (axi_tx_wdata  ),
		.axi_tx_bram_wstrb    (axi_tx_wstrb  ),
		.axi_tx_bram_wlast    (axi_tx_wlast  ),
		.axi_tx_bram_wready   (axi_tx_wready ),
		.axi_tx_bram_wvalid   (axi_tx_wvalid ),
		//
		// Write response
		.axi_tx_bram_bid      (axi_tx_bid     ),
		.axi_tx_bram_bresp    (axi_tx_bresp   ),
		.axi_tx_bram_bready   (axi_tx_bready  ),
		.axi_tx_bram_bvalid   (axi_tx_bvalid  ),
		//
		// Read address
		.axi_tx_bram_arid     (axi_tx_arid    ),
		.axi_tx_bram_araddr   (axi_tx_araddr  ),
		.axi_tx_bram_arlen    (axi_tx_arlen   ),
		.axi_tx_bram_arsize   (axi_tx_arsize  ),
		.axi_tx_bram_arburst  (axi_tx_arburst ),
		.axi_tx_bram_arlock   (),
		.axi_tx_bram_arcache  (),
		.axi_tx_bram_arprot   (),
		.axi_tx_bram_arqos    (),
		.axi_tx_bram_arregion (),
		.axi_tx_bram_arready  (axi_tx_arready ),
		.axi_tx_bram_arvalid  (axi_tx_arvalid ),
		//
		// Read data
		.axi_tx_bram_rid      (axi_tx_rid     ),
		.axi_tx_bram_rdata    (axi_tx_rdata   ),
		.axi_tx_bram_rlast    (axi_tx_rlast   ),
		.axi_tx_bram_rresp    (axi_tx_rresp   ),
		.axi_tx_bram_rready   (axi_tx_rready  ),
		.axi_tx_bram_rvalid   (axi_tx_rvalid  ),

		// AXI Interface for receive BRAM
		// -------------------------------
		//
		// Write address
		.axi_rx_bram_awid     (axi_rx_awid   ),
		.axi_rx_bram_awaddr   (axi_rx_awaddr ),
		.axi_rx_bram_awlen    (axi_rx_awlen  ),
		.axi_rx_bram_awsize   (axi_rx_awsize ),
		.axi_rx_bram_awburst  (axi_rx_awburst),
		.axi_rx_bram_awlock   (              ),
		.axi_rx_bram_awcache  (              ),
		.axi_rx_bram_awprot   (              ),
		.axi_rx_bram_awqos    (              ),
		.axi_rx_bram_awregion (              ),
		.axi_rx_bram_awready  (axi_rx_awready),
		.axi_rx_bram_awvalid  (axi_rx_awvalid),
		//
		// Write data
		.axi_rx_bram_wdata    (axi_rx_wdata  ),
		.axi_rx_bram_wstrb    (axi_rx_wstrb  ),
		.axi_rx_bram_wlast    (axi_rx_wlast  ),
		.axi_rx_bram_wready   (axi_rx_wready ),
		.axi_rx_bram_wvalid   (axi_rx_wvalid ),
		//
		// Write response
		.axi_rx_bram_bid      (axi_rx_bid     ),
		.axi_rx_bram_bresp    (axi_rx_bresp   ),
		.axi_rx_bram_bready   (axi_rx_bready  ),
		.axi_rx_bram_bvalid   (axi_rx_bvalid  ),
		//
		// Read address
		.axi_rx_bram_arid     (axi_rx_arid    ),
		.axi_rx_bram_araddr   (axi_rx_araddr  ),
		.axi_rx_bram_arlen    (axi_rx_arlen   ),
		.axi_rx_bram_arsize   (axi_rx_arsize  ),
		.axi_rx_bram_arburst  (axi_rx_arburst ),
		.axi_rx_bram_arlock   (),
		.axi_rx_bram_arcache  (),
		.axi_rx_bram_arprot   (),
		.axi_rx_bram_arqos    (),
		.axi_rx_bram_arregion (),
		.axi_rx_bram_arready  (axi_rx_arready ),
		.axi_rx_bram_arvalid  (axi_rx_arvalid ),
		//
		// Read data
		.axi_rx_bram_rid      (axi_rx_rid     ),
		.axi_rx_bram_rdata    (axi_rx_rdata   ),
		.axi_rx_bram_rlast    (axi_rx_rlast   ),
		.axi_rx_bram_rresp    (axi_rx_rresp   ),
		.axi_rx_bram_rready   (axi_rx_rready  ),
		.axi_rx_bram_rvalid   (axi_rx_rvalid  ),
		
		// AXI DRP
		// -------
		//
		// Write address
		.axi_drp_awaddr       (axi_drp_awaddr ),
		.axi_drp_awprot       (                ),
		.axi_drp_awvalid      (axi_drp_awvalid),
		.axi_drp_awready      (axi_drp_awready),
		//
		// Write data
		.axi_drp_wstrb        (axi_drp_wstrb  ),
		.axi_drp_wdata        (axi_drp_wdata  ),
		.axi_drp_wvalid       (axi_drp_wvalid ),
		.axi_drp_wready       (axi_drp_wready ),
		//
		// Write response
		.axi_drp_bresp        (axi_drp_bresp  ),
		.axi_drp_bvalid       (axi_drp_bvalid ),
		.axi_drp_bready       (axi_drp_bready ),
		//
		// Read address
		.axi_drp_araddr       (axi_drp_araddr ),
		.axi_drp_arprot       (                ),
		.axi_drp_arvalid      (axi_drp_arvalid),
		.axi_drp_arready      (axi_drp_arready),
		//
		// Read data and response
		.axi_drp_rdata        (axi_drp_rdata  ),
		.axi_drp_rresp        (axi_drp_rresp  ),
		.axi_drp_rvalid       (axi_drp_rvalid ),
		.axi_drp_rready       (axi_drp_rready )

	);

	// ------------------------------------------------------------------------
	// Transceiver AWG
	// ------------------------------------------------------------------------
	//
	xvr_awg u2 (
		// Transceiver Interface
		.xvr_refclk_in_p  (xvr_refclk_in_p ),
		.xvr_refclk_in_n  (xvr_refclk_in_n ),
		.xvr_refclk_out_p (xvr_refclk_out_p),
		.xvr_refclk_out_n (xvr_refclk_out_n),
		.xvr_rx_p         (xvr_rx_p        ),
		.xvr_rx_n         (xvr_rx_n        ),
		.xvr_tx_p         (xvr_tx_p        ),
		.xvr_tx_n         (xvr_tx_n        ),

		// AXI Reset and Clock
		.axi_rst_n        (axi_rst_n       ),
		.axi_clk          (axi_clk         ),
 
		// AXI registers
		.axi_regs_awaddr  (axi_regs_awaddr ),
		.axi_regs_awvalid (axi_regs_awvalid),
		.axi_regs_awready (axi_regs_awready),
		.axi_regs_wstrb   (axi_regs_wstrb  ),
		.axi_regs_wdata   (axi_regs_wdata  ),
		.axi_regs_wvalid  (axi_regs_wvalid ),
		.axi_regs_wready  (axi_regs_wready ),
		.axi_regs_bresp   (axi_regs_bresp  ),
		.axi_regs_bvalid  (axi_regs_bvalid ),
		.axi_regs_bready  (axi_regs_bready ),
		.axi_regs_araddr  (axi_regs_araddr ),
		.axi_regs_arvalid (axi_regs_arvalid),
		.axi_regs_arready (axi_regs_arready),
		.axi_regs_rdata   (axi_regs_rdata  ),
		.axi_regs_rresp	  (axi_regs_rresp  ),
		.axi_regs_rvalid  (axi_regs_rvalid ),
		.axi_regs_rready  (axi_regs_rready ),

		// AXI Transmit BRAM Interface
		.axi_tx_awid      (axi_tx_awid    ),
		.axi_tx_awaddr    (axi_tx_awaddr  ),
		.axi_tx_awlen     (axi_tx_awlen   ),
		.axi_tx_awsize    (axi_tx_awsize  ),
		.axi_tx_awburst   (axi_tx_awburst ),
		.axi_tx_awvalid   (axi_tx_awvalid ),
		.axi_tx_awready   (axi_tx_awready ),
		.axi_tx_wdata     (axi_tx_wdata   ),
		.axi_tx_wstrb     (axi_tx_wstrb   ),
		.axi_tx_wlast     (axi_tx_wlast   ),
		.axi_tx_wvalid    (axi_tx_wvalid  ),
		.axi_tx_wready    (axi_tx_wready  ),
		.axi_tx_bid       (axi_tx_bid     ),
		.axi_tx_bresp     (axi_tx_bresp   ),
		.axi_tx_bvalid    (axi_tx_bvalid  ),
		.axi_tx_bready    (axi_tx_bready  ),
		.axi_tx_arid      (axi_tx_arid    ),
		.axi_tx_araddr    (axi_tx_araddr  ),
		.axi_tx_arlen     (axi_tx_arlen   ),
		.axi_tx_arsize    (axi_tx_arsize  ),
		.axi_tx_arburst   (axi_tx_arburst ),
		.axi_tx_arvalid   (axi_tx_arvalid ),
		.axi_tx_arready   (axi_tx_arready ),
		.axi_tx_rid       (axi_tx_rid     ),
		.axi_tx_rdata     (axi_tx_rdata   ),
		.axi_tx_rresp     (axi_tx_rresp   ),
		.axi_tx_rlast     (axi_tx_rlast   ),
		.axi_tx_rvalid    (axi_tx_rvalid  ),
		.axi_tx_rready    (axi_tx_rready  ),

		// AXI4 RX BRAM Interface
		.axi_rx_awid      (axi_rx_awid    ),
		.axi_rx_awaddr    (axi_rx_awaddr  ),
		.axi_rx_awlen     (axi_rx_awlen   ),
		.axi_rx_awsize    (axi_rx_awsize  ),
		.axi_rx_awburst   (axi_rx_awburst ),
		.axi_rx_awvalid   (axi_rx_awvalid ),
		.axi_rx_awready   (axi_rx_awready ),
		.axi_rx_wdata     (axi_rx_wdata   ),
		.axi_rx_wstrb     (axi_rx_wstrb   ),
		.axi_rx_wlast     (axi_rx_wlast   ),
		.axi_rx_wvalid    (axi_rx_wvalid  ),
		.axi_rx_wready    (axi_rx_wready  ),
		.axi_rx_bid       (axi_rx_bid     ),
		.axi_rx_bresp     (axi_rx_bresp   ),
		.axi_rx_bvalid    (axi_rx_bvalid  ),
		.axi_rx_bready    (axi_rx_bready  ),
		.axi_rx_arid      (axi_rx_arid    ),
		.axi_rx_araddr    (axi_rx_araddr  ),
		.axi_rx_arlen     (axi_rx_arlen   ),
		.axi_rx_arsize    (axi_rx_arsize  ),
		.axi_rx_arburst   (axi_rx_arburst ),
		.axi_rx_arvalid   (axi_rx_arvalid ),
		.axi_rx_arready   (axi_rx_arready ),
		.axi_rx_rid       (axi_rx_rid     ),
		.axi_rx_rdata     (axi_rx_rdata   ),
		.axi_rx_rresp     (axi_rx_rresp   ),
		.axi_rx_rlast     (axi_rx_rlast   ),
		.axi_rx_rvalid    (axi_rx_rvalid  ),
		.axi_rx_rready    (axi_rx_rready  ),
 
		// AXI DRP
		.axi_drp_awaddr   (axi_drp_awaddr ),
		.axi_drp_awvalid  (axi_drp_awvalid),
		.axi_drp_awready  (axi_drp_awready),
		.axi_drp_wstrb    (axi_drp_wstrb  ),
		.axi_drp_wdata    (axi_drp_wdata  ),
		.axi_drp_wvalid   (axi_drp_wvalid ),
		.axi_drp_wready   (axi_drp_wready ),
		.axi_drp_bresp    (axi_drp_bresp  ),
		.axi_drp_bvalid   (axi_drp_bvalid ),
		.axi_drp_bready   (axi_drp_bready ),
		.axi_drp_araddr   (axi_drp_araddr ),
		.axi_drp_arvalid  (axi_drp_arvalid),
		.axi_drp_arready  (axi_drp_arready),
		.axi_drp_rdata    (axi_drp_rdata  ),
		.axi_drp_rresp    (axi_drp_rresp  ),
		.axi_drp_rvalid   (axi_drp_rvalid ),
		.axi_drp_rready   (axi_drp_rready )
	);
endmodule


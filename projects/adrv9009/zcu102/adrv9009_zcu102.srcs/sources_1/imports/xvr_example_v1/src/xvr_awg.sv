// ----------------------------------------------------------------------------
// xvr_awg.sv
//
// 4/26/2020 D. W. Hawkins (David.W.Hawkins@jpl.nasa.gov)
//
// Transceiver arbitrary 1-bit waveform generator.
//
// ----------------------------------------------------------------------------

module xvr_awg (

		// --------------------------------------------------------------------
		// Transceiver Interface
		// --------------------------------------------------------------------
		//
		// REFCLK input
		input         xvr_refclk_in_p,
		input         xvr_refclk_in_n,
		//
		// REFCLK output
		output        xvr_refclk_out_p,
		output        xvr_refclk_out_n,

		// Transceiver lanes
		input         xvr_rx_p,
		input         xvr_rx_n,
		output        xvr_tx_p,
		output        xvr_tx_n,

		// --------------------------------------------------------------------
		// AXI Reset and Clock
		// --------------------------------------------------------------------
		//
		input         axi_rst_n,
		input         axi_clk,

		// --------------------------------------------------------------------
		// AXI4-Lite Registers Interface
		// --------------------------------------------------------------------
		//
		// Write address
		output        axi_regs_awready,
		input         axi_regs_awvalid,
		input  [31:0] axi_regs_awaddr,

		// Write data
		output        axi_regs_wready,
		input         axi_regs_wvalid,
		input   [3:0] axi_regs_wstrb,
		input  [31:0] axi_regs_wdata,

		// Write response
		input         axi_regs_bready,
		output        axi_regs_bvalid,
		output  [1:0] axi_regs_bresp,

		// Read address
		output        axi_regs_arready,
		input         axi_regs_arvalid,
		input  [31:0] axi_regs_araddr,

		// Read data
		input         axi_regs_rready,
		output        axi_regs_rvalid,
		output  [1:0] axi_regs_rresp,
		output [31:0] axi_regs_rdata,

		// --------------------------------------------------------------------
		// AXI Transmit BRAM Interface
		// --------------------------------------------------------------------
		//
		// Write address
		input   [0:0] axi_tx_awid,
		input  [31:0] axi_tx_awaddr,
		input   [7:0] axi_tx_awlen,
		input   [2:0] axi_tx_awsize,
		input   [1:0] axi_tx_awburst,
		input         axi_tx_awvalid,
		output        axi_tx_awready,
		//
		// Write data
		input  [31:0] axi_tx_wdata,
		input   [3:0] axi_tx_wstrb,
		input         axi_tx_wlast,
		input         axi_tx_wvalid,
		output        axi_tx_wready,
		//
		// Write response
		output  [0:0] axi_tx_bid,
		output  [1:0] axi_tx_bresp,
		output        axi_tx_bvalid,
		input         axi_tx_bready,
		//
		// Read address
		input   [0:0] axi_tx_arid,
		input  [31:0] axi_tx_araddr,
		input   [7:0] axi_tx_arlen,
		input   [2:0] axi_tx_arsize,
		input   [1:0] axi_tx_arburst,
		input         axi_tx_arvalid,
		output        axi_tx_arready,
		//
		// Read data
		output  [0:0] axi_tx_rid,
		output [31:0] axi_tx_rdata,
		output  [1:0] axi_tx_rresp,
		output        axi_tx_rlast,
		output        axi_tx_rvalid,
		input         axi_tx_rready,

		// --------------------------------------------------------------------
		// AXI Receive BRAM Interface
		// --------------------------------------------------------------------
		//
		// Write address
		input   [0:0] axi_rx_awid,
		input  [31:0] axi_rx_awaddr,
		input   [7:0] axi_rx_awlen,
		input   [2:0] axi_rx_awsize,
		input   [1:0] axi_rx_awburst,
		input         axi_rx_awvalid,
		output        axi_rx_awready,
		//
		// Write data
		input  [31:0] axi_rx_wdata,
		input   [3:0] axi_rx_wstrb,
		input         axi_rx_wlast,
		input         axi_rx_wvalid,
		output        axi_rx_wready,
		//
		// Write response
		output  [0:0] axi_rx_bid,
		output  [1:0] axi_rx_bresp,
		output        axi_rx_bvalid,
		input         axi_rx_bready,
		//
		// Read address
		input   [0:0] axi_rx_arid,
		input  [31:0] axi_rx_araddr,
		input   [7:0] axi_rx_arlen,
		input   [2:0] axi_rx_arsize,
		input   [1:0] axi_rx_arburst,
		input         axi_rx_arvalid,
		output        axi_rx_arready,
		//
		// Read data
		output  [0:0] axi_rx_rid,
		output [31:0] axi_rx_rdata,
		output  [1:0] axi_rx_rresp,
		output        axi_rx_rlast,
		output        axi_rx_rvalid,
		input         axi_rx_rready,

		// --------------------------------------------------------------------
		// AXI4-Lite DRP Interface
		// --------------------------------------------------------------------
		//
		// Write address
		output        axi_drp_awready,
		input         axi_drp_awvalid,
		input  [31:0] axi_drp_awaddr,

		// Write data
		output        axi_drp_wready,
		input         axi_drp_wvalid,
		input   [3:0] axi_drp_wstrb,
		input  [31:0] axi_drp_wdata,

		// Write response
		input         axi_drp_bready,
		output        axi_drp_bvalid,
		output  [1:0] axi_drp_bresp,

		// Read address
		output        axi_drp_arready,
		input         axi_drp_arvalid,
		input  [31:0] axi_drp_araddr,

		// Read data
		input         axi_drp_rready,
		output        axi_drp_rvalid,
		output  [1:0] axi_drp_rresp,
		output [31:0] axi_drp_rdata

	);

	// ------------------------------------------------------------------------
	// Local parameters
	// ------------------------------------------------------------------------
	//
	// Transceiver-side BRAM size
	// * 32k x 128-bits = 2^15 x 128-bits
	localparam int XVR_BRAM_ADDR_WIDTH = 15;
	localparam int XVR_BRAM_DATA_WIDTH = 128;
	localparam int XVR_BRAM_WE_WIDTH   = XVR_BRAM_DATA_WIDTH/8;

	// Transceiver interface width
	// * This generic needs to match the setting in xvr.tcl
//	localparam int XVR_DATA_WIDTH = 40;
	localparam int XVR_DATA_WIDTH = 80;

	// ------------------------------------------------------------------------
	// Local signals
	// ------------------------------------------------------------------------
	//
	// AXI control/status registers
	logic  [31:0] axi_control0;
	logic  [31:0] axi_control1;
	logic [127:0] axi_pattern;
	logic  [31:0] axi_status0;
	logic  [31:0] axi_status1;
	logic  [31:0] axi_status2;
	logic  [31:0] axi_status3;
	logic  [31:0] axi_status4;

	// AXI control/status bits
	logic        axi_tx_enable;
	logic        axi_tx_done;
	logic        axi_rx_enable;
	logic        axi_rx_done;
	logic        axi_cnt_en;

	// AXI TX BRAM interface
	// 512kB = 128k x 32-bit, 19-bit byte address
	logic        axi_tx_bram_en;
	logic [31:0] axi_tx_bram_addr;
	logic [31:0] axi_tx_bram_wdata;
	logic  [3:0] axi_tx_bram_wstrb;
	logic [31:0] axi_tx_bram_rdata;

	// AXI RX BRAM interface
	// 512kB = 128k x 32-bit, 19-bit byte address
	logic        axi_rx_bram_en;
	logic [31:0] axi_rx_bram_addr;
	logic [31:0] axi_rx_bram_wdata;
	logic  [3:0] axi_rx_bram_wstrb;
	logic [31:0] axi_rx_bram_rdata;

	// Transceiver parallel clock domain reset and clock
	logic xvr_tx_rst_n;
	logic xvr_tx_clk;
	logic xvr_rx_rst_n;
	logic xvr_rx_clk;

	// Transmit path BRAM in XCVR domain
	(* MARK_DEBUG = "TRUE" *) logic                           xvr_tx_bram_en;
	(* MARK_DEBUG = "TRUE" *) logic   [XVR_BRAM_WE_WIDTH-1:0] xvr_tx_bram_we;
	(* MARK_DEBUG = "TRUE" *) logic [XVR_BRAM_ADDR_WIDTH-1:0] xvr_tx_bram_addr;
	(* MARK_DEBUG = "TRUE" *) logic [XVR_BRAM_DATA_WIDTH-1:0] xvr_tx_bram_wdata;
	(* MARK_DEBUG = "TRUE" *) logic [XVR_BRAM_DATA_WIDTH-1:0] xvr_tx_bram_rdata;
	//
	// Receive path BRAM
	(* MARK_DEBUG = "TRUE" *) logic                           xvr_rx_bram_en;
	(* MARK_DEBUG = "TRUE" *) logic   [XVR_BRAM_WE_WIDTH-1:0] xvr_rx_bram_we;
	(* MARK_DEBUG = "TRUE" *) logic [XVR_BRAM_ADDR_WIDTH-1:0] xvr_rx_bram_addr;
	(* MARK_DEBUG = "TRUE" *) logic [XVR_BRAM_DATA_WIDTH-1:0] xvr_rx_bram_wdata;
	(* MARK_DEBUG = "TRUE" *) logic [XVR_BRAM_DATA_WIDTH-1:0] xvr_rx_bram_rdata;
	//
	// Transceiver control/status
	(* MARK_DEBUG = "TRUE" *) logic        xvr_tx_enable;
	(* MARK_DEBUG = "TRUE" *) logic        xvr_tx_done;
	(* MARK_DEBUG = "TRUE" *) logic        xvr_rx_enable;
	(* MARK_DEBUG = "TRUE" *) logic        xvr_rx_done;

	// Transceiver parallel data streams
	(* MARK_DEBUG = "TRUE" *) logic [XVR_BRAM_DATA_WIDTH-1:0] xvr_tx_data;
	(* MARK_DEBUG = "TRUE" *) logic [XVR_BRAM_DATA_WIDTH-1:0] xvr_rx_data;

	// Transceiver control/status
	logic       xvr_reset_all;
	logic [2:0] xvr_loopback;
	logic [3:0] xvr_tx_diffctrl;
	logic [4:0] xvr_tx_postcursor;
	logic [4:0] xvr_tx_precursor;
	logic       xvr_power_good;
	logic       xvr_reset_tx_done;
	logic       xvr_reset_rx_done;

	// Transceiver differential clock buffer
	logic xvr_refclk_in;
	logic xvr_refclk_div;
	logic xvr_refclk;

	// REFCLK out monitoring
	logic       xvr_refclk_out_tx_clk;
	logic       xvr_refclk_out_rx_clk;
	logic       xvr_refclk_out_power_good;
	logic       xvr_refclk_out_reset_tx_done;
	logic       xvr_refclk_out_reset_rx_done;

	// Transmit pattern
	logic [XVR_BRAM_DATA_WIDTH-1:0] xvr_tx_pattern;

	// DRP Interface
	logic        drp_en;
	logic        drp_we;
	logic        drp_rdy;
	logic  [9:0] drp_addr;
	logic [15:0] drp_wdata;
	logic [15:0] drp_rdata;

	// ------------------------------------------------------------------------
	// AXI4-Lite Registers
	// ------------------------------------------------------------------------
	//
	xvr_registers u1 (
		// -------------------------
		// AXI4-Lite Interface
		// -------------------------
		//
		// AXI4 reset and clock
		.axi_rst_n   (axi_rst_n       ),
		.axi_clk     (axi_clk         ),

		// Write address
		.axi_awready (axi_regs_awready),
		.axi_awvalid (axi_regs_awvalid),
		.axi_awaddr  (axi_regs_awaddr ),

		// Write data
		.axi_wready  (axi_regs_wready ),
		.axi_wvalid  (axi_regs_wvalid ),
		.axi_wstrb   (axi_regs_wstrb  ),
		.axi_wdata   (axi_regs_wdata  ),

		// Write response
		.axi_bready  (axi_regs_bready ),
		.axi_bvalid  (axi_regs_bvalid ),
		.axi_bresp   (axi_regs_bresp  ),

		// Read address
		.axi_arready (axi_regs_arready),
		.axi_arvalid (axi_regs_arvalid),
		.axi_araddr  (axi_regs_araddr ),

		// Write data
		.axi_rready  (axi_regs_rready ),
		.axi_rvalid  (axi_regs_rvalid ),
		.axi_rresp   (axi_regs_rresp  ),
		.axi_rdata   (axi_regs_rdata  ),

		// -------------------------
		// Control/status registers
		// -------------------------
		//
		.control0    (axi_control0         ),
		.control1    (axi_control1         ),
		.control2    (),
		.control3    (),
		.control4    (axi_pattern[ 0 +: 32]), // 128-bit pattern (128-bit aligned)
		.control5    (axi_pattern[32 +: 32]),
		.control6    (axi_pattern[64 +: 32]),
		.control7    (axi_pattern[96 +: 32]),
		.status0     (axi_status0       ),
		.status1     (axi_status1       ),
		.status2     (axi_status2       ),
		.status3     (axi_status3       ),
		.status4     (axi_status4       ),
		.status5     ('0                ),
		.status6     ('0                ),
		.status7     ('0                )
	);

	// ------------------------------------------------------------------------
	// AXI control/status
	// ------------------------------------------------------------------------
	//
	// Transceiver controls
	assign xvr_reset_all = axi_control0[0];
	assign xvr_loopback  = axi_control0[3:1];

	// BRAM controls
	assign axi_tx_enable = axi_control0[4];
	assign axi_rx_enable = axi_control0[5];

	// Clock counter enable
	assign axi_cnt_en = axi_control1[0];

	// Transceiver controls
	// *** TODO: Synchronizer or registers in the XCVR clock domain?
	assign xvr_tx_diffctrl   = axi_control0[11:8];
	//
	// UG576, Table 3-35, p166, indicates that control of TXDIFFCTRL requires
	// TXPRECURSOR and TXPOSTCURSOR values to be zero.
	assign xvr_tx_postcursor = '0;
	assign xvr_tx_precursor  = '0;

	// Transceiver pattern
	// *** TODO: Add a synchronizer? Update when a write occurs?
	// If there are a lot of registers in the XVR domain use an
	// AXI clock-domain crossing bridge.
	assign xvr_tx_pattern = axi_pattern;

	// Status
	// *** TODO: Add synchronizers?
	assign axi_status0 = {
		axi_control0[31:12],
		1'b0,
		xvr_refclk_out_reset_rx_done,
		xvr_refclk_out_reset_tx_done,
		xvr_refclk_out_power_good,
		2'b00,
		axi_rx_done,
		axi_tx_done,
		1'b0,
		xvr_reset_rx_done,
		xvr_reset_tx_done,
		xvr_power_good
	};

	// ------------------------------------------------------------------------
	// AXI BRAM Controllers
	// ------------------------------------------------------------------------
	//
	axi4_bram_common_address #(
		// AXI parameters
		.AXI_ID_WIDTH   (1 ),
		.AXI_ADDR_WIDTH (32),
		.AXI_DATA_WIDTH (32),

		// BRAM pipeline length
		.BRAM_PIPELINE  (3)
	) u2 (
		.axi_rst_n   (axi_rst_n      ),
		.axi_clk     (axi_clk        ),

		// AXI4 Interface
		.axi_awid    (axi_tx_awid   ),
		.axi_awaddr  (axi_tx_awaddr ),
		.axi_awlen   (axi_tx_awlen  ),
		.axi_awsize  (axi_tx_awsize ),
		.axi_awburst (axi_tx_awburst),
		.axi_awvalid (axi_tx_awvalid),
		.axi_awready (axi_tx_awready),
		.axi_wdata   (axi_tx_wdata  ),
		.axi_wstrb   (axi_tx_wstrb  ),
		.axi_wlast   (axi_tx_wlast  ),
		.axi_wvalid  (axi_tx_wvalid ),
		.axi_wready  (axi_tx_wready ),
		.axi_bid     (axi_tx_bid    ),
		.axi_bresp   (axi_tx_bresp  ),
		.axi_bvalid  (axi_tx_bvalid ),
		.axi_bready  (axi_tx_bready ),
		.axi_arid    (axi_tx_arid   ),
		.axi_araddr  (axi_tx_araddr ),
		.axi_arlen   (axi_tx_arlen  ),
		.axi_arsize  (axi_tx_arsize ),
		.axi_arburst (axi_tx_arburst),
		.axi_arvalid (axi_tx_arvalid),
		.axi_arready (axi_tx_arready),
		.axi_rid     (axi_tx_rid    ),
		.axi_rdata   (axi_tx_rdata  ),
		.axi_rresp   (axi_tx_rresp  ),
		.axi_rlast   (axi_tx_rlast  ),
		.axi_rvalid  (axi_tx_rvalid ),
		.axi_rready  (axi_tx_rready ),

		// BRAM Interface
		.bram_en     (axi_tx_bram_en    ),
		.bram_addr   (axi_tx_bram_addr  ), // TODO: Change from byte-based?
		.bram_wdata  (axi_tx_bram_wdata ),
		.bram_wstrb  (axi_tx_bram_wstrb ),
		.bram_rdata  (axi_tx_bram_rdata )
	);

	axi4_bram_common_address #(
		// AXI parameters
		.AXI_ID_WIDTH   (1 ),
		.AXI_ADDR_WIDTH (32),
		.AXI_DATA_WIDTH (32),

		// BRAM pipeline length
		.BRAM_PIPELINE  (3)
	) u3 (
		.axi_rst_n   (axi_rst_n      ),
		.axi_clk     (axi_clk        ),

		// AXI4 Interface
		.axi_awid    (axi_rx_awid   ),
		.axi_awaddr  (axi_rx_awaddr ),
		.axi_awlen   (axi_rx_awlen  ),
		.axi_awsize  (axi_rx_awsize ),
		.axi_awburst (axi_rx_awburst),
		.axi_awvalid (axi_rx_awvalid),
		.axi_awready (axi_rx_awready),
		.axi_wdata   (axi_rx_wdata  ),
		.axi_wstrb   (axi_rx_wstrb  ),
		.axi_wlast   (axi_rx_wlast  ),
		.axi_wvalid  (axi_rx_wvalid ),
		.axi_wready  (axi_rx_wready ),
		.axi_bid     (axi_rx_bid    ),
		.axi_bresp   (axi_rx_bresp  ),
		.axi_bvalid  (axi_rx_bvalid ),
		.axi_bready  (axi_rx_bready ),
		.axi_arid    (axi_rx_arid   ),
		.axi_araddr  (axi_rx_araddr ),
		.axi_arlen   (axi_rx_arlen  ),
		.axi_arsize  (axi_rx_arsize ),
		.axi_arburst (axi_rx_arburst),
		.axi_arvalid (axi_rx_arvalid),
		.axi_arready (axi_rx_arready),
		.axi_rid     (axi_rx_rid    ),
		.axi_rdata   (axi_rx_rdata  ),
		.axi_rresp   (axi_rx_rresp  ),
		.axi_rlast   (axi_rx_rlast  ),
		.axi_rvalid  (axi_rx_rvalid ),
		.axi_rready  (axi_rx_rready ),

		// BRAM Interface
		.bram_en     (axi_rx_bram_en    ),
		.bram_addr   (axi_rx_bram_addr  ), // TODO: Change from byte-based?
		.bram_wdata  (axi_rx_bram_wdata ),
		.bram_wstrb  (axi_rx_bram_wstrb ),
		.bram_rdata  (axi_rx_bram_rdata )
	);

	// ------------------------------------------------------------------------
	// Transmit BRAM (dual-clock)
	// ------------------------------------------------------------------------
	//
	bram_128k_x_32_and_32k_x_128  #(
		.DOA_REG  (1),
		.DOB_REG  (1),
		.MUXA_REG (1)
	) u4 (
		// Port A
		.a_ram_rst (~axi_rst_n            ),
		.a_clk     (axi_clk               ),
		.a_addr    (axi_tx_bram_addr[18:2]),
		.a_addr_en (axi_tx_bram_en        ),
		.a_en      (axi_tx_bram_en        ),
		.a_we      (axi_tx_bram_wstrb     ),
		.a_wdata   (axi_tx_bram_wdata     ),
		.a_rdata   (axi_tx_bram_rdata     ),
		.a_reg_rst (~axi_rst_n            ),
		.a_reg_en  (axi_tx_bram_en        ),

		// Port B
		.b_ram_rst (~xvr_tx_rst_n    ),
		.b_clk     (xvr_tx_clk       ),
		.b_addr    (xvr_tx_bram_addr ),
		.b_addr_en (xvr_tx_bram_en   ),
		.b_en      (xvr_tx_bram_en   ),
		.b_we      (xvr_tx_bram_we   ),
		.b_wdata   (xvr_tx_bram_wdata),
		.b_rdata   (xvr_tx_bram_rdata),
		.b_reg_rst (~xvr_tx_rst_n    ),
		.b_reg_en  (xvr_tx_bram_en   )
	);

	// ------------------------------------------------------------------------
	// Receive BRAM (dual-clock)
	// ------------------------------------------------------------------------
	//
	bram_128k_x_32_and_32k_x_128  #(
		.DOA_REG  (1),
		.DOB_REG  (1),
		.MUXA_REG (1)
	) u5 (
		// Port A
		.a_ram_rst (~axi_rst_n            ),
		.a_clk     (axi_clk               ),
		.a_addr    (axi_rx_bram_addr[18:2]),
		.a_addr_en (axi_rx_bram_en        ),
		.a_en      (axi_rx_bram_en        ),
		.a_we      (axi_rx_bram_wstrb     ),
		.a_wdata   (axi_rx_bram_wdata     ),
		.a_rdata   (axi_rx_bram_rdata     ),
		.a_reg_rst (~axi_rst_n            ),
		.a_reg_en  (axi_rx_bram_en        ),

		// Port B
		.b_ram_rst (~xvr_rx_rst_n    ),
		.b_clk     (xvr_rx_clk       ),
		.b_addr    (xvr_rx_bram_addr ),
		.b_addr_en (xvr_rx_bram_en   ),
		.b_en      (xvr_rx_bram_en   ),
		.b_we      (xvr_rx_bram_we   ),
		.b_wdata   (xvr_rx_bram_wdata),
		.b_rdata   (xvr_rx_bram_rdata),
		.b_reg_rst (~xvr_rx_rst_n    ),
		.b_reg_en  (xvr_rx_bram_en   )
	);

	// ------------------------------------------------------------------------
	// Synchronizers
	// ------------------------------------------------------------------------
	//
	// Transmit enable
	xpm_cdc_single #(
		.DEST_SYNC_FF   (2),
		.INIT_SYNC_FF   (1), // 0=disable simulation init values, 1=enable simulation init values
		.SIM_ASSERT_CHK (1), // 0=disable simulation messages, 1=enable simulation messages
		.SRC_INPUT_REG  (1)  // 0=do not register input, 1=register input
	) u6 (
		// AXI clock domain
		.src_clk  (axi_clk      ),
		.src_in   (axi_tx_enable),

		// Transceiver clock domain
		.dest_clk (xvr_tx_clk   ),
		.dest_out (xvr_tx_enable)
	);

	// Transmit done
	xpm_cdc_single #(
		.DEST_SYNC_FF   (2),
		.INIT_SYNC_FF   (1), // 0=disable simulation init values, 1=enable simulation init values
		.SIM_ASSERT_CHK (1), // 0=disable simulation messages, 1=enable simulation messages
		.SRC_INPUT_REG  (1)  // 0=do not register input, 1=register input
	) u7 (
		// Transceiver clock domain
		.src_clk  (xvr_tx_clk ),
		.src_in   (xvr_tx_done),

		// AXI clock domain
		.dest_clk (axi_clk    ),
		.dest_out (axi_tx_done)
	);

	// Receive enable
	xpm_cdc_single #(
		.DEST_SYNC_FF   (2),
		.INIT_SYNC_FF   (1), // 0=disable simulation init values, 1=enable simulation init values
		.SIM_ASSERT_CHK (1), // 0=disable simulation messages, 1=enable simulation messages
		.SRC_INPUT_REG  (1)  // 0=do not register input, 1=register input
	) u8 (
		// AXI clock domain
		.src_clk  (axi_clk      ),
		.src_in   (axi_rx_enable),

		// Transceiver clock domain
		.dest_clk (xvr_rx_clk   ),
		.dest_out (xvr_rx_enable)
	);

	// Receive done
	xpm_cdc_single #(
		.DEST_SYNC_FF   (2),
		.INIT_SYNC_FF   (1), // 0=disable simulation init values, 1=enable simulation init values
		.SIM_ASSERT_CHK (1), // 0=disable simulation messages, 1=enable simulation messages
		.SRC_INPUT_REG  (1)  // 0=do not register input, 1=register input
	) u9 (
		// Transceiver clock domain
		.src_clk  (xvr_rx_clk ),
		.src_in   (xvr_rx_done),

		// AXI clock domain
		.dest_clk (axi_clk    ),
		.dest_out (axi_rx_done)
	);

	// ------------------------------------------------------------------------
	// Transmit BRAM read control
	// ------------------------------------------------------------------------
	//
	xvr_tx_bram #(
		.ADDR_WIDTH (XVR_BRAM_ADDR_WIDTH),
		.DATA_WIDTH (XVR_BRAM_DATA_WIDTH)
	) u10 (
		.rst_n      (xvr_tx_rst_n     ),
		.clk        (xvr_tx_clk       ),
		.enable     (xvr_tx_enable    ),
		.done       (xvr_tx_done      ),
		.pattern    (xvr_tx_pattern   ),
		.bram_en    (xvr_tx_bram_en   ),
		.bram_we    (xvr_tx_bram_we   ),
		.bram_addr  (xvr_tx_bram_addr ),
		.bram_rdata (xvr_tx_bram_rdata),
		.bram_wdata (xvr_tx_bram_wdata),
		.tx_data    (xvr_tx_data      )
	);

	// ------------------------------------------------------------------------
	// Receive BRAM write control
	// ------------------------------------------------------------------------
	//
	xvr_rx_bram #(
		.ADDR_WIDTH (XVR_BRAM_ADDR_WIDTH),
		.DATA_WIDTH (XVR_BRAM_DATA_WIDTH)
	) u11 (
		.rst_n      (xvr_rx_rst_n     ),
		.clk        (xvr_rx_clk       ),
		.enable     (xvr_rx_enable    ),
		.done       (xvr_rx_done      ),
		.bram_en    (xvr_rx_bram_en   ),
		.bram_we    (xvr_rx_bram_we   ),
		.bram_addr  (xvr_rx_bram_addr ),
		.bram_rdata (xvr_rx_bram_rdata),
		.bram_wdata (xvr_rx_bram_wdata),
		.rx_data    (xvr_rx_data      )
	);

	// -------------------------------------------------------------------------
	// Transceiver REFCLK buffer
	// -------------------------------------------------------------------------
	//
	IBUFDS_GTE4 #(
		.REFCLK_EN_TX_PATH (1'b0 ), // Must be 1'b0
		.REFCLK_HROW_CK_SEL(2'b00), // ODIV2 output is not divided
		.REFCLK_ICNTL_RX   (2'b00)  // Reserved
	) u12 (
		.I     (xvr_refclk_in_p),
		.IB    (xvr_refclk_in_n),
		.CEB   (1'b0           ),     // Enabled
		.ODIV2 (xvr_refclk_div ),     // Clock to BUFG_GT
		.O     (xvr_refclk_in  )      // Clock to transceiver block
	);

	// -------------------------------------------------------------------------
	// Transceiver TX/RX Interface
	// -------------------------------------------------------------------------
	//
	xvr_interface #(
		.DATA_WIDTH (XVR_BRAM_DATA_WIDTH),
		.XVR_WIDTH  (XVR_DATA_WIDTH     )
	) u13 (
		// Transceiver
		.refclk        (xvr_refclk_in),
		.tx_p          (xvr_tx_p     ),
		.tx_n          (xvr_tx_n     ),
		.rx_p          (xvr_rx_p     ),
		.rx_n          (xvr_rx_n     ),

		// Transmitter
		.tx_rst_n      (xvr_tx_rst_n ),
		.tx_clk        (xvr_tx_clk   ),
		.tx_data       (xvr_tx_data  ),

		// Receiver
		.rx_rst_n      (xvr_rx_rst_n ),
		.rx_clk        (xvr_rx_clk   ),
		.rx_data       (xvr_rx_data  ),

		// 125MHz clock
		.clk           (axi_clk      ),

		// Control/status
		.loopback      (xvr_loopback     ),
		.tx_diffctrl   (xvr_tx_diffctrl  ),
		.tx_postcursor (xvr_tx_postcursor),
		.tx_precursor  (xvr_tx_precursor ),
		.reset_all     (xvr_reset_all    ),
		.power_good    (xvr_power_good   ),
		.reset_tx_done (xvr_reset_tx_done),
		.reset_rx_done (xvr_reset_rx_done)
	);

	// ------------------------------------------------------------------------
	// AXI4-Lite DRP Bridge
	// ------------------------------------------------------------------------
	//
	// The bridge only decodes 10-bits of the 32-bit AXI address, so Vivado
	// will generate Synth 8-3331 warnings that write and read address bits
	// [31:12] and [1:0] are unused. Similarly, only the 16-bit LSBs
	// of the write data bus are used and the write-strobes are ignored,
	// so they also generate warnings. These warnings can be ignored.
	//
	axi4lite_to_drp_bridge #(
		.AXI_ID_WIDTH   (1 ),
		.AXI_ADDR_WIDTH (32),
		.AXI_DATA_WIDTH (32),
		.DRP_ADDR_WIDTH (10), // UltraScale+ is 10-bit
		.DRP_DATA_WIDTH (16)
	) u14 (
		// --------------------------
		// AXI4-Lite Interface
		// --------------------------
		//
		// Reset and clock
		.axi_rst_n    (axi_rst_n      ),
		.axi_clk      (axi_clk        ),

		// Write address
		.axi_awid     ('0             ),
		.axi_awaddr   (axi_drp_awaddr ),
		.axi_awvalid  (axi_drp_awvalid),
		.axi_awready  (axi_drp_awready),

		// Write data
		.axi_wvalid   (axi_drp_wvalid ),
		.axi_wready   (axi_drp_wready ),
		.axi_wdata    (axi_drp_wdata  ),
		.axi_wstrb    (axi_drp_wstrb  ),

		// Write response
		.axi_bvalid   (axi_drp_bvalid ),
		.axi_bready   (axi_drp_bready ),
		.axi_bid      (               ),
		.axi_bresp    (axi_drp_bresp  ),

		// Read address
		.axi_arvalid  (axi_drp_arvalid),
		.axi_arready  (axi_drp_arready),
		.axi_arid     ('0             ),
		.axi_araddr   (axi_drp_araddr ),

		// Read data
		.axi_rvalid   (axi_drp_rvalid ),
		.axi_rready   (axi_drp_rready ),
		.axi_rid      (               ),
		.axi_rdata    (axi_drp_rdata  ),
		.axi_rresp    (axi_drp_rresp  ),

		// --------------------------
		// DRP Interface
		// --------------------------
		//
		.drp_en       (drp_en         ),
		.drp_we       (drp_we         ),
		.drp_rdy      (drp_rdy        ),
		.drp_addr     (drp_addr       ),
		.drp_wdata    (drp_wdata      ),
		.drp_rdata    (drp_rdata      )
	);

	// -------------------------------------------------------------------------
	// Transceiver REFCLK Output Interface
	// -------------------------------------------------------------------------
	//
	xvr_refclk_out_interface u15 (
		// Transceiver
		.refclk_in     (xvr_refclk_in   ),
		.refclk_out_p  (xvr_refclk_out_p),
		.refclk_out_n  (xvr_refclk_out_n),
		.tx_p          (                ),
		.tx_n          (                ),
		.rx_p          (1'b0            ),
		.rx_n          (1'b1            ),

		// 125MHz clock
		.clk           (axi_clk         ),

		// Output clocks (to clock counters)
		.tx_clk        (xvr_refclk_out_tx_clk),
		.rx_clk        (xvr_refclk_out_rx_clk),

		// Control/status
		.reset_all     (xvr_reset_all   ),
		.power_good    (xvr_refclk_out_power_good   ),
		.reset_tx_done (xvr_refclk_out_reset_tx_done),
		.reset_rx_done (xvr_refclk_out_reset_rx_done),

		// DRP interface
		.drp_en        (drp_en          ),
		.drp_we        (drp_we          ),
		.drp_rdy       (drp_rdy         ),
		.drp_addr      (drp_addr        ),
		.drp_wdata     (drp_wdata       ),
		.drp_rdata     (drp_rdata       )
	);

	// -------------------------------------------------------------------------
	// REFCLK to fabric clock buffer
	// -------------------------------------------------------------------------
	//
	// Global clock buffer
	BUFG_GT u16 (
		.I       (xvr_refclk_div),
		.CLR     (1'b0          ),
		.CE      (1'b1          ),
		.CEMASK  (1'b0          ),
		.CLRMASK (1'b0          ),
		.DIV     (3'h0          ), // No division
		.O       (xvr_refclk    )
	);

	// -------------------------------------------------------------------------
	// Clock counters
	// -------------------------------------------------------------------------
	//
	// System clock
	// * This component uses the same synchronizer logic to read the system
	//   clock period, even though it is not technically needed.
	clock_counter #(
		.WIDTH (32)
	) u17 (
		.sys_rst_n (axi_rst_n  ),
		.sys_clk   (axi_clk    ),
		.sys_en    (axi_cnt_en ),
		.sys_count (axi_status1),
		.ext_clk   (axi_clk    )
	);

	// REFCLK input
	clock_counter #(
		.WIDTH (32)
	) u18 (
		.sys_rst_n (axi_rst_n  ),
		.sys_clk   (axi_clk    ),
		.sys_en    (axi_cnt_en ),
		.sys_count (axi_status2),
		.ext_clk   (xvr_refclk )
	);

	// Transceiver TX programmable clock
	clock_counter #(
		.WIDTH (32)
	) u19 (
		.sys_rst_n (axi_rst_n     ),
		.sys_clk   (axi_clk       ),
		.sys_en    (axi_cnt_en    ),
		.sys_count (axi_status3   ),
		.ext_clk   (xvr_refclk_out_tx_clk)
	);

	// Transceiver RX programmable clock (same as REFCLK output)
	clock_counter #(
		.WIDTH (32)
	) u20 (
		.sys_rst_n (axi_rst_n     ),
		.sys_clk   (axi_clk       ),
		.sys_en    (axi_cnt_en    ),
		.sys_count (axi_status4   ),
		.ext_clk   (xvr_refclk_out_rx_clk)
	);

endmodule


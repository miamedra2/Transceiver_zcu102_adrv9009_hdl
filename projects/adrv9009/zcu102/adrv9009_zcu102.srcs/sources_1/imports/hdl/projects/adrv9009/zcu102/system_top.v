// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  inout                   iic_scl,
  inout                   iic_sda,

  input                   ref_clk0_p,
  input                   ref_clk0_n,
  input                   ref_clk1_p,
  input                   ref_clk1_n,
  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,
  output      [ 3:0]      tx_data_p,
  output      [ 3:0]      tx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  output                  rx_os_sync_p,
  output                  rx_os_sync_n,
  input                   tx_sync_p,
  input                   tx_sync_n,
  input                   tx_sync_1_p,
  input                   tx_sync_1_n,
  input                   sysref_p,
  input                   sysref_n,

  output                  sysref_out_p,
  output                  sysref_out_n,

  output                  spi_csn_ad9528,
  output                  spi_csn_adrv9009,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   ad9528_reset_b,
  inout                   ad9528_sysref_req,
  inout                   adrv9009_tx1_enable,
  inout                   adrv9009_tx2_enable,
  inout                   adrv9009_rx1_enable,
  inout                   adrv9009_rx2_enable,
  inout                   adrv9009_test,
  inout                   adrv9009_reset_b,
  inout                   adrv9009_gpint,

  inout                   adrv9009_gpio_00,
  inout                   adrv9009_gpio_01,
  inout                   adrv9009_gpio_02,
  inout                   adrv9009_gpio_03,
  inout                   adrv9009_gpio_04,
  inout                   adrv9009_gpio_05,
  inout                   adrv9009_gpio_06,
  inout                   adrv9009_gpio_07,
  inout                   adrv9009_gpio_15,
  inout                   adrv9009_gpio_08,
  inout                   adrv9009_gpio_09,
  inout                   adrv9009_gpio_10,
  inout                   adrv9009_gpio_11,
  inout                   adrv9009_gpio_12,
  inout                   adrv9009_gpio_14,
  inout                   adrv9009_gpio_13,
  inout                   adrv9009_gpio_17,
  inout                   adrv9009_gpio_16,
  inout                   adrv9009_gpio_18,
  		// REFCLK
		input        xvr_refclk_in_p,
		input        xvr_refclk_in_n,

		output	     xvr_refclk_out_p,
		output       xvr_refclk_out_n,
		
		// SMA transceiver lanes
		input        xvr_rx_p,
		input        xvr_rx_n,
		output       xvr_tx_p,
		output       xvr_tx_n
  
  
  );

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire        [ 2:0]      spi_csn;
  wire                    ref_clk0;
  wire                    ref_clk1;
  wire                    rx_sync;
  wire                    rx_os_sync;
  wire                    tx_sync;
  wire                    sysref;
  //
  
    logic       axi_clk;
    logic       axi_rst_n;
    
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

  
  

  assign gpio_i[94:60] = gpio_o[94:60];
  assign gpio_i[31:21] = gpio_o[31:21];

  assign sysref_out = 0;

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_ref_clk1 (
    .CEB (1'd0),
    .I (ref_clk1_p),
    .IB (ref_clk1_n),
    .O (ref_clk1),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_os_sync (
    .I (rx_os_sync),
    .O (rx_os_sync_p),
    .OB (rx_os_sync_n));

  OBUFDS i_obufds_sysref_out (
    .I (sysref_out),
    .O (sysref_out_p),
    .OB (sysref_out_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync));

  IBUFDS i_ibufds_tx_sync_1 (
    .I (tx_sync_1_p),
    .IB (tx_sync_1_n),
    .O (tx_sync_1));

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  ad_iobuf #(.DATA_WIDTH(28)) i_iobuf (
    .dio_t ({gpio_t[59:32]}),
    .dio_i ({gpio_o[59:32]}),
    .dio_o ({gpio_i[59:32]}),
    .dio_p ({ ad9528_reset_b,       // 59
              ad9528_sysref_req,    // 58
              adrv9009_tx1_enable,  // 57
              adrv9009_tx2_enable,  // 56
              adrv9009_rx1_enable,  // 55
              adrv9009_rx2_enable,  // 54
              adrv9009_test,        // 53
              adrv9009_reset_b,     // 52
              adrv9009_gpint,       // 51
              adrv9009_gpio_00,     // 50
              adrv9009_gpio_01,     // 49
              adrv9009_gpio_02,     // 48
              adrv9009_gpio_03,     // 47
              adrv9009_gpio_04,     // 46
              adrv9009_gpio_05,     // 45
              adrv9009_gpio_06,     // 44
              adrv9009_gpio_07,     // 43
              adrv9009_gpio_15,     // 42
              adrv9009_gpio_08,     // 41
              adrv9009_gpio_09,     // 40
              adrv9009_gpio_10,     // 39
              adrv9009_gpio_11,     // 38
              adrv9009_gpio_12,     // 37
              adrv9009_gpio_14,     // 36
              adrv9009_gpio_13,     // 35
              adrv9009_gpio_17,     // 34
              adrv9009_gpio_16,     // 33
              adrv9009_gpio_18}));  // 32

  assign gpio_i[ 7: 0] = gpio_o[ 7: 0];
  assign gpio_i[20: 8] = gpio_bd_i;
  assign gpio_bd_o = gpio_o[ 7: 0];

  assign spi_csn_ad9528 =  spi_csn[0];
  assign spi_csn_adrv9009 =  spi_csn[1];

  system_wrapper i_system_wrapper (
    .dac_fifo_bypass (gpio_o[60]),
    .adc_fir_filter_active (gpio_o[61]),
    .dac_fir_filter_active (gpio_o[62]),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_ref_clk_0 (ref_clk1),
    .rx_ref_clk_2 (ref_clk1),
    .rx_sync_0 (rx_sync),
    .rx_sync_2 (rx_os_sync),
    .rx_sysref_0 (sysref),
    .rx_sysref_2 (sysref),
    .spi0_sclk (spi_clk),
    .spi0_csn (spi_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_ref_clk_0 (ref_clk1),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref),
	.axi_rst_n        (axi_rst_n         ),
	.axi_clk          (axi_clk           ),
		
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
	//.axi_tx_bram_awid     (axi_tx_awid   ),
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
	//.axi_tx_bram_bid      (axi_tx_bid     ),
	.axi_tx_bram_bresp    (axi_tx_bresp   ),
	.axi_tx_bram_bready   (axi_tx_bready  ),
	.axi_tx_bram_bvalid   (axi_tx_bvalid  ),
		//
		// Read address
	//.axi_tx_bram_arid     (axi_tx_arid    ),
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
	//.axi_tx_bram_rid      (axi_tx_rid     ),
	.axi_tx_bram_rdata    (axi_tx_rdata   ),
	.axi_tx_bram_rlast    (axi_tx_rlast   ),
	.axi_tx_bram_rresp    (axi_tx_rresp   ),
	.axi_tx_bram_rready   (axi_tx_rready  ),
		.axi_tx_bram_rvalid   (axi_tx_rvalid  ),

		// AXI Interface for receive BRAM
		// -------------------------------
		//
		// Write address
		//.axi_rx_bram_awid     (axi_rx_awid   ),
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
		//.axi_rx_bram_bid      (axi_rx_bid     ),
		.axi_rx_bram_bresp    (axi_rx_bresp   ),
		.axi_rx_bram_bready   (axi_rx_bready  ),
		.axi_rx_bram_bvalid   (axi_rx_bvalid  ),
		//
		// Read address
		//.axi_rx_bram_arid     (axi_rx_arid    ),
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
		//.axi_rx_bram_rid      (axi_rx_rid     ),
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
		.xvr_refclk_in_p (xvr_refclk_in_p),
		.xvr_refclk_in_n (xvr_refclk_in_n),
		.xvr_refclk_out_p(xvr_refclk_out_p),
		.xvr_refclk_out_n(xvr_refclk_out_n),
		.xvr_rx_p        (xvr_rx_p       ),
		.xvr_rx_n        (xvr_rx_n       ),
		.xvr_tx_p        (xvr_tx_p       ),
		.xvr_tx_n        (xvr_tx_n       ),

		// AXI Reset and Clock
		.axi_rst_n       (axi_rst_n      ),
		.axi_clk         (axi_clk        ),
 
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
		.axi_tx_awid     ('0    ),
		.axi_tx_awaddr   (axi_tx_awaddr  ),
		.axi_tx_awlen    (axi_tx_awlen   ),
		.axi_tx_awsize   (axi_tx_awsize  ),
		.axi_tx_awburst  (axi_tx_awburst ),
		.axi_tx_awvalid  (axi_tx_awvalid ),
		.axi_tx_awready  (axi_tx_awready ),
		.axi_tx_wdata    (axi_tx_wdata   ),
		.axi_tx_wstrb    (axi_tx_wstrb   ),
		.axi_tx_wlast    (axi_tx_wlast   ),
		.axi_tx_wvalid   (axi_tx_wvalid  ),
		.axi_tx_wready   (axi_tx_wready  ),
		.axi_tx_bid      ('0     ),
		.axi_tx_bresp    (axi_tx_bresp   ),
		.axi_tx_bvalid   (axi_tx_bvalid  ),
		.axi_tx_bready   (axi_tx_bready  ),
		.axi_tx_arid     ('0    ),
		.axi_tx_araddr   (axi_tx_araddr  ),
		.axi_tx_arlen    (axi_tx_arlen   ),
		.axi_tx_arsize   (axi_tx_arsize  ),
		.axi_tx_arburst  (axi_tx_arburst ),
		.axi_tx_arvalid  (axi_tx_arvalid ),
		.axi_tx_arready  (axi_tx_arready ),
		.axi_tx_rid      ('0     ),
		.axi_tx_rdata    (axi_tx_rdata   ),
		.axi_tx_rresp    (axi_tx_rresp   ),
		.axi_tx_rlast    (axi_tx_rlast   ),
		.axi_tx_rvalid   (axi_tx_rvalid  ),
		.axi_tx_rready   (axi_tx_rready  ),

		// AXI4 RX BRAM Interface
		.axi_rx_awid     ('0    ),
		.axi_rx_awaddr   (axi_rx_awaddr  ),
		.axi_rx_awlen    (axi_rx_awlen   ),
		.axi_rx_awsize   (axi_rx_awsize  ),
		.axi_rx_awburst  (axi_rx_awburst ),
		.axi_rx_awvalid  (axi_rx_awvalid ),
		.axi_rx_awready  (axi_rx_awready ),
		.axi_rx_wdata    (axi_rx_wdata   ),
		.axi_rx_wstrb    (axi_rx_wstrb   ),
		.axi_rx_wlast    (axi_rx_wlast   ),
		.axi_rx_wvalid   (axi_rx_wvalid  ),
		.axi_rx_wready   (axi_rx_wready  ),
		.axi_rx_bid      ('0     ),
		.axi_rx_bresp    (axi_rx_bresp   ),
		.axi_rx_bvalid   (axi_rx_bvalid  ),
		.axi_rx_bready   (axi_rx_bready  ),
		.axi_rx_arid     ('0    ),
		.axi_rx_araddr   (axi_rx_araddr  ),
		.axi_rx_arlen    (axi_rx_arlen   ),
		.axi_rx_arsize   (axi_rx_arsize  ),
		.axi_rx_arburst  (axi_rx_arburst ),
		.axi_rx_arvalid  (axi_rx_arvalid ),
		.axi_rx_arready  (axi_rx_arready ),
		.axi_rx_rid      ('0     ),
		.axi_rx_rdata    (axi_rx_rdata   ),
		.axi_rx_rresp    (axi_rx_rresp   ),
		.axi_rx_rlast    (axi_rx_rlast   ),
		.axi_rx_rvalid   (axi_rx_rvalid  ),
		.axi_rx_rready   (axi_rx_rready  ),
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

// ***************************************************************************
// ***************************************************************************

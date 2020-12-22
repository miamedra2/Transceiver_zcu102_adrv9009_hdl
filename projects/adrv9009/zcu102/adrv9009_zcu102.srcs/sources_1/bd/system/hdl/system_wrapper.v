//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Wed Dec 16 17:41:04 2020
//Host        : MT-202935 running 64-bit major release  (build 9200)
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (adc_fir_filter_active,
    axi_clk,
    axi_drp_araddr,
    axi_drp_arprot,
    axi_drp_arready,
    axi_drp_arvalid,
    axi_drp_awaddr,
    axi_drp_awprot,
    axi_drp_awready,
    axi_drp_awvalid,
    axi_drp_bready,
    axi_drp_bresp,
    axi_drp_bvalid,
    axi_drp_rdata,
    axi_drp_rready,
    axi_drp_rresp,
    axi_drp_rvalid,
    axi_drp_wdata,
    axi_drp_wready,
    axi_drp_wstrb,
    axi_drp_wvalid,
    axi_regs_araddr,
    axi_regs_arprot,
    axi_regs_arready,
    axi_regs_arvalid,
    axi_regs_awaddr,
    axi_regs_awprot,
    axi_regs_awready,
    axi_regs_awvalid,
    axi_regs_bready,
    axi_regs_bresp,
    axi_regs_bvalid,
    axi_regs_rdata,
    axi_regs_rready,
    axi_regs_rresp,
    axi_regs_rvalid,
    axi_regs_wdata,
    axi_regs_wready,
    axi_regs_wstrb,
    axi_regs_wvalid,
    axi_rst_n,
    axi_rx_bram_araddr,
    axi_rx_bram_arburst,
    axi_rx_bram_arcache,
    axi_rx_bram_arid,
    axi_rx_bram_arlen,
    axi_rx_bram_arlock,
    axi_rx_bram_arprot,
    axi_rx_bram_arqos,
    axi_rx_bram_arready,
    axi_rx_bram_arregion,
    axi_rx_bram_arsize,
    axi_rx_bram_arvalid,
    axi_rx_bram_awaddr,
    axi_rx_bram_awburst,
    axi_rx_bram_awcache,
    axi_rx_bram_awid,
    axi_rx_bram_awlen,
    axi_rx_bram_awlock,
    axi_rx_bram_awprot,
    axi_rx_bram_awqos,
    axi_rx_bram_awready,
    axi_rx_bram_awregion,
    axi_rx_bram_awsize,
    axi_rx_bram_awvalid,
    axi_rx_bram_bid,
    axi_rx_bram_bready,
    axi_rx_bram_bresp,
    axi_rx_bram_bvalid,
    axi_rx_bram_rdata,
    axi_rx_bram_rid,
    axi_rx_bram_rlast,
    axi_rx_bram_rready,
    axi_rx_bram_rresp,
    axi_rx_bram_rvalid,
    axi_rx_bram_wdata,
    axi_rx_bram_wlast,
    axi_rx_bram_wready,
    axi_rx_bram_wstrb,
    axi_rx_bram_wvalid,
    axi_tx_bram_araddr,
    axi_tx_bram_arburst,
    axi_tx_bram_arcache,
    axi_tx_bram_arid,
    axi_tx_bram_arlen,
    axi_tx_bram_arlock,
    axi_tx_bram_arprot,
    axi_tx_bram_arqos,
    axi_tx_bram_arready,
    axi_tx_bram_arregion,
    axi_tx_bram_arsize,
    axi_tx_bram_arvalid,
    axi_tx_bram_awaddr,
    axi_tx_bram_awburst,
    axi_tx_bram_awcache,
    axi_tx_bram_awid,
    axi_tx_bram_awlen,
    axi_tx_bram_awlock,
    axi_tx_bram_awprot,
    axi_tx_bram_awqos,
    axi_tx_bram_awready,
    axi_tx_bram_awregion,
    axi_tx_bram_awsize,
    axi_tx_bram_awvalid,
    axi_tx_bram_bid,
    axi_tx_bram_bready,
    axi_tx_bram_bresp,
    axi_tx_bram_bvalid,
    axi_tx_bram_rdata,
    axi_tx_bram_rid,
    axi_tx_bram_rlast,
    axi_tx_bram_rready,
    axi_tx_bram_rresp,
    axi_tx_bram_rvalid,
    axi_tx_bram_wdata,
    axi_tx_bram_wlast,
    axi_tx_bram_wready,
    axi_tx_bram_wstrb,
    axi_tx_bram_wvalid,
    dac_fifo_bypass,
    dac_fir_filter_active,
    gpio_i,
    gpio_o,
    gpio_t,
    rx_data_0_n,
    rx_data_0_p,
    rx_data_1_n,
    rx_data_1_p,
    rx_data_2_n,
    rx_data_2_p,
    rx_data_3_n,
    rx_data_3_p,
    rx_ref_clk_0,
    rx_ref_clk_2,
    rx_sync_0,
    rx_sync_2,
    rx_sysref_0,
    rx_sysref_2,
    spi0_csn,
    spi0_miso,
    spi0_mosi,
    spi0_sclk,
    spi1_csn,
    spi1_miso,
    spi1_mosi,
    spi1_sclk,
    tx_data_0_n,
    tx_data_0_p,
    tx_data_1_n,
    tx_data_1_p,
    tx_data_2_n,
    tx_data_2_p,
    tx_data_3_n,
    tx_data_3_p,
    tx_ref_clk_0,
    tx_sync_0,
    tx_sysref_0);
  input adc_fir_filter_active;
  output axi_clk;
  output [39:0]axi_drp_araddr;
  output [2:0]axi_drp_arprot;
  input axi_drp_arready;
  output axi_drp_arvalid;
  output [39:0]axi_drp_awaddr;
  output [2:0]axi_drp_awprot;
  input axi_drp_awready;
  output axi_drp_awvalid;
  output axi_drp_bready;
  input [1:0]axi_drp_bresp;
  input axi_drp_bvalid;
  input [31:0]axi_drp_rdata;
  output axi_drp_rready;
  input [1:0]axi_drp_rresp;
  input axi_drp_rvalid;
  output [31:0]axi_drp_wdata;
  input axi_drp_wready;
  output [3:0]axi_drp_wstrb;
  output axi_drp_wvalid;
  output [39:0]axi_regs_araddr;
  output [2:0]axi_regs_arprot;
  input axi_regs_arready;
  output axi_regs_arvalid;
  output [39:0]axi_regs_awaddr;
  output [2:0]axi_regs_awprot;
  input axi_regs_awready;
  output axi_regs_awvalid;
  output axi_regs_bready;
  input [1:0]axi_regs_bresp;
  input axi_regs_bvalid;
  input [31:0]axi_regs_rdata;
  output axi_regs_rready;
  input [1:0]axi_regs_rresp;
  input axi_regs_rvalid;
  output [31:0]axi_regs_wdata;
  input axi_regs_wready;
  output [3:0]axi_regs_wstrb;
  output axi_regs_wvalid;
  output [0:0]axi_rst_n;
  output [39:0]axi_rx_bram_araddr;
  output [1:0]axi_rx_bram_arburst;
  output [3:0]axi_rx_bram_arcache;
  output [1:0]axi_rx_bram_arid;
  output [7:0]axi_rx_bram_arlen;
  output [0:0]axi_rx_bram_arlock;
  output [2:0]axi_rx_bram_arprot;
  output [3:0]axi_rx_bram_arqos;
  input [0:0]axi_rx_bram_arready;
  output [3:0]axi_rx_bram_arregion;
  output [2:0]axi_rx_bram_arsize;
  output [0:0]axi_rx_bram_arvalid;
  output [39:0]axi_rx_bram_awaddr;
  output [1:0]axi_rx_bram_awburst;
  output [3:0]axi_rx_bram_awcache;
  output [1:0]axi_rx_bram_awid;
  output [7:0]axi_rx_bram_awlen;
  output [0:0]axi_rx_bram_awlock;
  output [2:0]axi_rx_bram_awprot;
  output [3:0]axi_rx_bram_awqos;
  input [0:0]axi_rx_bram_awready;
  output [3:0]axi_rx_bram_awregion;
  output [2:0]axi_rx_bram_awsize;
  output [0:0]axi_rx_bram_awvalid;
  input [1:0]axi_rx_bram_bid;
  output [0:0]axi_rx_bram_bready;
  input [1:0]axi_rx_bram_bresp;
  input [0:0]axi_rx_bram_bvalid;
  input [31:0]axi_rx_bram_rdata;
  input [1:0]axi_rx_bram_rid;
  input [0:0]axi_rx_bram_rlast;
  output [0:0]axi_rx_bram_rready;
  input [1:0]axi_rx_bram_rresp;
  input [0:0]axi_rx_bram_rvalid;
  output [31:0]axi_rx_bram_wdata;
  output [0:0]axi_rx_bram_wlast;
  input [0:0]axi_rx_bram_wready;
  output [3:0]axi_rx_bram_wstrb;
  output [0:0]axi_rx_bram_wvalid;
  output [39:0]axi_tx_bram_araddr;
  output [1:0]axi_tx_bram_arburst;
  output [3:0]axi_tx_bram_arcache;
  output [1:0]axi_tx_bram_arid;
  output [7:0]axi_tx_bram_arlen;
  output [0:0]axi_tx_bram_arlock;
  output [2:0]axi_tx_bram_arprot;
  output [3:0]axi_tx_bram_arqos;
  input [0:0]axi_tx_bram_arready;
  output [3:0]axi_tx_bram_arregion;
  output [2:0]axi_tx_bram_arsize;
  output [0:0]axi_tx_bram_arvalid;
  output [39:0]axi_tx_bram_awaddr;
  output [1:0]axi_tx_bram_awburst;
  output [3:0]axi_tx_bram_awcache;
  output [1:0]axi_tx_bram_awid;
  output [7:0]axi_tx_bram_awlen;
  output [0:0]axi_tx_bram_awlock;
  output [2:0]axi_tx_bram_awprot;
  output [3:0]axi_tx_bram_awqos;
  input [0:0]axi_tx_bram_awready;
  output [3:0]axi_tx_bram_awregion;
  output [2:0]axi_tx_bram_awsize;
  output [0:0]axi_tx_bram_awvalid;
  input [1:0]axi_tx_bram_bid;
  output [0:0]axi_tx_bram_bready;
  input [1:0]axi_tx_bram_bresp;
  input [0:0]axi_tx_bram_bvalid;
  input [31:0]axi_tx_bram_rdata;
  input [1:0]axi_tx_bram_rid;
  input [0:0]axi_tx_bram_rlast;
  output [0:0]axi_tx_bram_rready;
  input [1:0]axi_tx_bram_rresp;
  input [0:0]axi_tx_bram_rvalid;
  output [31:0]axi_tx_bram_wdata;
  output [0:0]axi_tx_bram_wlast;
  input [0:0]axi_tx_bram_wready;
  output [3:0]axi_tx_bram_wstrb;
  output [0:0]axi_tx_bram_wvalid;
  input dac_fifo_bypass;
  input dac_fir_filter_active;
  input [94:0]gpio_i;
  output [94:0]gpio_o;
  output [94:0]gpio_t;
  input rx_data_0_n;
  input rx_data_0_p;
  input rx_data_1_n;
  input rx_data_1_p;
  input rx_data_2_n;
  input rx_data_2_p;
  input rx_data_3_n;
  input rx_data_3_p;
  input rx_ref_clk_0;
  input rx_ref_clk_2;
  output [0:0]rx_sync_0;
  output [0:0]rx_sync_2;
  input rx_sysref_0;
  input rx_sysref_2;
  output [2:0]spi0_csn;
  input spi0_miso;
  output spi0_mosi;
  output spi0_sclk;
  output [2:0]spi1_csn;
  input spi1_miso;
  output spi1_mosi;
  output spi1_sclk;
  output tx_data_0_n;
  output tx_data_0_p;
  output tx_data_1_n;
  output tx_data_1_p;
  output tx_data_2_n;
  output tx_data_2_p;
  output tx_data_3_n;
  output tx_data_3_p;
  input tx_ref_clk_0;
  input [0:0]tx_sync_0;
  input tx_sysref_0;

  wire adc_fir_filter_active;
  wire axi_clk;
  wire [39:0]axi_drp_araddr;
  wire [2:0]axi_drp_arprot;
  wire axi_drp_arready;
  wire axi_drp_arvalid;
  wire [39:0]axi_drp_awaddr;
  wire [2:0]axi_drp_awprot;
  wire axi_drp_awready;
  wire axi_drp_awvalid;
  wire axi_drp_bready;
  wire [1:0]axi_drp_bresp;
  wire axi_drp_bvalid;
  wire [31:0]axi_drp_rdata;
  wire axi_drp_rready;
  wire [1:0]axi_drp_rresp;
  wire axi_drp_rvalid;
  wire [31:0]axi_drp_wdata;
  wire axi_drp_wready;
  wire [3:0]axi_drp_wstrb;
  wire axi_drp_wvalid;
  wire [39:0]axi_regs_araddr;
  wire [2:0]axi_regs_arprot;
  wire axi_regs_arready;
  wire axi_regs_arvalid;
  wire [39:0]axi_regs_awaddr;
  wire [2:0]axi_regs_awprot;
  wire axi_regs_awready;
  wire axi_regs_awvalid;
  wire axi_regs_bready;
  wire [1:0]axi_regs_bresp;
  wire axi_regs_bvalid;
  wire [31:0]axi_regs_rdata;
  wire axi_regs_rready;
  wire [1:0]axi_regs_rresp;
  wire axi_regs_rvalid;
  wire [31:0]axi_regs_wdata;
  wire axi_regs_wready;
  wire [3:0]axi_regs_wstrb;
  wire axi_regs_wvalid;
  wire [0:0]axi_rst_n;
  wire [39:0]axi_rx_bram_araddr;
  wire [1:0]axi_rx_bram_arburst;
  wire [3:0]axi_rx_bram_arcache;
  wire [1:0]axi_rx_bram_arid;
  wire [7:0]axi_rx_bram_arlen;
  wire [0:0]axi_rx_bram_arlock;
  wire [2:0]axi_rx_bram_arprot;
  wire [3:0]axi_rx_bram_arqos;
  wire [0:0]axi_rx_bram_arready;
  wire [3:0]axi_rx_bram_arregion;
  wire [2:0]axi_rx_bram_arsize;
  wire [0:0]axi_rx_bram_arvalid;
  wire [39:0]axi_rx_bram_awaddr;
  wire [1:0]axi_rx_bram_awburst;
  wire [3:0]axi_rx_bram_awcache;
  wire [1:0]axi_rx_bram_awid;
  wire [7:0]axi_rx_bram_awlen;
  wire [0:0]axi_rx_bram_awlock;
  wire [2:0]axi_rx_bram_awprot;
  wire [3:0]axi_rx_bram_awqos;
  wire [0:0]axi_rx_bram_awready;
  wire [3:0]axi_rx_bram_awregion;
  wire [2:0]axi_rx_bram_awsize;
  wire [0:0]axi_rx_bram_awvalid;
  wire [1:0]axi_rx_bram_bid;
  wire [0:0]axi_rx_bram_bready;
  wire [1:0]axi_rx_bram_bresp;
  wire [0:0]axi_rx_bram_bvalid;
  wire [31:0]axi_rx_bram_rdata;
  wire [1:0]axi_rx_bram_rid;
  wire [0:0]axi_rx_bram_rlast;
  wire [0:0]axi_rx_bram_rready;
  wire [1:0]axi_rx_bram_rresp;
  wire [0:0]axi_rx_bram_rvalid;
  wire [31:0]axi_rx_bram_wdata;
  wire [0:0]axi_rx_bram_wlast;
  wire [0:0]axi_rx_bram_wready;
  wire [3:0]axi_rx_bram_wstrb;
  wire [0:0]axi_rx_bram_wvalid;
  wire [39:0]axi_tx_bram_araddr;
  wire [1:0]axi_tx_bram_arburst;
  wire [3:0]axi_tx_bram_arcache;
  wire [1:0]axi_tx_bram_arid;
  wire [7:0]axi_tx_bram_arlen;
  wire [0:0]axi_tx_bram_arlock;
  wire [2:0]axi_tx_bram_arprot;
  wire [3:0]axi_tx_bram_arqos;
  wire [0:0]axi_tx_bram_arready;
  wire [3:0]axi_tx_bram_arregion;
  wire [2:0]axi_tx_bram_arsize;
  wire [0:0]axi_tx_bram_arvalid;
  wire [39:0]axi_tx_bram_awaddr;
  wire [1:0]axi_tx_bram_awburst;
  wire [3:0]axi_tx_bram_awcache;
  wire [1:0]axi_tx_bram_awid;
  wire [7:0]axi_tx_bram_awlen;
  wire [0:0]axi_tx_bram_awlock;
  wire [2:0]axi_tx_bram_awprot;
  wire [3:0]axi_tx_bram_awqos;
  wire [0:0]axi_tx_bram_awready;
  wire [3:0]axi_tx_bram_awregion;
  wire [2:0]axi_tx_bram_awsize;
  wire [0:0]axi_tx_bram_awvalid;
  wire [1:0]axi_tx_bram_bid;
  wire [0:0]axi_tx_bram_bready;
  wire [1:0]axi_tx_bram_bresp;
  wire [0:0]axi_tx_bram_bvalid;
  wire [31:0]axi_tx_bram_rdata;
  wire [1:0]axi_tx_bram_rid;
  wire [0:0]axi_tx_bram_rlast;
  wire [0:0]axi_tx_bram_rready;
  wire [1:0]axi_tx_bram_rresp;
  wire [0:0]axi_tx_bram_rvalid;
  wire [31:0]axi_tx_bram_wdata;
  wire [0:0]axi_tx_bram_wlast;
  wire [0:0]axi_tx_bram_wready;
  wire [3:0]axi_tx_bram_wstrb;
  wire [0:0]axi_tx_bram_wvalid;
  wire dac_fifo_bypass;
  wire dac_fir_filter_active;
  wire [94:0]gpio_i;
  wire [94:0]gpio_o;
  wire [94:0]gpio_t;
  wire rx_data_0_n;
  wire rx_data_0_p;
  wire rx_data_1_n;
  wire rx_data_1_p;
  wire rx_data_2_n;
  wire rx_data_2_p;
  wire rx_data_3_n;
  wire rx_data_3_p;
  wire rx_ref_clk_0;
  wire rx_ref_clk_2;
  wire [0:0]rx_sync_0;
  wire [0:0]rx_sync_2;
  wire rx_sysref_0;
  wire rx_sysref_2;
  wire [2:0]spi0_csn;
  wire spi0_miso;
  wire spi0_mosi;
  wire spi0_sclk;
  wire [2:0]spi1_csn;
  wire spi1_miso;
  wire spi1_mosi;
  wire spi1_sclk;
  wire tx_data_0_n;
  wire tx_data_0_p;
  wire tx_data_1_n;
  wire tx_data_1_p;
  wire tx_data_2_n;
  wire tx_data_2_p;
  wire tx_data_3_n;
  wire tx_data_3_p;
  wire tx_ref_clk_0;
  wire [0:0]tx_sync_0;
  wire tx_sysref_0;

  system system_i
       (.adc_fir_filter_active(adc_fir_filter_active),
        .axi_clk(axi_clk),
        .axi_drp_araddr(axi_drp_araddr),
        .axi_drp_arprot(axi_drp_arprot),
        .axi_drp_arready(axi_drp_arready),
        .axi_drp_arvalid(axi_drp_arvalid),
        .axi_drp_awaddr(axi_drp_awaddr),
        .axi_drp_awprot(axi_drp_awprot),
        .axi_drp_awready(axi_drp_awready),
        .axi_drp_awvalid(axi_drp_awvalid),
        .axi_drp_bready(axi_drp_bready),
        .axi_drp_bresp(axi_drp_bresp),
        .axi_drp_bvalid(axi_drp_bvalid),
        .axi_drp_rdata(axi_drp_rdata),
        .axi_drp_rready(axi_drp_rready),
        .axi_drp_rresp(axi_drp_rresp),
        .axi_drp_rvalid(axi_drp_rvalid),
        .axi_drp_wdata(axi_drp_wdata),
        .axi_drp_wready(axi_drp_wready),
        .axi_drp_wstrb(axi_drp_wstrb),
        .axi_drp_wvalid(axi_drp_wvalid),
        .axi_regs_araddr(axi_regs_araddr),
        .axi_regs_arprot(axi_regs_arprot),
        .axi_regs_arready(axi_regs_arready),
        .axi_regs_arvalid(axi_regs_arvalid),
        .axi_regs_awaddr(axi_regs_awaddr),
        .axi_regs_awprot(axi_regs_awprot),
        .axi_regs_awready(axi_regs_awready),
        .axi_regs_awvalid(axi_regs_awvalid),
        .axi_regs_bready(axi_regs_bready),
        .axi_regs_bresp(axi_regs_bresp),
        .axi_regs_bvalid(axi_regs_bvalid),
        .axi_regs_rdata(axi_regs_rdata),
        .axi_regs_rready(axi_regs_rready),
        .axi_regs_rresp(axi_regs_rresp),
        .axi_regs_rvalid(axi_regs_rvalid),
        .axi_regs_wdata(axi_regs_wdata),
        .axi_regs_wready(axi_regs_wready),
        .axi_regs_wstrb(axi_regs_wstrb),
        .axi_regs_wvalid(axi_regs_wvalid),
        .axi_rst_n(axi_rst_n),
        .axi_rx_bram_araddr(axi_rx_bram_araddr),
        .axi_rx_bram_arburst(axi_rx_bram_arburst),
        .axi_rx_bram_arcache(axi_rx_bram_arcache),
        .axi_rx_bram_arid(axi_rx_bram_arid),
        .axi_rx_bram_arlen(axi_rx_bram_arlen),
        .axi_rx_bram_arlock(axi_rx_bram_arlock),
        .axi_rx_bram_arprot(axi_rx_bram_arprot),
        .axi_rx_bram_arqos(axi_rx_bram_arqos),
        .axi_rx_bram_arready(axi_rx_bram_arready),
        .axi_rx_bram_arregion(axi_rx_bram_arregion),
        .axi_rx_bram_arsize(axi_rx_bram_arsize),
        .axi_rx_bram_arvalid(axi_rx_bram_arvalid),
        .axi_rx_bram_awaddr(axi_rx_bram_awaddr),
        .axi_rx_bram_awburst(axi_rx_bram_awburst),
        .axi_rx_bram_awcache(axi_rx_bram_awcache),
        .axi_rx_bram_awid(axi_rx_bram_awid),
        .axi_rx_bram_awlen(axi_rx_bram_awlen),
        .axi_rx_bram_awlock(axi_rx_bram_awlock),
        .axi_rx_bram_awprot(axi_rx_bram_awprot),
        .axi_rx_bram_awqos(axi_rx_bram_awqos),
        .axi_rx_bram_awready(axi_rx_bram_awready),
        .axi_rx_bram_awregion(axi_rx_bram_awregion),
        .axi_rx_bram_awsize(axi_rx_bram_awsize),
        .axi_rx_bram_awvalid(axi_rx_bram_awvalid),
        .axi_rx_bram_bid(axi_rx_bram_bid),
        .axi_rx_bram_bready(axi_rx_bram_bready),
        .axi_rx_bram_bresp(axi_rx_bram_bresp),
        .axi_rx_bram_bvalid(axi_rx_bram_bvalid),
        .axi_rx_bram_rdata(axi_rx_bram_rdata),
        .axi_rx_bram_rid(axi_rx_bram_rid),
        .axi_rx_bram_rlast(axi_rx_bram_rlast),
        .axi_rx_bram_rready(axi_rx_bram_rready),
        .axi_rx_bram_rresp(axi_rx_bram_rresp),
        .axi_rx_bram_rvalid(axi_rx_bram_rvalid),
        .axi_rx_bram_wdata(axi_rx_bram_wdata),
        .axi_rx_bram_wlast(axi_rx_bram_wlast),
        .axi_rx_bram_wready(axi_rx_bram_wready),
        .axi_rx_bram_wstrb(axi_rx_bram_wstrb),
        .axi_rx_bram_wvalid(axi_rx_bram_wvalid),
        .axi_tx_bram_araddr(axi_tx_bram_araddr),
        .axi_tx_bram_arburst(axi_tx_bram_arburst),
        .axi_tx_bram_arcache(axi_tx_bram_arcache),
        .axi_tx_bram_arid(axi_tx_bram_arid),
        .axi_tx_bram_arlen(axi_tx_bram_arlen),
        .axi_tx_bram_arlock(axi_tx_bram_arlock),
        .axi_tx_bram_arprot(axi_tx_bram_arprot),
        .axi_tx_bram_arqos(axi_tx_bram_arqos),
        .axi_tx_bram_arready(axi_tx_bram_arready),
        .axi_tx_bram_arregion(axi_tx_bram_arregion),
        .axi_tx_bram_arsize(axi_tx_bram_arsize),
        .axi_tx_bram_arvalid(axi_tx_bram_arvalid),
        .axi_tx_bram_awaddr(axi_tx_bram_awaddr),
        .axi_tx_bram_awburst(axi_tx_bram_awburst),
        .axi_tx_bram_awcache(axi_tx_bram_awcache),
        .axi_tx_bram_awid(axi_tx_bram_awid),
        .axi_tx_bram_awlen(axi_tx_bram_awlen),
        .axi_tx_bram_awlock(axi_tx_bram_awlock),
        .axi_tx_bram_awprot(axi_tx_bram_awprot),
        .axi_tx_bram_awqos(axi_tx_bram_awqos),
        .axi_tx_bram_awready(axi_tx_bram_awready),
        .axi_tx_bram_awregion(axi_tx_bram_awregion),
        .axi_tx_bram_awsize(axi_tx_bram_awsize),
        .axi_tx_bram_awvalid(axi_tx_bram_awvalid),
        .axi_tx_bram_bid(axi_tx_bram_bid),
        .axi_tx_bram_bready(axi_tx_bram_bready),
        .axi_tx_bram_bresp(axi_tx_bram_bresp),
        .axi_tx_bram_bvalid(axi_tx_bram_bvalid),
        .axi_tx_bram_rdata(axi_tx_bram_rdata),
        .axi_tx_bram_rid(axi_tx_bram_rid),
        .axi_tx_bram_rlast(axi_tx_bram_rlast),
        .axi_tx_bram_rready(axi_tx_bram_rready),
        .axi_tx_bram_rresp(axi_tx_bram_rresp),
        .axi_tx_bram_rvalid(axi_tx_bram_rvalid),
        .axi_tx_bram_wdata(axi_tx_bram_wdata),
        .axi_tx_bram_wlast(axi_tx_bram_wlast),
        .axi_tx_bram_wready(axi_tx_bram_wready),
        .axi_tx_bram_wstrb(axi_tx_bram_wstrb),
        .axi_tx_bram_wvalid(axi_tx_bram_wvalid),
        .dac_fifo_bypass(dac_fifo_bypass),
        .dac_fir_filter_active(dac_fir_filter_active),
        .gpio_i(gpio_i),
        .gpio_o(gpio_o),
        .gpio_t(gpio_t),
        .rx_data_0_n(rx_data_0_n),
        .rx_data_0_p(rx_data_0_p),
        .rx_data_1_n(rx_data_1_n),
        .rx_data_1_p(rx_data_1_p),
        .rx_data_2_n(rx_data_2_n),
        .rx_data_2_p(rx_data_2_p),
        .rx_data_3_n(rx_data_3_n),
        .rx_data_3_p(rx_data_3_p),
        .rx_ref_clk_0(rx_ref_clk_0),
        .rx_ref_clk_2(rx_ref_clk_2),
        .rx_sync_0(rx_sync_0),
        .rx_sync_2(rx_sync_2),
        .rx_sysref_0(rx_sysref_0),
        .rx_sysref_2(rx_sysref_2),
        .spi0_csn(spi0_csn),
        .spi0_miso(spi0_miso),
        .spi0_mosi(spi0_mosi),
        .spi0_sclk(spi0_sclk),
        .spi1_csn(spi1_csn),
        .spi1_miso(spi1_miso),
        .spi1_mosi(spi1_mosi),
        .spi1_sclk(spi1_sclk),
        .tx_data_0_n(tx_data_0_n),
        .tx_data_0_p(tx_data_0_p),
        .tx_data_1_n(tx_data_1_n),
        .tx_data_1_p(tx_data_1_p),
        .tx_data_2_n(tx_data_2_n),
        .tx_data_2_p(tx_data_2_p),
        .tx_data_3_n(tx_data_3_n),
        .tx_data_3_p(tx_data_3_p),
        .tx_ref_clk_0(tx_ref_clk_0),
        .tx_sync_0(tx_sync_0),
        .tx_sysref_0(tx_sysref_0));
endmodule

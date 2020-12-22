// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri Dec 18 11:12:26 2020
// Host        : MT-202935 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ xvr_refclk_out_stub.v
// Design      : xvr_refclk_out
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "xvr_refclk_out_gtwizard_top,Vivado 2018.3" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(gtwiz_userclk_tx_reset_in, 
  gtwiz_userclk_tx_srcclk_out, gtwiz_userclk_tx_usrclk_out, 
  gtwiz_userclk_tx_usrclk2_out, gtwiz_userclk_tx_active_out, gtwiz_userclk_rx_reset_in, 
  gtwiz_userclk_rx_srcclk_out, gtwiz_userclk_rx_usrclk_out, 
  gtwiz_userclk_rx_usrclk2_out, gtwiz_userclk_rx_active_out, 
  gtwiz_reset_clk_freerun_in, gtwiz_reset_all_in, gtwiz_reset_tx_pll_and_datapath_in, 
  gtwiz_reset_tx_datapath_in, gtwiz_reset_rx_pll_and_datapath_in, 
  gtwiz_reset_rx_datapath_in, gtwiz_reset_rx_cdr_stable_out, gtwiz_reset_tx_done_out, 
  gtwiz_reset_rx_done_out, gtwiz_userdata_tx_in, gtwiz_userdata_rx_out, drpaddr_in, 
  drpclk_in, drpdi_in, drpen_in, drpwe_in, gthrxn_in, gthrxp_in, gtrefclk0_in, rxcdrhold_in, 
  rxcdrovrden_in, drpdo_out, drprdy_out, gthtxn_out, gthtxp_out, gtpowergood_out, 
  rxpmaresetdone_out, rxprgdivresetdone_out, rxrecclkout_out, txpmaresetdone_out, 
  txprgdivresetdone_out)
/* synthesis syn_black_box black_box_pad_pin="gtwiz_userclk_tx_reset_in[0:0],gtwiz_userclk_tx_srcclk_out[0:0],gtwiz_userclk_tx_usrclk_out[0:0],gtwiz_userclk_tx_usrclk2_out[0:0],gtwiz_userclk_tx_active_out[0:0],gtwiz_userclk_rx_reset_in[0:0],gtwiz_userclk_rx_srcclk_out[0:0],gtwiz_userclk_rx_usrclk_out[0:0],gtwiz_userclk_rx_usrclk2_out[0:0],gtwiz_userclk_rx_active_out[0:0],gtwiz_reset_clk_freerun_in[0:0],gtwiz_reset_all_in[0:0],gtwiz_reset_tx_pll_and_datapath_in[0:0],gtwiz_reset_tx_datapath_in[0:0],gtwiz_reset_rx_pll_and_datapath_in[0:0],gtwiz_reset_rx_datapath_in[0:0],gtwiz_reset_rx_cdr_stable_out[0:0],gtwiz_reset_tx_done_out[0:0],gtwiz_reset_rx_done_out[0:0],gtwiz_userdata_tx_in[19:0],gtwiz_userdata_rx_out[19:0],drpaddr_in[9:0],drpclk_in[0:0],drpdi_in[15:0],drpen_in[0:0],drpwe_in[0:0],gthrxn_in[0:0],gthrxp_in[0:0],gtrefclk0_in[0:0],rxcdrhold_in[0:0],rxcdrovrden_in[0:0],drpdo_out[15:0],drprdy_out[0:0],gthtxn_out[0:0],gthtxp_out[0:0],gtpowergood_out[0:0],rxpmaresetdone_out[0:0],rxprgdivresetdone_out[0:0],rxrecclkout_out[0:0],txpmaresetdone_out[0:0],txprgdivresetdone_out[0:0]" */;
  input [0:0]gtwiz_userclk_tx_reset_in;
  output [0:0]gtwiz_userclk_tx_srcclk_out;
  output [0:0]gtwiz_userclk_tx_usrclk_out;
  output [0:0]gtwiz_userclk_tx_usrclk2_out;
  output [0:0]gtwiz_userclk_tx_active_out;
  input [0:0]gtwiz_userclk_rx_reset_in;
  output [0:0]gtwiz_userclk_rx_srcclk_out;
  output [0:0]gtwiz_userclk_rx_usrclk_out;
  output [0:0]gtwiz_userclk_rx_usrclk2_out;
  output [0:0]gtwiz_userclk_rx_active_out;
  input [0:0]gtwiz_reset_clk_freerun_in;
  input [0:0]gtwiz_reset_all_in;
  input [0:0]gtwiz_reset_tx_pll_and_datapath_in;
  input [0:0]gtwiz_reset_tx_datapath_in;
  input [0:0]gtwiz_reset_rx_pll_and_datapath_in;
  input [0:0]gtwiz_reset_rx_datapath_in;
  output [0:0]gtwiz_reset_rx_cdr_stable_out;
  output [0:0]gtwiz_reset_tx_done_out;
  output [0:0]gtwiz_reset_rx_done_out;
  input [19:0]gtwiz_userdata_tx_in;
  output [19:0]gtwiz_userdata_rx_out;
  input [9:0]drpaddr_in;
  input [0:0]drpclk_in;
  input [15:0]drpdi_in;
  input [0:0]drpen_in;
  input [0:0]drpwe_in;
  input [0:0]gthrxn_in;
  input [0:0]gthrxp_in;
  input [0:0]gtrefclk0_in;
  input [0:0]rxcdrhold_in;
  input [0:0]rxcdrovrden_in;
  output [15:0]drpdo_out;
  output [0:0]drprdy_out;
  output [0:0]gthtxn_out;
  output [0:0]gthtxp_out;
  output [0:0]gtpowergood_out;
  output [0:0]rxpmaresetdone_out;
  output [0:0]rxprgdivresetdone_out;
  output [0:0]rxrecclkout_out;
  output [0:0]txpmaresetdone_out;
  output [0:0]txprgdivresetdone_out;
endmodule

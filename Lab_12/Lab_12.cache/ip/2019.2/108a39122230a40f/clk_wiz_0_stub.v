// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun May  3 13:43:57 2020
// Host        : DESKTOP-EAA4J5I running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk_25, clk_50, clk_75, clk_100, clk_200, resetn, 
  locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_25,clk_50,clk_75,clk_100,clk_200,resetn,locked,clk_in1" */;
  output clk_25;
  output clk_50;
  output clk_75;
  output clk_100;
  output clk_200;
  input resetn;
  output locked;
  input clk_in1;
endmodule

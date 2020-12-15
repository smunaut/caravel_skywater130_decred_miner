`timescale 1ns / 1ps

`include "decred_defines.v"

module decred_top (
`ifdef USE_POWER_PINS
  inout vdda1,	// User area 1 3.3V supply
  inout vdda2,	// User area 2 3.3V supply
  inout vssa1,	// User area 1 analog ground
  inout vssa2,	// User area 2 analog ground
  inout vccd1,	// User area 1 1.8V supply
  inout vccd2,	// User area 2 1.8v supply
  inout vssd1,	// User area 1 digital ground
  inout vssd2,	// User area 2 digital ground
`endif
  input  wire  EXT_RESET_N_fromHost,
  input  wire  SCLK_fromHost,
  input  wire  M1_CLK_IN,
  input  wire  M1_CLK_SELECT,
  input  wire  PLL_INPUT,
  input  wire  S1_CLK_IN,
  input  wire  S1_CLK_SELECT,
  input  wire  SPI_CLK_RESET_N,
  input  wire  SCSN_fromHost,
  input  wire  MOSI_fromHost,
  input  wire  MISO_fromClient,
  input  wire  IRQ_OUT_fromClient,
  input  wire  ID_fromClient,

  output wire  SCSN_toClient,
  output wire  SCLK_toClient,
  output wire  MOSI_toClient,
  output wire  EXT_RESET_N_toClient,
  output wire  ID_toHost,

  output wire  CLK_LED,
  output wire  MISO_toHost,
  output wire  HASH_LED,
  output wire  IRQ_OUT_toHost
  );

  wire                             m1_clk_local;
  wire                             HASH_EN;
  wire [`NUMBER_OF_MACROS - 1: 0]  MACRO_WR_SELECT;
  wire [7: 0]                      DATA_TO_HASH;
  wire [`NUMBER_OF_MACROS - 1: 0]  MACRO_RD_SELECT;
  wire [5: 0]                      HASH_ADDR;
  wire [`NUMBER_OF_MACROS - 1: 0]  DATA_AVAILABLE;
  wire [7: 0]                      DATA_FROM_HASH;

  decred_controller decred_controller_block (

    .EXT_RESET_N_fromHost(EXT_RESET_N_fromHost),
    .SCLK_fromHost(SCLK_fromHost),
    .M1_CLK_IN(M1_CLK_IN),
    .M1_CLK_SELECT(M1_CLK_SELECT),
    .m1_clk_local(m1_clk_local),
    .PLL_INPUT(PLL_INPUT),
    .S1_CLK_IN(S1_CLK_IN),
    .S1_CLK_SELECT(S1_CLK_SELECT),
    .SPI_CLK_RESET_N(SPI_CLK_RESET_N),
    .SCSN_fromHost(SCSN_fromHost),
    .MOSI_fromHost(MOSI_fromHost),
    .MISO_fromClient(MISO_fromClient),
    .IRQ_OUT_fromClient(IRQ_OUT_fromClient),
    .ID_fromClient(ID_fromClient),

    .SCSN_toClient(SCSN_toClient),
    .SCLK_toClient(SCLK_toClient),
    .MOSI_toClient(MOSI_toClient),
    .EXT_RESET_N_toClient(EXT_RESET_N_toClient),
    .ID_toHost(ID_toHost),

    .CLK_LED(CLK_LED),
    .MISO_toHost(MISO_toHost),
    .HASH_LED(HASH_LED),
    .IRQ_OUT_toHost(IRQ_OUT_toHost),

    // hash macro exports
    .HASH_EN(HASH_EN),
    .MACRO_WR_SELECT(MACRO_WR_SELECT),
    .DATA_TO_HASH(DATA_TO_HASH),
    .MACRO_RD_SELECT(MACRO_RD_SELECT),
    .HASH_ADDR(HASH_ADDR),
    .DATA_AVAILABLE(DATA_AVAILABLE),
    .DATA_FROM_HASH(DATA_FROM_HASH)
  );

  genvar i;
  for (i = 0; i < `NUMBER_OF_MACROS; i = i + 1) begin: hash_macro_multi_block
    decred_hash_macro decred_hash_block (
					  
      .CLK(m1_clk_local), 
      .HASH_EN(HASH_EN), 
      .MACRO_WR_SELECT(MACRO_WR_SELECT[i]),
      .DATA_TO_HASH(DATA_TO_HASH),
      .MACRO_RD_SELECT(MACRO_RD_SELECT[i]),
      .HASH_ADDR(HASH_ADDR),
      .DATA_AVAILABLE(DATA_AVAILABLE[i]),
      .DATA_FROM_HASH(DATA_FROM_HASH)
  );
  end

endmodule // decred_top

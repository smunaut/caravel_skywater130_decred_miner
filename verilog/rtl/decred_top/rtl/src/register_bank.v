// Copyright 2020 Matt Aamold, James Aamold
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Language: Verilog 2001

`timescale 1ns / 1ps
`include "decred_defines.v"

module regBank #(
  parameter DATA_WIDTH=8,
  parameter ADDR_WIDTH=8
)(
  input  wire                  SPI_CLK,
  input  wire                  RST,
  input  wire						       M1_CLK,
  input  wire [ADDR_WIDTH-1:0] address,
  input  wire [DATA_WIDTH-1:0] data_in,
  input  wire                  read_strobe,
  input  wire                  write_strobe,
  output reg [DATA_WIDTH-1:0]  data_out,

  output wire						       hash_clock_reset,
  output wire                  LED_out,
  output wire	[6:0]				     spi_addr,
  output wire						       ID_out,
  output wire                  interrupt_out
  );

  localparam REGISTERS = 6;

  // //////////////////////////////////////////////////////
  // reg array

  reg  [DATA_WIDTH-1:0] registers [REGISTERS-1:0];

  reg  [7: 0] macro_data_read_rs[1:0];
  wire [3 :0] threadCount [`NUMBER_OF_MACROS-1:0];

  reg [31:0] perf_counter;
  always @(posedge M1_CLK)
    if (registers[3][2] == 1'b1) 
	    perf_counter <= perf_counter + 1'b1;

  always @(posedge SPI_CLK) begin : REG_WRITE_BLOCK
    integer i;
    if(RST) begin 
      for (i = 0; i < REGISTERS; i = i + 1) begin
        registers[i] <= 0;
      end
    end
    else begin
      if (write_strobe) begin
        registers[address] <= data_in;
      end
    end
  end

  always @(posedge SPI_CLK) begin
    if (read_strobe) begin
		if (address[7:0] == 8'h02) begin
			// interrupt active register
			data_out <= macro_rs[1];
		end else
		  if (address[7:0] == 8'h05) begin
			// ID register
			data_out <= 8'h11;
		end else
		  if (address[7:0] == 8'h06) begin
			// MACRO_INFO register
			data_out <= ((`NUMBER_OF_MACROS << 4) | (threadCount[0]));
		end else
		  if (address[7:0] == 8'h07) begin
			data_out <= perf_counter[7:0];
		end else
		  if (address[7:0] == 8'h08) begin
			data_out <= perf_counter[15:8];
		end else
		  if (address[7:0] == 8'h09) begin
			data_out <= perf_counter[23:16];
		end else
		  if (address[7:0] == 8'h0A) begin
			data_out <= perf_counter[31:24];
		end else
      if (address[7] == 0) begin
        data_out <= registers[address[6:0]];
      end
	   else begin
			data_out <= macro_data_read_rs[1];
	    end
    end
  end

  //  WRITE REGS
  // MACRO_ADDR  =  0     : 0x00
  // MACRO_DATA  =  1     : 0x01 (write only)
  // MACRO_SELECT=  2     : 0x02 (int status on readback)
  // CONTROL     =  3     : 0x03
  //   CONTROL.0 = HASHCTRL
  //   CONTROL.1 = <available>
  //   CONTROL.2 = PERF_COUNTER run
  //   CONTROL.3 = LED output
  //   CONTROL.4 = hash_clock_reset
  //   CONTROL.5 = ID_out
  // SPI_ADDR    =  4     : 0x04
  //   SPI_ADDR.x= Address on SPI bus (6:0)
  // ID REG      =  5     : 0x05 (read-only)
  // MACRO_WR_EN =  5     : macro write enable
  // MACRO_INFO  =  6     : 0x06 macro count (read-only)
  // PERF_CTR    = 10-7   : 0x0A - 0x07 (read-only)

  assign spi_addr = registers[4][6:0];

  assign LED_out = registers[3][3];
  assign ID_out = registers[3][5];

  assign hash_clock_reset = registers[3][4];

  // //////////////////////////////////////////////////////
  // resync - signals to hash_macro 

  reg [1:0] hash_en_rs;
  wire      HASH_start;

  always @ (posedge M1_CLK)
  begin
    hash_en_rs <= {hash_en_rs[0], registers[3][0]};
  end
  assign HASH_start = hash_en_rs[1];

  reg		[`NUMBER_OF_MACROS - 1: 0]	wr_select_rs[1:0];
  always @ (posedge M1_CLK)
  begin
    wr_select_rs[1] <= wr_select_rs[0];
    wr_select_rs[0] <= registers[5][`NUMBER_OF_MACROS - 1: 0];
  end

  reg		[7: 0]	macro_data_write_rs[1:0];
  always @ (posedge M1_CLK)
  begin
    macro_data_write_rs[1] <= macro_data_write_rs[0];
    macro_data_write_rs[0] <= registers[1];
  end

  reg		[`NUMBER_OF_MACROS - 1: 0]	rd_select_rs[1:0];
  always @ (posedge M1_CLK)
  begin
    rd_select_rs[1] <= rd_select_rs[0];
    rd_select_rs[0] <= registers[2][`NUMBER_OF_MACROS - 1: 0];
  end

  reg		[5: 0]	macro_addr_rs[1:0];
  always @ (posedge M1_CLK)
  begin
    macro_addr_rs[1] <= macro_addr_rs[0];
    macro_addr_rs[0] <= registers[0][5:0];
  end

  // //////////////////////////////////////////////////////
  // resync - signals from hash_macro 

  wire	[`NUMBER_OF_MACROS - 1: 0]	macro_interrupts;
  reg		[`NUMBER_OF_MACROS - 1: 0]	macro_rs[1:0];

  always @(posedge SPI_CLK) begin
    macro_rs[1] <= macro_rs[0];
    macro_rs[0] <= macro_interrupts;
  end

  assign interrupt_out = |macro_rs[1];

  wire [7: 0] macro_data_readback;

  always @(posedge SPI_CLK) begin
    macro_data_read_rs[1] <= macro_data_read_rs[0];
    macro_data_read_rs[0] <= macro_data_readback;
  end

  // //////////////////////////////////////////////////////
  // hash macro interface

  genvar i;
  for (i = 0; i < `NUMBER_OF_MACROS; i = i + 1) begin: hash_macro_multi_block
`ifdef USE_NONBLOCKING_HASH_MACRO
    blake256r14_core_nonblock hash_macro (
`else
    blake256r14_core_block hash_macro (
`endif
					  
						.CLK(M1_CLK), 
						.HASH_EN(HASH_start), 

						.MACRO_WR_SELECT(wr_select_rs[1][i]),
						.DATA_IN(macro_data_write_rs[1]),

						.MACRO_RD_SELECT(rd_select_rs[1][i]),
						.ADDR_IN(macro_addr_rs[1]),

						.THREAD_COUNT(threadCount[i]), // one is used == [0]

						.DATA_AVAILABLE(macro_interrupts[i]),
						.DATA_OUT(macro_data_readback)
					  );
  end

endmodule // regBank


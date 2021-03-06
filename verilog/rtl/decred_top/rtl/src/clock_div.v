`timescale 1ns / 1ps

module clock_div (
  input  wire  iCLK,
  input  wire  RSTn,

  output reg   clk_out
  );

  // this is really x2: period. CLOCK_DIVISOR = 2 means divide by 4
  localparam CLOCK_DIVISOR = 4; // match the next size with divisor = LOG2(divisor)
  reg [3:0] counter;

  always @(posedge iCLK)
    if (!RSTn)
      counter <= 0;
    else if (counter == CLOCK_DIVISOR - 1) 
      counter <= 0;
    else
      counter <= counter + 1;

  always @(posedge iCLK)
    if (!RSTn)
      clk_out <= 0;
    else if (counter == CLOCK_DIVISOR - 1) 
      clk_out <= ~clk_out;
    else
      clk_out <= clk_out;

endmodule // clock_div

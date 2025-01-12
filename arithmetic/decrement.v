`timescale 1ps/1ps
`include "subtractor.v"

module decrement8b(output wire[7:0] result, input wire[7:0] num1);
  wire cout;
  full_subtractor8b FULL_SUBTRACTOR8bDEC(.csub(result), .c_outc(cout), .numf1(num1), .numf2(8'b00000001));
endmodule
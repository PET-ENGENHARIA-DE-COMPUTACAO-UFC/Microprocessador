`timescale 1ps/1ps
`include "adder.v"

module increment8b(output wire[7:0] result, input wire[7:0] num1);
  wire cout;
  full_adder8b FULL_ADDER8bINC(.csum(result), .c_outc(cout), .numf1(num1), .numf2(8'b00000001));
endmodule
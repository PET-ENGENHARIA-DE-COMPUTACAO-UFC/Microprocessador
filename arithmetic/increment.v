`timescale 1ps/1ps
//`include "arithmetic/adder.v"

module increment8b(output wire[7:0] result, output wire cout, input wire[7:0] num1);
  full_adder8b FULL_ADDER8bINC(.csum(result), .c_outc(cout), .numf1(num1), .numf2(8'b00000001));
endmodule
`timescale 1ps/1ps

module half_adder(output wire c_out, sum, input wire num1, num2);
  xor(sum, num1, num2);
  and(c_out, num1, num2);
endmodule

module full_adder(output wire csum, c_outc, input wire numf1, numf2, c_in);
  wire aux_out, aux_sum, aux_out2;
  half_adder HALF_ADDER1(.num1(numf1), .num2(numf2), .c_out(aux_out), .sum(aux_sum));
  half_adder HALF_ADDER2(.num1(c_in), .num2(aux_sum), .sum(csum), .c_out(aux_out2));
  or(c_outc, aux_out2, aux_out);
endmodule

module full_adder4b(output wire[3:0] csum, output wire c_outc, input wire[3:0] numf1, numf2, input wire c_in);
  wire cin1, cin2, cin3;
  full_adder FULL_ADDER1(.numf1(numf1[0]), .numf2(numf2[0]), .c_in(c_in), .csum(csum[0]), .c_outc(cin1));
  full_adder FULL_ADDER2(.numf1(numf1[1]), .numf2(numf2[1]), .c_in(cin1), .csum(csum[1]), .c_outc(cin2));
  full_adder FULL_ADDER3(.numf1(numf1[2]), .numf2(numf2[2]), .c_in(cin2), .csum(csum[2]), .c_outc(cin3));
  full_adder FULL_ADDER4(.numf1(numf1[3]), .numf2(numf2[3]), .c_in(cin3), .csum(csum[3]), .c_outc(c_outc));
endmodule

module full_adder8b(output wire[7:0] csum, output wire c_outc, input wire[7:0] numf1, numf2);
  wire cin1;
  full_adder4b FULL_ADDER4b1(.numf1(numf1[3:0]), .numf2(numf2[3:0]), .c_in(1'b0), .csum(csum[3:0]), .c_outc(cin1));
  full_adder4b FULL_ADDER4b2(.numf1(numf1[7:4]), .numf2(numf2[7:4]), .c_in(cin1), .csum(csum[7:4]), .c_outc(c_outc));
endmodule

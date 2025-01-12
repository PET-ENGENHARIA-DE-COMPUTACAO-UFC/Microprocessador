`timescale 1ps/1ps

module half_subtractor(output wire c_out, sub, input wire num1, num2);
  assign sub = num1 ^ num2;
  assign c_out = ~num1 & num2;
endmodule

module full_subtractor(output wire c_outc, csub, input wire numf1, numf2, c_in);
  wire aux_out, aux_out2, aux_sub;
  half_subtractor HALF_SUBTRACTOR1(.c_out(aux_out), .sub(aux_sub), .num1(numf1), .num2(numf2));
  half_subtractor HALF_SUBTRACTOR2(.c_out(aux_out2), .sub(csub), .num1(aux_sub), .num2(c_in));
  or(c_outc, aux_out2, aux_out);
endmodule

module full_subtractor4b(output wire[3:0] csub, output wire c_outc, input wire[3:0] numf1, numf2, input wire c_in);
  wire cin1, cin2, cin3;
  full_subtractor FULL_SUBTRACTOR1(.numf1(numf1[0]), .numf2(numf2[0]), .c_in(c_in), .csub(csub[0]), .c_outc(cin1));
  full_subtractor FULL_SUBTRACTOR2(.numf1(numf1[1]), .numf2(numf2[1]), .c_in(cin1), .csub(csub[1]), .c_outc(cin2));
  full_subtractor FULL_SUBTRACTOR3(.numf1(numf1[2]), .numf2(numf2[2]), .c_in(cin2), .csub(csub[2]), .c_outc(cin3));
  full_subtractor FULL_SUBTRACTOR4(.numf1(numf1[3]), .numf2(numf2[3]), .c_in(cin3), .csub(csub[3]), .c_outc(c_outc));
endmodule

module full_subtractor8b(output wire[7:0] csub, output wire c_outc, input wire[7:0] numf1, numf2);
  wire cin1;
  full_subtractor4b FULL_SUBTRACTOR4b1(.numf1(numf1[3:0]), .numf2(numf2[3:0]), .c_in(1'b0), .csub(csub[3:0]), .c_outc(cin1));
  full_subtractor4b FULL_SUBTRACTOR4b2(.numf1(numf1[7:4]), .numf2(numf2[7:4]), .c_in(cin1), .csub(csub[7:4]), .c_outc(c_outc));
endmodule
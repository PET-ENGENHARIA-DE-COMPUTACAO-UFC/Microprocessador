module shift_right8b(input[7:0]a, input[2:0]shamt, output[7:0]y);
assign y = a >>> 1'b1;
endmodule
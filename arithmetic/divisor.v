`timescale 1ps/1ps

module divisor8b(output reg[7:0] result, rest, input wire[7:0] num1, num2);
  reg[7:0] accumulator;
  reg[7:0] quocient;
  reg[7:0] divided;
  integer i;
  always @(*) begin
    accumulator = 8'b0;
    quocient = 8'b0;
    divided = num1;
    
    for (i = 0; i < 8; i++) begin
      accumulator = accumulator << 1;
      accumulator[0] = divided[7];
      divided = divided << 1;
      quocient = quocient << 1;
      
      if (accumulator >= num2) begin
        quocient[0] = 1'b1;
        accumulator = accumulator - num2;
      end   
    end
    result = quocient;
    rest = accumulator;
  end
endmodule
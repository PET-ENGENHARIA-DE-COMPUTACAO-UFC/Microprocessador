`timescale 1ps/1ps

module module8b(output reg[7:0] rest, input wire[7:0] num1, num2);
  reg[7:0] accumulator;
  reg[7:0] divided;
  integer i;
  always @(*) begin
    accumulator = 8'b0;
    divided = num1;
    
    for (i = 0; i < 8; i++) begin
      accumulator = accumulator << 1;
      accumulator[0] = divided[7];
      divided = divided << 1;
      
      if (accumulator >= num2) begin
        accumulator = accumulator - num2;
      end   
    end
    rest = accumulator;
  end
endmodule
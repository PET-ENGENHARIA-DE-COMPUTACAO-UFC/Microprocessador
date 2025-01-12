`timescale 1ps/1ps

module multiplier8b(output reg [7:0] result, input wire [7:0] num1, num2);
  reg [15:0] accumulator;
  integer i;

  always @(*) begin
    accumulator = 16'b0;
    for (i = 0; i < 8; i++) begin
      if (num2[i]) begin
        accumulator = accumulator + (num1 << i); 
      end
    end
    result = accumulator[7:0];
  end
endmodule
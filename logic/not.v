`timescale 1ps/1ps

module not8b(output reg[7:0] result, input wire[7:0] num1);
  integer i;
  reg[7:0] resultado;
  always @(*) begin
    resultado = 8'b0;
    for (i = 0; i < 8; i++) begin
      resultado[i] = !num1[i];
    end
    result = resultado;
  end
endmodule
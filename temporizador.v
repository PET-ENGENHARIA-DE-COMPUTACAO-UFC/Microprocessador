module timer(
  input wire clk_in,        // Clock de entrada
  input wire rst,           // Reset
  output reg clk_out        // Clock de saída
);

  parameter DIVISOR = 1000000; // Fator de divisão para o clock (ajustável)
  
  reg [31:0] counter = 0;      // Contador de 32 bits

  always @(posedge clk_in or posedge rst) begin
    if (rst) begin
      counter <= 0;
      clk_out <= 0;
    end else begin
      if (counter == DIVISOR/2 - 1) begin
        clk_out <= ~clk_out; // Alterna o clock de saída
        counter <= 0;        // Reseta o contador
      end else begin
        counter <= counter + 1;
      end
    end
  end

endmodule
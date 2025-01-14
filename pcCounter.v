module pcCounter(
  input wire clk,
  output reg[4:0] PC);
  
  //memoria falsa apenas para testes:
  reg[7:0] memoria[31:0];
  
  
  initial begin
    PC <= 5'b00000; //depende do numero de endereços da memoria
  end
  always @(posedge clk) begin
    PC <= PC + 5'b00001;
  end
endmodule
    
  
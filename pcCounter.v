module pcCounter(
  input wire clk,
  output reg[7:0] PC);
  
  initial begin
    PC <= 5'b00000; //depende do numero de endereços da memoria
  end
  always @(posedge clk) begin
    PC <= PC + 5'b00001;
  end
endmodule
    
  
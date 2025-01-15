module pcCounter(
  input wire clk,
  input wire rst,
  output reg[7:0] PC);
  
  always @(posedge clk) begin
    if(rst)
    PC <= 5'b00000;
    else
    PC <= PC + 5'b00001;
  end
endmodule
    
  
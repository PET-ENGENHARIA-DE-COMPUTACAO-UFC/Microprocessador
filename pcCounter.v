module pcCounter(
<<<<<<< HEAD
  input wire clk,
  output reg[7:0] PC);
  
  initial begin
    PC <= 5'b00000; //depende do numero de endereços da memoria
  end
  always @(posedge clk) begin
    PC <= PC + 5'b00001;
=======
  input wire PC_load,
  input wire PC_inc,
  output reg[7:0] PC);
  
  always @(*) begin
    if(PC_inc)begin
    PC <= PC + 1'b1;
    end
    else begin
    PC <= PC_load;
    end


>>>>>>> fb3cf58715ee8ba137720c29729b04d67b3c8cae
  end
endmodule
    
  
module pcCounter(
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


  end
endmodule
    
  
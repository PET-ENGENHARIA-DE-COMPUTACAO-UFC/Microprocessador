module pcCounter(
  input wire clk,                
  input wire [7:0] PC_load,
  input wire PC_inc,
  input wire PC_en, 
  output reg [7:0] PC
);
/*initial begin
PC <= 8'b0;
end */
  always @(posedge clk) begin
    if (PC_en) begin
      if (PC_inc) 
        PC <= PC + 8'b00000001;        
      else 
        PC <= PC_load;           
    end
  end

endmodule

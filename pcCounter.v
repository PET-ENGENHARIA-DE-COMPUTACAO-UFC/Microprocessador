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
        PC <= PC_load;           
    end
    if (PC_inc) begin
        PC <= PC + 8'b00000001;        
    end
  end

endmodule

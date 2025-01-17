module RegisterFile(input wire clk,
                    input wire [7:0] A1,
                    input wire [7:0] A2,
                    input wire [7:0] A3,
                    input wire [7:0] WriteData, //pode vir da alu
					input wire regWriteEnable, //enable para escrever no reg
          input wire regReadEnable, //enable para escrever no reg
                    output reg [7:0] RD1,	//dados de saida
                    output reg [7:0] RD2);	//dados de saida
  
  //extensão da memoria apenas para registradores
  reg[7:0] registers [31:0];
  
  
  
  always @(posedge clk) begin
    if(regWriteEnable) begin
      registers[A3[5:0]] <= WriteData;
    end
  end

always@(*) begin
if(regReadEnable) begin
  RD1 <= registers[A1[5:0]];
  RD2 <= registers[A2[5:0]];
end
else begin
  RD1 <= 8'b0;
  RD2 <= 8'b0;
end
end
endmodule
`timescale 1ns/1ps
module RegisterFile(input wire clk,
                    input wire [7:0] A1,
                    input wire [7:0] A2,
                    input wire [7:0] A3,
                    input wire [7:0] WriteData, //pode vir da alu
                    input wire [6:0] Flag_input,
					input wire regWriteEnable, //enable para escrever no reg
          input wire regReadEnable, //enable para escrever no reg
                    output reg [7:0] RD1,	//dados de saida
                    output reg [7:0] RD2);	//dados de saida
  
  //extensão da memoria apenas para registradores
  reg[7:0] registers [31:0];
  
  
  
  always @(posedge clk) #9
  begin
    if(regWriteEnable) begin
      registers[A3[4:0]] <= WriteData;
      registers[00011] <= Flag_input;
    end
  end

always@(*) #9
begin
if(regReadEnable) begin
  RD1 <= registers[A1[4:0]];
  RD2 <= registers[A2[4:0]];
end
else begin
  RD1 <= 8'b0;
  RD2 <= 8'b0;
end 
end


endmodule
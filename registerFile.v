module RegisterFile(input wire clk,
                    input wire [7:0] A1,
                    input wire [7:0] A2,
                    input wire [7:0] A3,
                    input wire [7:0] WriteData, //pode vir da alu
					input wire regWriteEnable, //enable para escrever no reg
                    output wire [7:0] RD1,	//dados de saida
                    output wire [7:0] RD2);	//dados de saida
  
  //extensão da memoria apenas para registradores
  reg[7:0] registers [31:0];
  
  
  //recebe 8 bits -> pega os 5 ultimos
  
  assign RD1 = registers[A1[5:0]];
  assign RD2 = registers[A2[5:0]];
  
  always @(posedge clk) begin
    if(regWriteEnable) begin
      registers[A3[5:0]] <= WriteData;
    end
  end
endmodule
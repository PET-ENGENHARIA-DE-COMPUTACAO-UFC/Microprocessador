module RegisterFile(input wire clk,
                    input wire [4:0] A1,
                    input wire [4:0] A2,
                    input wire [4:0] A3,
                    input wire [7:0] WriteData, //pode vir da alu
					input wire regWriteEnable, //enable para escrever no reg
                    output wire [7:0] RD1,	//dados de saida
                    output wire [7:0] RD2);	//dados de saida
  
  //extensão da memoria apenas para registradores
  reg[7:0] registers [31:0];
  
  assign RD1 = registers[A1];
  assign RD2 = registers[A2];
  
  always @(posedge clk) begin
    if(regWriteEnable) begin
      registers[A3] <= WriteData;
    end
  end
endmodule
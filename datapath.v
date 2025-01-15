`include "pcCounter.sv"
`include "instructionRegister.sv"
module DataPath(input wire clk,
                input wire [7:0] opcode, operando1, operando2
                ,output reg[7:0] pc,
                output reg[23:0] instReg
               );

    
    //Código da RAM -> Feito
    

  pcCounter pcCounter(
    .clk(clk),
    .PC(pc) // saida que contêm os endereços
  );
    

    
    //Código do MAR -> Mateus
    

    
    //Código do Instruction Register -> Lobo:
  
  InstructionRegister insRegister(
    .opcode(opcode),
    .operando1(operando1),
    .operando2(operando2),
    .instReg(instReg)
  );
  

    
    //Código do Control Unit -> Amorim
   

    
    //Código do Register File -> Feito
   

   
    //ALU -> Feito


endmodule
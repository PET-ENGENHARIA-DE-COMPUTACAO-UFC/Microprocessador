module ControlUnit(input wire[23:0] command_word, input wire clk, input wire rst, input wire [1:0]fullRegFlag, output reg[7:0]PC_load, output reg PC_inc, output reg PC_en, output reg MAR_load, output reg IR_load, output reg [7:0]write_data, output reg[7:0]ALU_sel, output reg [7:0]ADR_1, output reg [7:0]ADR_2, output reg [7:0]ADR_3, output reg [7:0]Op1, output reg[7:0]Op2, output reg regWriteEnable, output reg regReadEnable, output reg Path_Type);

//FSM Encoding
localparam FETCH_0 = 0, FETCH_1 = 1, FETCH_2 = 3, DECODE = 4, STR_IMM_0 = 5, STR_DIR_0 = 6, STR_DIR_1 = 7, LOA_IMM_0 = 8, LOA_DIR_0 = 9, LOA_DIR_1 = 10, MOV_0 = 11, MOV_1 = 12, ARITHMETIC_OPERATION_0 = 13, ARITHMETIC_OPERATION_1 = 14, ARITHMETIC_OPERATION_2 = 15, JMP_0 = 16, JMP_1 = 17, CALL_0 = 18, CALL_1 = 19, RET_0 = 20, JC = 21, JZ_1 = 22, JNZ_1 = 23, JG_1 = 24, JL_1 = 25, JC_2 = 26;

//OPCODE Encoding
localparam 
STR_IMM = 8'b00000001,
STR_DIR = 8'b00000010,
LOA_IMM = 8'b00011000,
LOA_DIR = 8'b00011001,
MOV = 8'b00011010,
ADD = 8'b00000011,
SUB = 8'b00000100,
MULT = 8'b00000101,
DIV = 8'b00000110,
INC = 8'b00010000,
DEC = 8'b00010010,
MOD = 8'b00000111,
SL = 8'b00010100,
SR = 8'b00010101,
L_AND = 8'b00001000,
L_NAND = 8'b00001110,
L_NOR = 8'b00001101,
L_NOT = 8'b00001010,
L_OR = 8'b00001001,
L_XNOR = 8'b00001111,
L_XOR = 8'b00010001,
L_ROL = 8'b00010110,
L_ROR = 8'b00010111,
CMP = 8'b00011000,
JMP = 8'b00011001,
CALL = 8'b00011010,
RET = 8'b00011011,
JZ = 8'b00011100,
JNZ = 8'b00011101,
JG = 8'b00011110,
JL = 8'b00011111;

//Path encoding
localparam alu_path = 0, memory_path = 1;

//Register Encoding
localparam REG_C = 8'b00000010;

//Registradores de estado
reg[7:0] current_state, next_state; 

//Registradores de informações temporárias
reg[7:0] temporary_info_reg;

//Registrador de valores do PC
reg[7:0] pc_value_reg;

always@(posedge clk)begin
  if(rst)begin
  current_state <= FETCH_0;
  end
  else begin
  current_state <= next_state;
  end
end

always@(posedge clk)begin
case(current_state) 
    FETCH_0 : next_state = FETCH_1;
    FETCH_1 : next_state = FETCH_2;
    FETCH_2 : next_state = DECODE;

    DECODE: 
            if(command_word[23:16] == STR_IMM) begin
              next_state = STR_IMM_0;
              Path_Type = memory_path;
            end

            else if(command_word[23:16] == STR_DIR)   begin
              next_state = STR_DIR_0;
              Path_Type = memory_path;
            end

            else if(command_word[23:16] == LOA_IMM)   begin
              next_state = LOA_IMM_0;
              Path_Type = memory_path;
            end

            else if(command_word[23:16] == LOA_DIR)   begin
              next_state = LOA_DIR_0;
              Path_Type = memory_path;
            end

            else if(command_word[23:16] == MOV)   begin
            next_state = MOV_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == ADD)   begin
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == SUB)   begin
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == MULT)   begin
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == DIV)  begin
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == MOD)   begin
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == L_AND)   begin
              next_state = ARITHMETIC_OPERATION_0;
              Path_Type = alu_path;
            end

            else if(command_word[23:16] == L_OR)   begin
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end
            
            else if(command_word[23:16] == L_NOT)   begin
              next_state = ARITHMETIC_OPERATION_0;
              Path_Type = alu_path;
            end

            else if(command_word[23:16] == L_XOR)  begin
               next_state = ARITHMETIC_OPERATION_0;
               Path_Type = alu_path;
            end

            else if(command_word[23:16] == L_NAND)   begin
              next_state = ARITHMETIC_OPERATION_0;
              Path_Type = alu_path;
            end

            else if(command_word[23:16] == L_XNOR)   begin
              next_state = ARITHMETIC_OPERATION_0;
              Path_Type = alu_path;
            end

            else if(command_word[23:16] == INC)  begin 
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == DEC)   begin
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == SL)  begin 
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == SR)   begin
            next_state = ARITHMETIC_OPERATION_0;
            Path_Type = alu_path;
            end

            else if(command_word[23:16] == L_ROL)  begin
              next_state = ARITHMETIC_OPERATION_0;
              Path_Type = alu_path;
            end

            else if(command_word[23:16] == L_ROR)   begin
              next_state = ARITHMETIC_OPERATION_0;
              Path_Type = alu_path;
            end
            else if(command_word[23:16] == JMP)   begin
              next_state = JMP_0;
              Path_Type = alu_path;
            end
            else if(command_word[23:16] == CALL)  begin
               next_state = CALL_0;
               Path_Type = memory_path;
            end
            else if(command_word[23:16] == RET)   begin
              next_state = RET_0;
              Path_Type = memory_path;
            end
            else if(command_word[23:16] == JZ || command_word[23:16] == JNZ || command_word[23:16] == JG || command_word[23:16] == JL)   begin next_state = JC;
              Path_Type = memory_path;
            end

    STR_IMM_0: next_state <= FETCH_0;
    LOA_IMM_0: next_state <= FETCH_0;

    STR_DIR_0: next_state <= STR_DIR_1;
    STR_DIR_1: next_state <= FETCH_0;

    LOA_DIR_0: next_state <= LOA_DIR_1;
    LOA_DIR_1: next_state <= FETCH_0;

    MOV_0: next_state <= MOV_1;

    ARITHMETIC_OPERATION_0: next_state <= ARITHMETIC_OPERATION_1;

    ARITHMETIC_OPERATION_1: next_state <= ARITHMETIC_OPERATION_2;

    ARITHMETIC_OPERATION_2: next_state <= FETCH_0;

    JMP_0: next_state <= JMP_1;
    JMP_1: next_state <= FETCH_0;

    CALL_0: next_state <= CALL_1;
    CALL_1: next_state <= FETCH_0;

endcase

end

always@(current_state) begin
PC_inc = 0;
MAR_load = 1;
IR_load = 0;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
temporary_info_reg = 8'b0;
ALU_sel = 8'b0;
pc_value_reg = 8'b0;

case(current_state) 
FETCH_0: begin //Carrega o valor do pc no MAR
if(rst) begin //Se o reset for acionado o valor do pc pra zero
PC_load = 8'b0;
PC_en = 1;
end

PC_inc = 0;
MAR_load = 1;
IR_load = 0;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
temporary_info_reg = 8'b0;
ALU_sel = 8'b0;
end

FETCH_1: begin //Incrementa o pc
PC_inc = 1;
MAR_load = 0;
IR_load = 0;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

FETCH_2: begin //Carrega o ir com o valor lido pelo mar
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

STR_IMM_0: begin //Guarda o valor do operando num registrador
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = command_word[7:0];
regWriteEnable = 1;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = command_word[15:8];
Op1 = 8'b0;
Op2 = 8'b0;
end

LOA_IMM_0: begin // Carrega um valor da memória num registrador de destino
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = command_word[7:0];
regWriteEnable = 0;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = command_word[15:8];
Op1 = 8'b0;
Op2 = 8'b0;
end

STR_DIR_0: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 1;
//temporary_info_reg = command_word[15:8];
ADR_1 = command_word[7:0];
ADR_2 = 8'b0;
ADR_3 = command_word[15:8];
//Op1 = 8'b0;
//Op2 = 8'b0;
end

STR_DIR_1: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = command_word[23:16];
regWriteEnable = 1;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = temporary_info_reg;
Op1 = 8'b0;
Op2 = 8'b0;
end

LOA_DIR_0: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 1;
temporary_info_reg = command_word[15:8];
ADR_1 = command_word[7:0];
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

LOA_DIR_1: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = temporary_info_reg;
regWriteEnable = 0;
regReadEnable = 1;
ADR_1 = command_word[23:16];
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

MOV_0: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 1;
temporary_info_reg = command_word[15:8];
ADR_1 = command_word[7:0];
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

MOV_1: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = command_word[23:16];
regWriteEnable = 1;
regReadEnable = 0;
ADR_1 = temporary_info_reg;
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

ARITHMETIC_OPERATION_0: begin //Lendo o endereço
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 1;
temporary_info_reg = command_word[23:16];
ADR_1 = command_word[15:8];               
ADR_2 = command_word[7:0];
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

ARITHMETIC_OPERATION_1: begin //Passando os parâmetros da operação
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = command_word[23:16];
Op2 = command_word[15:8];
ALU_sel = temporary_info_reg;
end

ARITHMETIC_OPERATION_2: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = command_word[23:16];
regWriteEnable = 1;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = 8'b00000010;
Op1 = 8'b0;
Op2 = 8'b0;
ALU_sel = 8'b0;
end

JMP_0: begin
PC_en = 1;
PC_load = command_word[15:8];
end

JMP_1: begin
PC_en = 0;
end

CALL_0: begin
IR_load = 1;
end

CALL_1: begin
pc_value_reg = command_word[23:16];
end

RET_0: begin
PC_en = 1;
PC_load = pc_value_reg;
end

JC: begin
IR_load = 1; 
regReadEnable = 1;
temporary_info_reg = command_word[15:8];
ADR_1 = 8'b00000011;
ADR_2 = 8'b0;
case(command_word[23:16]) 
JZ: next_state <= JZ_1;
JNZ: next_state <= JNZ_1;
JG: next_state <= JG_1;
JL: next_state <= JL_1;
endcase
end

JZ_1: begin
IR_load = 0; 
next_state <= (command_word[0] == 0) ? JC_2 : FETCH_0;
end

JNZ_1: begin
IR_load = 0; 
next_state <= (command_word[0] != 0) ? JC_2 : FETCH_0;
end

JG_1: begin
IR_load = 0; 
next_state <= (!command_word[0] && !command_word[2] && !command_word[6]) ? JC_2 : FETCH_0;
end

JL_1: begin
IR_load = 0; 
next_state <= (command_word[2] ^ command_word[6]) ? JC_2 : FETCH_0;
end

JC_2: begin
PC_en = 1;
PC_load = temporary_info_reg;
next_state <= JMP_1;
end





endcase
end

endmodule
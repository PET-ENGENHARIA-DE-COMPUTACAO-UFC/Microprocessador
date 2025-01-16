module ControlUnit(input[23:0] command_word, input clk, input rst, output [7:0]PC_load, output PC_inc, output MAR_load, output IR_load, output [7:0]write_data, output [7:0]ALU_sel, output [7:0]ADR_1, output [7:0]ADR_2, output [7:0]ADR_3, output [7:0]Op1, output [7:0]Op2, output regWriteEnable, output regReadEnable);

//FSM Encoding
localparam FETCH_0 = 0, FETCH_1 = 1, FETCH_2 = 3, DECODE = 4, STR_IMM_0 = 5, STR_DIR_0 = 6, STR_DIR_1 = 7, LOA_IMM_0 = 8, LOA_DIR_0 = 9, LOA_DIR_1 = 10, MOV_0 = 11, MOV_1 = 12, ARITHMETIC_OPERATION_0 = 13, ARITHMETIC_OPERATION_1 = 14, ARITHMETIC_OPERATION_2 = 15;

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
CMP = 8'b00011000;

//Registradores de estado
reg[7:0] current_state, next_state; 

//Registradores de informações temporárias
reg[7:0] temporary_info_reg;

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
            if(command_word[7:0] == STR_IMM) next_state = STR_IMM_0;

            else if(command_word[7:0] == STR_DIR)   next_state = STR_DIR_0;

            else if(command_word[7:0] == LOA_IMM)   next_state = LOA_IMM_0 ;

            else if(command_word[7:0] == LOA_DIR)   next_state = LOA_DIR_0;

            else if(command_word[7:0] == MOV)   
            next_state = MOV_0;

            else if(command_word[7:0] == ADD)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == SUB)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == MULT)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == DIV)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == MOD)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == L_AND)   next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == L_OR)   
            next_state = ARITHMETIC_OPERATION_0;
            
            else if(command_word[7:0] == L_NOT)   next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == L_XOR)   next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == L_NAND)   next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == L_XNOR)   next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == INC)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == DEC)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == SL)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == SR)   
            next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == L_ROL)   next_state = ARITHMETIC_OPERATION_0;

            else if(command_word[7:0] == L_ROR)   next_state = ARITHMETIC_OPERATION_0;

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

endcase

end

always@(current_state) begin
case(current_state) 
FETCH_0: begin //Carrega o valor do pc no MAR
if(rst) begin //Se o reset for acionado o valor do pc pra zero
PC_load = 8'b0;
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
write_data = command_word[23:16];
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
write_data = command_word[23:16];
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
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 1;
temporary_info_reg = command_word[15:8];
ADR_1 = command_word[23:16];
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

STR_DIR_1: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = command_word[7:0];
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
ADR_1 = command_word[23:16];
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

LOA_DIR_1: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 1;
temporary_info_reg = command_word[15:8];
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
ADR_1 = command_word[23:16];
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

MOV_1: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = command_word[7:0];
regWriteEnable = 1;
regReadEnable = 0;
ADR_1 = temporary_info_reg;
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

ARITHMETIC_OPERATION_0: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 1;
temporary_info_reg = command_word[7:0];
ADR_1 = command_word[15:8];
ADR_2 = command_word[23:16];
ADR_3 = 8'b0;
Op1 = 8'b0;
Op2 = 8'b0;
end

ARITHMETIC_OPERATION_1: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 1;
write_data = 8'b0;
regWriteEnable = 0;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = 8'b0;
Op1 = command_word[15:8];
Op2 = command_word[23:16];
ALU_sel = temporary_info_reg;
end

ARITHMETIC_OPERATION_2: begin
PC_inc = 0;
MAR_load = 0;
IR_load = 0;
write_data = command_word[7:0];
regWriteEnable = 1;
regReadEnable = 0;
ADR_1 = 8'b0;
ADR_2 = 8'b0;
ADR_3 = /*reg3adress*/;
Op1 = 8'b0;
Op2 = 8'b0;
ALU_sel = 8'b0;
end





endcase
end

endmodule
`include "ControlUnit.v"
`include "temporizador.v"
`include "ALU.v"
`include "RAM.v"
`include "pcCounter.v"
`include "MAR.v"
`include "instructionRegister.v"
`include "registerFile.v"
module processor();
wire clk, rst, clk_in; //Fios de clock e reset
wire [7:0]PC_load_wire; //Fio do sinal de PC load
wire PC_inc_wire, PC_en_wire; //Fios de incremento do PC e enable do PC
wire MAR_load; //Fio de "enable" do MAR
wire IR_load; //Fio de "enable" do IR
wire [23:0]command_word_wire; //Fio com a entrada da Control Unit
wire [7:0]operand1_wire, operand2_wire; //Fios dos operandos da ALU.
wire [7:0]ADR_1_wire, ADR_2_wire; //Fios de endereço a ser lido
wire [7:0]ADR_3_wire; //Fios de endereço a ser escrito
wire [7:0]write_data_wire; //Fio de dados a serem escritos
wire regWriteEnable_wire; //Fio do enable da escrita
wire regReadEnable_wire; //Fio do enable da leitura
wire [7:0]ALU_sel_wire; //Fio do sinal de controle da ALU
wire [7:0]PC_adress_wire; //Fio do endereço apontado pelo PC
wire [7:0]RAM_instruction_wire; //Fio da instrução lida pelo MAR
wire [7:0]IR_opcode_wire; //Fio da instrução lida pelo MAR
wire [7:0]IR_operand1_wire; //Fio da instrução lida pelo MAR
wire [7:0]IR_operand2_wire; //Fio da instrução lida pelo MAR
wire [2:0]compare_result_wire; //Fio da instrução lida pelo MAR
wire [6:0]flag_wire; //Fio da instrução lida pelo MAR

//timer tmp(.clk_out(clk), .clk_in(clk_in),.rst(rst));

ControlUnit UC(
    .command_word(command_word_wire),
    .clk(clk),
    .rst(rst),
    .PC_load(PC_load_wire),
    .PC_inc(PC_inc_wire),
    .PC_en(PC_en_wire),
    .MAR_load(MAR_load),
    .IR_load(IR_load),
    .write_data(write_data_wire),
    .ALU_sel(ALU_sel_wire),
    .ADR_1(ADR_1_wire),
    .ADR_2(ADR_2_wire),
    .ADR_3(ADR_3_wire),
    .Op1(operand1_wire),
    .Op2(operand2_wire),
    .regWriteEnable(regWriteEnable_wire),
    .regReadEnable(regReadEnable_wire)
);

ALU ArithmeticLogicUnit(
    .operand1(operand1_wire),
    .operand2(operand2_wire),
    .clk(clk),
    .operation_result(IR_opcode_wire), //Deverá ser truncado
    .ALU_sel(ALU_sel_wire),
    .Flags(flag_wire), //Vai pro register file 
    .eq(compare_result_wire[0]), //Deverá ser truncado
    .gt(compare_result_wire[1]),
    .lt(compare_result_wire[2])
);

ram RandomAcessMemory(
    .clk(clk),
    .rst(rst),
    .write_en(1'b0),
    .write_adress(8'b0),
    .data_in(8'b0),
    .rd_en(1'b1),
    .rd_adress(PC_adress_wire),
    .data_out(RAM_instruction_wire)
);

pcCounter ProgramCounter(
    .PC_load(PC_load_wire),
    .PC_inc(PC_inc_wire),
    .PC_en(PC_en_wire),
    .PC(PC_adress_wire)
);

MAR MemoryAdressRegister(
    .MAR_load(MAR_load),
    .clk(clk),
    .data(RAM_instruction_wire),
    .instruction(IR_opcode_wire)
);



InstructionRegister IR(
    .IR_load(IR_load),
    .clk(clk),
    .opcode(IR_opcode_wire),
    .operando1(IR_operand1_wire),
    .operando2(IR_operand2_wire),
    .instReg(command_word_wire)
);

RegisterFile RF(
    .clk(clk),
    .A1(ADR_1_wire),
    .A2(ADR_2_wire),
    .A3(ADR_3_wire),
    .WriteData(write_data_wire),
    .regWriteEnable(regWriteEnable_wire),
    .regReadEnable(regReadEnable_wire),
    .RD1(IR_opcode_wire), //Deverão ser truncados        RD1 RD2 ADR_2
    .RD2(command_word_wire[15:8])
);


endmodule
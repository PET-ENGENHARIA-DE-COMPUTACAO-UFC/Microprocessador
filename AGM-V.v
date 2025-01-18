`include "ControlUnit2.v"
`include "temporizador.v"
`include "ALU.v"
`include "RAM.v"
`include "pcCounter.v"
`include "MAR.v"
`include "instructionRegister.v"
`include "registerFile.v"
module processor(
    input wire clk, //Sinal de clock
    input wire rst, //Sinal de reset
    output wire [7:0]PC_wire, // Endereço lido na RAM
    output wire [7:0]data_out, // Dado que foi lido na RAM
    output wire [7:0]ADR_1_wire, // Fio de endereço 1 passado ao Register File (leitura)
    output wire [7:0]ADR_2_wire, // Fio de endereço 2 passado ao Register File (leitura)
    output wire [7:0]ADR_3_wire, // Fio de endereço 3 passado ao Register File (escrita)
    output wire [7:0]RD1_wire, //
    output wire [7:0]RD2_wire, //
    output wire PC_inc_wire,
    output wire PC_en_wire, //Fios de incremento do PC e enable do PC
    output wire [7:0]current_state_out_wire, 
    output wire [23:0]command_word_wire,
    output wire ReadyRegFlag_wire,
    output wire IR_load_wire, //Fio de "enable" do IR
    output wire [7:0]MAR_instruction_wire, //Fio da instrução lida pelo MAR
    output wire MAR_load_wire, //Fio de "enable" do MAR
    output wire [7:0]opcode_out,
    output wire [1:0]Path_Type_wire, //Fio do tipo de circuito
    output wire [7:0]PC_load_wire //Fio do sinal de PC load
);

wire [7:0]write_data_wire; //Fio de dados a serem escritos

wire regWriteEnable_wire; //Fio do enable da escrita

wire regReadEnable_wire; //Fio do enable da leitura

wire [7:0]ALU_sel_wire; //Fio do sinal de controle da ALU

wire [7:0]IR_opcode_wire; //Fio da instrução lida pelo MAR

wire [6:0]flag_wire; //Fio da instrução lida pelo MAR

wire [7:0]mux_result_wire; //Fio do que irá ao write adress

wire [7:0]operation_result_wire; //Fio do resultado da operação aritmética

//SINAIS DA RAM:
wire write_en;
wire rd_en;
reg [7:0]data_in;
reg [7:0]write_adress;


//timer tmp(.clk_out(clk), .clk_in(clk_in),.rst(rst));

ControlUnit UC(
    .command_word(command_word_wire),
    .clk(clk),
    .rst(rst),
    .ReadyRegFlag(ReadyRegFlag_wire),
    .PC_current_value(PC_wire),
    .PC_load(PC_load_wire),
    .PC_inc(PC_inc_wire),
    .PC_en(PC_en_wire),
    .MAR_load(MAR_load_wire),
    .IR_load(IR_load_wire),
    .write_data(write_data_wire),
    .ALU_sel(ALU_sel_wire),
    .ADR_1(ADR_1_wire),
    .ADR_2(ADR_2_wire),
    .ADR_3(ADR_3_wire),
    .regWriteEnable(regWriteEnable_wire),
    .regReadEnable(regReadEnable_wire),
    .Path_Type(Path_Type_wire),
    .rd_en(rd_en),
    .current_state_out(current_state_out_wire),
    .opcode_out(opcode_out)
);

ALU ArithmeticLogicUnit(
    .operand1(RD1_wire),
    .operand2(RD2_wire),
    .clk(clk),
    .operation_result(operation_result_wire), //Deverá ser truncado
    .ALU_sel(ALU_sel_wire),
    .Flags(flag_wire) //Vai pro register file 
);

ram RandomAcessMemory(
    .clk(clk),
    .rst(rst),
    .write_en(write_en),
    .write_adress(write_adress),
    .data_in(data_in),
    .rd_en(rd_en),
    .rd_adress(PC_wire),
    .data_out(data_out)
);

pcCounter ProgramCounter(
    .clk(clk),
    .PC_load(PC_load_wire),
    .PC_inc(PC_inc_wire),
    .PC_en(PC_en_wire),
    .PC(PC_wire)
);

MAR MemoryAdressRegister(
    .MAR_load(MAR_load_wire),
    .clk(clk),
    .data(data_out),
    .instruction(MAR_instruction_wire)
);



InstructionRegister IR(
    .IR_load(IR_load_wire),
    .clk(clk),
    .payload(MAR_instruction_wire),
    .instReg(command_word_wire),
    .ReadyFlag(ReadyRegFlag_wire)
);

assign mux_result_wire = (Path_Type_wire == 2'b00) ? operation_result_wire : (Path_Type_wire == 2'b01) ? RD1_wire : (Path_Type_wire == 2'b10) ? write_data_wire : 8'b0;

RegisterFile RF(
    .clk(clk),
    .A1(ADR_1_wire),
    .A2(ADR_2_wire),
    .A3(ADR_3_wire),
    .WriteData(mux_result_wire),
    .Flag_input(flag_wire),
    .regWriteEnable(regWriteEnable_wire),
    .regReadEnable(regReadEnable_wire),
    .RD1(RD1_wire),
    .RD2(RD2_wire)
);


endmodule
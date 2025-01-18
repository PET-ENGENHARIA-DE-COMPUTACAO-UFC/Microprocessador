`timescale 1ns/1ps
`include "ControlUnit2.v"
module ControlUnit_tb;

// Inputs
reg [23:0] command_word;
reg clk;
reg rst;
reg [1:0] fullRegFlag;

// Outputs
wire [7:0] PC_load;
wire PC_inc;
wire PC_en;
wire MAR_load;
wire IR_load;
wire [7:0] write_data;
wire [7:0] ALU_sel;
wire [7:0] ADR_1;
wire [7:0] ADR_2;
wire [7:0] ADR_3;
wire regWriteEnable;
wire regReadEnable;

// Instantiate the ControlUnit
ControlUnit uut (
    .command_word(command_word),
    .clk(clk),
    .rst(rst),
    .ReadyRegFlag(fullRegFlag),
    .PC_load(PC_load),
    .PC_inc(PC_inc),
    .PC_en(PC_en),
    .MAR_load(MAR_load),
    .IR_load(IR_load),
    .write_data(write_data),
    .ALU_sel(ALU_sel),
    .ADR_1(ADR_1),
    .ADR_2(ADR_2),
    .ADR_3(ADR_3),
    .regWriteEnable(regWriteEnable),
    .regReadEnable(regReadEnable)
);

// Clock generation
always #5 clk = ~clk;

// Testbench logic
initial begin
    // Initialize inputs
    clk = 0;
    rst = 0;
    fullRegFlag = 0;
    command_word = 24'b0;

    // Reset the system
    rst = 1;
    #10;
    rst = 0;
    #10;

    // Test FETCH and DECODE with STR_IMM command
    fullRegFlag = 1;
    command_word = {8'b00000001, 8'b00000010, 8'b00000011}; // STR_IMM, destination=2, data=3
    #50; // Let the FSM progress through states

    // Test FETCH and DECODE with LOA_IMM command
    fullRegFlag = 1;
    command_word = {8'b00011000, 8'b00000100, 8'b00000101}; // LOA_IMM, destination=4, data=5
    #50;

    // Test FETCH and DECODE with MOV command
    fullRegFlag = 1;
    command_word = {8'b00011010, 8'b00000110, 8'b00000111}; // MOV, source=6, destination=7
    #50;

    // Test FETCH and DECODE with ADD command
    fullRegFlag = 1;
    command_word = {8'b00000011, 8'b00001000, 8'b00001001}; // ADD, src1=8, src2=9
    #50;

    // Test JMP command
    fullRegFlag = 1;
    command_word = {8'b00011001, 8'b00000000, 8'b00001010}; // JMP, address=10
    #50;

    // Test CALL command
    fullRegFlag = 1;
    command_word = {8'b00011010, 8'b00000000, 8'b00001011}; // CALL, address=11
    #50;

    // Test RET command
    fullRegFlag = 1;
    command_word = {8'b00011011, 8'b00000000, 8'b00000000}; // RET
    #50;

    // End simulation
    $finish;
end

// Monitor output signals
initial begin
    $monitor("Time=%0t | State=%0d | PC_load=%0d | PC_inc=%b | PC_en=%b | MAR_load=%b | IR_load=%b | write_data=%0d | ALU_sel=%0d | ADR_1=%0d | ADR_2=%0d | ADR_3=%0d | regWriteEnable=%b | regReadEnable=%b",
        $time, uut.current_state, PC_load, PC_inc, PC_en, MAR_load, IR_load, write_data, ALU_sel, ADR_1, ADR_2, ADR_3, regWriteEnable, regReadEnable);
end

endmodule
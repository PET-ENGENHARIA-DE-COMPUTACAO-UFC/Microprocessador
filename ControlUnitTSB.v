`include "ControlUnit2.v"
module testbench();
    reg[23:0] command_word; //input
    wire clk, rst, ReadyRegFlag; //input
    reg[7:0] PC_load, PC_inc, PC_en, MAR_load, IR_load, ALU_sel, ADR_1, ADR_2, ADR_3; //output
    reg regWriteEnable, regReadEnable, Path_Type; //output

endmodule
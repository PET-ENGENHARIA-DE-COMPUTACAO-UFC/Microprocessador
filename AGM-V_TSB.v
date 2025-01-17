`timescale 1ns / 1ps

module processor_tb;

// Testbench signals
reg clk_in;             // Input clock for the timer
reg rst;                // Reset signal
wire clk;               // Output clock from the timer (clk_out)

// Processor signals (internal wires for monitoring or connections)
wire [7:0] PC_load_wire;
wire PC_inc_wire, PC_en_wire;
wire MAR_load;
wire IR_load;
wire [23:0] command_word_wire;
wire [7:0] operand1_wire, operand2_wire;
wire [7:0] ADR_1_wire, ADR_2_wire;
wire [7:0] ADR_3_wire;
wire [7:0] write_data_wire;
wire regWriteEnable_wire;
wire regReadEnable_wire;
wire [7:0] ALU_sel_wire;
wire [7:0] PC_adress_wire;
reg [7:0] RAM_instruction_wire;
wire [7:0] IR_opcode_wire;
wire [7:0] IR_operand1_wire;
wire [7:0] IR_operand2_wire;
wire [2:0] compare_result_wire;
wire [6:0] flag_wire;

// Instantiate the processor module
processor DUT();

// Clock generation for clk_in
initial begin
    clk_in = 0;
    forever #5 clk_in = ~clk_in; // Toggle clk_in every 5 ns (100 MHz input clock)
end

// Stimulus block
initial begin
    // Initialize reset
    rst = 1;  // Assert reset
    #20;      // Hold reset for 20ns
    rst = 0;  // Release reset

    RandomAcessMemory[00000000] = 00000001;
    RandomAcessMemory[00000001] = 00000000; // -> 000000
    RandomAcessMemory[00000010] = 00000010;

    #10

    RandomAcessMemory[00000000] = 00000001;
    RandomAcessMemory[00000001] = 00000001; // -> endereço registrador b
    RandomAcessMemory[00000010] = 00000010;

    #10

    RandomAcessMemory[00000000] = 00000011;
    RandomAcessMemory[00000001] = 00000000; // -> 000000
    RandomAcessMemory[00000010] = 00000001;

    #20;

    // Stop the simulation
    $stop;
end

// Monitor key signals
initial begin
    $monitor(
        "Time: %0dns | rst: %b | clk: %b | PC: %b | Opcode: %b | Operand1: %b | Operand2: %b", 
        $time, rst, clk, PC_adress_wire, IR_opcode_wire, IR_operand1_wire, IR_operand2_wire
    );
end

// Waveform dump for debugging
initial begin
    $dumpfile("processor_tb.vcd");  // VCD file for waveform analysis
    $dumpvars(0, processor_tb);     // Dump all variables in this testbench
end

endmodule

`timescale 1ns / 1ps
`include "AGM-V.v"
module processor_tb;

// Testbench signals
reg clk_in;             // Input clock for the timer
reg rst;                // Reset signal
wire clk;               // Output clock from the timer (clk_out)

// Processor signals (internal wires for monitoring or connections)
reg clk;
reg rst;
wire [7:0]PC_wire;
wire [7:0]data_out;
wire [7:0]ADR_1_wire;
wire [7:0]ADR_2_wire;
wire [7:0]ADR_3_wire;
wire [7:0]RD1_wire;
wire [7:0]RD2_wire;

// Instantiate the processor module
processor DUT(
    .clk(clk),
    .rst(rst),
    .PC_wire(PC_wire),
    .data_out(data_out),
    .ADR_1_wire(ADR_1_wire),
    .ADR_2_wire(ADR_2_wire),
    .ADR_3_wire(ADR_3_wire),
    .IR_operand1_wire(RD1_wire),
    .IR_operand2_wire(RD2_wire)
);

// Clock generation for clk_in
initial begin
    clk = 0;
    forever #5 clk_in = ~clk_in; // Toggle clk_in every 5 ns (100 MHz input clock)
end

// Stimulus block
initial begin
    // Initialize reset
    rst = 1;  // Assert reset
    #20;      // Hold reset for 20ns
    rst = 0;  // Release reset

  #20

    

    // Stop the simulation
    $finish;
end

// Monitor key signals
initial begin
    $monitor(
        "Time: %0dns | rst: %b | clk: %b | Endereço memoria: %b | dados da memoria: %b | endereço na porta A1: %b | Endereço na porta A2: %b | Endereço na porta A3: %b\n Saída porta A1: %b | Saida na porta A2: %b", 
        $time, rst, clk,PC_wire, data_out, ADR_1_wire, ADR_2_wire, ADR_3_wire,RD1_wire,RD2_wire
    );
end

// Waveform dump for debugging
initial begin
    $dumpfile("processor_tb.vcd");  // VCD file for waveform analysis
    $dumpvars(0, processor_tb);     // Dump all variables in this testbench
end

endmodule

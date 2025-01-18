`timescale 1us / 1ps
`include "AGM-V.v"
module processor_tb;
// Processor signals (internal wires for monitoring or connections)
reg clk;
reg rst;
wire [7:0]ADR_1_wire;
wire [7:0]ADR_2_wire;
wire [7:0]ADR_3_wire;
wire [7:0]RD1_wire;
wire [7:0]RD2_wire;
wire [7:0]opcode_out;

processor DUT(
    .clk(clk),
    .rst(rst),
    .ADR_1_wire(ADR_1_wire),
    .ADR_2_wire(ADR_2_wire),
    .ADR_3_wire(ADR_3_wire),
    .RD1_wire(RD1_wire),
    .RD2_wire(RD2_wire),
    .opcode_out(opcode_out)
);

// Clock generation for clk_in
initial begin
    clk = 0;
    forever #30 clk = ~clk; // Toggle clk_in every 5 ns (100 MHz input clock)
end

// Stimulus block
initial begin
    // Initialize reset
    rst = 0;  // Assert reset
    #100;      // Hold reset for 20ns
    rst = 1;  // Release reset
    #100
    rst = 0;

  #2000


    // Stop the simulation
    $finish;
end

// Monitor key signals
initial begin
    $monitor(
        "rst: %b | clk: %b | endereco na porta A1: %b | Endereco na porta A2: %b | Endereco na porta A3: %b\n Saida porta A1: %b | Saida na porta A2: %b | opcode = %b \n" , 
        rst, clk, ADR_1_wire, ADR_2_wire, ADR_3_wire,RD1_wire,RD2_wire, opcode_out
    );
end

// Waveform dump for debugging
initial begin
    $dumpfile("processor_tb.vcd");  // VCD file for waveform analysis
    $dumpvars(0, processor_tb);     // Dump all variables in this testbench
end

endmodule
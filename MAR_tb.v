`include "MAR.v"
module MAR_tb;

    // Testbench signals
    reg clk;
    reg [7:0] address;
    reg [7:0] memory [255:0];
    wire [7:0] instruction;

    // Instantiate the MAR module
    MAR mar_instance (
        .clk(clk),
        .address(address),
        .memory(memory),
        .instruction(instruction)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units period
    end

    // Test sequence
    initial begin
        // Initialize memory with some values
        memory[0] = 8'b00000001;
        memory[1] = 8'b00000100;
        memory[2] = 8'b00010000;
        memory[3] = 8'b10000000;
        memory[4] = 8'b00100000;

        // Test different addresses
        address = 8'b00000000;
        #10; // Wait for one clock cycle
        $display("Address: %b, Instruction: %b", address, instruction);

        address = 8'b00000001;
        #10; // Wait for one clock cycle
        $display("Address: %b, Instruction: %b", address, instruction);

        address = 8'b00000010;
        #10; // Wait for one clock cycle
        $display("Address: %b, Instruction: %b", address, instruction);

        address = 8'b00000011;
        #10; // Wait for one clock cycle
        $display("Address: %b, Instruction: %b", address, instruction);

        address = 8'b00000100;
        #10; // Wait for one clock cycle
        $display("Address: %b, Instruction: %b", address, instruction);

        // Finish the simulation
        $finish;
    end

endmodule
`timescale 1ns/1ps
`include "ALU.v"

module ALU_tb;
    reg[7:0] src1, src2, ALU_sel; // Inputs
    wire[7:0] result; // Output
    wire[6:0] flags; // Flags

    ALU uut(.operand1(src1), .operand2(src2), .operation_result(result), .ALU_sel(ALU_sel), .Flags(flags));

    initial begin
        $monitor("Time = %0t | ALU_sel = %b | src1 = %d | src2 = %d | result = %d | Flags = %b", 
             $time, ALU_sel, src1, src2, result, flags);
  
        #1;

        // Initialize inputs
        src1 = 8'd0;
        src2 = 8'd0;
        ALU_sel = 8'b00000000; 

        // Addition test: Addition
        #10 src1 = 8'd10; src2 = 8'd15; ALU_sel = 8'b00000001; // Add
        #10 if (result != 8'd25) $display("Addition test Failed");

        #10 src1 = 8'd0; src2 = 8'd15; ALU_sel = 8'b00000001; // Add
        #10 if (result != 8'd15) $display("Addition test Failed");

        #10 src1 = 8'd240; src2 = 8'd15; ALU_sel = 8'b00000001; // Add
        #10 if (result != 8'd255) $display("Addition test Failed");

        #10 src1 = 8'd255; src2 = 8'd1; ALU_sel = 8'b00000001; // Add
        #10 if (result != 8'd0) $display("Addition test Failed"); 


        // Subtraction test: Subtraction
        #10 src1 = 8'd20; src2 = 8'd5; ALU_sel = 8'b00000010; // Subtract
        #10 if (result != 8'd15) $display("Subtraction test Failed");

        #10 src1 = 8'b00000001; src2 = 8'b00000010; ALU_sel = 8'b00000010; // Subtract
        #10 if (result != 8'b11111111) $display("Subtraction test Failed");

        #10 src1 = 8'd32; src2 = 8'd7; ALU_sel = 8'b00000010; // Subtract
        #10 if (result != 8'd25) $display("Subtraction test Failed");


        // Multiplication test: Multiplication
        #10 src1 = 8'd3; src2 = 8'd4; ALU_sel = 8'b00000011; // Multiply
        #10 if (result != 8'd12) $display("Multiplication test Failed");

        #10 src1 = 8'd0; src2 = 8'd240; ALU_sel = 8'b00000011; // Multiply
        #10 if (result != 8'd0) $display("Multiplication test Failed");

        #10 src1 = 8'd27; src2 = 8'd4; ALU_sel = 8'b00000011; // Multiply
        #10 if (result != 8'd108) $display("Multiplication test Failed");


        // Division test: Division
        #10 src1 = 8'd16; src2 = 8'd4; ALU_sel = 8'b00000100; // Divide
        #10 if (result != 8'd4) $display("Division test Failed");

        #10 src1 = 8'd8; src2 = 8'd0; ALU_sel = 8'b00000100; // Divide
        #10 if (result != 8'd255) $display("Division test Failed");

        #10 src1 = 8'd16; src2 = 8'd1; ALU_sel = 8'b00000100; // Divide
        #10 if (result != 8'd16) $display("Division test Failed");


        // Increment test: Increment
        #10 src1 = 8'd5; src2 = 8'd0; ALU_sel = 8'b00000101; // Increment
        #10 if (result != 8'd6) $display("Increment test Failed");

        #10 src1 = 8'd255; src2 = 8'd0; ALU_sel = 8'b00000101; // Increment
        #10 if (result != 8'd0) $display("Increment test Failed");


        // Decrement test: Decrement
        #10 src1 = 8'd10; src2 = 8'd0; ALU_sel = 8'b00000110; // Decrement
        #10 if (result != 8'd9) $display("Decrement test Failed");

        #10 src1 = 8'd0; src2 = 8'd0; ALU_sel = 8'b00000110; // Decrement
        #10 if (result != 8'd255) $display("Decrement test Failed");


        // Module test: Modulo
        #10 src1 = 8'd10; src2 = 8'd3; ALU_sel = 8'b00000111; // Modulo
        #10 if (result != 8'd1) $display("Module test Failed");

        #10 src1 = 8'd25; src2 = 8'd5; ALU_sel = 8'b00000111; // Modulo
        #10 if (result != 8'd0) $display("Module test Failed");

        #10 src1 = 8'd30; src2 = 8'd4; ALU_sel = 8'b00000111; // Modulo
        #10 if (result != 8'd2) $display("Module test Failed");


        // Shift left test: Shift Left
        #10 src1 = 8'b00001111; src2 = 8'd0; ALU_sel = 8'b00001000; // Shift Left
        #10 if (result != 8'b00011110) $display("Shift left test Failed");

        #10 src1 = 8'b00001011; src2 = 8'd0; ALU_sel = 8'b00001000; // Shift Left
        #10 if (result != 8'b00010110) $display("Shift left test Failed");


        // Shift right test: Shift Right
        #10 src1 = 8'b00001111; src2 = 8'd0; ALU_sel = 8'b00001001; // Shift Right
        #10 if (result != 8'b00000111) $display("Shift right test Failed");

        #10 src1 = 8'b00001011; src2 = 8'd0; ALU_sel = 8'b00001001; // Shift Right
        #10 if (result != 8'b00000101) $display("Shift right test Failed");


        // Addition test0: AND
        #10 src1 = 8'b10101010; src2 = 8'b11001100; ALU_sel = 8'b00001010; // AND
        #10 if (result != 8'b10001000) $display("And test Failed");

        #10 src1 = 8'b11110000; src2 = 8'b00001111; ALU_sel = 8'b00001010; // AND
        #10 if (result != 8'b00000000) $display("And test Failed");

        #10 src1 = 8'b01100101; src2 = 8'b10110101; ALU_sel = 8'b00001010; // AND
        #10 if (result != 8'b00100101) $display("And test Failed");


        // Addition test1: NAND
        #10 src1 = 8'b10101010; src2 = 8'b11001100; ALU_sel = 8'b00001011; // NAND
        #10 if (result != 8'b01110111) $display("NAND test Failed");

        #10 src1 = 8'b11110000; src2 = 8'b00001111; ALU_sel = 8'b00001011; // NAND
        #10 if (result != 8'b11111111) $display("NAND test Failed");

        #10 src1 = 8'b01100101; src2 = 8'b10110101; ALU_sel = 8'b00001011; // NAND
        #10 if (result != 8'b11011010) $display("NAND test Failed");


        // Addition test2: NOR
        #10 src1 = 8'b10101010; src2 = 8'b11001100; ALU_sel = 8'b00001101; // NOR
        #10 if (result != ~(8'b10101010 | 8'b11001100)) $display("NOR test Failed");

        #10 src1 = 8'b11110000; src2 = 8'b00001111; ALU_sel = 8'b00001101; // NOR
        #10 if (result != ~(8'b11110000 | 8'b00001111)) $display("NOR test Failed");

        #10 src1 = 8'b01100101; src2 = 8'b10110101; ALU_sel = 8'b00001101; // NOR
        #10 if (result != ~(8'b01100101 | 8'b10110101)) $display("NOR test Failed");


        // Addition test3: OR
        #10 src1 = 8'b10101010; src2 = 8'b11001100; ALU_sel = 8'b00001111; // OR
        #10 if (result != 8'b11101110) $display("OR test Failed");

        #10 src1 = 8'b11110000; src2 = 8'b00001111; ALU_sel = 8'b00001111; // OR
        #10 if (result != 8'b11111111) $display("OR test Failed");

        #10 src1 = 8'b01100101; src2 = 8'b10110101; ALU_sel = 8'b00001111; // OR
        #10 if (result != 8'b11110101) $display("OR test Failed");


        // Addition test4: XNOR
        #10 src1 = 8'b10101010; src2 = 8'b11001100; ALU_sel = 8'b00010000; // XNOR
        #10 if (result != ~(8'b10101010 ^ 8'b11001100)) $display("XNOR test Failed");

        #10 src1 = 8'b10101010; src2 = 8'b01010101; ALU_sel = 8'b00010000; // XNOR
        #10 if (result != ~(8'b10101010 ^ 8'b01010101)) $display("XNOR test Failed");

        #10 src1 = 8'b11110000; src2 = 8'b11110000; ALU_sel = 8'b00010000; // XNOR
        #10 if (result != ~(8'b11110000 ^ 8'b11110000)) $display("XNOR test Failed");


        // Addition test5: XOR
        #10 src1 = 8'b10101010; src2 = 8'b11001100; ALU_sel = 8'b00010001; // XOR
        #10 if (result != 8'b01100110) $display("XOR test Failed");

        #10 src1 = 8'b10101010; src2 = 8'b01010101; ALU_sel = 8'b00010001; // XOR
        #10 if (result != 8'b11111111) $display("XOR test Failed");

        #10 src1 = 8'b11110000; src2 = 8'b11110000; ALU_sel = 8'b00010001; // XOR
        #10 if (result != 8'b00000000) $display("XOR test Failed"); 

        // Addition test5: Rotate Left (ROL)
        #10 src1 = 8'b10101010; src2 = 8'b00000000; ALU_sel = 8'b00010010; // ROL
        #10 if (result != 8'b01010101) $display("ROL test Failed");

        #10 src1 = 8'b00000001; src2 = 8'b00000000; ALU_sel = 8'b00010010; // ROL
        #10 if (result != 8'b00000010) $display("ROL test Failed");


        // Addition test5: Rotate Right (ROR)
        #10 src1 = 8'b10101010; src2 = 8'b00000000; ALU_sel = 8'b00010011; // ROR
        #10 if (result != 8'b01010101) $display("ROR test Failed");

        #10 src1 = 8'b10000000; src2 = 8'b00000000; ALU_sel = 8'b00010011; // ROR
        #10 if (result != 8'b01000000) $display("ROR test Failed");

        #10 src1 = 8'b00000001; src2 = 8'b00000000; ALU_sel = 8'b00010011; // ROR
        #10 if (result != 8'b10000000) $display("ROR test Failed");


        // Test complete
        #10 $finish;
    end
endmodule
`include "ALU.v"
`include "ram.v"
`include "instructionRegister.v"
`include "MAR.v"
`include "pcCounter.v"
module DataPath(input clk, input rst);

wire [7:0]ProgramCounter_position; wire[7:0]MAR_instruction; 
    /*
    Código da RAM -
    */

    ram RAM(
        .clk(clk),
        .rst(rst),
        .write_en(),
        .write_adress(),
        .data_in(),
        .rd_en(),
        .rd_adress(),
        .data_out()
    );
    
    /*
    Código do Pc Counter 
    */
    pcCounter ProgramCounter(
        .clk(clk),
        .rst(rst),
        .PC(ProgramCounter_position)
    );

    /*
    Código do MAR 
    */
    MAR MemoryAdressRegister(
        .clk(clk),
        .address(ProgramCounter_position),
        .memory(RAM),
        .instruction(MAR_instruction)
    );
    

    /*
    Código do Instruction Register 
    */



    /*
    Código do Control Unit -> Amorim

    */

    /*
    Código do Register File -> Feito
    */

    /*
    ALU -> Feito
    */


endmodule
`include "ALU.v"
`include "ram.v"
`include "instructionRegister.v"
`include "MAR.v"
`include "pcCounter.v"
module DataPath();

    /*
    Código da RAM -
    */

    ram RAM(
        .clk(),
        .rst(),
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
        .clk(),
        .PC()
    );

    /*
    Código do MAR 
    */



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
`include "ALU.v"
`include "ram.v"
`include "MAR.v"
module DataPath();

    /*
    Código da RAM -> Feito
    */

    /*
    Código do Pc Counter -> Lobo
    */

    /*
    Código do MAR -> Mateus
    */
    MAR mar(
        .clk(clk),
        .address(address),
        .memory(memory),
        .instruction(instruction)
    );
    /*
    Código do Instruction Register -> Lobo
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
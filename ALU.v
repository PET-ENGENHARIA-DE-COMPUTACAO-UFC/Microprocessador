`timescale 1ps/1ps
`include "arithmetic/adder.v"
`include "arithmetic/decrement.v"
`include "arithmetic/divisor.v"
`include "arithmetic/increment.v"
`include "arithmetic/div_module.v"
`include "arithmetic/multiplier.v"
`include "arithmetic/subtractor.v"
`include "arithmetic/shift_left8b.v"
`include "arithmetic/shift_right8b.v"
`include "logic/and_gate.v"
`include "logic/nand_gate.v"
`include "logic/nor_gate.v"
`include "logic/not_gate.v"
`include "logic/or_gate.v"
`include "logic/xnor_gate.v"
`include "logic/xor_gate.v"
`include "logic/numberroll.v"

/*
Flags[0] <= Zero Flag
Flags[1] <= Carry Flag
Flags[2] <= Sinal
Flags[3] <= Paridade
Flags[4] <= Interrupção
Flags[5] <= Direção
Flags[6] <= Overflow
*/

/*
Para propósitos de teste faremos:
soma <= 00000001
subtração <= 00000010
multiplicação <= 00000011
divisão <= 00000100
incremento <= 00000101
decremento <= 00000110
módulo <= 00000111
shiftleft <= 00001000
shiftright <= 00001001
and <= 00001010
nand <= 00001011
nor <= 00001101
not <= 00001110
or <= 00001111
xnor <= 00010000
xor <= 00010001
rol <= 00010010
ror <= 00010011

*/

module ALU(input[7:0]operand1, input[7:0]operand2, input clk, output reg[7:0]operation_result, input[7:0] ALU_sel, output reg[6:0]Flags);
wire[7:0] add_result, sub_result, increment_result, decrement_result, mod_result, mult_result, div_result, sr_result, sl_result;
wire[7:0] and_result, nand_result, nor_result, not_result, or_result, xnor_result, xor_result, rol_result, ror_result;
wire add_carry, sub_carry, inc_carry, dec_carry;
wire[7:0]div_rest;

//Somador
full_adder8b adder (
    .csum(add_result), 
    .c_outc(add_carry), 
    .numf1(operand1), 
    .numf2(operand2)
); 

//Subtrator
full_subtractor8b subtractor (
    .csub(sub_result),
    .c_outc(sub_carry),
    .numf1(operand1),
    .numf2(operand2)
);

//Incrementador de 1
increment8b incrementor (
    .result(increment_result),
    .cout(inc_carry),
    .num1(operand1)
);

//Decrementador de 1
decrement8b decrementor (
    .result(decrement_result),
    .cout(dec_carry),
    .num1(operand1)
);

//Multiplicador
multiplier8b multiplier(
    .result(mult_result),
    .num1(operand1),
    .num2(operand2)
);

//Divisor
divisor8b divisor(
    .result(div_result),
    .rest(div_rest),
    .num1(operand1),
    .num2(operand2)
);

//Cálculo do Módulo
module8b div_module(
    .rest(mod_result),
    .num1(operand1),
    .num2(operand2)
);

shift_left8b left_shifter(
    .a(operand1),
    .y(sl_result)
    
);

shift_right8b shift_right(
    .a(operand1),
    .y(sr_result)
);

and8b and_gate(
    .result(and_result),
    .num1(operand1),
    .num2(operand2)
);

nand8b nand_gate(
    .result(nand_result),
    .num1(operand1),
    .num2(operand2)
);

nor8b nor_gate(
    .result(nor_result),
    .num1(operand1),
    .num2(operand2)
);

not8b not_gate(
    .result(not_result),
    .num1(operand1)
);

or8b or_gate(
    .result(or_result),
    .num1(operand1),
    .num2(operand2)
);

xnor8b xnor_gate(
    .result(xnor_result),
    .num1(operand1),
    .num2(operand2)
);

xor8b xor_gate(
    .result(xor_result),
    .num1(operand1),
    .num2(operand2)
);

rol rol_gate(
    .a(operand1),
    .y(rol_result)
);

ror ror_gate(
    .a(operand1),
    .y(ror_result)
);

always@(*) begin
    case(ALU_sel)

    //Caso do somador
    8'b00000001: begin //Soma
        operation_result <= add_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= add_carry;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= (operand1[7] == operand2[7]) && (operand1[7] != operation_result[7]);
    end

    //Caso do subtrator
    8'b00000010: begin
        operation_result <= sub_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= sub_carry;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= (operand1[7] != operand2[7]) && (operand1[7] == operation_result[7]);
    end

    //Caso do incremento em 1
    8'b00000101: begin
        operation_result <= increment_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= inc_carry;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= (operand1[7] == operand2[7]) && (operand1[7] != operation_result[7]);
    end

    //Caso do decremento em 1
    8'b00000110: begin
        operation_result <= decrement_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= dec_carry;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= (operand1[7] != operand2[7]) && (operand1[7] == operation_result[7]);
    end

    //Caso do multiplicador
    8'b00000011: begin
        operation_result <= mult_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= (operand1[7] == operand2[7]) && (operand1[7] != operation_result[7]);
    end

    //Caso do divisor
    8'b00000100: begin
        operation_result <= div_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= (operand2 == 0) ? 1 : 0;
    end

    //Caso do cálculo do resto da divisão
    8'b00000111: begin
        operation_result <= mod_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= (operand2 == 0) ? 1 : 0;
    end

    //Caso do shift left
    8'b00001000: begin
        operation_result <= sl_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= operand1[7];
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 1;
        Flags[6] <= (operand1[7] != operation_result[7]);
    end

    //Caso do shift right
    8'b00001001: begin
        operation_result <= sr_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= operand1[0];
        Flags[2] <= (operand1[7] == 1) ? 1 : operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end

    //Caso do E lógico
    8'b00001010: begin
        operation_result <= and_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end

    //Caso do E negado lógico
    8'b00001011: begin
        operation_result <= nand_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end

    //Caso do Ou negado lógico
    8'b00001101: begin
        operation_result <= nor_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end

    //Caso da negação lógica
    8'b00001110: begin
        operation_result <= not_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end

    //Caso do Ou lógico
    8'b00001111: begin
        operation_result <= or_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end

    //Caso do Ou negado exclusivo lógico
    8'b00010000: begin
        operation_result <= xnor_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end

    //Caso do Ou exclusivo lógico
    8'b00010001: begin
        operation_result <= xor_result;
        Flags[0] <= (operation_result == 0) ? 1 : 0;
        Flags[1] <= 0;
        Flags[2] <= operation_result[7];
        Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end

    //Caso de Rolar à esquerda
    8'b00010010: begin
        operation_result <= rol_result;
        Flags[0] <= (operation_result == 8'b0) ? 1'b1 : 1'b0;
        Flags[1] <= operand1[7];
        Flags[2] <= operation_result[7];
        Flags[3] <= ~^(operation_result);
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
end

    //Caso de rolar à direita
    8'b00010011: begin
    operation_result <= ror_result;
    Flags[0] <= (operation_result == 8'b0) ? 1'b1 : 1'b0;
    Flags[1] <= operand1[0];
    Flags[2] <= operation_result[7];
    Flags[3] <= (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] <= 0;
    Flags[5] <= 0;
    Flags[6] <= 0;
end

    default: begin
        operation_result <= 8'b00000000;
        Flags[0] <= 1;
        Flags[1] <= 0;
        Flags[2] <= 0;
        Flags[3] <= 1;
        Flags[4] <= 0;
        Flags[5] <= 0;
        Flags[6] <= 0;
    end



    

    endcase    
    end
endmodule

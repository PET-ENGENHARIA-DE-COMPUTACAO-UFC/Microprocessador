`include "arithmetic//adder.v"
`include "arithmetic//decrement.v"
`include "arithmetic//divisor.v"
`include "arithmetic//increment.v"
`include "arithmetic//div_module.v"
`include "arithmetic//multiplier.v"
`include "arithmetic//subtractor.v"
`include "arithmetic//shift_left.v"
`include "arithmetic//shift_right.v"
`include "logic//and.v"
`include "logic//nand.v"
`include "logic//nor.v"
`include "logic//or.v"
`include "logic//xnor.v"
`include "logic//xor.v"

/*
Flags[0] = Zero Flag
Flags[1] = Carry Flag
Flags[2] = Sinal
Flags[3] = Paridade
Flags[4] = Interrupção
Flags[5] = Direção
Flags[6] = Overflow
*/

/*
Para propósitos de teste faremos:
soma = 00000001
subtração = 00000010
multiplicação = 00000011
divisão = 00000100
incremento = 00000101
decremento = 00000110
módulo = 00000111
shiftleft = 00001000
shiftright = 00001001
and = 00001010
nand = 00001011
nor = 00001101
not = 00001110
or = 00001111
xnor = 00010000
xor = 00010001
*/

module ALU(input[7:0]operand1, input[7:0]operand2, output[7:0]operation_result, input ALU_sel, output[6:0]Flags);
wire[7:0] add_result, sub_result, increment_result, decrement_result, mod_result, mult_result, div_result, sr_result, sl_result;
wire[7:0] and_result, nand_result, nor_result, not_result, or_result, xnor_result, xor_result;
wire add_carry, sub_carry, div_rest, inc_carry, dec_carry;

//Somador
adder adder (
    .csum(add_result), 
    .c_outc(add_carry), 
    .numf1(operand1), 
    .numf2(operand2)
);

//Subtrator
subtractor subtractor (
    .csub(sub_result),
    .c_outc(sub_carry),
    .numf1(operand1),
    .numf2(operand2)
);

//Incrementador de 1
increment incrementor (
    .result(increment_result),
    .cout(inc_carry),
    .num1(operand1)
);

//Decrementador de 1
decrement decrementor (
    .result(decrement_result),
    .cout(dec_carry),
    .num1(operand1)
);

//Multiplicador
multiplier multiplier(
    .result(mult_result),
    .num1(operand1),
    .num2(operand2)
);

//Divisor
divisor divisor(
    .result(div_result),
    .rest(div_rest),
    .num1(operand1),
    .num2(operand2)
);

//Cálculo do Módulo
div_module div_module(
    .rest(mod_result),
    .num1(operand1),
    .num2(operand2)
);

shift_left left_shifter(
    .a(operand1),
    .y(sl_result)
    
);

shift_right shift_right(
    .a(operand1),
    .y(sr_result)
);

and and_gate(
    .result(and_result),
    .num1(operand1),
    .num2(operand2)
);

nand nand_gate(
    .result(nand_result),
    .num1(operand1),
    .num2(operand2)
);

nor nor_gate(
    .result(nor_result),
    .num1(operand1),
    .num2(operand2)
);

not not_gate(
    .result(not_result),
    .num1(operand1)
);

or or_gate(
    .result(or_result),
    .num1(operand1),
    .num2(operand2)
);

xnor xnor_gate(
    .result(xnor_result),
    .num1(operand1),
    .num2(operand2)
);

xor xor_gate(
    .result(xor_result),
    .num1(operand1),
    .num2(operand2)
);

always@(operand1, operand2, ALU_sel) begin
    case(ALU_sel)

    //Caso do somador
    8'b00000001 begin: //Soma
    operation_result = add_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = add_carry;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = (operand1[7] == operand2[7]) && (operand1[7] != operation_result[7]);
    end

    //Caso do subtrator
    8'b00000010 begin:
    operation_result = sub_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = sub_carry;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = (operand1[7] != operand2[7]) && (operand1[7] == operation_result[7]);

    end

    //Caso do incremento em 1
    8'b00000101 begin:
    y = increment_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = inc_carry;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = (operand1[7] == operand2[7]) && (operand1[7] != operation_result[7]);
    end

    //Caso do decremento em 1
    8'b00000110 begin:
    y = decrement_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = dec_carry;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = (operand1[7] != operand2[7]) && (operand1[7] == operation_result[7]);
    end

    //Caso do multiplicador
    8'b00000011 begin:
    y = mult_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = (operand1[7] == operand2[7]) && (operand1[7] != operation_result[7]);
    end

    //Caso do divisor
    8'b00000100 begin:
    y = div_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = (operand2 == 0) ? 1 : 0;
    end

    //Caso do cálculo do resto da divisão
    8'b00000111 begin:
    y = mod_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = (operand2 == 0) ? 1 : 0;
    end

    //Caso do shift left
    8'b00001000 begin:
    y = sl_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = operand1[7];
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 1;
    Flags[6] = (operand1[7] != operation_result[7]);
    end

    //Caso do shift right
    8'b00001001 begin:
    y = sr_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = operand1[0];
    Flags[2] = (operand1[7] == 1) ? 1 : operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end

    //Caso do E lógico
    8'b00001010 begin:
    y = and_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end

    //Caso do E negado lógico
    8'b00001011 begin:
    y = nand_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end

    //Caso do Ou negado lógico
    8'b00001101 begin:
    y = nor_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end

    //Caso da negação lógica
    8'b00001110 begin:
    y = not_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end

    //Caso do Ou lógico
    8'b00001111 begin:
    y = or_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end

    //Caso do Ou negado exclusivo lógico
    8'b00010000 begin:
    y = xnor_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end

    //Caso do Ou exclusivo lógico
    8'b00010001 begin:
    y = xor_result;
    Flags[0] = (operation_result == 0) ? 1 : 0;
    Flags[1] = 0;
    Flags[2] = operation_result[7];
    Flags[3] = (operation_result[0] ^ operation_result[1] ^ operation_result[2] ^ operation_result[3] ^ operation_result[4] ^ operation_result[5] ^ operation_result[6] ^ operation_result[7]) ? 0 : 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end

    default: begin
    y = 8'b00000000;
    Flags[0] = 1;
    Flags[1] = 0;
    Flags[2] = 0;
    Flags[3] = 1;
    Flags[4] = 0;
    Flags[5] = 0;
    Flags[6] = 0;
    end



    

    
    
endmodule

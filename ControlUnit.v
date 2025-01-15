`timescale 1ps/1ps
module ControlUnit(input [23:0]control_signal, input clk, input reset, output reg regWriteEnable, output reg regReadEnable, output reg[7:0]ALU_sel,  output reg[7:0] adr_1, output reg[7:0]adr_2, output reg[7:0]adr_3, output reg[7:0]WriteData);

localparam FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10;
reg[0:1] current_state, next_state;

always@(posedge clk or posedge reset) begin
    if(reset)
        current_state <= FETCH;
    else
        current_state <= next_state;
end

    always@(*) begin
        regWriteEnable = 0;
        regReadEnable = 0;
        ALU_sel = 8'b0;
        adr_1 = 8'b0;
        adr_2 = 8'b0;
        adr_3 = 8'b0;
        WriteData = 8'b0;
        next_state = FETCH;

        case(current_state) 
        FETCH: begin
        regReadEnable = 1'b1;
        next_state = DECODE;
        end
        DECODE: begin
            case(control_signal[0:7])
            8'b0000001: begin//STR_IMM: Guarda o valor do operando num registrador da memória
            regWriteEnable <= 1'b1; 
            regReadEnable <= 1'b0;
            adr_3 <= control_signal[8:15];
            WriteData <= control_signal[16:23];
            end

            8'b00000010: begin//STR_DIR: Guarda o valor no endereço do operando num registrador de destino na memória
            regWriteEnable <= 1'b1; 
            regReadEnable <= 1'b0;
            adr_3 <= control_signal[8:15];
            WriteData <= control_signal[16:23];
            end

            8'b00000011: begin //LOA_IMM: Carrega um valor da memória num registrador de destino          
            end

            8'b00000100: begin//LOA_DIR: Carrega o valor no endereço do operando no registrador de destino       
            end

            8'b00011010: begin//MOV: Move um valor de um registrador para outro
            end

            8'b00010111: begin//REA_ADR: Realiza a operação de leitura em um endereço de memória
            end
            
            8'b00000011: begin//ADD: Realiza a soma do valor no endereço um e do valor no endereço dois e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23]; 
            end

            8'b00000010: begin//STR_DIR: Guarda o valor no endereço do operando num registrador de destino na memória
            regWriteEnable <= 1'b1; 
            regReadEnable <= 1'b0;
            adr_3 <= control_signal[8:15];
            WriteData <= control_signal[16:23];
            end

            8'b00000100: begin //SUB_AB: Realiza a subtração do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23]; 
            end

            8'b00000101: begin//MUL_AB: Realiza a multiplicação do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23]; 
            end

            8'b00000110: begin//DIV_AB: Realiza a divisão do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23]; 
            end

            8'b00000111: begin//MOD_AB: Calcula o resto da divisão do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23]; 
            end

            8'b00001000: begin//AND_AB: Calcula o E lógico do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23]; 
            end

            8'b00001001:begin //OR_AB: Calcula o Ou lógico do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23];
            end

            8'b00001010: begin//NOT_A: Calcula a negação do valor no registrador A
            end

            8'b00001011: begin//NOT_B: Calcula a negação do valor no registrador B
            end

            8'b00001100: begin//XOR_AB: Calcula o Ou exclusivo do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23];
            end

            8'b00001101: begin//NOR_AB: Calcula o Não-Ou lógico do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23];
            end

            8'b00001110: begin//NAND_AB: Calcula o Não-E lógico do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23];
            end

            8'b00001111: begin//XNOR_AB: Calcula o Não-Ou exclusivo do valor no registrador A e do valor no registrador B e guarda seu valor no registrador C
            regWriteEnable <= 1'b0; 
            regReadEnable <= 1'b1;
            adr_1 <= control_signal[8:15];
            adr_2 <= control_signal[16:23];
            end

            8'b00010000: begin//INC_A: Incrementa o operando no valor do registrador A e armazena seu valor em C
            end

            8'b00010001: begin//INC_B: Incrementa o operando no valor do registrador B e armazena seu valor em C
            end

            8'b00010010: begin//DEC_A: Decrementa o operando no valor do registrador A e armazena seu valor em C
            end

            8'b00010011: begin//DEC_B: Decrementa o operando no valor do registrador B e armazena seu valor em C
            end

            8'b00010100: begin//SL_A: Realiza a operação shift left no registrador A e armazena seu valor em C
            end

            8'b00010101: begin//SR_A: Realiza a operação shift right no registrador A e armazena seu valor em C
            end

            8'b00010110: begin//ROL_A: Realiza a rotação à esquerda no registrador A e armazena seu valor em C
            end

            8'b00010110: begin//ROR_A: Reaaliza a rotação à Direita no registrador A e armazena seu valor em C
            end
        end

            endcase
    end
endmodule
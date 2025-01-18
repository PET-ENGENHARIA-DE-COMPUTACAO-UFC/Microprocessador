# Processador AGM-V

O projeto do processador foi pelos alunos do PET Eng Comp UFC em colaboração com um amigo dos membros.

## Como usar
É válido ressaltar que o código que deve ser usado deve ser o da branch "Gabriel_Amorim".


A lógica do Assembly é simples e funciona linha a linha, em que você adiciona a instrução (qualquer uma das 27 listadas na tabela de opcodes) e a quantidade de operandos necessários para essa operação, sendo esses operandos "A" e/ou "B". O arquivo deverá ser chamado **instructions.txt**.

Segue um exemplo de entrada:

```
ADD # comentario inline
A
B
SL
A
# Comentario qualquer
```   

## Tabela de opcodes 

| **Mnemônico** | **Opcode** | **Descrição** | **Exemplo** |
|---------------|------------|---------------|-------------|
| STR_IMM       | 00000001   | Guarda o valor do operando num registrador na memória destino | STR_IMM `$reg_{dest}$`, bin |
| STR_DIR       | 00000010   | Guarda o valor que está no endereço do operando num registrador de destino na memória | STR_DIR `$reg_{dest}$`, bin |
| LOA_IMM       | 00000011   | Carrega um valor da memória num registrador de destino | LOA_IMM `reg_dest`, bin |
| LOA_DIR       | 00000100   | Carrega o valor no endereço do operando no registrador de destino | LOA_DIR `$reg_{dest}$`, bin |
| MOV           | 00000101   | Move um valor de um registrador para outro | MOV `$reg_{dest}$`, `$reg_{org}$` |
| ADD           | 00000110   | Soma dois valores e guarda o resultado no registrador C | ADD `$reg_{o1p}$`, `$reg_{op2}$` |
| SUB           | 00000111   | Subtrai o primeiro pelo segundo valor e guarda o resultado no registrador C | SUB `$reg_{o1p}$`, `$reg_{op2}$` |
| MULT          | 00001000   | Multiplica dois valores e guarda o resultado no registrador C | MUL `$reg_{o1p}$`, `$reg_{op2}$` |
| DIV           | 00001001   | Divide o primeiro valor pelo segundo e guarda o resultado no registrador C | DIV `$reg_{op1}$`, `$reg_{op2}$` |
| INC           | 00001010   | Incrementa o valor no registrador | INC `$reg_{op}$` |
| DEC           | 00001011   | Decrementa o valor no registrador | DEC `$reg_{op}$` |
| MOD           | 00001100   | Calcula o resto da divisão de dois valores | MOD `$reg_{o1p}$`, `$reg_{op2}$` |
| SL            | 00001101   | Desloca os bits para a esquerda | SL `$reg_{op}$` |
| SR            | 00001110   | Desloca os bits para a direita | SR `$reg_{op}$` |
| L_AND         | 00001111   | Calcula o E lógico entre dois valores | L_AND `$reg_{o1p}$`, `$reg_{op2}$` |
| L_NAND        | 00010000   | Calcula o Não-E lógico entre dois valores | L_NAND `$reg_{o1p}$`, `$reg_{op2}$` |
| L_NOR         | 00010001   | Calcula o Não-Ou lógico entre dois valores | L_NOR `$reg_{o1p}$`, `$reg_{op2}$` |
| L_NOT         | 00010010   | Calcula a negação lógica do valor no registrador | L_NOT `$reg_{op}$` |
| L_OR          | 00010011   | Calcula o Ou lógico entre dois valores | L_OR `$reg_{o1p}$`, `$reg_{op2}$` |
| L_XNOR        | 00010100   | Calcula o Não-Ou exclusivo entre dois valores | L_XNOR `$reg_{o1p}$`, `$reg_{op2}$` |
| L_XOR         | 00010101   | Calcula o Ou exclusivo entre dois valores | L_XOR `$reg_{o1p}$`, `$reg_{op2}$` |
| L_ROL         | 00010110   | Rotaciona os bits para a esquerda | L_ROL `$reg_{op}$` |
| L_ROR         | 00010111   | Rotaciona os bits para a direita | L_ROR `$reg_{op}$` |
| JMP           | 00011001   | Realiza um salto para o endereço especificado | JMP Address |
| CALL          | 00011010   | Salva o endereço atual e realiza um salto | CALL |
| RET           | 00011011   | Retorna ao endereço salvo pelo CALL | RET |
| READ          | 00011100   | Realiza a leitura de um registrador | READ `$reg_{op}$` |


Onde `$reg_{dest}$` = destino, `$reg_{org}$` = origem e `$reg_{op}$` = registrador em que a operação ocorrerá.

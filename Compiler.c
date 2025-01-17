#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

// O que vamos fazer? ler um arquivo, ler o que tem dentro dele e comparar com os nossos OPCODES
// Sinalização de instrução e parâmetros.

// void depura(char *string)
//{
//     for (int i = 0; i < strlen(string); i++)
//     {
//         printf("string[%d] = '%c' (ASCII: %d)\n", i, string[i], string[i]);
//     }
// }

int len(char *string) // Calcula o tamanho da string, antes do \0
{
    int c = 0;
    char *index;
    index = string;
    while (*index != '\0')
    {
        c++;
        index++;
    }
    return c;
}

char *gts(char *string, int n, FILE *file) // fgets so que implementado
{
    int c;
    char *concat;
    concat = string;

    while (--n > 0 && (c = getc(file)) != EOF)
    {
        if ((*(concat++) = c) == '\n')
        {
            break;
        }
    }
    concat--;
    if (*concat != '\n')
        concat++;
    *concat = '\0';

    return (c == EOF && concat == string) ? NULL : string;
}

int binaryCheck(char *string)
{
    char zero[] = "0";
    char one[] = "1";

    char *index;
    index = string;
    int length = len(string);
    int counter0 = 0;
    int counter1 = 0;
    for (int i = 0; i < length; i++)
    {
        if (*(index + i) == zero[0])
            counter0++;
        else if (*(index + i) == one[0])
            counter1++;
    }
    if (counter0 + counter1 == length)
    {
        return 0;
    }
    return -1;
}

//Função para remover os espaços em "branco"
void eraser(char*string){
    // índices para percorrer a string, sendo o índice i para a posição que está sendo verificada e j para a posição do último caractere válido
    int i = 0; 
    int j = 0; 

    while (string[i] != '\0') {

        if (!isspace((unsigned char)string[i])) {
            // Se não for um espaço em branco, copiamos o caractere para a posição j
            string[j] = string[i];
            j++;
        }

        i++; // Avançar para o próximo caractere
    }

    // Adicionar o terminador de string '\0' após o último caractere válido
    string[j] = '\0';
}


//Função para remover os comentários
void remove_comments(char* string){
    eraser(string);
    char* find = strchr(string, '#'); // Encontra o primeiro '#'
    if (find != NULL) {
        *find = '\0'; // Substitui o '#' e tudo que vem depois por um terminador de string
    }
}

//Função para substituir as entradas pelo endereço de memória correspondentes
void replace_registers(char *string) {
    if (strcmp(string, "A") == 0) {
        strcpy(string, "00000000");
    } else if (strcmp(string, "B") == 0) {
        strcpy(string, "00000001");
    } else if (strcmp(string, "C") == 0) {
        strcpy(string, "00000010");
    }
}

struct OPCODE
{
    char *code;     // OPCODE propriamente dito, o nosso codigo so que convertido para binário
    int parameters; // Quantos parâmetros nossa instrução pede.
};

struct OPCODE comparator(char *buffer)
{
    struct OPCODE opcode;
    if(strcmp(buffer, "STR_IMM") == 0)
    {
        opcode.code = "00000001";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "STR_DIR") == 0)
    {
        opcode.code = "00000010";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer,"LOA_IMM") == 0)
    {
        opcode.code = "00011000";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "LOA_DIR") == 0)
    {
        opcode.code = "00011001";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "MOV") == 0){
        opcode.code = "00011010";
        opcode.parameters = 2;
        return opcode;
    }
    //Operações aritméticas
    else if (strcmp(buffer, "ADD") == 0)
    {
        opcode.code = "00000011"; 
        opcode.parameters = 2;    
        return opcode;
    }
    else if (strcmp(buffer, "SUB") == 0)
    {
        opcode.code = "00000100"; 
        opcode.parameters = 2;    
        return opcode;
    }
    else if(strcmp(buffer, "MULT") == 0)
    {
        opcode.code = "00000101";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "DIV") == 0)
    {
        opcode.code = "00000110";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "INC") == 0)
    {
        opcode.code = "00010000";
        opcode.parameters = 1;
        return opcode;
    }
    else if(strcmp(buffer, "DEC") == 0)
    {
        opcode.code = "00010010";
        opcode.parameters = 1;
        return opcode;
    }
    else if(strcmp(buffer, "MOD") == 0)
    {
        opcode.code = "00000111";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "SL") == 0)
    {
        opcode.code = "00010100";
        opcode.parameters = 1;
        return opcode;
    }
    else if(strcmp(buffer, "SR") == 0)
    {
        opcode.code = "00010101";
        opcode.parameters = 1;
        return opcode;
    }
    // Operações lógicas
    else if(strcmp(buffer, "L_AND") == 0)
    {
        opcode.code = "00001000";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "OR") == 0)
    {
        opcode.code = "00001001";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "L_NOT") == 0)
    {
        opcode.code = "00001010";
        opcode.parameters = 1;
        return opcode;
    }
    else if(strcmp(buffer, "L_NOR") == 0)
    {
        opcode.code = "00001101";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "L_NAND") == 0)
    {
        opcode.code = "00001110";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "L_XNOR") == 0)
    {
        opcode.code = "00001111";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "L_XOR") == 0)
    {
        opcode.code = "00010001";
        opcode.parameters = 2;
        return opcode;
    }
    else if(strcmp(buffer, "L_ROL") == 0)
    {
        opcode.code = "00010110";
        opcode.parameters = 1;
        return opcode;
    }
    else if(strcmp(buffer, "L_ROR") == 0)
    {
        opcode.code = "00010111";
        opcode.parameters = 1;
        return opcode;
    }
    else if(strcmp(buffer, "CMP") == 0)
    {
        opcode.code = "00011000";
        opcode.parameters = 2;
        return opcode;
    }
    else
    {
        opcode.code = NULL;
        opcode.parameters = 0;
        return opcode;
    }
}

int main()
{
    FILE *instructions = fopen("C:\\Users\\matri\\Documents\\4_semestre\\Microprocessadores\\Projeto\\Microprocessador\\instructions.txt", "r");    
    FILE *binary = fopen("C:\\Users\\matri\\Documents\\4_semestre\\Microprocessadores\\Projeto\\Microprocessador\\binary.txt", "w");
    char *CurrentLine = malloc(100 * sizeof(char));

    if (instructions == NULL)
    {
        printf("Unable to open the file");
    }
    else
    {
        while (gts(CurrentLine, 100, instructions) != NULL) // CHECAGENS E ESCRITA EM BINARY
        {
            remove_comments(CurrentLine);
            printf("Line after removing comments: '%s'\n", CurrentLine);

            if (strlen(CurrentLine) == 0) { // Ignora linhas vazias
                continue;
            }
            struct OPCODE code = comparator(CurrentLine); // Contêm a primeira frase

            // CHECAGEM DE SE FAZ PARTE DO NOSSO ASSEMBLY OU NAO A INSTRUÇÃO RECEBIDA
            if(code.code == NULL){
                printf("Error! This instruction: %s is not a part of our assembly!\n", CurrentLine);
                goto CompileError;
            }
            int parameters = code.parameters;
            if (code.parameters > 0 && code.code != NULL) // Vê se a instrução espera algum parâmetro e se é uma instrução ou um parâmetro
            {
                fprintf(binary, "%s\n", code.code); // IMPRIME NO ARQUIVO BINARY O OPCODE, ALTERAR, ESSA IMPRESSAO AQUI FICA NA PARTE DE CHECAGEM DE SE FAZ PARTE DO ASSEMBLY OU NAO
                for (int i = 0; i < parameters; i++)
                {
                    if (gts(CurrentLine, 100, instructions) != NULL)
                    { // SEMPRE AO CHAMAR GTS s recebe a proxima linha
                        
                        int b = 0;
                        remove_comments(CurrentLine);
                        replace_registers(CurrentLine);

                        code = comparator(CurrentLine);
                        if (code.code != NULL) // Checa se nao recebeu outra instrução
                        {
                            printf("\nExpected a parameter, received an instruction");
                            goto CompileError;
                        }
                        else if ((b = len(CurrentLine)) != 8) // Checa se a string tem 8 caracteres, 8 bits.
                        {
                            printf("\nExpected 8, received %d bits", b);
                            goto CompileError;
                        }
                        else if (binaryCheck(CurrentLine) == -1) // Checa se o parâmetro é binário
                        {
                            printf("\nExpected binary, received non-binary parameter ");
                            goto CompileError;
                        }
                        fprintf(binary, "%s\n", CurrentLine);
                    }
                    else
                    {
                        printf("\nExpected %d, received %d", code.parameters, i);
                        goto CompileError;
                    }
                }
            }
            else
            {
                printf("\nExpected an instruction received an parameter");
                goto CompileError;
            }
        }
    }

    fclose(instructions);
    fclose(binary);
    free(CurrentLine);
    CurrentLine = NULL;

    return 0;

CompileError:
    fclose(instructions);
    fclose(binary);
    binary = fopen("binary.txt", "w"); // ARQUIVO BINARIO FICA EM BRANCO JA QUE FALHOU A COMPILAÇÃO
    fclose(binary);
    free(CurrentLine);
    CurrentLine = NULL;
    return -1;
}

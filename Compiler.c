#include <stdio.h>
#include <string.h>
#include <stdlib.h>

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

struct OPCODE
{
    char *code;     // OPCODE propriamente dito, o nosso codigo so que convertido para binário
    int parameters; // Quantos parâmetros nossa instrução pede.
};

struct OPCODE comparator(char *buffer)
{
    struct OPCODE opcode;
    if (strcmp(buffer, "ADD") == 0)
    {
        // Para o caso ADD, temos os seguintes:
        opcode.code = "00000001"; //"ADD" = 00000001
        opcode.parameters = 2;    // Espera 2 parâmetros
        return opcode;
    }
    else if (strcmp(buffer, "SUB") == 0)
    {
        opcode.code = "00000010"; //"ADD" = 00000001
        opcode.parameters = 2;    // Espera 2 parâmetros
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
    FILE *instructions = fopen("instructions.txt", "r");
    FILE *binary = fopen("binary.txt", "w");
    char *CurrentLine = malloc(100 * sizeof(char));

    if (instructions == NULL)
    {
        printf("Unable to open the file");
    }
    else
    {
        while (gts(CurrentLine, 10, instructions) != NULL) // CHECAGENS E ESCRITA EM BINARY
        {

            struct OPCODE code = comparator(CurrentLine); // Contêm a primeira frase

            // COLOCAR AQUI A CHECAGEM DE SE FAZ PARTE DO NOSSO ASSEMBLY OU NAO A INSTRUÇÃO RECEBIDA
            int parameters = code.parameters;
            if (code.parameters > 0 && code.code != NULL) // Vê se a instrução espera algum parâmetro e se é uma instrução ou um parâmetro
            {
                fprintf(binary, "%s\n", code.code); // IMPRIME NO ARQUIVO BINARY O OPCODE, ALTERAR, ESSA IMPRESSAO AQUI FICA NA PARTE DE CHECAGEM DE SE FAZ PARTE DO ASSEMBLY OU NAO
                for (int i = 0; i < parameters; i++)
                {
                    if (gts(CurrentLine, 10, instructions) != NULL)
                    { // SEMPRE AO CHAMAR GTS s recebe a proxima linha
                        int b = 0;
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

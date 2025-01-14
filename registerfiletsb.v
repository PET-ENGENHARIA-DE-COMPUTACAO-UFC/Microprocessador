module RegisterFile_tb;

    // Declaração dos sinais para teste
    reg clk;                       // Sinal de clock
    reg [4:0] A1, A2, A3;          // Endereços dos registradores
    reg [7:0] WriteData;           // Dado para escrita
    reg regWriteEnable;            // Habilita escrita
    wire [7:0] RD1, RD2;           // Dados lidos dos registradores

    // Instancia o módulo RegisterFile
    RegisterFile uut (
        .clk(clk),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WriteData(WriteData),
        .regWriteEnable(regWriteEnable),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Gera o sinal de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock com período de 10 unidades de tempo
    end

    // Gera os estímulos para o teste
    initial begin
        // Inicializa os sinais
        regWriteEnable = 0;
        A1 = 5'b00000;
        A2 = 5'b00001;
        A3 = 5'b00010;
        WriteData = 8'd0;

        // Teste 1: Escreve no registrador 2
        #10;
        regWriteEnable = 1;
        A3 = 5'b00010;  // Escreve no registrador 2
        WriteData = 8'd42; // Valor a ser escrito
        #10;
        regWriteEnable = 0; // Desativa escrita

        // Teste 2: Lê os valores dos registradores 2 e 1
        A1 = 5'b00010;  // Lê do registrador 2
        A2 = 5'b00001;  // Lê do registrador 1
        #10;

        // Teste 3: Escreve em outro registrador
        regWriteEnable = 1;
        A3 = 5'b00100;  // Escreve no registrador 4
        WriteData = 8'd99;
        #10;
        regWriteEnable = 0;

        // Teste 4: Lê os valores dos registradores 4 e 2
        A1 = 5'b00100;  // Lê do registrador 4
        A2 = 5'b00010;  // Lê do registrador 2
        #10;
      	
      	regWriteEnable = 1;
      	A3 = 5'b00001;
      	WriteData = 8'd67;
      	#10
      	regWriteEnable = 0;
      
      	A1 = 5'b00001;
      	A2 = 5'b00010;
      	#10

        // Finaliza a simulação
        $finish;
    end

    // Monitora as mudanças e exibe os valores no console
    initial begin
        $monitor("Tempo: %0t | A1: %d -> RD1: %d | A2: %d -> RD2: %d | A3: %d -> WriteData: %d | regWriteEnable: %b",
                 $time, A1, RD1, A2, RD2, A3, WriteData, regWriteEnable);
    end

endmodule

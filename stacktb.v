// Testbench para o módulo stack
module stack_tb;

    // Parâmetros para o LIFO
    parameter WIDTH = 8;
    parameter DEPTH = 4; // Set a smaller depth for testing

    // Sinais do testbench
    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;
    wire empty;
    wire full;

    // Instância do módulo stack
    stack #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Geração do clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Período de clock de 10 ns
    end

    // Sequência de teste
    initial begin
        // Inicializar sinais
        rst <= 1;
        push <= 0;
        pop <= 0;
        data_in <= 0;

        // Aguardar alguns ciclos de clock
        #10;

        // Liberar reset
        rst <= 0;

        // Testar operações aleatórias de push e pop
      for (integer i = 0; i < 15; i = i + 1) begin
            @(posedge clk);
            if ($random % 2) begin
                push <= 1;
                pop <= 0;
                data_in <= $random & ((1 << WIDTH) - 1); // Gera valores binários limitados a WIDTH bits
            end else begin
                pop <= 1;
                push <= 0;
            end

            // Exibir informações de teste
            $display("[%0t] Operação push=%0d pop=%0d data_in=%b empty=%0b full=%0b data_out=%b", 
                     $time, push, pop, data_in, empty, full, data_out);
        end

        // Encerrar simulação após 100 ns
        #100;
        $finish;
    end
endmodule

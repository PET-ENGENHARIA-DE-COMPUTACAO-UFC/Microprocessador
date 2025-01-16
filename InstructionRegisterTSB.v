module InstructionRegister_tsb;
  // Declaração de sinais
  reg clk;
  reg [7:0] opcode, operando1, operando2;
  wire [23:0] instReg; // Deve ser wire, pois é a saída do módulo

  // Instância do módulo InstructionRegister
  InstructionRegister utt (
    .clk(clk),
    .opcode(opcode),
    .operando1(operando1),
    .operando2(operando2),
    .instReg(instReg)
  );

  // Geração do clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock com período de 10 unidades de tempo
  end

  // Estímulos iniciais
  initial begin
    opcode = 8'b00000001;
    #10
    operando1 = 8'b00000001;
    #10
    operando2 = 8'b00000001;

    #10; // Aguarda 20 unidades de tempo para permitir a propagação
	#10
    $finish; // Termina a simulação
  end

  // Monitoramento dos sinais
  initial begin
    $monitor("tempo %0t | opcode: %b | operando1: %b | operando2: %b | instReg: %b | clk: %d",
             $time, opcode, operando1, operando2, instReg, clk);
  end
endmodule

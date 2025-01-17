module InstructionRegister(
  input wire IR_load,
  input wire clk,
  input wire [7:0] opcode,
  input wire [7:0] operando1,
  input wire [7:0] operando2,
  output reg [23:0] instReg,
  output reg[1:0] fullRegFlag
);

  parameter delay = 2;
  reg [2:0] counter;

  // Inicialização do contador
  initial begin
    counter = 0;
    fullRegFlag = 1'b0;
  end

  // Lógica síncrona com delay
  always @(posedge clk) begin
    if(IR_load) begin
    if (counter < delay) begin
      counter <= counter + 1;
    end else begin
      instReg <= {opcode, operando1, operando2};
      fullRegFlag = 1'b1;
    end
    end
  end

endmodule
module InstructionRegister(
  input wire IR_load,
  input wire clk,
  input wire [7:0] payload,
  output reg [23:0] instReg,
  output reg ReadyFlag);

 reg[7:0] temp[2:0];
 output reg[2:0] counter;

  parameter delay = 3'b010;

  // Inicialização do contador
  initial begin
    counter = 3'b000;
    ReadyFlag = 0;
  end

  // Lógica síncrona com delay
  always @(posedge clk) begin
    if(IR_load) begin
    if (counter < delay) begin
      temp[counter] <= payload;
      counter <= counter + 3'b001;
    end else begin
      instReg <= {temp[00], temp[01], payload};
      ReadyFlag <= 1;
    end
    end
  end

endmodule
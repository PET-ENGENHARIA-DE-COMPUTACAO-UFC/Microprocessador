`include "instructionRegister.v"
`include "pcCounter.v"
`include "MAR.v"
module testbench();

wire clk;


InstructionRegister uut(
    .IR_load(),
    .clk(),
    .payload(),
    .instReg(),
    .ReadyFlag()
);

pcCounter dut(
    .clk(),
    .PC_load(),
    .PC_inc(),
    .PC_en(),
    .PC()
);

MAR tut(
    .MAR_load(),
    .clk(),
    .data(),
    .instruction()
);

endmodule
`timescale 1ns/1ps
module ram
#(
  parameter addr_size = 8,
  parameter data_size = 8
)
(
  input wire clk,
  input wire rst,

  input wire write_en,
  input wire [addr_size-1:0] write_adress,
  input wire [data_size-1:0] data_in,

  input wire rd_en,
  input wire [addr_size-1:0] rd_adress,
  output reg [data_size-1:0] data_out
);


//Declaração da Memória:

reg[7:0] ram [0:255];

initial begin
  $readmemb("binary.mem",ram); 
  end
always@(posedge clk) #5
  begin
    if(rst)
      $readmemb("binary.mem",ram);
    else
      begin 
          ram[write_adress] <= data_in;
          data_out <= ram[rd_adress];
      end
  end
endmodule
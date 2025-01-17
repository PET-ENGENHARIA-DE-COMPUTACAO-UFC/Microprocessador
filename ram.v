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

reg[7:0] ram [255:0];

always@(posedge clk)
  begin
    if(rst)
      ram[write_adress]<= 0;
    else
      begin 
        if(write_en)
          ram[write_adress] <= data_in;
        if(rd_en)
          data_out <= ram[rd_adress];
      end
  end
endmodule
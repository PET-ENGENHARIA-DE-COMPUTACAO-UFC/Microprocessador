module ram
#(
  parameter addr_size = 8,
  parameter data_size = 8
)
(
  input clk,
  input rst,
  
  
  input write_en,
  input [addr_size-1:0]write_adress,
  input [data_size-1:0]data_in,
  
  input rd_en,
  input [addr_size-1:0]rd_adress,
<<<<<<< HEAD
  out reg [data_size-1:0]data_out,
=======
  output reg [data_size-1:0]data_out
>>>>>>> origin/Hubert
);


//Declaração da Memória:

  reg[data_size-1:0] ram[255:0];

always@(posedge clk)
  begin
    if(rst)
      ram[write_adress]<= 'bz;
    else
      begin 
        if(write_en)
          ram[write_adress] <= data_in;
<<<<<<< HEAD
        if(read_en)
=======
        if(rd_en)
>>>>>>> origin/Hubert
          data_out <= ram[rd_adress];
      end
  end
endmodule
`include "pcCounter.v"
module testbench();
  reg clk;
  reg [7:0] PC_load;
  reg PC_en, PC_inc;
  wire [7:0] PC;

  pcCounter uut (
    .clk(clk),
    .PC_load(PC_load),
    .PC_inc(PC_inc),
    .PC_en(PC_en),
    .PC(PC)
  );

  initial begin
    clk = 0;
    forever #10 clk = ~clk;  
  end

  initial begin
    PC_load = 8'b00000000; PC_en = 1; PC_inc = 0; #20;
    display;

    PC_inc = 1; #20;
    display;

    PC_inc = 1; #20;
    display;

    PC_inc = 1; #20;
    display;

    PC_load = 8'b11011001; PC_en = 1; PC_inc = 0; #20;
    display;

    PC_inc = 1; #20;
    display;

    $stop;  
  end

  task display;
    #1 $display("PC = %b", PC);
  endtask

endmodule

`timescale 1ns / 1ps

module ram_tb;

// Parameters
parameter ADDR_SIZE = 8;
parameter DATA_SIZE = 8;

// Testbench Signals
reg clk;
reg rst;
reg write_en;
reg rd_en;
reg [ADDR_SIZE-1:0] write_adress;
reg [ADDR_SIZE-1:0] rd_adress;
reg [DATA_SIZE-1:0] data_in;
wire [DATA_SIZE-1:0] data_out;

// Instantiate the RAM module
ram #(
  .addr_size(ADDR_SIZE),
  .data_size(DATA_SIZE)
) dut (
  .clk(clk),
  .rst(rst),
  .write_en(write_en),
  .write_adress(write_adress),
  .data_in(data_in),
  .rd_en(rd_en),
  .rd_adress(rd_adress),
  .data_out(data_out)
);

// Clock Generation
always #5 clk = ~clk; // 100 MHz clock, period = 10ns

// Testbench Procedure
initial begin
  // Initialize signals
  clk = 0;
  rst = 1; // Apply reset
  write_en = 0;
  rd_en = 0;
  write_adress = 0;
  rd_adress = 0;
  data_in = 0;

  // Wait for a few clock cycles under reset
  #20;
  rst = 0; // Release reset

  // Test 1: Write data to the RAM and then read it back
  $display("Test 1: Writing and reading back data.");
  write_en = 1;
  write_adress = 8'hA5;  // Write address
  data_in = 8'h3C;       // Write data
  #10;                   // Wait one clock cycle
  write_en = 0;          // Disable write

  rd_en = 1;
  rd_adress = 8'hA5;     // Read from the same address
  #10;                   // Wait one clock cycle
  rd_en = 0;

  // Check the output
  if (data_out == 8'h3C)
    $display("PASS: Data read from address 0xA5 matches expected value 0x3C.");
  else
    $display("FAIL: Data read from address 0xA5 does not match expected value.");

  // Test 2: Write data to multiple addresses and read them back
  $display("Test 2: Writing and reading back data from multiple addresses.");
  write_en = 1;
  write_adress = 8'h10;  // Write to address 0x10
  data_in = 8'h55;       // Write data 0x55
  #10;
  write_adress = 8'h20;  // Write to address 0x20
  data_in = 8'hAA;       // Write data 0xAA
  #10;
  write_en = 0;

  // Read back data from address 0x10
  rd_en = 1;
  rd_adress = 8'h10;
  #10;
  if (data_out == 8'h55)
    $display("PASS: Data read from address 0x10 matches expected value 0x55.");
  else
    $display("FAIL: Data read from address 0x10 does not match expected value.");

  // Read back data from address 0x20
  rd_adress = 8'h20;
  #10;
  if (data_out == 8'hAA)
    $display("PASS: Data read from address 0x20 matches expected value 0xAA.");
  else
    $display("FAIL: Data read from address 0x20 does not match expected value.");
  rd_en = 0;

  $display("All tests completed.");
  $finish;
end

endmodule
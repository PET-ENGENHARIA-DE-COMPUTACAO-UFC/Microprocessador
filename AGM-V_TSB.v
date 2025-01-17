`timescale 1ms / 1ps

module processor_tb;

// Testbench signals             // Input clock for the timer
reg rst;                // Reset signal           

// Processor signals (internal wires for monitoring or connections)
reg clk; //Fios de clock e reset
wire [7:0]PC_load_wire; //Fio do sinal de PC load
wire PC_inc_wire, PC_en_wire; //Fios de incremento do PC e enable do PC
wire MAR_load; //Fio de "enable" do MAR
wire IR_load; //Fio de "enable" do IR
wire [23:0]command_word_wire; //Fio com a entrada da Control Unit
wire [7:0]operand1_wire, operand2_wire; //Fios dos operandos da ALU.
wire [7:0]ADR_1_wire, ADR_2_wire; //Fios de endereço a ser lido
wire [7:0]ADR_3_wire; //Fios de endereço a ser escrito
wire [7:0]write_data_wire; //Fio de dados a serem escritos
wire regWriteEnable_wire; //Fio do enable da escrita
wire regReadEnable_wire; //Fio do enable da leitura
wire [7:0]ALU_sel_wire; //Fio do sinal de controle da ALU
wire [7:0]PC_adress_wire; //Fio do endereço apontado pelo PC
wire [7:0]RAM_instruction_wire; //Fio da instrução lida pelo MAR
wire [7:0]IR_opcode_wire; //Fio da instrução lida pelo MAR
wire [7:0]IR_operand1_wire; //Fio da instrução lida pelo MAR
wire [7:0]IR_operand2_wire; //Fio da instrução lida pelo MAR
wire [2:0]compare_result_wire; //Fio da instrução lida pelo MAR
wire [6:0]flag_wire;
// Instantiate the processor module
processor DUT();

// clock:

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

// Stimulus block
initial begin
    // Initialize reset
    rst = 1;  // Assert reset
    #20;      // Hold reset for 20ns
    rst = 0;  // Release reset

    #20

    DUT.RandomAcessMemory.init_memory(8'b00000000, 8'b00000001);
    DUT.RandomAcessMemory.init_memory(8'b00000001,  8'b00000000); // -> 000000
    DUT.RandomAcessMemory.init_memory(8'b00000010 , 8'b00000010);

    #20

    DUT.RandomAcessMemory.init_memory(8'b00000011 , 8'b00000001);
    DUT.RandomAcessMemory.init_memory(8'b00000100 , 8'b00000001); // -> endereço registrador b
    DUT.RandomAcessMemory.init_memory(8'b00000101 , 8'b00000010);

    #20

    DUT.RandomAcessMemory.init_memory(8'b00000110 , 8'b00000011);
    DUT.RandomAcessMemory.init_memory(8'b00000111, 8'b00000000); // -> 000000
    DUT.RandomAcessMemory.init_memory(8'b00001000, 8'b00000001);

    #20;

    // Stop the simulation
    $finish;
end

// Monitor key signals
initial begin
    $monitor(
        "Time: %0dns | rst: %b | clk: %b | A: %b | B: %b | C: %b | memoria aleatoria: %b", 
        $time, rst, clk, registers[00000] ,registers[00001], registers[00010], DUT.RandomAcessMemory[00000000]
    );
end

// Waveform dump for debugging
initial begin
    $dumpfile("processor_tb.vcd");  // VCD file for waveform analysis
    $dumpvars(0, processor_tb);     // Dump all variables in this testbench
end

endmodule

module MAR(
    input wire clk,
    input wire [7:0] address, // Address from the pcCounter
    input wire [7:0] memory[255:0], // RAM Memory
    output reg [7:0] instruction //  Output instruction
);


    always@(posedge clk) begin
        if(address >= 0 && address <= 255)begin
            instruction <= memory[address];
        end
    end

endmodule
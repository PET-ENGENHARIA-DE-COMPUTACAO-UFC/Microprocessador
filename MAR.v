module MAR(
    input MAR_load,
    input wire [7:0] address, // Address from the pcCounter
    input reg [7:0] memory[255:0], // RAM Memory
    output reg [7:0] instruction //  Output instruction
);


    always@(posedge clk) begin
        if(MAR_load)begin
        if(address > 0 && address < 255) begin
            instruction <= memory[address];
        end
        end
    end

endmodule
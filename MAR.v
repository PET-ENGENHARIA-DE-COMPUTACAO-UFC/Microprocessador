module MAR(
    input MAR_load,
    input clk,
    input wire [7:0] data, // Address from the pcCounter
    output reg [7:0] instruction //  Output instruction
);


    always@(posedge clk) begin
        if(MAR_load)begin
            instruction <= data;
        end
    end

endmodule
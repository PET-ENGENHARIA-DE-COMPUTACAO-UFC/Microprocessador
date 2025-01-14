module rol (
    input  [7:0] a,
    output [7:0] y
);
    assign y = {a[6:0], a[7]};
endmodule
module ror (
    input  [7:0] a,
    output [7:0] y
);
    assign y = {a[0], a[7:1]};
endmodule
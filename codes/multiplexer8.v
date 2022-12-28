module Multiplexer8 #(
    parameter DATA_W = 64
) (
    input [2:0] select,
    input [DATA_W-1:0] a,
    input [DATA_W-1:0] b,
    input [DATA_W-1:0] c,
    input [DATA_W-1:0] d,
    input [DATA_W-1:0] e,
    input [DATA_W-1:0] f,
    input [DATA_W-1:0] g,
    input [DATA_W-1:0] h,
    output [DATA_W-1:0] out
);

wire [DATA_W-1:0] out1;
wire [DATA_W-1:0] out2;

Multiplexer4 M41 (select[1:0], a, b, c, d, out1);
Multiplexer4 M42 (select[1:0], e, f, g, h, out2);

assign out = (select[2] == 0) ? out1 : out2;
    
endmodule
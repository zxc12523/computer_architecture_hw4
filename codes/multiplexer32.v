module Multiplexer32 #(
    parameter DATA_W = 64
) (
    input [4:0] select,
    input [DATA_W-1:0] a,
    input [DATA_W-1:0] b,
    input [DATA_W-1:0] c,
    input [DATA_W-1:0] d,
    input [DATA_W-1:0] e,
    input [DATA_W-1:0] f,
    input [DATA_W-1:0] g,
    input [DATA_W-1:0] h,
    input [DATA_W-1:0] a1,
    input [DATA_W-1:0] b1,
    input [DATA_W-1:0] c1,
    input [DATA_W-1:0] d1,
    input [DATA_W-1:0] e1,
    input [DATA_W-1:0] f1,
    input [DATA_W-1:0] g1,
    input [DATA_W-1:0] h1,
    input [DATA_W-1:0] a2,
    input [DATA_W-1:0] b2,
    input [DATA_W-1:0] c2,
    input [DATA_W-1:0] d2,
    input [DATA_W-1:0] e2,
    input [DATA_W-1:0] f2,
    input [DATA_W-1:0] g2,
    input [DATA_W-1:0] h2,
    input [DATA_W-1:0] a3,
    input [DATA_W-1:0] b3,
    input [DATA_W-1:0] c3,
    input [DATA_W-1:0] d3,
    input [DATA_W-1:0] e3,
    input [DATA_W-1:0] f3,
    input [DATA_W-1:0] g3,
    input [DATA_W-1:0] h3,
    output [DATA_W-1:0] out
);

wire [DATA_W-1:0] out1;
wire [DATA_W-1:0] out2;
wire [DATA_W-1:0] out3;
wire [DATA_W-1:0] out4;

Multiplexer8 M80 (select[2:0], a, b, c, d, e, f, g, h, out1);
Multiplexer8 M81 (select[2:0], a1, b1, c1, d1, e1, f1, g1, h1, out2);
Multiplexer8 M82 (select[2:0], a2, b2, c2, d2, e2, f2, g2, h2, out3);
Multiplexer8 M83 (select[2:0], a3, b3, c3, d3, e3, f3, g3, h3, out4);


Multiplexer4 M4 (select[4:3], out1, out2, out3, out4, out);
    
endmodule
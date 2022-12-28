module Multiplexer4 #(
    parameter DATA_W = 64
) (
    input [1:0] select,
    input [DATA_W-1:0] a,
    input [DATA_W-1:0] b,
    input [DATA_W-1:0] c,
    input [DATA_W-1:0] d,
    output [DATA_W-1:0] out
);

wire [DATA_W-1:0] out1;
wire [DATA_W-1:0] out2;

assign out1 = (select[0] == 0) ? a : b;
assign out2 = (select[0] == 0) ? c : d;
assign out = (select[1] == 0) ? out1 : out2;
    
endmodule
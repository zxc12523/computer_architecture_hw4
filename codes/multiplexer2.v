module multiplexer2 #(
    parameter DATA_W = 64
) (
    input select,
    input [DATA_W-1:0] a,
    input [DATA_W-1:0] b,
    output [DATA_W-1:0] out
);

assign out = (select == 0) ? a : b;
    
endmodule
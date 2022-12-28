module ALU #(
    parameter DATA_W = 64
) (
    input   [9:0]           opcode,
    input   [DATA_W-1:0]    a,
    input   [DATA_W-1:0]    b,
    output  [DATA_W-1:0]    out
);

reg [DATA_W-1:0] out_r;

assign out = out_r;

always @(*) begin
    case (opcode)
        10'b0100000000: out_r = a + b;
        10'b0100000100: out_r = a ^ b;
        10'b0100000110: out_r = a | b;
        10'b0100000111: out_r = a & b;
        10'b0100000001: out_r = a << b;
        10'b0100000101: out_r = a >> b;
        10'b1000000000: out_r = a + b; 
        10'b1100000000: out_r = a - b; 
        10'b1000000100: out_r = a ^ b; 
        10'b1000000110: out_r = a | b; 
        10'b1000000111: out_r = a & b; 
    endcase
end

endmodule
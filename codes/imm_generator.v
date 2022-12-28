module Imm_Gen #(
    parameter DATA_W = 12
) (
    input [31:0] i_i_inst,
    output [DATA_W-1:0] immediate
);

reg [DATA_W-1:0] imm;

assign immediate = imm;

always @(*) begin
    case(i_i_inst[6:0])
            7'b0000011:     // ld
            begin 
                imm                     = i_i_inst[31:20];
            end
            7'b0100011:     // sd
            begin 
                imm[4:0]                = i_i_inst[11:7];
                imm[11:5]               = i_i_inst[31:25];
            end
            7'b1100011:     // branch
            begin 
                {imm[3:0], imm[10]}     = i_i_inst[11:7];
                {imm[11], imm[9:4]}     = i_i_inst[31:25];
            end
            7'b0010011:     // RI
            begin
                imm                     = i_i_inst[31:20];
            end
        endcase 
end
    
endmodule
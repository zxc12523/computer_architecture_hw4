module BranchUnit #(
    parameter DATA_W = 64,
    parameter ADDR_W = 64
) (
    input   [31:0]          i_inst,
    input   [DATA_W-1:0]    r1,
    input   [DATA_W-1:0]    r2,
    input   [11:0]          imm,
    output                  br,
    output  [ADDR_W-1:0]    br_addr
);

wire beq, bne;

wire signed [11:0] br_addr_w;

assign beq = (i_inst[6:0] == 7'b1100011) & (i_inst[12] == 0);
assign bne = (i_inst[6:0] == 7'b1100011) & (i_inst[12] == 1);
assign br  = (beq & (r1 == r2)) | (bne & (r1 != r2));
assign br_addr_w = imm;
assign br_addr  = br_addr_w[11] == 0 ? br_addr_w << 1 : -((-br_addr_w) << 1);


endmodule
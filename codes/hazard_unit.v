module Hazard_Unit #(
    parameter DATA_W = 64
) (
    input                   i_clk,
    input                   ID_MemRead,
    input   [4:0]           ID_rd,
    input   [DATA_W-1:0]    IF_r1,
    input   [DATA_W-1:0]    IF_r2,
    input   [31:0]          i_inst,
    output                  flush,
    output                  stall,
    output  [1:0]           ind
);

wire        o_load_use_hazard;
wire        o_branch_hazard;
wire        beq, bne, br;
wire [4:0]  IF_rs1, IF_rs2;

assign IF_rs1   = i_inst[19:15];
assign IF_rs2   = i_inst[24:20];

assign beq = (i_inst[6:0] == 7'b1100011) & (i_inst[12] == 0);
assign bne = (i_inst[6:0] == 7'b1100011) & (i_inst[12] == 1);
assign br  = (beq & (IF_r1 == IF_r2)) | (bne & (IF_r1 != IF_r2));

assign o_load_use_hazard = ID_MemRead & ((ID_rd == IF_rs1) || (ID_rd == IF_rs2));
assign o_branch_hazard = br;


reg [1:0] ind_r = 0;
assign ind      = ind_r;
assign flush    = bh_cnt > 0;
assign stall    = o_load_use_hazard;

integer bh_cnt = 0;
integer dh_cnt1 = 0;
integer dh_cnt2 = 0;

always @(posedge i_clk) begin
    if (dh_cnt1 > 1) begin
        dh_cnt1 = dh_cnt1 - 1;
    end

    if (dh_cnt2 > 1) begin
        dh_cnt2 = dh_cnt2 - 1;
    end

    if (bh_cnt > 1) begin
        bh_cnt = bh_cnt - 1;
    end
end

always @(negedge i_clk) begin
    if (dh_cnt1 == 1) begin
        dh_cnt1 = dh_cnt1 - 1;
        ind_r = ind_r - 1;
    end

    if (dh_cnt2 == 1) begin
        dh_cnt2 = dh_cnt2 - 1;
        ind_r = ind_r - 1;
    end

    if (bh_cnt == 1) begin
        bh_cnt = bh_cnt - 1;
    end
end

always @(negedge i_clk) begin
    if (o_load_use_hazard) begin
        ind_r = ind_r + 1;

        if (dh_cnt1 == 0) begin
            dh_cnt1 = 5;
        end
        else begin
            dh_cnt2 = 5;
        end
    end
end

always @(negedge i_clk) begin
    if (o_branch_hazard) begin
        bh_cnt = 5;
    end
end

endmodule
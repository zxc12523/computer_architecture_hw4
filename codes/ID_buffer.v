module ID_buffer #(
    parameter DATA_W = 64
) (
    input i_clk,
    input stall, 
    input Finish, 
    input MemRead,
    input MemWrite,
    input [9:0] ExeOpcode,
    input WriteBack, 
    input [DATA_W-1:0] r1,
    input [DATA_W-1:0] r2,
    input [11:0] immediate,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    output ID_Finish,
    output ID_MemRead,
    output ID_MemWrite,
    output [9:0] ID_ExeOpcode,
    output ID_WriteBack, 
    output [DATA_W-1:0] ID_r1,
    output [DATA_W-1:0] ID_r2,
    output [11:0] ID_immediate,
    output [4:0] ID_rs1,
    output [4:0] ID_rs2,
    output [4:0] ID_rd
);

reg                 Finish_w, Finish_r;
reg                 MemRead_w, MemRead_r;
reg                 MemWrite_w, MemWrite_r;
reg [9:0]           ExeOpcode_w, ExeOpcode_r;
reg                 WriteBack_w, WriteBack_r;
reg [DATA_W-1:0]    r1_w, r1_r, r2_w, r2_r;
reg [11:0]          immediate_w, immediate_r;
reg [4:0]           rs1_w, rs1_r, rs2_w, rs2_r, rd_w, rd_r;

assign ID_Finish = Finish_r;
assign ID_MemRead = MemRead_r;
assign ID_MemWrite = MemWrite_r;
assign ID_ExeOpcode = ExeOpcode_r;
assign ID_WriteBack = WriteBack_r;
assign ID_r1 = r1_r;
assign ID_r2 = r2_r;
assign ID_immediate = immediate_r;
assign ID_rs1 = rs1_r;
assign ID_rs2 = rs2_r;
assign ID_rd = rd_r;

always @(*) begin
    Finish_w    = stall ? 0 : Finish;
    MemRead_w   = stall ? 0 : MemRead;
    MemWrite_w  = stall ? 0 : MemWrite;
    ExeOpcode_w = stall ? 0 : ExeOpcode;
    WriteBack_w = stall ? 0 : WriteBack;
    r1_w        = stall ? 0 : r1;
    r2_w        = stall ? 0 : r2;
    immediate_w = stall ? 0 : immediate;
    rs1_w       = stall ? 0 : rs1;
    rs2_w       = stall ? 0 : rs2;
    rd_w        = stall ? 0 : rd;
end

always @(posedge i_clk) begin
    Finish_r = Finish_w;
    MemRead_r = MemRead_w;
    MemWrite_r = MemWrite_w;
    ExeOpcode_r = ExeOpcode_w;
    WriteBack_r = WriteBack_w;
    r1_r = r1_w;
    r2_r = r2_w;
    immediate_r = immediate_w;
    rs1_r = rs1_w;
    rs2_r = rs2_w;
    rd_r = rd_w;
end

endmodule
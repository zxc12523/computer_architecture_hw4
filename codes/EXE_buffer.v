module EXE_buffer #(
    parameter DATA_W = 64
) (
    input i_clk,
    input ID_Finish,
    input ID_WriteBack,
    input [DATA_W-1:0] ID_out,
    input [4:0] ID_rd,
    output EXE_Finish,
    output EXE_WriteBack,
    output [DATA_W-1:0] EXE_out,
    output [4:0] EXE_rd
);

reg EXE_Finish_w, EXE_Finish_r; 
reg EXE_WriteBack_w;
reg EXE_WriteBack_r;
reg [DATA_W-1:0] EXE_out_w;
reg [DATA_W-1:0] EXE_out_r;
reg [4:0] EXE_rd_w;
reg [4:0] EXE_rd_r;

assign EXE_Finish = EXE_Finish_r;
assign EXE_WriteBack = EXE_WriteBack_r;
assign EXE_out = EXE_out_r;
assign EXE_rd = EXE_rd_r;

always @(*) begin
    EXE_Finish_w    = ID_Finish;
    EXE_WriteBack_w = ID_WriteBack;
    EXE_out_w       = ID_out;
    EXE_rd_w        = ID_rd;
end

always @(posedge i_clk) begin
    EXE_Finish_r = EXE_Finish_w;
    EXE_WriteBack_r = EXE_WriteBack_w;
    EXE_out_r       = EXE_out_w;
    EXE_rd_r        = EXE_rd_w;
end

    
endmodule
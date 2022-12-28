module MEM1_buffer (
    input i_clk,
    input ID_MemRead,
    input [4:0] ID_rd,
    output MEM1_MemRead,
    output [4:0] MEM1_rd
);

reg MEM1_MemRead_w, MEM1_MemRead_r;
reg [4:0] MEM1_rd_w, MEM1_rd_r;

assign MEM1_MemRead = MEM1_MemRead_r;
assign MEM1_rd = MEM1_rd_r;

always @(*) begin
    MEM1_MemRead_w = ID_MemRead;
    MEM1_rd_w = ID_rd;
end

always @(posedge i_clk) begin
    MEM1_MemRead_r = MEM1_MemRead_w;
    MEM1_rd_r = MEM1_rd_w;
end
    
    
endmodule
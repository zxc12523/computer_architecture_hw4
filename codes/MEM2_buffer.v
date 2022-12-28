module MEM2_buffer (
    input i_clk,
    input MEM1_Memread,
    input [4:0] MEM1_rd,
    output MEM2_Memread,
    output [4:0] MEM2_rd
);

reg MEM2_Memread_w;
reg MEM2_Memread_r;
reg [4:0] MEM2_rd_w;
reg [4:0] MEM2_rd_r;

assign MEM2_Memread = MEM2_Memread_r;
assign MEM2_rd = MEM2_rd_r;

always @(*) begin
    MEM2_Memread_w = MEM1_Memread;
    MEM2_rd_w = MEM1_rd;
end

always @(posedge i_clk) begin
    MEM2_Memread_r = MEM2_Memread_w;
    MEM2_rd_r = MEM2_rd_w;
end
    
    
endmodule
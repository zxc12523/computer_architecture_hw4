module IF_buffer #(
    parameter DATA_W = 32
) (
    input                   i_clk,
    input   [1:0]           ind,
    input   [DATA_W-1:0]    i_inst,
    input                   flush, 
    output  [DATA_W-1:0]    o_inst
);

reg [DATA_W-1:0] IF0, IF1, IF2;
reg [DATA_W-1:0] o_inst_r;
reg [1:0] ind_r, ind_w;

assign o_inst = o_inst_r;

initial begin
    IF0 = 0;
    IF1 = 0;
    IF2 = 0;
    ind_r = 0;
    ind_w = 0;
end

always @(ind) begin
    ind_w = ind;
end

always @(posedge i_clk) begin
    if (flush) begin
        o_inst_r = 0;
    end
    else if (ind_w == 0) begin
        o_inst_r = IF0;
    end
    else if (ind_w == 1) begin
        o_inst_r = IF1;
    end
    else if (ind_w == 2) begin
        o_inst_r = IF2;
    end
end

always @(negedge i_clk) begin
    IF2 = IF1;
    IF1 = IF0;
    IF0 = i_inst;
end
    
endmodule
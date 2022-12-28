module PC #(
    parameter ADDR_W = 64
) (
    input                       i_clk,
    input                       i_rst_n,
    input                       stall,
    input                       br,
    input   [ ADDR_W-1 : 0 ]    br_addr,
    output  [ ADDR_W-1 : 0 ]    o_i_addr,
    output                      o_i_valid_addr
);

reg [ADDR_W - 1 : 0] o_i_addr_w = 64'h0;
reg [ADDR_W - 1 : 0] o_i_addr_r = 64'h0;

assign o_i_addr = o_i_addr_r;
assign o_i_valid_addr = 1;

always @(*) begin
    if (stall) begin
        o_i_addr_w = o_i_addr_r;
    end
    else if (br) begin
        o_i_addr_w = o_i_addr_r + br_addr - 16;
    end
    else begin
        o_i_addr_w = o_i_addr_r + 4;
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        o_i_addr_r = 0;
    end
    else begin
        o_i_addr_r = o_i_addr_w; 
    end
end
    
endmodule
module Mem_adder #(
    parameter DATA_W = 64,
    parameter ADDR_W = 64
) (
    input                       ID_MemRead,
    input                       ID_MemWrite,
    input   [DATA_W-1:0]        ID_r1,
    input   [DATA_W-1:0]        ID_r2,
    input   [11:0]              ID_immediate,
    output  [ DATA_W-1 : 0 ]    o_d_w_data,     // to data memory
    output  [ ADDR_W-1 : 0 ]    o_d_w_addr,     // to data memory
    output  [ ADDR_W-1 : 0 ]    o_d_r_addr,     // to data memory
    output                      o_d_MemRead,    // to data memory
    output                      o_d_MemWrite   // to data memory
);

assign o_d_w_data   = ID_r2;
assign o_d_w_addr   = ID_r1 + ID_immediate;
assign o_d_r_addr   = ID_r1 + ID_immediate;
assign o_d_MemRead  = ID_MemRead;
assign o_d_MemWrite = ID_MemWrite;
    
endmodule
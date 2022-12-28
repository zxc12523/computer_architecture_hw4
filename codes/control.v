module Control #(
    parameter INST_W = 32
) (
    input   [INST_W-1:0]    i_i_inst,
    output                  o_MemRead,
    output                  o_MemWrite,
    output  [9:0]           o_ExeOpcode,
    output                  o_WriteBack,
    output                  o_finish
);

reg o_MemRead_r;
reg o_MemWrite_r;
reg o_WriteBack_r;
reg [9:0] o_ExeOpcode_r;
reg o_finish_r;
reg [2:0] func3;
reg [6:0] func7;
reg [6:0] opcode;

assign o_MemRead = o_MemRead_r;
assign o_MemWrite = o_MemWrite_r;
assign o_ExeOpcode = o_ExeOpcode_r;
assign o_WriteBack = o_WriteBack_r;
assign o_finish = o_finish_r;

always @(i_i_inst) begin

    o_finish_r      = 0;
    o_MemRead_r     = 0;
    o_MemWrite_r    = 0;
    o_ExeOpcode_r   = 0;
    o_WriteBack_r   = 0;

    opcode          = i_i_inst[6:0];
    func3           = i_i_inst[14:12];
    func7           = i_i_inst[31:25];

    case(opcode)
        7'b0000011:     // ld
        begin 
            o_MemRead_r             = 1'b1;
        end
        7'b0100011:     // sd
        begin 
            o_MemWrite_r            = 1'b1;
        end
        7'b0010011:     // RI
        begin
            o_ExeOpcode_r           = {7'b0100000, func3};
            o_WriteBack_r           = 1'b1;
        end
        7'b0110011:     // R
        begin 
            o_ExeOpcode_r           = {1'b1, func7[5:0], func3};
            o_WriteBack_r           = 1'b1;
        end
        7'b1111111:     // stop
        begin 
            o_finish_r              = 1'b1;
        end
    endcase
end
    
endmodule
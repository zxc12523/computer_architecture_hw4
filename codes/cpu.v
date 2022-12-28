module cpu #( // Do not modify interface
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input                   i_clk,
    input                   i_rst_n,
    input                   i_i_valid_inst, // from instruction memory
    input  [ INST_W-1 : 0 ] i_i_inst,       // from instruction memory
    input                   i_d_valid_data, // from data memory
    input  [ DATA_W-1 : 0 ] i_d_data,       // from data memory
    output                  o_i_valid_addr, // to instruction memory
    output [ ADDR_W-1 : 0 ] o_i_addr,       // to instruction memory
    output [ DATA_W-1 : 0 ] o_d_w_data,     // to data memory
    output [ ADDR_W-1 : 0 ] o_d_w_addr,     // to data memory
    output [ ADDR_W-1 : 0 ] o_d_r_addr,     // to data memory
    output                  o_d_MemRead,    // to data memory
    output                  o_d_MemWrite,   // to data memory
    output                  o_finish
);

wire                stall, br;
wire [ADDR_W-1:0]   br_addr;
wire                br_hazard, data_hazard;
wire                flush;
wire [1:0]          ind;
wire [INST_W-1:0]   fetched_inst;
wire                IF_Finish;
wire                IF_MemRead;
wire                IF_MemWrite;
wire [9:0]          IF_ExeOpcode;
wire                IF_WriteBack;
wire [DATA_W-1:0]   IF_r1, IF_r2;
wire [11:0]         IF_immediate;
wire [4:0]          IF_rs1, IF_rs2, IF_rd;
wire                ID_Finish;
wire                ID_MemRead;
wire                ID_MemWrite;
wire [9:0]          ID_ExeOpcode;
wire                ID_WriteBack;
wire [DATA_W-1:0]   ID_r1, ID_r2;
wire [11:0]         ID_immediate;
wire [4:0]          ID_rs1, ID_rs2, ID_rd;
wire                MEM1_MemRead;
wire [4:0]          MEM1_rd;
wire                MEM2_MemRead;
wire [4:0]          MEM2_rd;
wire [1:0]          select1, select2;
wire [DATA_W-1:0]   forward1, forward2;
wire [DATA_W-1:0]   DMC_addr, DMC_data;
wire [DATA_W-1:0]   ALU_a, ALU_b, ALU_out;
wire                EXE_Finish;
wire                EXE_WriteBack;
wire [DATA_W-1:0]   EXE_out;
wire [4:0]          EXE_rd;

assign IF_rs1   = fetched_inst[19:15];
assign IF_rs2   = fetched_inst[24:20];
assign IF_rd    = fetched_inst[11:7];
assign stall    = data_hazard;
assign br       = br_hazard;
assign o_finish = EXE_Finish;

PC              PC          (i_clk, i_rst_n, stall, br, br_addr, o_i_addr, o_i_valid_addr);

IF_buffer       IF          (i_clk, ind, i_i_inst, flush, fetched_inst);

Register        REG         (i_clk, IF_rs1, IF_rs2, 
                                EXE_WriteBack, EXE_rd, EXE_out, 
                                MEM2_MemRead, MEM2_rd, i_d_data, 
                                IF_r1, IF_r2);

Imm_Gen         IMM         (fetched_inst, IF_immediate);
Hazard_Unit     HU          (i_clk, ID_MemRead, ID_rd, IF_r1, IF_r2, fetched_inst, flush, stall, ind);
Control         CON         (fetched_inst, IF_MemRead, IF_MemWrite, IF_ExeOpcode, IF_WriteBack, IF_Finish);
BranchUnit      BU          (fetched_inst, IF_r1, IF_r2, IF_immediate, br, br_addr);

ID_buffer       ID          (i_clk, stall, IF_Finish, IF_MemRead, IF_MemWrite, IF_ExeOpcode, IF_WriteBack, IF_r1, IF_r2, IF_immediate, IF_rs1, IF_rs2, IF_rd, 
                                ID_Finish, ID_MemRead, ID_MemWrite, ID_ExeOpcode, ID_WriteBack, ID_r1, ID_r2, ID_immediate, ID_rs1, ID_rs2, ID_rd);

MEM1_buffer     MEM1        (i_clk, ID_MemRead, ID_rd, MEM1_MemRead, MEM1_rd);
MEM2_buffer     MEM2        (i_clk, MEM1_MemRead, MEM1_rd, MEM2_MemRead, MEM2_rd);
Multiplexer4    DMC_Addr    (select1, ID_r1, 64'b0, forward1, forward2, DMC_addr);
Multiplexer4    DMC_Data    (select2, ID_r2, 64'b0, forward1, forward2, DMC_data);
Mem_adder       DMC         (ID_MemRead, ID_MemWrite, DMC_addr, DMC_data, ID_immediate, 
                                o_d_w_data, o_d_w_addr, o_d_r_addr, o_d_MemRead, o_d_MemWrite);

Multiplexer4    ALU_A       (select1, ID_r1, 64'b0, forward1, forward2, ALU_a);
Multiplexer4    ALU_B       (select2, ID_r2, {52'b0, ID_immediate}, forward1, forward2, ALU_b);
ALU             ALU1        (ID_ExeOpcode, ALU_a, ALU_b, ALU_out);

EXE_buffer      EXE         (i_clk, ID_Finish, ID_WriteBack, ALU_out, ID_rd, EXE_Finish, EXE_WriteBack, EXE_out, EXE_rd);

Forward_Unit    FU          (ID_rs1, ID_rs2, ID_ExeOpcode, 
                             EXE_WriteBack, EXE_rd, EXE_out,
                             MEM2_MemRead, MEM2_rd, i_d_data,
                             select1, select2, forward1, forward2);

endmodule

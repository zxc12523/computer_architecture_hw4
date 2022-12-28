module Forward_Unit #(
    parameter DATA_W = 64
) (
    input   [4:0]           ID_rs1,
    input   [4:0]           ID_rs2,
    input   [9:0]           ID_ExeOpcode,
    input                   EXE_WriteBack,
    input   [4:0]           EXE_rd,
    input   [DATA_W-1:0]    EXE_out,
    input                   MEM2_MemRead,
    input   [4:0]           MEM2_rd,
    input   [DATA_W-1:0]    o_data,
    output  [1:0]           select1,
    output  [1:0]           select2,
    output  [DATA_W-1:0]    forward1,
    output  [DATA_W-1:0]    forward2
);

// 0 for exe, 1 for mem

// reg [1:0] select1_r;
// reg [1:0] select2_r;

// always @(*) begin
//     if ((EXE_WriteBack && (ID_rs1 == EXE_rd)) || (MEM2_MemRead && (ID_rs1 == MEM2_rd))) begin
//         if (EXE_WriteBack && (ID_rs1 == EXE_rd)) begin
//             select1_r = 2'b10;
//         end
//         else begin
//             select1_r = 2'b11;
//         end
//     end
//     else begin
//         select1_r = 2'b00;
//     end
// end

wire exe2rs1, mem2rs1;
wire exe2rs2, mem2rs2;

assign exe2rs1 = EXE_WriteBack && (ID_rs1 == EXE_rd);
assign mem2rs1 = MEM2_MemRead && (ID_rs1 == MEM2_rd);
assign exe2rs2 = EXE_WriteBack && (ID_rs2 == EXE_rd);
assign mem2rs2 = MEM2_MemRead && (ID_rs2 == MEM2_rd);

assign select1 = (exe2rs1 || mem2rs1) ? exe2rs1 ? 2'b10 : 2'b11 : 2'b00;
assign select2 = (ID_ExeOpcode[9:3] == 7'b0100000) ? 2'b01 : (exe2rs2 || mem2rs2) ? exe2rs2 ? 2'b10 : 2'b11 : 2'b00;

// always @(*) begin
//     if (ID_ExeOpcode[0] == 1'b1) begin
//         select1_r = 2'b01;
//     end
//     else if ((EXE_WriteBack && (ID_rs2 == EXE_rd)) || (MEM2_MemRead && (ID_rs2 == MEM2_rd))) begin
//         if (EXE_WriteBack && (ID_rs2 == EXE_rd)) begin
//             select1_r = 2'b10;
//         end
//         else begin
//             select1_r = 2'b11;
//         end
//     end
//     else begin
//         select1_r = 2'b00;
//     end
// end

assign forward1 = EXE_out;
assign forward2 = o_data;

    
endmodule
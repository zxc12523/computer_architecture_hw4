module Register #(
    parameter DATA_W = 64
) (
    input                   i_clk,
    input   [4:0]           rs1,
    input   [4:0]           rs2,
    input                   EXE_wb,
    input   [4:0]           EXE_rd,
    input   [DATA_W-1:0]    EXE_data,
    input                   MEM_wb,
    input   [4:0]           MEM_rd,
    input   [DATA_W-1:0]    MEM_data,
    output  [DATA_W-1:0]    r1,
    output  [DATA_W-1:0]    r2
);

integer i = 0;

initial begin
    for(i = 0; i < 32 ; i = i + 1) begin
        x[i] = 0;
    end
end

reg [DATA_W-1:0] x[0:31];

Multiplexer32 M1 (rs1, x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7], 
                        x[8], x[9], x[10], x[11], x[12], x[13], x[14], x[15], 
                        x[16], x[17], x[18], x[19], x[20], x[21], x[22], x[23], 
                        x[24], x[25], x[26], x[27], x[28], x[29], x[30], x[31], r1);

Multiplexer32 M2 (rs2, x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7], 
                        x[8], x[9], x[10], x[11], x[12], x[13], x[14], x[15], 
                        x[16], x[17], x[18], x[19], x[20], x[21], x[22], x[23], 
                        x[24], x[25], x[26], x[27], x[28], x[29], x[30], x[31], r2);
                        
always @(negedge i_clk) begin
    if (EXE_wb && MEM_wb) begin
        if (EXE_rd == MEM_rd) begin
            x[EXE_rd] = EXE_data;
        end
        else begin
            x[EXE_rd] = EXE_data;
            x[MEM_rd] = MEM_data;
        end
    end
    else if (EXE_wb) begin
        x[EXE_rd] = EXE_data;
    end
    else if (MEM_wb) begin
        x[MEM_rd] = MEM_data;
    end
end
    
endmodule
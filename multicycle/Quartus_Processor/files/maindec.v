module maindec(input clk, reset,
               input [6:0] opcode,
               input [2:0] funct,
               output RegWriteW, MemWriteM, LoadD, ByteD, ALUSrcE, ByteW, MemtoRegW,
               output [1:0] aluop);

reg [7:0] controls;
wire RegWriteF, MemWriteF, LoadF, ByteF, ALUSrcF, MemtoRegF;
wire RegWriteD, MemWriteD, ALUSrcD, MemtoRegD;
wire RegWriteE, MemWriteE, ByteE, MemtoRegE;
wire RegWriteM, ByteM, MemtoRegM;

assign {RegWriteF, MemWriteF, LoadF, ByteF, ALUSrcF, MemtoRegF, aluop} = controls;

always @(*)
    if(~reset)
        case(opcode)
            7'b0000011: case(funct)
                            3'b000:  controls <= 8'b10111100; //LB
                            3'b010:  controls <= 8'b10101100; //LW
                            default: controls <= 8'bxxxxxxxx;
                        endcase
            7'b0100011: case(funct)
                            3'b000:  controls <= 8'b01011x00; //SB
                            3'b010:  controls <= 8'b01001x00; //SW
                            default: controls <= 8'bxxxxxxxx;
                        endcase
            7'b0110011: case(funct)
                            3'b000:  controls <= 8'b10x00010; //ADD | SUB | MUL
                            default: controls <= 8'bxxxxxxxx;
                        endcase
            default:                 controls <= 8'bxxxxxxxx;
        endcase

creg #(6) cregF(clk, {RegWriteF, MemWriteF, LoadF, ByteF, ALUSrcF, MemtoRegF}, {RegWriteD, MemWriteD, LoadD, ByteD, ALUSrcD, MemtoRegD});
creg #(5) cregD(clk, {RegWriteD, MemWriteD, ByteD, ALUSrcD, MemtoRegD}, {RegWriteE, MemWriteE, ByteE, ALUSrcE, MemtoRegE});
creg #(4) cregE(clk, {RegWriteE, MemWriteE, ByteE, MemtoRegE}, {RegWriteM, MemWriteM, ByteM, MemtoRegM});
creg #(3) cregM(clk, {RegWriteM, ByteM, MemtoRegM}, {RegWriteW, ByteW, MemtoRegW});

endmodule

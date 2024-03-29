`include "controller.v"
`include "datapath.v"

module riscv(input clk, reset, pc_en, dhit,
             input [31:0] instr,
             input [31:0] ReadData,
             output [31:0] pc,
	     output LoadM,
             output [31:0] ALUOut,
             output [31:0] WriteData,
             output MemWrite);

wire RegWrite, LoadD, ByteD, ALUSrcE, ByteW, MemtoRegW;
wire [2:0] ALUControl;

controller c(clk, reset, pc_en, dhit, alu_busy, instr[6:0], instr[14:12], instr[31:25], sendNop,
		RegWrite, RegWriteM, MemWrite, MemWriteD, LoadD, BranchD, JumpD, ByteD, ALUSrcE, BranchM, JumpM, LoadM, ByteW, MemtoRegW, ALUControl);

datapath dp(clk, reset, pc_en, dhit, instr, RegWrite, RegWriteM, MemWriteD, LoadD, BranchD, JumpD, ALUControl, ReadData, ByteD, ALUSrcE, BranchM, JumpM, ByteW, 
		MemtoRegW, pc, alu_busy, ALUOut, WriteData, sendNop);   

always @ (negedge clk)
    if(MemWrite)
        $display("In top at %d: MemWrite=%b, ALUOut=%d, WriteData=%d", $time, MemWrite, ALUOut, WriteData); 


endmodule             

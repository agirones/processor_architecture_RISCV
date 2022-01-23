`include "icache.v"
`include "dcache.v"
`include "muxCache.v"
`include "sb.v"
`include "riscv.v"

module top(input clk, reset,
           output [31:0] WriteData, ALUOut,
           output MemWrite);

wire [31:0] instr, ReadData, pc, sb_address, sb_data, dcache_address, dcache_data;
wire ALUop;
assign ALUop = (~MemWrite & ~LoadM);

//cpu
riscv      riscv(clk, reset, ihit, dhit, instr, ReadData, 
		 pc, LoadM, ALUOut, WriteData, MemWrite);

//data memory
muxCache #(64) muxToCache(sb_write_cache, {ALUOut, WriteData}, {sb_address, sb_data},
	                  dcache_address, dcache_data);

dcache     dcache(clk, sb_write_cache, LoadM, sb_hit, dcache_address, dcache_data, 
		  dhit, ReadData);

sb         sb(clk, dhit, MemWrite, LoadM, ALUOut, WriteData, 
	      sb_hit, sb_write_cache, sb_address, sb_data);

//instruction memory
icache     icache(clk, pc, 
		  ihit, instr);

always @ (negedge clk) 
	$display("-------------------------------At %d, memwrite = %b, addres = %d, writedata = %d", $time, MemWrite, ALUOut, WriteData);

endmodule

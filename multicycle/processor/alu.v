//-----------------------------------------------------
// This is the ALU
// Design Name : alu
// File Name : alu.v
//-----------------------------------------------------
module alu(input clk,
	   input        [31:0]  A, B,
           input  logic [2:0]   F,
           output reg   [31:0]  Y,
           output reg zero_flag, busy);

wire [31:0] S, Bout;
reg [31:0] M;

assign Bout = F[2] ? ~B : B;
assign S = A + Bout + F[2];
assign M = A * B;

initial begin
    zero_flag <= 1'b0;
    busy <= 1'b0;
end

always @ (*) begin
    casez(F)
        3'b?00: Y <= A & Bout;
        3'b?01: Y <= A | Bout;
        3'b?10: Y <= S;
	3'b011: begin
	    busy <= 1;
	    repeat (4) @ (posedge clk) begin
	        Y <= A * B;
            end
	    busy <= 0;
        end
        3'b111: Y <= S[31];
	default: busy <= 0;
    endcase

    if (Y == 0)
            zero_flag <= 1'b1;
        else
            zero_flag <= 1'b0;
end

endmodule

`include "imem.v"

typedef struct packed {
	logic valid;         // 154
	logic [25:0] tag;    // 153:128
	logic [127:0] data;  // 127:0
} i_cache_entry;

module icache(input clk,
	      input logic [31:0] a,
	      output reg hit,
              output reg [31:0] rd);

    wire [127:0] instr;
    //debug
    reg valid0, valid1, valid2, valid3;
    reg [25:0] tag0, tag1, tag2, tag3;
    reg [127:0] data0, data1, data2, data3;
    reg [1:0] set;

    imem imem (a, instr);
    i_cache_entry icache [4];
    initial
    begin
	    icache[0][154] <= 0;
	    icache[1][154] <= 0;
	    icache[2][154] <= 0;
	    icache[3][154] <= 0;
    end

    always @ (*)
    begin
            valid0 <= icache[0][154];
            tag0 <= icache[0][153:128];
            data0 <= icache[0][127:0];

            valid1 <= icache[1][154];
            tag1 <= icache[1][153:128];
            data1 <= icache[1][127:0];

            valid2 <= icache[2][154];
            tag2 <= icache[2][153:128];
            data2 <= icache[2][127:0];

            valid3 <= icache[3][154];
            tag3 <= icache[3][153:128];
            data3 <= icache[3][127:0];

	    set <= a[5:4];

	    case(a[5:4])
		    2'b00: begin
			   if(a[31:6] == icache[0][153:128] && icache[0][154])
			   begin
				   hit <= 1;
				   case(a[3:2])
					   2'b00: rd <= icache[0][31:0];
					   2'b01: rd <= icache[0][63:32];
					   2'b10: rd <= icache[0][95:64];
					   2'b11: rd <= icache[0][127:96];
				   endcase
			   end
			   else
			   begin
				   hit <= 0;
				   icache[0][154] <= 1;
				   icache[0][153:128] <= a[31:6];
				   repeat (10) @ (posedge clk);
				   icache[0][127:0] <= instr;
				   hit <= 1;
			   end
		   	   end

		    2'b01: begin
			   if(a[31:6] === icache[1][153:128] && icache[1][154])
			   begin
				   hit <= 1;
				   case(a[3:2])
					   2'b00: rd <= icache[1][31:0];
					   2'b01: rd <= icache[1][63:32];
					   2'b10: rd <= icache[1][95:64];
					   2'b11: rd <= icache[1][127:96];
				   endcase
			   end
			   else
			   begin
				   hit <= 0;
				   icache[1][154] <= 1;
				   icache[1][153:128] <= a[31:6];
				   repeat (10) @ (posedge clk);
				   icache[1][127:0] <= instr;
				   hit <= 1;
			   end
			   end

		   2'b10:  begin
			   if(a[31:6] == icache[2][153:128] && icache[2][154])
			   begin
				   hit <= 1;
				   case(a[3:2])
					   2'b00: rd <= icache[2][31:0];
					   2'b01: rd <= icache[2][63:32];
					   2'b10: rd <= icache[2][95:64];
					   2'b11: rd <= icache[2][127:96];
				   endcase
			   end
			   else
			   begin
				   hit <= 0;
				   icache[2][154] <= 1;
				   icache[2][153:128] <= a[31:6];
				   repeat (10) @ (posedge clk);
				   icache[2][127:0] <= instr;
				   hit <= 1;
			   end
			   end

		   2'b11: begin
			   if(a[31:6] == icache[3][153:128] && icache[3][154])
			   begin
				   hit <= 1;
				   case(a[3:2])
					   2'b00: rd <= icache[3][31:0];
					   2'b01: rd <= icache[3][63:32];
					   2'b10: rd <= icache[3][95:64];
					   2'b11: rd <= icache[3][127:96];
				   endcase
			   end
			   else
			   begin
				   hit <= 0;
				   icache[3][154] <= 1;
				   icache[3][153:128] <= a[31:6];
				   repeat (10) @ (posedge clk);
				   icache[3][127:0] <= instr;
				   hit <= 1;
			   end
			   end
		    endcase
    end

endmodule

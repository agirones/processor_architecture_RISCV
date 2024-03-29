`include "dmem.v"

typedef struct packed {
	logic valid;         // 154
	logic [25:0] tag;    // 153:128
	logic [127:0] data;  // 127:0
} d_cache_entry;

module dcache(input clk, we, load,
	      input logic [31:0] a, wd,
	      output reg hit,
              output reg [31:0] rd);

    wire [127:0] data;
    //debug
    reg valid0, valid1, valid2, valid3;
    reg [25:0] tag0, tag1, tag2, tag3;
    reg [127:0] data0, data1, data2, data3;
    reg [1:0] set;

    dmem dmem (clk, we, a, wd, data);
    d_cache_entry dcache [4];
    initial
    begin
	    dcache[0][154] <= 0;
	    dcache[1][154] <= 0;
	    dcache[2][154] <= 0;
	    dcache[3][154] <= 0;
	    hit <= 1; //TODO
    end

    always @ (*)
    begin
            valid0 <= dcache[0][154];
            tag0 <= dcache[0][153:128];
            data0 <= dcache[0][127:0];

            valid1 <= dcache[1][154];
            tag1 <= dcache[1][153:128];
            data1 <= dcache[1][127:0];

            valid2 <= dcache[2][154];
            tag2 <= dcache[2][153:128];
            data2 <= dcache[2][127:0];

            valid3 <= dcache[3][154];
            tag3 <= dcache[3][153:128];
            data3 <= dcache[3][127:0];

	    set <= a[5:4];

	    if(we | load)
	        case(a[5:4])
		    2'b00: begin
			   if(a[31:6] == dcache[0][153:128] && dcache[0][154])
				   hit <= 1;
			   else
			   begin
				   hit <= 0;
				   dcache[0][154] <= 1;
				   dcache[0][153:128] <= a[31:6];
				   repeat (10) @ (posedge clk);
				   dcache[0][127:0] <= data;
				   hit <= 1;
			   end

			   if(we)
			       case(a[3:2])
				   2'b00: dcache[0][ 31:0 ] <= wd;
				   2'b01: dcache[0][ 63:32] <= wd;
				   2'b10: dcache[0][ 95:64] <= wd;
				   2'b11: dcache[0][127:96] <= wd;
			       endcase
			   else
			       case(a[3:2])
				   2'b00: rd <= dcache[0][31:0];
				   2'b01: rd <= dcache[0][63:32];
				   2'b10: rd <= dcache[0][95:64];
				   2'b11: rd <= dcache[0][127:96];
			       endcase
		   	   end

		    2'b01: begin
			   if(a[31:6] === dcache[1][153:128] && dcache[1][154])
			   begin
				   hit <= 1;
			   end
			   else
			   begin
				   hit <= 0;
				   dcache[1][154] <= 1;
				   dcache[1][153:128] <= a[31:6];
				   repeat (10) @ (posedge clk);
				   dcache[1][127:0] <= data;
				   hit <= 1;
			   end

			   if(we)
			       case(a[3:2])
				   2'b00: dcache[1][ 31:0 ] <= wd;
				   2'b01: dcache[1][ 63:32] <= wd;
				   2'b10: dcache[1][ 95:64] <= wd;
				   2'b11: dcache[1][127:96] <= wd;
			       endcase
			   else
			       case(a[3:2])
				   2'b00: rd <= dcache[1][31:0];
				   2'b01: rd <= dcache[1][63:32];
				   2'b10: rd <= dcache[1][95:64];
				   2'b11: rd <= dcache[1][127:96];
			       endcase
			   end

		   2'b10:  begin
			   if(a[31:6] == dcache[2][153:128] && dcache[2][154])
			   begin
				   hit <= 1;
			   end
			   else
			   begin
				   hit                <= 0;
				   dcache[2][154]     <= 1;
				   dcache[2][153:128] <= a[31:6];
				   repeat (10) @ (posedge clk);
				   dcache[2][127:0]   <= data;
				   hit                <= 1;
			   end

			   if(we)
			       case(a[3:2])
				   2'b00: dcache[2][ 31:0 ] <= wd;
				   2'b01: dcache[2][ 63:32] <= wd;
				   2'b10: dcache[2][ 95:64] <= wd;
				   2'b11: dcache[2][127:96] <= wd;
			       endcase
			   else
			       case(a[3:2])
				   2'b00: rd <= dcache[2][31:0];
				   2'b01: rd <= dcache[2][63:32];
				   2'b10: rd <= dcache[2][95:64];
				   2'b11: rd <= dcache[2][127:96];
			       endcase
			   end

		   2'b11: begin
			   if(a[31:6] == dcache[3][153:128] && dcache[3][154])
			   begin
				   hit <= 1;
			   end
			   else
			   begin
				   hit <= 0;
				   dcache[3][154] <= 1;
				   dcache[3][153:128] <= a[31:6];
				   repeat (10) @ (posedge clk);
				   dcache[3][127:0] <= data;
				   hit <= 1;
			   end

			   if(we)
			       case(a[3:2])
				   2'b00: dcache[3][ 31:0 ] <= wd;
				   2'b01: dcache[3][ 63:32] <= wd;
				   2'b10: dcache[3][ 95:64] <= wd;
				   2'b11: dcache[3][127:96] <= wd;
			       endcase
			   else
			       case(a[3:2])
				   2'b00: rd <= dcache[3][31:0];
				   2'b01: rd <= dcache[3][63:32];
				   2'b10: rd <= dcache[3][95:64];
				   2'b11: rd <= dcache[3][127:96];
			       endcase
			   end
		endcase
    end

endmodule

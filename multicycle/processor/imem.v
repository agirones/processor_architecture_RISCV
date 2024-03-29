module imem(input logic [31:0] a,
            output reg [127:0] rd);

    logic [31:0] RAM[63:0];
    reg [31:0] add0, add1, add2, add3;


    initial
        $readmemh("memfile.dat", RAM);

    always @ (*)
    begin
	add0 = (a>>4)<<2;
	add1 = add0 + 32'h1;
	add2 = add0 + 32'h2;
	add3 = add0 + 32'h3;

        rd <= {RAM[add3], RAM[add2], RAM[add1], RAM[add0]};
    end

endmodule

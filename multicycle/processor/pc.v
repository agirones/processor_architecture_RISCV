module pc(input clk, reset, en, input logic [31:0] pc_, output logic [31:0] pc);

always@(posedge clk, posedge reset)
begin
    if(reset)
        pc <= 32'b0;
    else if (en)
        pc <= pc_;
end

endmodule

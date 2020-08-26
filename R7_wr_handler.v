module R7_wr_handler(opcode,Rd,wr,write_enable);
	input [2:0] Rd;
	input [3:0] opcode;
	input wr;
	output reg write_enable;
	
	always@(*)
	begin
		if(Rd==3'b111)
			write_enable=1'b0;
		else
			write_enable=wr;
	end

endmodule

module branch_control(opcode,ALU_out,is_taken,is_jlr);
	input [3:0] opcode;
	input [15:0] ALU_out;
	output reg is_taken;
	output reg is_jlr;
	
	
	
	always @(*)
		begin
			if(opcode==4'b1001)
				begin
					is_jlr=1'b1;
					is_taken=1'b0;
				end
			else if (opcode==4'b1100 && ALU_out==16'b0)
				begin
					is_jlr=1'b0;
					is_taken=1'b1;	
				end
			else
				begin
					is_jlr=1'b0;
					is_taken=1'b0;
				end
		end


endmodule

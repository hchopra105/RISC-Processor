module R7_control_RR(ZP9_en,incoming_PC,Rd,ZP9_data,new_PC,R7_jump);
	input ZP9_en;
	input [15:0] incoming_PC,ZP9_data;
	input [2:0] Rd;	
	output reg [15:0] new_PC;
	output reg R7_jump;
	
	always @(*)
		begin
			R7_jump = 1'b0;
			new_PC = incoming_PC;
			if(ZP9_en && Rd==3'b111)
				begin
					R7_jump = 1'b1;
					new_PC = ZP9_data;	
				end
		end
	
	
endmodule

module R7_control_ID(jal,SEPC,PC_plus1_new,Ra,NPC);
	input jal;
	input [15:0] SEPC,PC_plus1_new;
	input [2:0] Ra;
	output reg [15:0] NPC;
	
	always @(*)
		begin
			if(jal && Ra!=3'b111)
						NPC=SEPC;
			else
				NPC=PC_plus1_new;
		end 
	
endmodule

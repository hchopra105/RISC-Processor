module Sign_Extend(Imm9,Imm6,sel,dout);
	input [8:0] Imm9;
	input [5:0] Imm6;
	input sel;
	output [15:0] dout;
	wire [15:0] SE_9,SE_6;
	
	assign SE_9={{7{Imm9[8]}},Imm9};
	assign SE_6={{10{Imm6[5]}},Imm6};
	
	assign dout= sel ? SE_9 : SE_6;
	

	
endmodule

module Mux_2 #(parameter input_size=16) (sel,a,b,Out);
	input sel;
	input [input_size-1:0] a,b;
	output [input_size-1:0] Out;
	
	assign Out = sel ? a :b;
	
	
endmodule

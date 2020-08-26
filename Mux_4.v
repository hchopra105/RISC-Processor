module Mux_4 #(parameter input_size=16) (sel,a,b,c,d,Out);
	input [1:0] sel;
	input [input_size-1:0] a,b,c,d;
	output reg [input_size-1:0] Out;
	
	always@(sel,a,b,c,d)
		begin
			case(sel)
				2'b00:
				Out = a;
				2'b01:
				Out = b;
				2'b10:
				Out = c;
				2'b11:
				Out = d;
			endcase
		end
		
endmodule

module adder(a,b,sum,cout);
	input [15:0] a,b;
	output [15:0] sum;
	output cout;
	
	assign {cout,sum} = a + b;

endmodule
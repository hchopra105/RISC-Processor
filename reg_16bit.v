module reg_16bit #(parameter data_width=16)(clk,ena,rst,din,dout);
	input clk,rst,ena;
	input [data_width-1:0] din;
	output [data_width-1:0] dout;
	reg [data_width-1:0] out;
	
	always @(posedge clk)
		begin
			if(rst==1) out<=0;
			else if(rst==1'b0 && ena==1'b1) out<=din;
		end
		
	assign dout=out;	
	
endmodule

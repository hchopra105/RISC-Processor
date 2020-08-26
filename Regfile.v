module Regfile(data_out1,data_out2,data_in,R7_in,sr1,sr2,wr,write_en,R7_en,clk,rst);
	input rst,write_en,R7_en,clk;
	input [2:0] sr1,sr2,wr; // address of registers
	input [15:0] data_in,R7_in;
	output [15:0] data_out1,data_out2;
	
	reg [7:0] ena;
	//wire R7_enable;
	//wire [15:0] R7_input;
	wire [15:0] reg_out [7:0];
	
	genvar p;
// instantiating registers R0 to R6
	
	generate for(p=0;p<7;p=p+1)
		begin:Register
				reg_16bit Reg(.clk(clk),.ena(ena[p]),.rst(rst),.din(data_in),.dout(reg_out[p]));
		end
	endgenerate

	reg_16bit R7(.clk(clk),.ena(R7_en),.rst(rst),.din(R7_in),.dout(reg_out[7]));
	
	always @(write_en,wr)
		begin
			ena = 1'b0;
			ena[wr] = write_en;
		end
		
	//assign R7_enable = R7_en | ena[7]; // write signal for R7
	//assign R7_input = R7_en ? R7_in : data_in;
	
	assign data_out1 = reg_out[sr1];
	assign data_out2 = reg_out[sr2];
	
endmodule

module ALU(in1,in2,alu_ct,result,zero,carry);
	input [15:0] in1,in2;
	input [1:0] alu_ct;
	output reg [15:0] result;
	output reg carry,zero;
	wire [15:0] sum;
	wire cout;
	
	
	adder ad(in1,in2,sum,cout);
	
	always @(*)
		begin
			case(alu_ct)
					2'b00: begin
							result = sum;
							carry = cout;
							if(result==16'b0) zero=1'b1;
							else zero=1'b0;
							end
					2'b01: begin
							result = ~(in1 & in2);
							carry=1'bx;
							if(result==16'b0) zero=1'b1;
							else zero=1'b0; 
						end
					2'b10: begin
							 result=in1-in2;
							 zero=1'bx;
							 carry=1'bx;
						end
					default:begin
									result=16'bx;
									carry=1'bx;
									zero=1'bx;
							  end
					
			endcase
		end
//			always@(*)
//		begin
//			if(flag_ctl[1])
//					carry = carry_temp;
//			if(flag_ctl[0])
//					zero = zero_temp;
//		end

		
endmodule

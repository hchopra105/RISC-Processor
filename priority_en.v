module priority_en(data,out,ok);
	input [7:0] data;
	output reg [2:0] out;
	output reg ok;
	integer i;
	always @(data)
		begin
				ok=1'b1;
			   if(data[0]) out = 3'b000;  
				else if(data[1]) out = 3'b001;  
				else if(data[2]) out = 3'b010;  
				else if(data[3]) out = 3'b011;  
				else if(data[4]) out = 3'b100;  
				else if(data[5]) out = 3'b101;  
				else if(data[6]) out = 3'b110;  
				else if(data[7]) out = 3'b111;  
				else 
					begin
						out = 3'bxxx;
						ok=1'b0;
					end	
		end


endmodule

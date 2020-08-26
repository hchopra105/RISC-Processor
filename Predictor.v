module Predictor(clk,rst,PC_current,PC_new,PC_plus,BA_new,is_beq,is_branch,is_taken,BTA,next_PC,change_PC);
	input clk,rst;
	input [15:0] PC_current;
	input [15:0] PC_new ;// PC_current is at PC register and PC_new is PC of instruction at EX stage
	input [15:0] BA_new ;
	input [15:0] PC_plus;  // new branch address
	input is_beq,is_branch;// is_beq is from RREX pipe -'1' if instr is branch.  is_branch =1 if Aluout=0;
	output reg is_taken; /// predicted taken
	output reg [15:0] BTA,next_PC;// predicted address /// next_PC changes the PC if prediction is invailated
	output reg change_PC;
	genvar p,q,r;
	integer i,j;
	reg temp;
	integer index;
	wire [2:0] count_in,count_out;
	reg [4:0] PC_en,BTA_en,His_en;
	reg count_en,first;
	wire [15:0] BA_out [4:0];
	wire [15:0] PC_out [4:0];
	wire [1:0] His_out[4:0];
	reg [1:0] His_new ;
	
	generate for(p=0;p<5;p=p+1)
		begin:PC_pred
				reg_16bit Reg(.clk(clk),.ena(PC_en[p]),.rst(rst),.din(PC_new),.dout(PC_out[p]));			
		end
	endgenerate
	
	generate for(q=0;q<5;q=q+1)
		begin:BTA_pred
				reg_16bit Reg(.clk(clk),.ena(BTA_en[q]),.rst(rst),.din(BA_new),.dout(BA_out[q]));			
		end
	endgenerate
	
	generate for(r=0;r<5;r=r+1)
		begin:His_pred
				reg_16bit #(2) Reg(.clk(clk),.ena(His_en[r]),.rst(rst),.din(His_new),.dout(His_out[r]));			
		end
	endgenerate
	
	reg_16bit #(3) Counter(.clk(clk),.ena(count_en),.rst(rst),.din(count_in),.dout(count_out));			
	
	
	assign count_in = count_out + 1'b1;
	
	always @(PC_current)
		begin
			  is_taken=1'b0;
			   BTA=16'bx;
			for(i=0;i<5;i=i+1)
				begin
					if(PC_current==PC_out[i])   // checking every PC
						begin
								if(His_out[i]==2'b10 || His_out[i]==2'b11)  // if MSB of History bits is 1 i.e. Taken
									begin
										BTA=BA_out[i];
										is_taken=1'b1;
									end
								else
									begin
										BTA=16'bx;
										is_taken=1'b0;
									end	
						end
				end
		end
	
	
	always @(*)  // updating BPT in EX stage
		begin		
						PC_en=5'b0;	
						BTA_en=5'b0;
						His_en=2'b0;
						count_en=1'b0;
						first=1'bx;
						
					if(is_beq==1'b1)
							begin	
								temp=1'b0;
								index=1'bx;
								for(j=0;j<5;j=j+1)
										begin
												if(PC_new==PC_out[j]) 
													begin
														index=j;
														temp=1'b1;
													end	
										end
								
								
								if(temp==1'b0)   // if no entry then create one
									begin
										PC_en[count_out]=1'b1;
										BTA_en[count_out]=1'b1;
										His_en[count_out]=1'b1;
										count_en=1'b1;
										first=1'b1;  // first entry
										end
								else             // entry is present , update BTA and History bits
									begin
										PC_en[index]=1'b0;
										BTA_en[index]=1'b1;
										His_en[index]=1'b1;
										count_en=1'b0;
										first=1'b0;  // not first entry
									end
							end
					
		end
		
		
		// History bits state machine//
		always @(*)
			begin
				His_new=2'b00;
				change_PC =1'b0;   // will flush the pipeline and select line of mux
				next_PC = 16'bx;
				if(is_beq==1'b1)
			   //His_new=0;
					begin
							if(first==1'b1 && is_branch==1'b1)
								begin
									His_new=2'b10;
									change_PC =1'b1;   // will flush the pipeline and select line of mux
									next_PC = BA_new;
								end
							else if (first==1'b1 && is_branch==1'b0)
								begin
									His_new=2'b01;
									change_PC=1'b0;
									next_PC=16'bx;
								end
							else
								begin
										case(His_out[index])
												2'b00:begin   // Strong Not-Taken
												
															if(is_branch==1'b1)
																	begin
																	His_new=2'b01;  // move to weak Not-Taken
																	change_PC=1'b1;
																	next_PC = BA_new;
																	end
															else  begin
																	His_new=2'b00;
																	change_PC=1'b0;
																	next_PC = 16'bx;
																	end
														end
												2'b01:begin   // Weak Not-Taken

															if(is_branch==1'b1)
																begin
																	His_new=2'b10;  // move to weak Taken
																	change_PC=1'b1;
																	next_PC = BA_new;
																end	
															else
																begin
																	His_new=2'b00;  // move to strong NOt-Taken
																	change_PC=1'b0;
																	next_PC = 16'bx;
																end	
														end
												2'b10:begin   // Weak Taken

															if(is_branch==1'b1)
																begin
																	His_new=2'b11;  // move to Strong Taken
																	change_PC=1'b0;
																	next_PC = 16'bx;
																end	
															else
																begin
																	His_new=2'b01;  // move to weak Not-Taken
																	change_PC=1'b1;
																	next_PC = PC_plus;
																end	
														end	
												2'b11:begin   // Strong Taken

														if(is_branch==1'b1)
															begin
																His_new=2'b11;  // Stay here
																change_PC=1'b0;
																next_PC = 16'bx;
															end	
														else
															begin
																His_new=2'b10;  // move to weak Taken
																change_PC=1'b1;
																next_PC = PC_plus;
															end
														end
									
										endcase
									end	
						end			
			end
		
endmodule		
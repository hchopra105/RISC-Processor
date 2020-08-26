module LMSM(clk,reset,IDRR_LM,IDRR_SM,SE16,PE_out,alu_do1_sel,one_sel,LM_dest_sel,LM_wr_en,
				fwd_bit,disable_pipe,reg_write,alu_in,SM_mem_wr_sel,r2_sel,mem_write);
	input clk,reset;
	input IDRR_LM,IDRR_SM;
	input [15:0] SE16;
	output [2:0] PE_out;
	// ID mux sel line

	// RR mux sel lines
	output reg alu_do1_sel,r2_sel,SM_mem_wr_sel;
	// EX mux sel lines
	output reg one_sel,LM_dest_sel,LM_wr_en;
	output reg [15:0] alu_in;
	
	// signal to fwd logic to stop forwarding
	output reg fwd_bit;
	// output for disabling other pipe reg
	output reg disable_pipe;
	//output for destination reg write signal and memory input
	output reg reg_write;
	//output for memmory write signal
	output reg mem_write;
	// signal to LMSM_starter 
	reg direct,enable_holdreg;
	// input from LMSM_starter
	wire over,ok;     // Rd address from PE_out
	reg [7:0] Imm8;
	reg [2:0] pstate,nstate;		
		
	parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100;
	
	LMSM_starter HR(.clk(clk),.direct(direct),.enable_holdreg(enable_holdreg),
						 .reset(reset),.Imm8(Imm8),
						 .ok(ok),.over(over),.PE_out(PE_out));
	
	always @(posedge clk)
		begin
			if(reset) pstate<=S0;
			else pstate<=nstate;
		end
		
//	always @(pstate,IDRR_LM,over,ok,IDRR_SM,SE16)
//		begin
//			case(pstate)
//				S0:begin
//						SM_en=1'b0;
//						LM_en=1'b0;
//						r2_sel=1'b0;
//						SM_mem_wr_sel=1'b0;   SM_mem_in_sel=1'b0;
//						mem_write=1'bx;
//						IDRR_SM_in=1'bx;
//						enable_holdreg=1'b0;
//						disable_pipe = 1'b0;
//						Imm8 = 8'b0;
//						reg_write=1'bx;
//						alu_do1_sel = 1'b0;  // mux before RREX
//						one_sel     = 1'b0;  // mux supplying 0 or 1 to alu
//						LM_dest_sel = 1'b0;	// to update destination for LM
//						LM_wr_en    = 1'b0;	// to update reg_write for LM
//						settozero   = 1'b0;	// given to LM_starter
//						fwd_bit     = 1'b1;	// given to fwd logic to deactivate fwding  when required for Rs only
//						IDRR_LM_in  = 1'bx;  // given to IDRR_LM input when enabling the registers again
//						alu_in      = 16'bx; // giving 0 and 1 to mux connected to alu
//						if(IDRR_LM)
//							begin
//								nstate = S1;
//								disable_pipe = 1'b1;
//								enable_holdreg = 1'b1;
//								Imm8 = SE16[7:0];
//							end
//						else if(IDRR_SM)
//							begin
//								nstate = S3;
//								disable_pipe = 1'b1;
//								enable_holdreg = 1'b1;
//								Imm8 = SE16[7:0];
//							end
//						else
//							begin
//								nstate = S0;
//							end
//					end
//				S1:begin
//						SM_en=1'b0;						r2_sel=1'b0;
//						SM_mem_wr_sel=1'b0; 		   SM_mem_in_sel=1'b0;
//						mem_write=1'bx;				IDRR_SM_in=1'bx;
//						Imm8 = 8'bx;
//						alu_do1_sel = 1'b1;	 		LM_wr_en = 1'b1;
//						one_sel     = 1'b1; 			settozero = 1'b1;
//						LM_dest_sel = 1'b1; 			fwd_bit   = 1'b1;
//						reg_write   = ok;   	 		alu_in =16'b0;
//						disable_pipe = 1'b1;  		LM_en = 1'b0;
//						enable_holdreg = 1'b1;  	IDRR_LM_in  = 1'bx;
//					
//						if(over)
//							begin
//								disable_pipe=1'b0;
//								LM_en = 1'b1;
//								IDRR_LM_in=1'b0;
//								enable_holdreg=1'b0;
//								nstate = S0;
//							end
//						else 
//							begin
//								nstate = S2;
//								
//							end	
//					end
//		
//				S2:begin
//						SM_en=1'b0;                       r2_sel=1'b0;
//						SM_mem_wr_sel=1'b0;               SM_mem_in_sel=1'b0;
//						mem_write=1'bx;						 IDRR_SM_in=1'bx;
//						Imm8 = 8'bx;                      fwd_bit     = 1'b0;// disabling forwarding
//						alu_do1_sel = 1'b1;               reg_write   = ok;
//						one_sel     = 1'b1;               disable_pipe = 1'b1;
//						LM_dest_sel = 1'b1;               enable_holdreg = 1'b1;
//						LM_wr_en    = 1'b1;               alu_in =16'b1;
//						settozero   = 1'b1;               LM_en = 1'b0;
//						IDRR_LM_in=1'bx;
//						if(over)
//							begin
//								disable_pipe=1'b0;
//								LM_en = 1'b1;
//								IDRR_LM_in=1'b0;
//								enable_holdreg=1'b0;
//								nstate = S0;
//							end
//						else 
//							nstate = S2;
//					end
//			   S3:begin
//						alu_do1_sel = 1'b1;              r2_sel  = 1'b1;
//						one_sel = 1'b1;                  fwd_bit = 1'b1;
//						SM_en   = 1'b0;                  settozero = 1'b1;
//						SM_mem_wr_sel = 1'b1;            alu_in = 16'b0;
//						Imm8   = 8'bx;                   disable_pipe = 1'b1;
//						mem_write  = ok ;                IDRR_SM_in = 1'bx;
//						enable_holdreg = 1'b1;           SM_mem_in_sel=1'b1;
//		// signals of LM just for preventing latches			
//						LM_dest_sel = 1'b1; 	            LM_wr_en = 1'b1;
//						reg_write   = 1'b0;					LM_en = 1'b0;
//						IDRR_LM_in  = 1'bx;
//						
//						if(over)
//							begin
//								disable_pipe =  1'b0;      enable_holdreg = 1'b0; 
//								IDRR_SM_in = 1'b0;         SM_en = 1'b1;
//								nstate= S0;
//							end
//						else
//							nstate = S4;
//					end
//				S4:begin
//						alu_do1_sel = 1'b1;              r2_sel  = 1'b1;
//						one_sel = 1'b1;                  fwd_bit = 1'b0;
//						SM_en   = 1'b0;                  settozero = 1'b1;
//						SM_mem_wr_sel = 1'b1;            alu_in = 16'b1;
//						Imm8   = 8'bx;                   disable_pipe = 1'b1;
//						mem_write  = ok ;                 IDRR_SM_in = 1'bx;
//						enable_holdreg = 1'b1;            SM_mem_in_sel=1'b1;
//						
//						// signals of LM just for preventing latches			
//						LM_dest_sel = 1'b1; 	            LM_wr_en = 1'b1;
//						reg_write   = 1'b0;					LM_en = 1'b0;
//						IDRR_LM_in  = 1'bx;
//						
//						if(over)
//							begin
//								disable_pipe =  1'b0;      enable_holdreg = 1'b0; 
//								IDRR_SM_in = 1'b0;         SM_en = 1'b1;
//								nstate= S0;
//							end
//						else
//							nstate = S4;
//					end
//
//			endcase
//		end

	

	always @(pstate,IDRR_LM,over,ok,IDRR_SM,SE16)
		begin
			case(pstate)
				S0:begin
						enable_holdreg=1'b0;
						disable_pipe = 1'b0;
						Imm8 = SE16[7:0];
						reg_write=1'bx;         mem_write   = 1'bx;  SM_mem_wr_sel = 1'b0;   r2_sel  = 1'b0;
						alu_do1_sel = 1'b0;  // mux before RREX
						one_sel     = 1'b0;  // mux supplying 0 or 1 to alu
						LM_dest_sel = 1'b0;	// to update destination for LM
						LM_wr_en    = 1'b0;	// to update reg_write for LM
						direct      = 1'b1;	// given to LM_starter
						fwd_bit     = 1'b1;	// given to fwd logic to deactivate fwding  when required for Rs only
						alu_in      = 16'bx; // giving 0 and 1 to mux connected to alu
						if(IDRR_LM && (Imm8!=8'b0))
							begin
									reg_write   = ok;
									one_sel     = 1'b1;        
									LM_dest_sel = 1'b1;	       
									LM_wr_en    = 1'b1;	
									alu_in      = 16'b0;
									
									if(over)
										begin
											nstate = S0;
										end
									else
										begin
											nstate = S1;
											disable_pipe = 1'b1;
											enable_holdreg=1'b1;
										end
							end
						else if(IDRR_SM && (Imm8!=8'b0))
							begin
									one_sel     = 1'b1;              
									mem_write   = ok;
									SM_mem_wr_sel = 1'b1;
									r2_sel  = 1'b1;
									alu_in      = 16'b0;
									if(over)
										begin
											nstate = S0;
										end
									else
										begin
											nstate = S2;
											disable_pipe = 1'b1;
											enable_holdreg=1'b1;
										end
							end	
						else
							begin
								nstate = S0;
							end
					end
				S1:begin
						Imm8 = 8'bx;
						alu_do1_sel = 1'b1;	 		LM_wr_en = 1'b1;
						one_sel     = 1'b1; 			direct = 1'b0;
						LM_dest_sel = 1'b1; 			fwd_bit   = 1'b0;
						reg_write   = ok;   	 		alu_in =16'h0001;
						disable_pipe = 1'b1; 		
						enable_holdreg = 1'b1;	
					   mem_write   = 1'b0;
						SM_mem_wr_sel = 1'b0;
						r2_sel  = 1'b0;
						if(over)
							begin
								disable_pipe=1'b0;
								enable_holdreg=1'b0;
								nstate = S0;
							end
						else 
							begin
								nstate = S1;		
							end	
					end
				S2:begin
						Imm8 = 8'bx;
						alu_do1_sel = 1'b1;	 		LM_wr_en = 1'b0;
						one_sel     = 1'b1; 			direct = 1'b0;
						LM_dest_sel = 1'b0; 			fwd_bit   = 1'b0;
						reg_write   = 1'b0;   	 		alu_in =16'h0001;
						disable_pipe = 1'b1; 		
						enable_holdreg = 1'b1;
						mem_write   = ok;
						SM_mem_wr_sel = 1'b1;
						r2_sel  = 1'b1;
						if(over)
							begin
								disable_pipe=1'b0;
								enable_holdreg=1'b0;
								nstate = S0;
							end
						else 
							begin
								nstate = S2;		
							end	
					end	
					
			endcase
	end
endmodule

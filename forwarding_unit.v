module forwarding_unit(RR_EX_Rs,RR_EX_Rt,EX_Mem_mux_sel,EX_Mem_Rd,EX_Mem_Regwrite,LM_fwd,RR_EX_PC,
								EX_Mem_ALU_out,EX_Mem_ZP9,EX_Mem_PC_plus,Mem_WB_Rd,Mem_WB_Regwrite,
								Mem_WB_data,WB_end_data,WB_end_Rd,WB_end_Regwrite,forwardA,forwarding_dataA,
								forwardB,forwarding_dataB);
	//input clk;
	input [15:0] RR_EX_PC;
	input [2:0] RR_EX_Rs,RR_EX_Rt;
	////////////////////////////////////
	input [1:0] EX_Mem_mux_sel;	
   input [2:0] EX_Mem_Rd;
	input EX_Mem_Regwrite;
	input [15:0] EX_Mem_ALU_out,EX_Mem_ZP9,EX_Mem_PC_plus;
	////////////////////////////////////	
   input [2:0] Mem_WB_Rd;
	input Mem_WB_Regwrite;
	input [15:0] Mem_WB_data;
	////////////////////////////////////
	input [15:0] WB_end_data;
	input [2:0] WB_end_Rd;
	input WB_end_Regwrite;
	///////////////////////////////////
	input LM_fwd;
	///////////////////////////////////
	output reg forwardA,forwardB;
	output reg [15:0] forwarding_dataA,forwarding_dataB;
	
	wire [15:0] EX_Mem_data;
	
	
	Mux_4 EXMem_mux(.sel(EX_Mem_mux_sel),.a(EX_Mem_ALU_out),.b(EX_Mem_ZP9),
				  .c(16'bx),.d(EX_Mem_PC_plus),.Out(EX_Mem_data));
	
//	always @(EX_Mem_data, Mem_WB_data,WB_end_data, EX_Mem_Regwrite,RR_EX_Rs,
//				Mem_WB_Regwrite,EX_Mem_Rd, Mem_WB_Rd,WB_end_Rd,WB_end_Regwrite,LM_fwd)
   always @(*)
		begin
		   
					if(RR_EX_Rs==3'b111)
						begin
							forwarding_dataA=RR_EX_PC;
							forwardA=1'b1;
						end
					else if((EX_Mem_Regwrite)&&(EX_Mem_Rd==RR_EX_Rs)&&(LM_fwd))//LM_fwd handels forwarding in LM and SM both	
						begin
							forwarding_dataA=EX_Mem_data;
							forwardA=1'b1;
						end	
				
					
					else if ((Mem_WB_Regwrite) && (Mem_WB_Rd==RR_EX_Rs)&&(LM_fwd))	
						begin
							forwarding_dataA=Mem_WB_data;// after WB stage mux data
							forwardA=1'b1;
						end		
					
			
					else if((WB_end_Regwrite) && (WB_end_Rd==RR_EX_Rs)&&(LM_fwd))
						begin
							forwarding_dataA=WB_end_data;
							forwardA=1'b1;
						end
					
					
					else
						begin
							forwarding_dataA=16'bx;
							forwardA=1'b0;
						end	
		
		end
	
//	always @(EX_Mem_data, Mem_WB_data,WB_end_data, EX_Mem_Regwrite,RR_EX_Rt,
//				Mem_WB_Regwrite,EX_Mem_Rd, Mem_WB_Rd,WB_end_Rd,WB_end_Regwrite)
	always @(*)
		begin
		   
			
					if(RR_EX_Rt==3'b111)
						begin
							forwarding_dataB=RR_EX_PC;
							forwardB=1'b1;
						end
					
					else if((EX_Mem_Regwrite)&&(EX_Mem_Rd==RR_EX_Rt))	
						begin
							forwarding_dataB=EX_Mem_data;
							forwardB=1'b1;
						end		
						
					else if((Mem_WB_Regwrite) && (Mem_WB_Rd==RR_EX_Rt))	
						begin
							forwarding_dataB=Mem_WB_data;// after WB stage mux data
							forwardB=1'b1;
						end	
					
					else if((WB_end_Regwrite) && (WB_end_Rd==RR_EX_Rt))
						begin
							forwarding_dataB=WB_end_data;
							forwardB=1'b1;
						end
						
					else
						begin
							forwarding_dataB=16'bx;
							forwardB=1'b0;
						end
		
		end
	
	
endmodule

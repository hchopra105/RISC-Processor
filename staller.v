module staller(LW,LM,RREX_LM,RREX_SW,RREX_SM,Rs,Rt,Rd,opcode,valid,isLW_dep);
		input LW,LM,RREX_LM,RREX_SW,RREX_SM,valid;
		input [2:0] Rs,Rd,Rt;
		input [3:0] opcode;
		output reg isLW_dep;// disabling pipes preceding EXMem and resetting EXMem
		
		
		always @(*)
			begin
				
				if((LW==1'b1 || LM==1'b1) &&((Rs==Rd) || (Rt==Rd)) && valid && (Rd!=3'b111))
						begin
							isLW_dep=1'b1;
							if(opcode==4'b0001 && (Rd==Rt) && (Rd!=Rs)) // ADI,if Rb==Rd => No stall as it is destination
								isLW_dep=1'b0;
							else if(opcode==4'b0011 || opcode==4'b1000) // no stall for LHI and jalr ra,imm
								isLW_dep=1'b0;
							else if(opcode==4'b0100 && (Rd==Rs) && (Rd!=Rt))	// LW, no stall for Ra
								isLW_dep=1'b0;
							else if(opcode==4'b0110 && (Rd==Rt) && (Rd!=Rs))	// LM, no stall for Rb
								isLW_dep=1'b0;	
							else if((RREX_SW && (Rd==Rs) && (Rd!=Rt)) || ( RREX_SM && (Rd==Rt) &&(Rd!=Rs)))
								isLW_dep=1'b0;
							else if(opcode==4'b1001 && (Rd==Rs) && (Rd!=Rt)) // jalr, no stall for Ra
								isLW_dep=1'b0;
						end
				else
						begin
							isLW_dep=1'b0;
						end
			end

endmodule

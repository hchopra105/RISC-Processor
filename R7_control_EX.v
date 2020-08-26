module R7_control_EX(RREX_opcode,jlr,jalr_PC,incoming_PC,cond,Rd,Alu_result,new_PC,its_R7);
		input [3:0] RREX_opcode;
		input [2:0] Rd;
		input [1:0] cond;
		input jlr;
		input [15:0] Alu_result,jalr_PC,incoming_PC;
		output reg [15:0] new_PC;
      output reg its_R7;
		always @(*)
			begin
			   its_R7 = 1'b0;
				new_PC = incoming_PC;
			
						// add              			 ndu                                   	adi
				if((((RREX_opcode==3'b0000 || RREX_opcode==3'b0010) && cond==2'b00) || RREX_opcode==3'b0001) && Rd==3'b111)	
					begin 
						its_R7=1'b1;
		    			new_PC = Alu_result;				
					end				
				else if (jlr && Rd!=3'b111)
						 begin
							new_PC = jalr_PC;
						   its_R7=1'b1;
						 end
				
			end

endmodule

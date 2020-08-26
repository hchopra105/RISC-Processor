module R7_control_Mem(EXMem_opcode,incoming_PC,cond,Rd,Alu_result,Mem_out,LW,LM,
							 Reg_write,new_PC,R7_again);
		input [3:0] EXMem_opcode;
		input [2:0] Rd;
		input [1:0] cond;
		input [15:0] Alu_result,Mem_out,incoming_PC;
		input LW,LM,Reg_write;
		output reg [15:0] new_PC;
      output reg R7_again;
		always @(*)
			begin
			   R7_again = 1'b0;
				new_PC = incoming_PC;
			
						// adc              			 ndc                                   	
				if((((EXMem_opcode==3'b0000 || EXMem_opcode==3'b0010) && cond==2'b10) || 
						((EXMem_opcode==3'b0000 || EXMem_opcode==3'b0010) && cond==2'b01)) && Rd==3'b111 && Reg_write)	
						     //adz                       ndz
					begin 
						R7_again=1'b1;
		    			new_PC = Alu_result;				
					end				
				else if ((LM || LW) && Rd==3'b111)
						 begin
							new_PC = Mem_out;
						   R7_again=1'b1;
						 end
				
			end

endmodule

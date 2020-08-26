module condition_control(Rd,reg_write,cond,flag,Flag_reg,opcode,Mem_out,C,Z,write_en,LW,flag_ctl);
	input [1:0] cond,flag,Flag_reg,flag_ctl; // flag from EX_Mem ,,,,, flag_reg from main flags
	input [3:0] opcode;
	input [2:0] Rd;
	input [15:0] Mem_out;
	input reg_write,LW;
	output reg write_en;
	output reg C,Z;
	//reg write_en;
	//wire temp;
	
	//R7_wr_handler R7handle(.opcode(opcode),.Rd(Rd),.wr(temp),.write_enable(write_en));
   //assign temp=write_en;
	
	always @(*)
		begin
			if(LW)
				begin
					if(Mem_out==16'b0)
							begin
								C = flag[1];	
								Z = 1'b1;	
								write_en = reg_write;	
							end
					else
							begin
								C = flag[1];
								Z = 1'b0;
								write_en = reg_write;
							end
				end
		
			else if((opcode==4'b0000 || opcode==4'b0010) && cond==2'b10 )   //ADC or NDC 
				begin
					if(Flag_reg[1])
						begin
							write_en=1'b1;
							{C,Z} = flag;
						end	
					else
						begin
							write_en=1'b0;
							{C,Z} = Flag_reg;
						end
				end
			
			
			else if((opcode==4'b0000 || opcode==4'b0010) && cond==2'b01)   //ADZ or NDZ 
				begin
					if(Flag_reg[0])
						begin
							write_en=1'b1;
							{C,Z} = flag;
						end
					else
						begin
							write_en=1'b0;
							{C,Z} = Flag_reg;
						end
				end		
			else 
				begin                    // for other cases if flag control allows then update main flag else same.
						write_en=reg_write;
						if(flag_ctl[0]) // if Z_control==1							
								Z = flag[0];
						else
								Z = Flag_reg[0];
						if(flag_ctl[1])   /// if CY_control==1
								C = flag[1];
						else
								C = Flag_reg[1];
				end
		end
	



endmodule

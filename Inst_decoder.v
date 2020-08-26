module Inst_decoder(instr,PC,PC_plus,SE9_6_sel,JAL,ZP9_en,valid,EX_ctl,Mem_ctl,WB_ctl,dest_reg,LM,SM,SW);
	input [15:0] instr,PC,PC_plus;
	output reg SE9_6_sel,ZP9_en,JAL;
	output [6:0] EX_ctl;
	output [1:0] Mem_ctl;
	output [4:0] WB_ctl;
	output reg valid,LM,SM,SW; 
	output reg [1:0] dest_reg;
	
	reg [1:0] ALU_Ct,Flag_Ct,cond,WB_sel;
	reg DO2_SE16_sel,LW_Stall,Mem_write,branch,Reg_write,DO1_SE16_sel;
	
	always @(instr,PC,PC_plus)
	
		if (instr==16'b0 && PC==16'b0 && PC_plus==16'b0)
			begin
							SE9_6_sel=1'bx; // 0 for Imm6
							valid=1'bx;
							ZP9_en=1'bx;
							Mem_write=1'b0;
							Reg_write=1'b0;                        
							ALU_Ct=2'bxx;
							Flag_Ct=2'bxx;   //{carry,zero}
							cond=2'bxx;
							WB_sel=2'bxx;
							dest_reg=2'bxx;
							DO2_SE16_sel=1'bx;// 0 for DO2
							LW_Stall=1'bx;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
			end
		else	
			begin
		
							SE9_6_sel=1'bx; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'bx;
							Mem_write=1'b0;
							Reg_write=1'b0;                        
							ALU_Ct=2'bxx;
							Flag_Ct=2'bxx;   //{carry,zero}
							cond=2'bxx;
							WB_sel=2'bxx;
							dest_reg=2'bxx;
							DO2_SE16_sel=1'bx;// 0 for DO2
							LW_Stall=1'bx;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
			
			case(instr[15:12])
				4'b0000: begin           // ADD,ADC,ADZ
							SE9_6_sel=1'bx; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b0;
							Mem_write=1'b0;
							Reg_write=1'b1;                        
							ALU_Ct=2'b00;
							Flag_Ct=2'b11;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'b00;
							dest_reg=2'b11;
							DO2_SE16_sel=1'b0;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
						end
				4'b0001: begin           	// adi rb, ra, imm6
							SE9_6_sel=1'b0; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b0;
							Mem_write=1'b0;
							Reg_write=1'b1;                        
							ALU_Ct=2'b00;
							Flag_Ct=2'b11;   //{carry,zero}
							cond=2'b00;
							WB_sel=2'b00;
							dest_reg=2'b10;
							DO2_SE16_sel=1'b1;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
						end
				4'b0010: begin        		//  ndu,ndc,ndz							
							SE9_6_sel=1'bx; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b0;
							Mem_write=1'b0;
							Reg_write=1'b1;                        
							ALU_Ct=2'b01;
							Flag_Ct=2'b01;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'b00;
							dest_reg=2'b11;
							DO2_SE16_sel=1'b0;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
						end
						
				4'b0011: begin       		 //lhi ra, Imm9
							SE9_6_sel=1'b1; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b1;
							Mem_write=1'b0;
							Reg_write=1'b1;                        
							ALU_Ct=2'bxx;
							Flag_Ct=2'b00;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'b01;
							dest_reg=2'b01;
							DO2_SE16_sel=1'bx;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
						end
				
            4'b0100: begin             //lw ra, rb, Imm6

							SE9_6_sel=1'b0; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b0;
							Mem_write=1'b0;
							Reg_write=1'b1;                        
							ALU_Ct=2'b00;
							Flag_Ct=2'b01;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'b10;
							dest_reg=2'b01;
							DO2_SE16_sel=1'b0;// 0 for DO2
							LW_Stall=1'b1;
							branch=1'b0;
							DO1_SE16_sel=1'b1; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
						end
						
				4'b0101: begin             //sw ra, rb, Imm6
							SE9_6_sel=1'b0; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b0;
							Mem_write=1'b1;
							Reg_write=1'b0;                        
							ALU_Ct=2'b00;
							Flag_Ct=2'b00;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'bxx;
							dest_reg=2'bxx;
							DO2_SE16_sel=1'b0;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b0;
							DO1_SE16_sel=1'b1; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b1;
						end	
				4'b0110: begin             //lm ra, Imm9

							SE9_6_sel=1'b1; // 0 for Imm6
							valid=1'b1;
							if(instr[8:0]==9'd0)
								valid=1'b0;
							ZP9_en=1'b0;
							Mem_write=1'b0;
							Reg_write=1'b0;                        
							ALU_Ct=2'b00;
							Flag_Ct=2'b00;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'b10;
							dest_reg=2'b00;
							DO2_SE16_sel=1'bx;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b1;
							SM=1'b0;
							SW=1'b0;
						end	
				4'b0111: begin             //sm ra,Imm9
						SE9_6_sel=1'b1; // 0 for Imm6
						valid=1'b1;
						if(instr[8:0]==9'd0)
								valid=1'b0;
						ZP9_en=1'b0;
						Mem_write=1'b0;
						Reg_write=1'b0;                        
						ALU_Ct=2'b00;
						Flag_Ct=2'b00;   //{carry,zero}
						cond=instr[1:0];
						WB_sel=2'bxx;
						dest_reg=2'bxx;
						DO2_SE16_sel=1'b0;// 0 for DO2
						LW_Stall=1'b0;
						branch=1'b0;
						DO1_SE16_sel=1'b0; // 0 for DO1
						JAL=1'b0;
						LM=1'b0;
						SM=1'b1;
						SW=1'b0;
					end		
				
				4'b1100: begin             //beq ra, rb, Imm6
							SE9_6_sel=1'b0; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b0;
							Mem_write=1'b0;
							Reg_write=1'b0;                        
							ALU_Ct=2'b10;
							Flag_Ct=2'b00;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'bxx;
							dest_reg=2'bxx;
							DO2_SE16_sel=1'b0;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b1;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
						end		
				
				4'b1000: begin             //jalr ra, Imm9    JAL
	
							SE9_6_sel=1'b1; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b0;
							Mem_write=1'b0;
							Reg_write=1'b1;                        
							ALU_Ct=2'bxx;
							Flag_Ct=2'b00;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'b11;
							dest_reg=2'b01;
							DO2_SE16_sel=1'bx;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b1;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
					   end
						
				4'b1001: begin             //jalr ra, rb      JLR

							SE9_6_sel=1'bx; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'b0;
							Mem_write=1'b0;
							Reg_write=1'b1;                        
							ALU_Ct=2'bxx;
							Flag_Ct=2'b00;   //{carry,zero}
							cond=instr[1:0];
							WB_sel=2'b11;
							dest_reg=2'b01;
							DO2_SE16_sel=1'b0;// 0 for DO2
							LW_Stall=1'b0;
							branch=1'b0;
							DO1_SE16_sel=1'bx; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
					   end			
				default:begin
						   SE9_6_sel=1'bx; // 0 for Imm6
							valid=1'b1;
							ZP9_en=1'bx;
							Mem_write=1'b0;
							Reg_write=1'b0;                        
							ALU_Ct=2'bxx;
							Flag_Ct=2'bxx;   //{carry,zero}
							cond=2'bxx;
							WB_sel=2'bxx;
							dest_reg=2'bxx;
							DO2_SE16_sel=1'bx;// 0 for DO2
							LW_Stall=1'bx;
							branch=1'b0;
							DO1_SE16_sel=1'b0; // 0 for DO1
							JAL=1'b0;
							LM=1'b0;
							SM=1'b0;
							SW=1'b0;
							end
			endcase
		end
	
	assign EX_ctl={DO1_SE16_sel,Flag_Ct,LW_Stall,DO2_SE16_sel,ALU_Ct};
	assign Mem_ctl={branch,Mem_write};
	assign WB_ctl={WB_sel,Reg_write,cond};

endmodule

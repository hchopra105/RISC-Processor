module risc(clk,reset);	
	input clk,reset;
	///////////////////IF stage//////////////////////////////
	wire PC_en,IF_ID_en,IF_ID_clear,is_branch;
	wire [15:0] PC_in,PC_out,PC_plus1,instr,IFID_PC,IFID_PCplus,IFID_IR;
   wire [15:0] BTA,next_PC,PC_plus1_new;
	wire change_PC;
	
	////////////////////// ID Stage//////////////////////////
	wire SE9_6_sel,ID_RR_en,ZP9_en,IDRR_ZP9_en,isJAL,ID_RR_clear,valid_bits,IDRR_valid;
	wire LM,IDRR_LM,SM,IDRR_SM,SW,IDRR_SW;
	wire [15:0] SE_16bit,IDRR_PC,IDRR_PCplus,IDRR_SE16,DO1,DO2,SE_PC,IDRR_SEPC,NPC;
	wire [2:0] IDRR_R1,IDRR_R2,IDRR_R3;
	wire [6:0] EX_ctl,IDRR_EX_ctl;
	wire [3:0] IDRR_opcode;
	wire [1:0] Mem_ctl,IDRR_Mem_ctl,Dst_reg,IDRR_Dst_reg;
	wire [4:0] WB_ctl,IDRR_WB_ctl;
	////////////////////// RR Stage//////////////////////////
	wire RR_EX_en,RR_EX_clear,RREX_valid,mem_write_new,R7_jump;
	wire [15:0] ZP9,RREX_PCplus,RREX_SE16,RREX_SEPC,RREX_DO1,RREX_DO2,RREX_ZP9,DO1_new,RREX_PC,NPC0;
	wire [2:0] RREX_R1,RREX_R2,RREX_R3,Rd,RREX_Rd,R2_new;
	wire [6:0] RREX_EX_ctl;
	wire [3:0] RREX_opcode;
	wire [1:0] RREX_Mem_ctl,IDRR_Mem_ctl_new;
	wire [4:0] RREX_WB_ctl,RREX_WB_ctl_new;
	wire RREX_LM,RREX_SM,RREX_SW;
	wire [23:0] LM_signals;
	wire [23:0] LM_signals_out;
	//////////////////// LM-SM  //////////////////////////////
	wire [2:0] PE_out;
	wire isLM,LM_reg_write,alu_do1_sel;
	wire one_sel,LM_dest_sel,LM_wr_en,fwd_bit;
	wire SM_mem_wr_sel,r2_sel,mem_write;
	////////////////////// EX Stage//////////////////////////
	wire EX_Mem_en,regwrite_en,zero,carry,is_taken,is_jlr,reg_write_new,EX_Mem_clear;
	wire [15:0] alu_2nd,alu_1st,EXMem_PCplus,EXMem_SEPC,EXMem_ZP9,EXMem_ALUout,NPC1;
	wire [15:0] ALU_out,EXMem_DO1,EXMem_DO2;
	wire [1:0] Flag,EXMem_Flag;
	wire [2:0] EXMem_R1,EXMem_R2,EXMem_R3,EXMem_Rd,Rd_new;
	wire [1:0] EXMem_Mem_ctl,flag_cont;
	wire [4:0] EXMem_WB_ctl;
	wire [3:0] EXMem_opcode;
	wire fwdA,fwdB,EXMem_valid,EX_Mem_LM,its_R7,EX_Mem_SW,EX_Mem_SM;
	wire [15:0] dataA,dataB,A_DO1,B_DO2,alu_2nd_new,alu_in;
	
	////////////////////// Mem Stage//////////////////////////
	wire Mem_WB_en,DO1orDO2,LW,MemWB_valid,new_write_en,C,Z,isLW_dep,MemWB_LM,MemWB_LW,fwd_sw,R7_again;
	wire [15:0] Mem_DO,MemWB_Mem_DO,Mem_din,new_Mem_din,NPC2;
	wire [15:0] MemWB_PCplus,MemWB_SEPC,MemWB_ZP9,MemWB_ALUout;
	wire [15:0] MemWB_DO1;
	wire [2:0]  MemWB_R1,MemWB_R2,MemWB_R3,MemWB_Rd;
	wire [4:0]  MemWB_WB_ctl,EXMem_WB_ctl_new;
	wire [3:0]  MemWB_opcode;
	
	////////////////////// WB Stage//////////////////////////
	wire [15:0] Reg_din;
	wire [2:0] wrReg_num;
	wire Flag_Zero,Flag_Carry;
	///////////////////////End Stage////////////////////////
	wire WB_End_en,WB_End_reg_write;
	wire [15:0] WB_End_data;
	wire [2:0] WB_End_dest;
	
	
	
										////////////////
//////////////////////////////// IF stage /////////////////////////////////////////////
									 ////////////////

	 reg_16bit PC(.clk(clk), .ena(PC_en), .rst(reset), .din(PC_in), .dout(PC_out));
	 
	 assign PC_en=1'b1 & (~(isLM)) & (~(isLW_dep));
	 
	 assign PC_plus1 = PC_out + 16'b1;
	 
	 Mux_2 PCorpred(.sel(is_taken),.a(BTA),.b(PC_plus1),.Out(PC_plus1_new));
	 
	 IM ROM(PC_out,instr);
	 
	 
	 Predictor pred(.clk(clk),.rst(reset),.PC_current(PC_out),.PC_new(RREX_PC),
							.PC_plus(RREX_PCplus),.BA_new(RREX_SEPC),.is_beq(RREX_Mem_ctl[1]),
							.is_branch(is_branch),.is_taken(is_taken),
							.BTA(BTA),.next_PC(next_PC),.change_PC(change_PC));
				  
	Mux_2 beq_PCupdate(.sel(change_PC),.a(next_PC),.b(NPC1),.Out(NPC2));	// if branch is invalidated then new PC	
	

//////////////////////////////// IF_ID_Reg////////////////////////////////////////////
	 
	 IF_ID_registers IFID(.clock(clk),.clear(IF_ID_clear),.enable(IF_ID_en),.PC(PC_out),.PC_plus(PC_plus1),
							.IR(instr),.PC_out(IFID_PC),.PC_plus_out(IFID_PCplus),.IR_out(IFID_IR));
							
	assign IF_ID_clear = reset | isJAL | its_R7 | change_PC |R7_again | R7_jump;
	 
	 assign IF_ID_en=1'b1 & (~(isLM)) & (~(isLW_dep));
	 
	 
	 
	 
								  ////////////////
//////////////////////////// ID stage /////////////////////////////////////////////////
								////////////////
	
	Inst_decoder Insdecoder(.instr(IFID_IR),.PC(IFID_PC),.PC_plus(IFID_PCplus),.SE9_6_sel(SE9_6_sel),
									.ZP9_en(ZP9_en),.LM(LM),
									.valid(valid_bits),.EX_ctl(EX_ctl),.Mem_ctl(Mem_ctl),.WB_ctl(WB_ctl),
									.dest_reg(Dst_reg),.JAL(isJAL),.SM(SM),.SW(SW));
	
	Sign_Extend signExtend(.Imm9(IFID_IR[8:0]),.Imm6(IFID_IR[5:0]),.sel(SE9_6_sel),.dout(SE_16bit));
	
	assign SE_PC = SE_16bit + IFID_PC;
	
   //Mux_2 Jal_SEPC(.sel(isJAL),.a(SE_PC),.b(PC_plus1_new),.Out(NPC));
	
	R7_control_ID JAL_control(.jal(isJAL),.SEPC(SE_PC),.PC_plus1_new(PC_plus1_new),
									.Ra(IFID_IR[11:9]),.NPC(NPC));
	
	
//////////////////////////////// ID_RR_Reg////////////////////////////////////////////
	ID_RR_registers IDRR(.clock(clk),.clear(ID_RR_clear),.enable(ID_RR_en),.PC(IFID_PC),.PC_plus(IFID_PCplus),
						  .R1(IFID_IR[11:9]),.R2(IFID_IR[8:6]),.SW(SW),
						  .R3(IFID_IR[5:3]),.SE16(SE_16bit),.opcode(IFID_IR[15:12]),
						  .EX_Ct(EX_ctl),.Mem_Ct(Mem_ctl),.WB_Ct(WB_ctl),.ZP9_en(ZP9_en),.Dst_reg(Dst_reg),.LM(LM),// changed from mux to direct LM
						  .valid(valid_bits),.PC_out(IDRR_PC),.Dst_reg_out(IDRR_Dst_reg),.SEPC(SE_PC),.SM(SM),//changed from mux to direct
                    .PC_plus_out(IDRR_PCplus),.R1_out(IDRR_R1),.R2_out(IDRR_R2),.ZP9_en_out(IDRR_ZP9_en),
						  .R3_out(IDRR_R3),.SE16_out(IDRR_SE16),.EX_Ct_out(IDRR_EX_ctl),.SEPC_out(IDRR_SEPC),
						  .Mem_Ct_out(IDRR_Mem_ctl),.WB_Ct_out(IDRR_WB_ctl),.LM_out(IDRR_LM),.SM_out(IDRR_SM),
						  .valid_out(IDRR_valid),.opcode_out(IDRR_opcode),.SW_out(IDRR_SW));
	 
	 assign ID_RR_en=1'b1 & (~(isLM)) & (~(isLW_dep));
	 assign ID_RR_clear= reset  | its_R7 | change_PC | R7_again | R7_jump;
		
	
	
	
	 
								  ////////////////
//////////////////////////// RR stage /////////////////////////////////////////////////
								////////////////
	
	Mux_2 #(3)R2_MUX(.sel(r2_sel),.a(PE_out),.b(IDRR_R2),.Out(R2_new));
	
	 Regfile regfile(.data_out1(DO1),.data_out2(DO2),.data_in(Reg_din),.R7_in(PC_in),
						  .sr1(IDRR_R1),.sr2(R2_new),.wr(MemWB_Rd),.write_en(MemWB_WB_ctl[2]),
						  .R7_en(PC_en),.clk(clk),.rst(reset));
	
	R7_control_RR R7_ZP9_jump(.ZP9_en(IDRR_ZP9_en),.incoming_PC(NPC),.Rd(Rd),
									  .ZP9_data(ZP9),.new_PC(NPC0),.R7_jump(R7_jump));
	 
	 assign ZP9 = IDRR_ZP9_en ? IDRR_SE16<<7 :16'bx;
	 
	 Mux_4 #(3) Destreg_Mux(.sel(IDRR_Dst_reg),.a(3'bx),.b(IDRR_R1),
														.c(IDRR_R2),.d(IDRR_R3),.Out(Rd));					
	
	 LMSM LS(.clk(clk),.reset(reset),.IDRR_LM(IDRR_LM),.SE16(IDRR_SE16),.PE_out(PE_out),
					.alu_do1_sel(alu_do1_sel),.one_sel(one_sel),
					.LM_dest_sel(LM_dest_sel),.LM_wr_en(LM_wr_en),
					.fwd_bit(fwd_bit),.disable_pipe(isLM),.IDRR_SM(IDRR_SM),
					.reg_write(LM_reg_write),.alu_in(alu_in),
					.SM_mem_wr_sel(SM_mem_wr_sel),.r2_sel(r2_sel),
					.mem_write(mem_write));
	
	Mux_2 ALUDo1_MUX(.sel(alu_do1_sel),.a(ALU_out),.b(DO1),.Out(DO1_new));		// used in case of LM
					
	Mux_2 #(1)Memwrite_MUX(.sel(SM_mem_wr_sel),.a(mem_write),.b(IDRR_Mem_ctl[0]),.Out(mem_write_new)); 
	 
	assign  IDRR_Mem_ctl_new={IDRR_Mem_ctl[1],mem_write_new};
	
	assign LM_signals={alu_in,PE_out,fwd_bit,LM_reg_write,LM_wr_en,LM_dest_sel,one_sel};
	 
//////////////////////////////// RR_EX_Reg////////////////////////////////////////////	 

	RR_EX_registers RREX(.clock(clk),.clear(RR_EX_clear),.enable(RR_EX_en),.PC_plus(IDRR_PCplus),.Rd(Rd),
								.DO1(DO1_new),.DO2(DO2),.R1(IDRR_R1),.R2(R2_new),.R3(IDRR_R3),.SE16(IDRR_SE16),
								.SEPC(IDRR_SEPC),.ZP9(ZP9),.EX_Ct(IDRR_EX_ctl),.Mem_Ct(IDRR_Mem_ctl_new),
								.LM(IDRR_LM),.SM(IDRR_SM),.SW(IDRR_SW),
								.WB_Ct(IDRR_WB_ctl),.PC(IDRR_PC),.PC_out(RREX_PC),.LM_signals(LM_signals),
								.LM_out(RREX_LM),.SM_out(RREX_SM),.SW_out(RREX_SW),
								.valid(IDRR_valid),.PC_plus_out(RREX_PCplus),.DO1_out(RREX_DO1),.DO2_out(RREX_DO2),
								.LM_signals_out(LM_signals_out),
								.R1_out(RREX_R1),.R2_out(RREX_R2),.R3_out(RREX_R3),.SE16_out(RREX_SE16),.opcode(IDRR_opcode),
								.SEPC_out(RREX_SEPC),.ZP9_out(RREX_ZP9),.valid_out(RREX_valid),.Rd_out(RREX_Rd),
							   .EX_Ct_out(RREX_EX_ctl),.Mem_Ct_out(RREX_Mem_ctl),.WB_Ct_out(RREX_WB_ctl),
								.opcode_out(RREX_opcode));
	assign RR_EX_en=1'b1  & (~(isLW_dep));
	assign RR_EX_clear= reset  | its_R7 | change_PC | R7_again;
	
	
	
	 
								  ////////////////
//////////////////////////// EX stage /////////////////////////////////////////////////
								////////////////	
	

	Mux_2 fwdA_MUX(.sel(fwdA),.a(dataA),.b(RREX_DO1),.Out(A_DO1));
	Mux_2 fwdB_MUX(.sel(fwdB),.a(dataB),.b(RREX_DO2),.Out(B_DO2));	
	
	Mux_2 Aluin1_MUX(.sel(RREX_EX_ctl[6]),.a(RREX_SE16),.b(A_DO1),.Out(alu_1st));
	Mux_2 Aluin2_MUX(.sel(RREX_EX_ctl[2]),.a(RREX_SE16),.b(B_DO2),.Out(alu_2nd));
	
	Mux_2 LMALUin_MUX(.sel(LM_signals_out[0]),.a(LM_signals_out[23:8]),.b(alu_2nd),.Out(alu_2nd_new));

	
	ALU al(.in1(alu_1st),.in2(alu_2nd_new),.alu_ct(RREX_EX_ctl[1:0]),
				.result(ALU_out),.zero(Flag[0]),.carry(Flag[1]));
	
		

	
	
	forwarding_unit forward(.RR_EX_Rs(RREX_R1),.RR_EX_Rt(RREX_R2),.EX_Mem_mux_sel(EXMem_WB_ctl[4:3]),
									.EX_Mem_Rd(EXMem_Rd),.EX_Mem_Regwrite(new_write_en),.RR_EX_PC(RREX_PC),
									.EX_Mem_ALU_out(EXMem_ALUout),.EX_Mem_ZP9(EXMem_ZP9),
									.EX_Mem_PC_plus(EXMem_PCplus),.Mem_WB_Rd(MemWB_Rd),.LM_fwd(LM_signals_out[4]),
									.Mem_WB_Regwrite(MemWB_WB_ctl[2]),.Mem_WB_data(Reg_din),.WB_end_data(WB_End_data),
									.WB_end_Rd(WB_End_dest),.WB_end_Regwrite(WB_End_reg_write),.forwardA(fwdA),
									.forwarding_dataA(dataA),.forwardB(fwdB),
									.forwarding_dataB(dataB));
									
		


	branch_control BC(.opcode(RREX_opcode),.ALU_out(ALU_out),.is_taken(is_branch),.is_jlr(is_jlr));
	
	
	//Mux_2 Jlr_PCupdate(.sel(is_jlr),.a(alu_2nd),.b(NPC),.Out(NPC1));
	
	R7_control_EX jlr_R7(.RREX_opcode(RREX_opcode),.jlr(is_jlr),.jalr_PC(alu_2nd),.incoming_PC(NPC0),
								.cond(RREX_WB_ctl[1:0]),.Rd(RREX_Rd),.Alu_result(ALU_out),.new_PC(NPC1),.its_R7(its_R7));
	
	Mux_2 #(3)LMdest_MUX(.sel(LM_signals_out[1]),.a(LM_signals_out[7:5]),.b(RREX_Rd),.Out(Rd_new));
	
	Mux_2 #(1)LMregwrite_MUX(.sel(LM_signals_out[2]),.a(LM_signals_out[3]),.b(RREX_WB_ctl[2]),.Out(reg_write_new));
	
	assign RREX_WB_ctl_new={RREX_WB_ctl[4:3],reg_write_new,RREX_WB_ctl[1:0]};
	
//////////////////////////////// EX_Mem_Reg////////////////////////////////////////////	

	


	EX_Mem_registers EX_Mem(.clock(clk),.clear(EX_Mem_clear),.enable(EX_Mem_en),.DO1_DO2_sel(RREX_EX_ctl[6]),
									.PC_plus(RREX_PCplus),.DO1(A_DO1),.DO2(B_DO2),.SW(RREX_SW),.SM(RREX_SM),
									.R1(RREX_R1),.R2(RREX_R2),.R3(RREX_R3),.SEPC(RREX_SEPC),.ZP9(RREX_ZP9),.Rd(Rd_new),
									.Mem_Ct(RREX_Mem_ctl),.WB_Ct(RREX_WB_ctl_new),.ALUout(ALU_out),.Flags(Flag),
									.valid(RREX_valid),.PC_plus_out(EXMem_PCplus),.DO1_out(EXMem_DO1),
									.DO2_out(EXMem_DO2),.LW(RREX_EX_ctl[3]),.LW_out(LW),.flag_ct(RREX_EX_ctl[5:4]),
									.flag_ct_out(flag_cont),.SW_out(EX_Mem_SW),.SM_out(EX_Mem_SM),
									.R1_out(EXMem_R1),.R2_out(EXMem_R2),.R3_out(EXMem_R3),.SEPC_out(EXMem_SEPC),
									.ZP9_out(EXMem_ZP9),.ALUout_out(EXMem_ALUout),.Rd_out(EXMem_Rd),.opcode(RREX_opcode),
									.Flags_out(EXMem_Flag),.valid_out(EXMem_valid),.Mem_Ct_out(EXMem_Mem_ctl),
									.WB_Ct_out(EXMem_WB_ctl),.DO1_DO2_sel_out(DO1orDO2),.opcode_out(EXMem_opcode),
									.LM(RREX_LM),.LM_out(EX_Mem_LM));

	assign EX_Mem_en=1'b1;
	assign EX_Mem_clear= reset | isLW_dep | R7_again;
	
	 
	 
	 
	 
								  ////////////////
//////////////////////////// Mem stage /////////////////////////////////////////////////
								////////////////		
		
		R7_control_Mem R7_Mem(.EXMem_opcode(EXMem_opcode),.incoming_PC(NPC2),.cond(EXMem_WB_ctl[1:0]),
										.Rd(EXMem_Rd),.Alu_result(EXMem_ALUout),.Mem_out(Mem_DO),
										.LW(LW),.LM(EX_Mem_LM),
										.Reg_write(new_write_en),.new_PC(PC_in),.R7_again(R7_again));
		
		
		
		Mux_2 DO1_DO2_MUX(.sel(DO1orDO2),.a(EXMem_DO1),.b(EXMem_DO2),.Out(Mem_din));// DO1orDO2=1 for SW and 0 for SM. it's same signal used in EX stage fore DO1orSE16_sel
	
	
		Mux_2 lwsw_stall_MUX(.sel(fwd_sw),.a(MemWB_Mem_DO),.b(Mem_din),.Out(new_Mem_din));
	
	/////// for load dependancy stall/////////
	                                                       
	staller ST(.LW(LW),.LM(EX_Mem_LM),.RREX_LM(RREX_LM),.RREX_SW(RREX_SW),.RREX_SM(RREX_SM),.opcode(RREX_opcode),
					.valid(RREX_valid),.Rs(RREX_R1),.Rt(RREX_R2),.Rd(EXMem_Rd),.isLW_dep(isLW_dep));
						
	////////////// Load - store forwarding/////////////////
	
		lwsw_fwd lwsw(.MemWB_lw(MemWB_LW),.MemWb_LM(MemWB_LM),.ExMem_SW(EX_Mem_SW),.EXMem_SM(EX_Mem_SM),
						  .Rd(MemWB_Rd),.Rt(EXMem_R2),.Rs(EXMem_R1),.fwd_sw(fwd_sw));
	////DRAM///////
	    DM ram(.clk(clk),.write_en(EXMem_Mem_ctl[0]),.read_en(1'b1),
				  .addr(EXMem_ALUout),.data_in(new_Mem_din),.data_out(Mem_DO));
				  
			
			///Flag HAndling/////////
			
   condition_control CC(.Rd(EXMem_Rd),.reg_write(EXMem_WB_ctl[2]),.cond(EXMem_WB_ctl[1:0]),.flag_ctl(flag_cont),
								.flag(EXMem_Flag),.LW(LW),.Flag_reg({Flag_Carry,Flag_Zero}),
								.opcode(EXMem_opcode),.Mem_out(Mem_DO),.C(C),.Z(Z),.write_en(new_write_en));

		assign EXMem_WB_ctl_new = {EXMem_WB_ctl[4:3],new_write_en,EXMem_WB_ctl[1:0]}	;	  
				  
		reg_16bit #(1)ZerO(.clk(clk), .ena(1'b1), .rst(reset), .din(Z), .dout(Flag_Zero));
		reg_16bit #(1)CarrY(.clk(clk), .ena(1'b1), .rst(reset), .din(C), .dout(Flag_Carry));
	
//////////////////////////////// Mem_WB_Reg////////////////////////////////////////////		
	
	Mem_WB_registers Mem_WB(.clock(clk),.clear(reset),.enable(Mem_WB_en),.PC_plus(EXMem_PCplus),.DO1(EXMem_DO1),
						  .R1(EXMem_R1),.R2(EXMem_R2),.R3(EXMem_R3),.SEPC(EXMem_SEPC),.ZP9(EXMem_ZP9),
						  .WB_Ct(EXMem_WB_ctl_new),.ALUout(EXMem_ALUout),.Rd(EXMem_Rd),
						  .Mem_DO(Mem_DO),.valid(EXMem_valid),.opcode(EXMem_opcode),.LM(EX_Mem_LM),.LW(LW),
						  .PC_plus_out(MemWB_PCplus),.DO1_out(MemWB_DO1),.R1_out(MemWB_R1),.R2_out(MemWB_R2),
						  .R3_out(MemWB_R3),.SEPC_out(MemWB_SEPC),.ZP9_out(MemWB_ZP9),.ALUout_out(MemWB_ALUout),
						  .Mem_DO_out(MemWB_Mem_DO),.Rd_out(MemWB_Rd),.LW_out(MemWB_LW),.LM_out(MemWB_LM),
						  .valid_out(MemWB_valid),.WB_Ct_out(MemWB_WB_ctl),.opcode_out(MemWB_opcode));
	assign Mem_WB_en=1'b1;
	
	 
								  ////////////////
//////////////////////////// WB stage /////////////////////////////////////////////////
								////////////////		
							
						
	Mux_4 WB_Mux(.sel(MemWB_WB_ctl[4:3]),.a(MemWB_ALUout),.b(MemWB_ZP9),.c(MemWB_Mem_DO),
					.d(MemWB_PCplus),.Out(Reg_din));	
					
					
					
 
	
	
	 
//////////////////////////////// WB_End_Reg////////////////////////////////////////////				
			
	WB_End_registers WB_End(.clock(clk),.clear(reset),.enable(WB_End_en),.data(Reg_din),.Rdest_num(MemWB_Rd),
									.Reg_write(MemWB_WB_ctl[2]),.data_out(WB_End_data),
									.Reg_write_out(WB_End_reg_write),.Rdest_num_out(WB_End_dest));	
								
	
	
	assign WB_End_en=1'b1;
			
endmodule

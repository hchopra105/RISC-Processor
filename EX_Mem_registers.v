module EX_Mem_registers(clock,clear,enable,PC_plus,DO1,DO2,DO1_DO2_sel,R1,R2,R3,SEPC,ZP9,opcode,LW,LM,SM,SW,
								Mem_Ct,WB_Ct,ALUout,Flags,valid,Rd,Rd_out,opcode_out,flag_ct,LM_out,
								SM_out,SW_out,
								PC_plus_out,DO1_out,DO2_out,R1_out,R2_out,R3_out,SEPC_out,ZP9_out,ALUout_out,Flags_out,
								valid_out,Mem_Ct_out,WB_Ct_out,DO1_DO2_sel_out,LW_out,flag_ct_out);
							
	input clock,clear,enable,DO1_DO2_sel,LW;
	input [15:0] PC_plus,SEPC,DO1,DO2,ZP9,ALUout;
	input [2:0] R1,R2,R3,Rd;
	input [1:0] Mem_Ct; // [0] Mem_write , [1] branch
	input [4:0] WB_Ct; // [1:0] condition , [2] Reg_write, [4:3] WB_sel
	input [1:0] Flags,flag_ct; // [1] carry, [0] Zero
	input valid,LM,SM,SW;
	input [3:0] opcode;
	
	output [15:0] PC_plus_out,SEPC_out,DO1_out,DO2_out,ZP9_out,ALUout_out;
	output [2:0] R1_out,R2_out,R3_out,Rd_out;
	output [1:0] Mem_Ct_out; 
	output [4:0] WB_Ct_out; 
	output [1:0] Flags_out,flag_ct_out;
	output valid_out,LM_out,SM_out,SW_out;
	output [3:0] opcode_out;
	output DO1_DO2_sel_out,LW_out;// 1 for DO1
	
	reg_16bit PC_plus_reg (.clk(clock), .ena(enable), .rst(clear), .din(PC_plus), .dout(PC_plus_out));
	reg_16bit SEPC_reg (.clk(clock), .ena(enable), .rst(clear), .din(SEPC), .dout(SEPC_out));
	reg_16bit DO1_reg (.clk(clock), .ena(enable), .rst(clear), .din(DO1), .dout(DO1_out));
	reg_16bit DO2_reg (.clk(clock), .ena(enable), .rst(clear), .din(DO2), .dout(DO2_out));
	reg_16bit ZP9_reg (.clk(clock), .ena(enable), .rst(clear), .din(ZP9), .dout(ZP9_out));
	reg_16bit ALUout_reg (.clk(clock), .ena(enable), .rst(clear), .din(ALUout), .dout(ALUout_out));

	
	reg_16bit #(4) opcode_reg (.clk(clock), .ena(enable), .rst(clear), .din(opcode), .dout(opcode_out));
	
	reg_16bit #(3)Rd_reg (.clk(clock), .ena(enable), .rst(clear), .din(Rd), .dout(Rd_out));
	
	reg_16bit #(1) DO1_DO2_reg (.clk(clock), .ena(enable), .rst(clear), .din(DO1_DO2_sel), .dout(DO1_DO2_sel_out));
	reg_16bit #(1) LW_reg (.clk(clock), .ena(enable), .rst(clear), .din(LW), .dout(LW_out));
	reg_16bit #(1) LM_reg (.clk(clock), .ena(enable), .rst(clear), .din(LM), .dout(LM_out));
	
	reg_16bit #(1) SM_reg (.clk(clock), .ena(enable), .rst(clear), .din(SM), .dout(SM_out));
	reg_16bit #(1) SW_reg (.clk(clock), .ena(enable), .rst(clear), .din(SW), .dout(SW_out));
	reg_16bit #(1) valid_reg (.clk(clock), .ena(enable), .rst(clear), .din(valid), .dout(valid_out));
	
	
	reg_16bit #(2) Flags_reg (.clk(clock), .ena(enable), .rst(clear), .din(Flags), .dout(Flags_out));
	reg_16bit #(2) FlagsCTL_reg (.clk(clock), .ena(enable), .rst(clear), .din(flag_ct), .dout(flag_ct_out));
	
	reg_16bit #(3) R1_reg (.clk(clock), .ena(enable), .rst(clear), .din(R1), .dout(R1_out));
	reg_16bit #(3) R2_reg (.clk(clock), .ena(enable), .rst(clear), .din(R2), .dout(R2_out));
	reg_16bit #(3) R3_reg (.clk(clock), .ena(enable), .rst(clear), .din(R3), .dout(R3_out));
	
	reg_16bit #(2) Mem_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(Mem_Ct), .dout(Mem_Ct_out));
	reg_16bit #(5) WB_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(WB_Ct), .dout(WB_Ct_out));


endmodule

module RR_EX_registers(clock,clear,enable,PC,PC_plus,DO1,DO2,R1,R2,R3,SE16,SEPC,ZP9,EX_Ct,LM,SM,SW,
								Mem_Ct,WB_Ct,valid,Rd,opcode,PC_out,LM_signals,LM_out,SM_out,SW_out,
								PC_plus_out,DO1_out,DO2_out,R1_out,R2_out,R3_out,SE16_out,SEPC_out,
								ZP9_out,valid_out,Rd_out,
								EX_Ct_out,Mem_Ct_out,WB_Ct_out,opcode_out,LM_signals_out);

							
	input clock,clear,enable;
	input [15:0] PC_plus,SE16,SEPC,DO1,DO2,ZP9,PC;
	input [2:0] R1,R2,R3,Rd;
	input [6:0] EX_Ct; // [1:0] ALU_Ct, [2] DO2_SE16_sel , [3] LW_stall, [5:4] Flag_ct, [6] DO1_SE16_sel
	input [1:0] Mem_Ct; // [0] Mem_write , [1] branch
	input [4:0] WB_Ct; // [1:0] condition , [2] Reg_write, [4:3] WB_sel
	input  valid,LM,SM,SW;
	input [3:0] opcode;
	input [23:0] LM_signals; // [0] one_sel, [1] LM_dest_sel, [2] LM_wr_sel, [3] LM_reg_write, [4] fwd_bit, [7:5] PE_out, [23:8] alu_in
	
	output [15:0] PC_plus_out,SE16_out,SEPC_out,DO1_out,DO2_out,ZP9_out,PC_out;
	output [2:0] R1_out,R2_out,R3_out,Rd_out;
	output [6:0] EX_Ct_out; 
	output [1:0] Mem_Ct_out; 
	output [4:0] WB_Ct_out; 
	output valid_out,LM_out,SM_out,SW_out;
	output [3:0] opcode_out;
	output [23:0] LM_signals_out;
	
	reg_16bit #(24)LMsignals_reg (.clk(clock), .ena(enable), .rst(clear), .din(LM_signals), .dout(LM_signals_out));
	reg_16bit PC_plus_reg (.clk(clock), .ena(enable), .rst(clear), .din(PC_plus), .dout(PC_plus_out));
	reg_16bit PC_reg (.clk(clock), .ena(enable), .rst(clear), .din(PC), .dout(PC_out));
	reg_16bit SEPC_reg (.clk(clock), .ena(enable), .rst(clear), .din(SEPC), .dout(SEPC_out));
	reg_16bit SE16_reg (.clk(clock), .ena(enable), .rst(clear), .din(SE16), .dout(SE16_out));
	reg_16bit DO1_reg (.clk(clock), .ena(enable), .rst(clear), .din(DO1), .dout(DO1_out));
	reg_16bit DO2_reg (.clk(clock), .ena(enable), .rst(clear), .din(DO2), .dout(DO2_out));
	reg_16bit ZP9_reg (.clk(clock), .ena(enable), .rst(clear), .din(ZP9), .dout(ZP9_out));
	
	reg_16bit #(1) LM_reg (.clk(clock), .ena(enable), .rst(clear), .din(LM), .dout(LM_out));
	reg_16bit #(1) SM_reg (.clk(clock), .ena(enable), .rst(clear), .din(SM), .dout(SM_out));
	reg_16bit #(1) SW_reg (.clk(clock), .ena(enable), .rst(clear), .din(SW), .dout(SW_out));
	
	reg_16bit #(4) opcode_reg (.clk(clock), .ena(enable), .rst(clear), .din(opcode), .dout(opcode_out));
	
	reg_16bit #(3)Rd_reg (.clk(clock), .ena(enable), .rst(clear), .din(Rd), .dout(Rd_out));
	
	reg_16bit #(1) valid_reg (.clk(clock), .ena(enable), .rst(clear), .din(valid), .dout(valid_out));
	
	reg_16bit #(3) R1_reg (.clk(clock), .ena(enable), .rst(clear), .din(R1), .dout(R1_out));
	reg_16bit #(3) R2_reg (.clk(clock), .ena(enable), .rst(clear), .din(R2), .dout(R2_out));
	reg_16bit #(3) R3_reg (.clk(clock), .ena(enable), .rst(clear), .din(R3), .dout(R3_out));
	
	reg_16bit #(7) EX_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(EX_Ct), .dout(EX_Ct_out));
	reg_16bit #(2) Mem_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(Mem_Ct), .dout(Mem_Ct_out));
	reg_16bit #(5) WB_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(WB_Ct), .dout(WB_Ct_out));


endmodule

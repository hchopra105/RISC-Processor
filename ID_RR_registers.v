module ID_RR_registers(clock,clear,enable,PC,PC_plus,R1,R2,R3,SE16,EX_Ct,
							  Mem_Ct,WB_Ct,PC_out,valid,ZP9_en,SEPC,LM,SM,SW,
                       PC_plus_out,R1_out,R2_out,R3_out,SE16_out,EX_Ct_out,
							  ZP9_en_out,Dst_reg,SEPC_out,opcode,LM_out,SM_out,SW_out,
							  Mem_Ct_out,WB_Ct_out,valid_out,Dst_reg_out,opcode_out);
	input clock,clear,enable,ZP9_en,LM,SM,SW;
	input [15:0] PC,PC_plus,SE16,SEPC;
	input [2:0] R1,R2,R3;
	input [3:0] opcode;
	input [6:0] EX_Ct; // [1:0] ALU_Ct, [2] DO2_SE16_sel ,[3] LW_stall, [5:4] Flag_ct, [6]DO1_SE16_sel
	input [1:0] Mem_Ct; // [0] Mem_write , [1] branch
	input [4:0] WB_Ct; // [1:0] condition , [2] Reg_write, [4:3] WB_sel
	input  valid;
	input [1:0] Dst_reg;
	
	output ZP9_en_out,LM_out,SM_out,SW_out;
	output [15:0] PC_out,PC_plus_out,SE16_out,SEPC_out;
	output [2:0] R1_out,R2_out,R3_out;
	output [3:0] opcode_out;
	output [6:0] EX_Ct_out; 
	output [1:0] Mem_Ct_out; 
	output [4:0] WB_Ct_out; 
	output valid_out;
	output [1:0] Dst_reg_out;
	
	reg_16bit PC_reg (.clk(clock), .ena(enable), .rst(clear), .din(PC), .dout(PC_out));
	reg_16bit PC_plus_reg (.clk(clock), .ena(enable), .rst(clear), .din(PC_plus), .dout(PC_plus_out));
	reg_16bit SE16_reg (.clk(clock), .ena(enable), .rst(clear), .din(SE16), .dout(SE16_out));
	reg_16bit SEPC_reg (.clk(clock), .ena(enable), .rst(clear), .din(SEPC), .dout(SEPC_out));
	
	reg_16bit #(4) opcode_reg (.clk(clock), .ena(enable), .rst(clear), .din(opcode), .dout(opcode_out));

	reg_16bit #(1) ZP9_en_reg (.clk(clock), .ena(enable), .rst(clear), .din(ZP9_en), .dout(ZP9_en_out));
	
	reg_16bit #(1) LM_reg (.clk(clock), .ena(enable), .rst(clear), .din(LM), .dout(LM_out));
	reg_16bit #(1) SM_reg (.clk(clock), .ena(enable), .rst(clear), .din(SM), .dout(SM_out));
	reg_16bit #(1) SW_reg (.clk(clock), .ena(enable), .rst(clear), .din(SW), .dout(SW_out));
	reg_16bit #(1) valid_reg (.clk(clock), .ena(enable), .rst(clear), .din(valid), .dout(valid_out));
	
	reg_16bit #(3) R1_reg (.clk(clock), .ena(enable), .rst(clear), .din(R1), .dout(R1_out));
	reg_16bit #(3) R2_reg (.clk(clock), .ena(enable), .rst(clear), .din(R2), .dout(R2_out));
	reg_16bit #(3) R3_reg (.clk(clock), .ena(enable), .rst(clear), .din(R3), .dout(R3_out));
	
	reg_16bit #(2) Dst_reg_reg (.clk(clock), .ena(enable), .rst(clear), .din(Dst_reg), .dout(Dst_reg_out));
		
	reg_16bit #(7) EX_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(EX_Ct), .dout(EX_Ct_out));
	reg_16bit #(2) Mem_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(Mem_Ct), .dout(Mem_Ct_out));
	reg_16bit #(5) WB_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(WB_Ct), .dout(WB_Ct_out));
	
	
endmodule

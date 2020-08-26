module Mem_WB_registers(clock,clear,enable,PC_plus,DO1,R1,R2,R3,SEPC,ZP9,WB_Ct,ALUout,Mem_DO,
							valid,Rd,opcode,LM,LW,LM_out,LW_out,
							PC_plus_out,DO1_out,R1_out,R2_out,R3_out,SEPC_out,ZP9_out,ALUout_out,Mem_DO_out,
							valid_out,WB_Ct_out,Rd_out,opcode_out);
	
	input clock,clear,enable;
	input [15:0] PC_plus,SEPC,DO1,ZP9,ALUout,Mem_DO;
	input [2:0] R1,R2,R3,Rd;
	input [4:0] WB_Ct; // [1:0] condition , [2] Reg_write, [4:3] WB_sel
	input valid,LM,LW;
	input [3:0] opcode;
	
	output [15:0] PC_plus_out,SEPC_out,DO1_out,ZP9_out,ALUout_out,Mem_DO_out;
	output [2:0] R1_out,R2_out,R3_out,Rd_out;
	output [4:0] WB_Ct_out; 
	output valid_out,LM_out,LW_out;
	output [3:0] opcode_out;
	
	
	reg_16bit PC_plus_reg (.clk(clock), .ena(enable), .rst(clear), .din(PC_plus), .dout(PC_plus_out));
	reg_16bit SEPC_reg (.clk(clock), .ena(enable), .rst(clear), .din(SEPC), .dout(SEPC_out));
	reg_16bit DO1_reg (.clk(clock), .ena(enable), .rst(clear), .din(DO1), .dout(DO1_out));
	reg_16bit ZP9_reg (.clk(clock), .ena(enable), .rst(clear), .din(ZP9), .dout(ZP9_out));
	reg_16bit ALUout_reg (.clk(clock), .ena(enable), .rst(clear), .din(ALUout), .dout(ALUout_out));
	reg_16bit Mem_DO_reg (.clk(clock), .ena(enable), .rst(clear), .din(Mem_DO), .dout(Mem_DO_out));
	reg_16bit #(4) opcode_reg (.clk(clock), .ena(enable), .rst(clear), .din(opcode), .dout(opcode_out));
	
	reg_16bit #(3) Rd_reg (.clk(clock), .ena(enable), .rst(clear), .din(Rd), .dout(Rd_out));
	
	reg_16bit #(1) valid_reg (.clk(clock), .ena(enable), .rst(clear), .din(valid), .dout(valid_out));
	reg_16bit #(1) LW_reg (.clk(clock), .ena(enable), .rst(clear), .din(LW), .dout(LW_out));
	reg_16bit #(1) LM_reg (.clk(clock), .ena(enable), .rst(clear), .din(LM), .dout(LM_out));
	
	reg_16bit #(3) R1_reg (.clk(clock), .ena(enable), .rst(clear), .din(R1), .dout(R1_out));
	reg_16bit #(3) R2_reg (.clk(clock), .ena(enable), .rst(clear), .din(R2), .dout(R2_out));
	reg_16bit #(3) R3_reg (.clk(clock), .ena(enable), .rst(clear), .din(R3), .dout(R3_out));
	
	
	reg_16bit #(5) WB_Ct_reg (.clk(clock), .ena(enable), .rst(clear), .din(WB_Ct), .dout(WB_Ct_out));


endmodule

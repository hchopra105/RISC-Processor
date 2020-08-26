module IF_ID_registers(clock,clear,enable,PC,PC_plus,IR,PC_out,PC_plus_out,IR_out);
	input clock,clear,enable;
	input [15:0] PC,PC_plus,IR;
	output  [15:0] PC_out,PC_plus_out,IR_out;
	
		
		
		reg_16bit PC_reg (.clk(clock), .ena(enable), .rst(clear), .din(PC), .dout(PC_out));
		reg_16bit PC_plus_reg (.clk(clock), .ena(enable), .rst(clear), .din(PC_plus), .dout(PC_plus_out));
		reg_16bit IR_reg (.clk(clock), .ena(enable), .rst(clear), .din(IR), .dout(IR_out));
		
		
endmodule

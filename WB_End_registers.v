module WB_End_registers(clock,clear,enable,data,Rdest_num,Reg_write,data_out,Reg_write_out,Rdest_num_out);
	input clock,clear,enable;
	input [2:0] Rdest_num;
	input Reg_write;
	input [15:0] data;
	
	output [2:0] Rdest_num_out;
	output Reg_write_out;
	output [15:0] data_out;
	
	reg_16bit data_reg (.clk(clock), .ena(enable), .rst(clear), .din(data), .dout(data_out));
	reg_16bit #(1) regwr_reg (.clk(clock), .ena(enable), .rst(clear), .din(Reg_write), .dout(Reg_write_out));

	reg_16bit #(3) destreg_reg (.clk(clock), .ena(enable), .rst(clear), .din(Rdest_num), .dout(Rdest_num_out));


endmodule

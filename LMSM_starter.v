module LMSM_starter(clk,direct,enable_holdreg,reset,Imm8,ok,over,PE_out);
	input clk,direct,enable_holdreg,reset;
	input [7:0]Imm8;
	output ok,over;
	reg over;
	output [2:0] PE_out;
	
	wire [7:0] mux_out,reg_out;
	reg [7:0] reg_temp;
	
	
	
	reg_16bit #(8) hold_reg(.clk(clk),.ena(enable_holdreg),.rst(reset),.din(reg_temp),.dout(reg_out));
	
	Mux_2 #(8) Imm_PEmux(.sel(direct),.a(Imm8),.b(reg_out),.Out(mux_out));

	priority_en PE(mux_out,PE_out,ok);
	
	
	always @(PE_out,mux_out)
		begin
			reg_temp=mux_out;
			reg_temp[PE_out]=1'b0;
			
			if(reg_temp==8'b0)
				over=1'b1;
			else
				over=1'b0;
			
		end
	
	
endmodule

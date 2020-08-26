module DM(clk,write_en,read_en,addr,data_in,data_out);
	input read_en,write_en,clk;
	input [15:0] addr;
	input [15:0] data_in;
	output reg [15:0] data_out;
	integer i;
	
	reg [15:0] ram[0:1023];

	
	
	
	always @(posedge clk)
	begin
//		if(rst)
//			for(i=0;i<1024;i=i+1)
//				ram[i]<=16'b0;
//		else 
		if(write_en==1'b1)
		begin
			ram[addr]=data_in;
			$display("WRITE: ram[%d] = %d", addr, data_in);
		end
		
	end

	always @(read_en,ram[addr],addr)
	begin
		if(read_en)
			data_out = ram[addr];
		else data_out=16'bx;	
		$display("READ: ram[%d] = %d", addr, ram[addr]);
    end


endmodule

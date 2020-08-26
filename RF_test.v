`timescale 10ns/1ns
module test ;
	reg [2:0] sr1,sr2,wr;
	reg write_en,clk,R7_en,rst;
	reg [15:0] data_in,R7_in;
	wire [15:0] data_out1,data_out2;
	integer k,i;
	Regfile a (data_out1,data_out2,data_in,R7_in,sr1,sr2,wr,write_en,R7_en,clk,rst);

	initial
		begin
			clk=0;rst=1;
		end
	always #5 clk = ~clk;
	initial write_en=0;
	initial
	begin 
	#6 rst=0;
	#1
	for (k=0; k<7;k=k+1)
		begin 
			wr=k; data_in=10*k; write_en = 1;
			#10 write_en=0;
			end
		#20
	for(i=0;i<7;i=i+2)
	begin
	 sr1=i;sr2=i+1;
	 #5;
	 $display ("Reg[%2d]=%d,Reg [%2d] = %d", sr1,data_out1,sr2,data_out2);
	 end
	#2000 $finish;
	end
	initial
		begin
		#81 R7_en=1;R7_in=122;		
		end
	
endmodule

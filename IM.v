module IM(addr,instr);
	input [15:0] addr;
	output [15:0] instr;
	
	reg [15:0] rom [0:1023];
	integer i;
	
	assign instr=rom[addr];
	
	
	initial
		begin
			$readmemb("D:/Sem_2/Processor/Project_1/Pipelined_risc/instr_bin.txt",rom);
			for(i=0;i<5;i=i+1)
				$display("rom[%2d]= %16b",i,rom[i]);
		end

endmodule 
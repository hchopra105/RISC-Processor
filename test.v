`timescale 10ns/1ns
module test;
   reg clk,rst;
	integer k,i;
	
	risc cpu(clk,rst);

	initial
		   clk=1'b0;
	always
			#5 clk=~clk;
		
		initial
			begin
			    
				 rst=1'b0;  
				#1 rst=1'b1;
				#10 rst=1'b0;
			end
		
		
    initial
	   begin

       		  			 cpu.ram.ram[0] =16'd993;
					 cpu.ram.ram[1] =16'd882;
					 cpu.ram.ram[2] =16'd123;
        			cpu.ram.ram[3] =16'd413;
					cpu.ram.ram[4] =16'd158;
					cpu.ram.ram[5] =16'd614;
					cpu.ram.ram[6] =16'd712;
					cpu.ram.ram[7] =16'd330;
					cpu.ram.ram[8] =16'd255;
					cpu.ram.ram[9] =16'd128;
					cpu.ram.ram[10] =16'd236;
					cpu.ram.ram[11] =16'd3;
					cpu.ram.ram[25] =16'hfffe;
					cpu.ram.ram[26] =16'd100;
			  
			  //$monitor("time:%2d PC+1:%2d r0:%2d sel1:%2d  sel2:%2d",$time,cpu.RREX.PC_plus_out,cpu.regfile.Register[0].Reg.dout,
				//								cpu.Aluin1_MUX.b,cpu.Aluin2_MUX.b);
			  
			  $monitor("time:%2d PC:%3d PC+_last_stage:%3d",$time,cpu.PC.dout,cpu.Mem_WB.PC_plus_out);
			   
				 
				 
			
			//cpu.PC.dout = 0;
			//  $monitor("time :%3d Instr: %16b ",$time,cpu.IFID.IR_out);
			
			
				
			
			#1400
			  
			    $display("R%d - %2d",0,cpu.regfile.Register[0].Reg.dout);
				 $display("R%d - %2d",1,cpu.regfile.Register[1].Reg.dout);
				 $display("R%d - %2d",2,cpu.regfile.Register[2].Reg.dout);
				 $display("R%d - %2d",3,cpu.regfile.Register[3].Reg.dout);
			    $display("R%d - %2d",4,cpu.regfile.Register[4].Reg.dout);
				 $display("R%d - %2d",5,cpu.regfile.Register[5].Reg.dout);
				 $display("R%d - %16b",6,cpu.regfile.Register[6].Reg.dout);
				 $display("R%d - %2d",7,cpu.regfile.R7.dout);
//				   for(k=100;k<20;k=k+1)
//						 $display("Mem[%3d] : %2d",k,cpu.ram.ram[k]);

				$display("Mem[%3d] : %3d",8,cpu.ram.ram[8]);
				$display("Mem[%3d] : %3d",9,cpu.ram.ram[9]);
				$display("Mem[%3d] : %3d",10,cpu.ram.ram[10]);
				$display("Mem[%3d] : %3d",11,cpu.ram.ram[11]); 
//				$display("Mem[%3d] : %3d",104,cpu.ram.ram[104]);
//				$display("Mem[%3d] : %3d",105,cpu.ram.ram[105]);
//				$display("Mem[%3d] : %3d",106,cpu.ram.ram[106]);
//				$display("Mem[%3d] : %3d",107,cpu.ram.ram[107]);
//				$display("Mem[%3d] : %3d",108,cpu.ram.ram[108]);
//				$display("Mem[%3d] : %3d",109,cpu.ram.ram[109]);
	
		end
		
	initial
		#1405 $finish;		
endmodule

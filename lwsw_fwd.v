module lwsw_fwd(MemWB_lw,MemWb_LM,ExMem_SW,EXMem_SM,Rd,Rt,Rs,fwd_sw);
	input MemWB_lw,MemWb_LM,ExMem_SW,EXMem_SM;
	input [2:0] Rd,Rt,Rs;
	output reg fwd_sw;
	
	always@(*)
		begin
			if( ( MemWB_lw || MemWb_LM ) && (Rd==Rs) && ExMem_SW)
					fwd_sw = 1'b1;
			else if( ( MemWB_lw || MemWb_LM ) && (Rd==Rt) && EXMem_SM)
					fwd_sw = 1'b1;
			else 
					fwd_sw = 1'b0;
		end

endmodule

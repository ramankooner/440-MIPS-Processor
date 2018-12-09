`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: regfile32.v
*Date:     October 16th, 2018
*Version:  1.3
*
*Notes: 
*
* This is a 32 bit register file, which writes to the registers
* when D_En is a one. We use register 0 as the zero register 
* and it cannot be written to. We store the data in a 32-bit 
* by 32-bit register. 
*
*
***********************************************************/
module regfile32( clk, reset, D_En, D_Addr, S_Addr, T_Addr, D, S, T );
	
	// Inputs
	input         clk, reset, D_En;
	input   [4:0] D_Addr, S_Addr, T_Addr;
	input  [31:0] D;

	// Outputs/Registers
	output [31:0] S, T;
	
	reg    [31:0] register [31:0];
	
	// Always Block
	always @ ( posedge clk, posedge reset )
		
		// If reset, set the register to 0
		if ( reset )
			register[0] <= 32'h0;
		
		else
			// We only load the register if D_En is 1
			if ( D_En )
				if ( D_Addr == 0 )
					register[D_Addr] <= register[D_Addr];
				else
					register[D_Addr] <= D; 
			
			else
				register[D_Addr] <= register[D_Addr];
		
	assign S = register[S_Addr];
	assign T = register[T_Addr];
					
endmodule

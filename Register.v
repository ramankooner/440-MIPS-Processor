`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: Register.v
*Date:     October 16th, 2018
*Version:  1.3
*
*Notes: 
*
* This is a 32-bit register module, which will be used to
* instantiate the six registers in the Integer Datapath 
* module. It takes a 32-bit input D and a 1'bit input load.
* Q will get the value of D if reset is 0 and our load is
* enabled.
*
***********************************************************/
module Register( clk, reset, D, Q, load );
	
	// Inputs
	input          clk, reset, load;
	input   [31:0] D;
	
	// Outputs
	output  [31:0] Q;
	reg     [31:0] Q;
	
	// Always Block
	always @ ( posedge clk, posedge reset )
		if ( reset )
			Q <= 32'b0;
		else
			// Only load register if load is enabled
			if ( load )
				Q <= D;
			else 
				Q <= Q;


endmodule

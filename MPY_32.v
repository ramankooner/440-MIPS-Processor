`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: MPY_32.v
*Date:     October 4th, 2018
*Version:  1.3
*
*Notes: 
*
* This module will take two inputs: a and b.
* Two integers are assigned to a and b and they are 
* multiplied together for the ALU module. 
*
***********************************************************/
module MPY_32( a, b, y );
	
	// Inputs
	input  [31:0] a, b;
	
	// Outputs
	output [63:0] y;
	reg    [63:0] y;
	
	// Integers
	integer int_a, int_b;
	
	// Always Block
	always @ (a, b) begin
		
		// Assign integers to inputs
		int_a = a; 
		int_b = b;
		
		// Get results
		y     = int_a * int_b;  
		
	end

endmodule

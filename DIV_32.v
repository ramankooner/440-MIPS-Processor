`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: DIV_32.v
*Date:     October 4th, 2018
*Version:  1.3
*
*Notes: 
*
* This module will take two inputs: a and b.
* Two integer are assigned to a and b to be divided
* for the ALU module. We will assign the quotient to Y_lo 
* and the remainder to Y_hi.
*
*
***********************************************************/
module DIV_32( a, b, quotient, remainder );

	// Inputs
	input  [31:0] a, b;
	
	// Outputs
	output [31:0] quotient, remainder;
	reg    [31:0] quotient, remainder;
	
	// Integers
	integer int_a, int_b;
	
	// Always Block
	always @ (a, b) begin 
		
		// Assign inputs to integers
		int_a     = a;
		int_b     = b;
		
		// Get results
		quotient  = int_a / int_b;
		remainder = int_a % int_b;
		
	end
	
endmodule

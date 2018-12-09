`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: alu_32.v
*Date:     October 4th, 2018
*Version:  1.3
*
*Notes: 
*
* The alu_32 module will instantiate three different modules: 
* 		MIPS_32, MPY_32, and DIV_32
* It is a wrapper function that chooses the outputs for Y_hi
* and Y_lo depending on the function select value. 
* The status flags will also depend on the function select.
*
***********************************************************/
module alu_32( S, T, FS, Y_hi, Y_lo, C, V, N, Z, shamt );

	// Inputs
	input  [31:0] S, T;
	input  [5:0]  FS;
	input  [8:0]  shamt;
	
	// Outputs
	output [31:0] Y_hi, Y_lo; 
	output        N, Z, V, C;
	
	// Wires
	wire   [63:0] MUL_y;
	wire   [31:0] MIPS_lo, DIV_quo, DIV_rem;
	wire    [1:0] shift_t;
	wire   [31:0] shift_out;
	wire    [4:0] shamt_w;
	
	
	                 // in, shift_type, shamt,    out
	barrel_shifter u3 ( T , shift_t   , shamt_w, shift_out);
	
				        // F_Sel, S, T,    Y,    C, V
	MIPS_32        u2 (  FS  , S, T, MIPS_lo, C, V );
	
	                 // a, b,   y
	MPY_32         u1 ( S, T, MUL_y );
	
	                 // a, b, quotient, remainder
	DIV_32         u0 ( S, T, DIV_quo, DIV_rem );

	// Assign the outputs: Y_hi and Y_lo
													  // Barrel Shift (SLL/SLLI)
	assign {Y_hi, Y_lo} = ((FS == 6'h0C)||(FS == 6'h2C)) ? 
	                                       { 32'h0       ,   shift_out }: 
														
													  // Barrel Shift (SRL/SRLI)
								 ((FS == 6'h0D)||(FS == 6'h2D)) ? 
									               { 32'h0       ,   shift_out }:
														
													  // Barrel Shift (SRA/SRAI)
						  		 ((FS == 6'h0E)||(FS == 6'h2E)) ? 
									               { 32'h0       ,   shift_out }: 
														
													  // Multply
													  (FS == 5'h1E)  ? 
												  	   { MUL_y[63:32], MUL_y[31:0] }: 
													
													  // Divide
													  (FS == 5'h1F)  ? 
														{ DIV_rem     ,     DIV_quo }: 
														
														{ 32'h0       ,     MIPS_lo };  
														 
	// Mux to Determine Shift Type
	assign shift_t = ((FS == 6'h0C) || (FS == 6'h2C)) ? 2'b00: //SLL/SLLI
						  ((FS == 6'h0D) || (FS == 6'h2D)) ? 2'b01: //SRL/SRLI
						  ((FS == 6'h0E) || (FS == 6'h2E)) ? 2'b10: //SRA/SRAI
												                   2'b11; //NULL SHIFT (No Shift)
												
	// Mux to Determine Shift Amount
	assign shamt_w = (FS == 5'h0C) ? shamt[8:4]: // SLL
						  (FS == 5'h0D) ? shamt[8:4]: // SRL
						  (FS == 5'h0E) ? shamt[8:4]: // SRA
									  {2'b0, shamt[2:0]}; // Immediate Shift Type (Enhanced)
	
	assign Z = (Y_lo == 32'b0);
	
	// Set the negative flags
	assign N = (FS == 5'h1E) ?   MUL_y[31]: 
	           (FS == 5'h1F) ? DIV_quo[31]:
				                     Y_lo[31];
	
endmodule

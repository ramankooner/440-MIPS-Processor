`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: PC.v
*Date:     October 16th, 2018
*Version:  1.3
*
*Notes: 
*
* The program counter holds the address of the next 
* instruction. When pc_inc is enabled, the program counter
* will increment by four in correspondance with the MIPs 
* specification for addressing memory. When pc_ld is enabled,
* the program counter will get the contents of the PC_in.
*
***********************************************************/
module PC( clk, reset, pc_ld, pc_inc, PC_in, PC_out );

	// Inputs
	input          clk, reset, pc_ld, pc_inc;
	input  [31:0]  PC_in;
	
	// Outputs 
	output [31:0]  PC_out;
	reg    [31:0]  PC_out;
	
	// Always Block
	always @ ( posedge clk, posedge reset )
		if ( reset )
			PC_out <= 32'b0;
			
		else  
			// Case Statement 
			case({pc_ld, pc_inc})
					2'b01:   PC_out <= PC_out + 4;
					2'b10:   PC_out <= PC_in;
					default: PC_out <= PC_out;
			endcase			
endmodule

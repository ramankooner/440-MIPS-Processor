`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: inputOutput.v
*Date:     November 20th, 2018
*Version:  1.3
*
*Notes: 
*
* This module is the input/output memory module. It acts
* exactly like a data memory except it uses input and output
* instructions. The input instruction functions like a load word
* and the output instruction functions like a store word. 
* The interrupt is generated in this module.
* 
***********************************************************/
module inputOutput( clk, io_cs, io_rd, io_wr, addr, 
						  D_in_IO, D_out_IO, int_ack, intr );

	// Inputs
	input         clk, io_cs, io_rd, io_wr, int_ack;
	input  [31:0] D_in_IO;
	input  [31:0] addr;
	
	// Outputs
	output 	     intr;
	output [31:0] D_out_IO;
	
	reg     [7:0] IOMem [4095:0];
	reg           intr;
 
	// Always Block
	always @ ( posedge clk )
	
		// If chip select and write are enabled, Memory will get D_in
		if( (io_cs && io_wr) == 1'b1 )
			{ IOMem[addr], IOMem[addr + 1], IOMem[addr + 2], IOMem[addr + 3] } <= D_in_IO;
		else
			{ IOMem[addr], IOMem[addr + 1], IOMem[addr + 2], IOMem[addr + 3] } <= 
			{ IOMem[addr], IOMem[addr + 1], IOMem[addr + 2], IOMem[addr + 3] };
		
	// D_out gets 32-bit word starting at address if chip select and 
	// read are enabled
	assign D_out_IO = ( (io_cs && io_rd) == 1'b1 ) ? { IOMem[addr]    ,
	                                                   IOMem[addr + 1],
												           	      IOMem[addr + 2],
													               IOMem[addr + 3]} : 32'bZZZZ_ZZZZ;
	// Generate Interrupt
	//initial begin
	//	#1000 intr = 1;
	//	@(posedge int_ack) intr = 0;
	//end
													
endmodule

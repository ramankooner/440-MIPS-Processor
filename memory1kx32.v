`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: memory1k32.v
*Date:     October 16th, 2018
*Version:  1.3
*
*Notes: 
*
* This verilog module creates a Data Memory module that emulates
* a 1024 x 32 byte-addressable memory implemented as an array of
* registers, consisting of 4096 memory locations each being one 
* byte wide. This data memory module is structed in "Big Endian"
* format, and bidirectional data movement (Read/Write).
* 
***********************************************************/
module memory1kx32( clk, dm_cs, dm_rd, dm_wr, addr, D_in, D_out_mem );

	// Inputs
	input         clk, dm_cs, dm_rd, dm_wr;
	input  [31:0] D_in;
	input  [31:0] addr;
	
	// Outputs
	output [31:0] D_out_mem;
	
	reg     [7:0] DMem [4095:0];
 
	// Always Block
	always @ ( posedge clk )
	
		// If chip select and write are enabled, Memory will get D_in
		if( (dm_cs && dm_wr) == 1'b1 )
			{ DMem[addr], DMem[addr + 1], DMem[addr + 2], DMem[addr + 3] } <= D_in;
		else
			{ DMem[addr], DMem[addr + 1], DMem[addr + 2], DMem[addr + 3] } <= 
			{ DMem[addr], DMem[addr + 1], DMem[addr + 2], DMem[addr + 3] };
		
	// D_out gets 32-bit word starting at address if chip select and 
	// read are enabled
	assign D_out_mem = ( (dm_cs && dm_rd) == 1'b1 ) ? { DMem[addr]    ,
	                                                    DMem[addr + 1],
												           	       DMem[addr + 2],
													                DMem[addr + 3]} : 32'bZZZZ_ZZZZ;
													
endmodule

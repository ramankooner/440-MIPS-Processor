`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: Instruction_Unit.v
*Date:     October 24th, 2018
*Version:  1.3
*
*Notes: 
*
* The instruction unit module instantiates the program counter,
* instruction memory and the instruction register. The program
* counter and the instruction register are 32-bit registers. 
* The program counter sits on top of the instruction memory and
* the instruction register is below the instruction memory. The
* instruction memory is a 4096x8 byte addressable memory. It is 
* in big Endian format. 
*
***********************************************************/
module Instruction_Unit( clk, reset, pc_sel, pc_ld, pc_inc, 
                         im_cs, im_wr, im_rd, ir_ld, 
								 PC_in_IU, PC_out, IR_out, SE_16,
								 e_sel );
	// Inputs
	input         clk, reset;
	input         e_sel;
	input         pc_ld, pc_inc, ir_ld;
	input         im_cs, im_wr, im_rd;
	input   [1:0] pc_sel;
	input  [31:0] PC_in_IU;
	
	// Outputs and Wires
	output [31:0] PC_out, IR_out, SE_16;
	
	wire   [31:0] D_out_wire, PC_wire;
	
	
	               // clk, reset, pc_ld, pc_inc, PC_in_IU, PC_out
	PC           u2 ( clk, reset, pc_ld, pc_inc, PC_wire, PC_out   );

	
	               // clk, dm_cs, dm_rd, dm_wr,    
	memory1kx32  u1 ( clk, im_cs, im_rd, im_wr, 
	               //      addr,             D_in, D_out_mem  
						  {20'b0, PC_out[11:0]}, 32'h0, D_out_wire      );


	               // clk, reset,      D    ,    Q  ,  load 
	Register     u0 ( clk, reset, D_out_wire, IR_out, ir_ld        );
				
	// Sign Extend
	assign SE_16 = (e_sel) ? { {16{IR_out[20]}}, IR_out[20:5] } : 
	                         { {16{IR_out[15]}}, IR_out[15:0] } ;
	
	assign PC_wire = (pc_sel == 2'b11) ? { PC_out[31:28], IR_out[25:6], 8'b00 } :
						  (pc_sel == 2'b10) ?   PC_in_IU                             :
						  (pc_sel == 2'b01) ? { PC_out[31:28], IR_out[25:0], 2'b00 } :
						  (pc_sel == 2'b00) ?   PC_out + { SE_16[29:0], 2'b00      } : 
													   PC_in_IU                             ;
						  
	
endmodule

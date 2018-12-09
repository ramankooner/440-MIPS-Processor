`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: Integer_Datapath.v
*Date:     October 24th, 2018
*Version:  1.3
*
*Notes: 
*
* The Integer_Datapath module will instantiate three different modules: 
* 		regfile32, alu_32 and register
* It is a wrapper function that has a register on top of an 
* ALU and the outputs of the regfile go to registers. This will set our
* lab up for pipeling in the future lab, although we are not pipelining
* in this lab. The output of the ALU can either go to the Alu_out register 
* or the HI and LO registers on a multiply or divide. The Y-Mux will
* choose what data to output and send to the memory module through
* the Alu_out or the D_out.
*
***********************************************************/
module Integer_Datapath( clk, reset, d_en, hilo_ld, t_sel, PC_in,
                         y_sel, S_Addr, D_Addr, T_Addr, FS, DT, 
								 shamt, flag_sel,
								 DY, C, V, N, Z, 
								 Alu_out, D_out, D_out_sel, da_sel );
	
	// Inputs
	input         clk, reset, d_en, hilo_ld;
	input   [1:0] t_sel;
	input   [2:0] y_sel, da_sel;
	input   [4:0] S_Addr, D_Addr, T_Addr;
	input   [5:0] FS;
	input  [31:0] DT, DY, PC_in;
	input   [8:0] shamt;
	input   [1:0] D_out_sel;
	input         flag_sel;
	
	// Outputs
	output        C, V, N, Z; 
	output [31:0] Alu_out, D_out;
	
	
	// Wires and registers
	wire   [4:0]  addr;
	wire   [31:0] S_wire, T_wire, Y_lo_wire, Y_hi_wire, DT_wire;
	wire   [31:0] Hi_reg, Lo_reg, D_in_reg, Alu_out_reg, RS_reg, RT_reg;
	wire          C_wire, V_wire, N_wire, Z_wire;

	// Instantiations 
	
					// clk, reset, D_En, D_Addr, S_Addr, T_Addr,    
	regfile32 u7 ( clk, reset, d_en,   addr, S_Addr, T_Addr, 
					// 	D,       S,     T
						Alu_out, S_wire, T_wire );
	
	            //    S,     T,   FS,    Y_hi,      Y_lo,     
	alu_32    u6 ( RS_reg, D_out, FS, Y_hi_wire, Y_lo_wire, 
               //    C,     V,      N,      Z,    shamt
						C_wire, V_wire, N_wire, Z_wire, shamt ); 
					
	
	// RS          clk, reset,    D,     Q,    load
	Register  u5 ( clk, reset, S_wire, RS_reg, 1'b1 );
	
	// RT          clk, reset,    D,     Q,    load
	Register  u4 ( clk, reset, DT_wire, RT_reg, 1'b1 );
	
	// Alu_Out     clk, reset,     D,          Q,      load
	Register  u3 ( clk, reset, Y_lo_wire, Alu_out_reg, 1'b1 );
	
	// D_in        clk, reset,  D,    Q,     load
	Register  u2 ( clk, reset, DY, D_in_reg, 1'b1 );
	
	// HI          clk, reset,     D,       Q,     load
	Register  u1 ( clk, reset, Y_hi_wire, Hi_reg, hilo_ld );
	
	// LO          clk, reset,    D,        Q,     load
	Register  u0 ( clk, reset, Y_lo_wire, Lo_reg, hilo_ld );
	
	// Flag Management
	assign {C, N, Z, V} = (flag_sel) ? D_in_reg[3:0]: {C_wire, N_wire, Z_wire, V_wire};
	
	// D_out output from T-Mux
	assign DT_wire = (t_sel == 2'b11) ? DT        : 
	                 (t_sel == 2'b01) ? Y_lo_wire :
						  (t_sel == 2'b00) ? T_wire    :
						                     T_wire    ;
		
	// Alu_out output from Y-Mux 
	assign Alu_out = ( y_sel == 3'b000 ) ? Hi_reg      : 
						  ( y_sel == 3'b001 ) ? Lo_reg      : 
						  ( y_sel == 3'b010 ) ? Alu_out_reg : 
						  ( y_sel == 3'b011 ) ? D_in_reg    : 
						  ( y_sel == 3'b100 ) ? PC_in       : Y_lo_wire;
	
	// Address Select
	assign addr = (da_sel == 3'b011) ? 5'h1D  :
					  (da_sel == 3'b010) ? 5'h1F  : 
					  (da_sel == 3'b001) ? T_Addr : // IR[20:16] for Write Address $rt
					  (da_sel == 3'b100) ? S_Addr : // IR[25:21] for Write Address $rs
												  D_Addr ; // IR[15:11] for Write Address $rd
	
	// D_Out Output Select
	assign D_out = (D_out_sel == 2'b01) ?               PC_in: // PC (For Stack)
						(D_out_sel == 2'b10) ? {28'b0, C, N, Z, V}: // Flags (For Stack)
												                  RT_reg;
																		
endmodule

`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: MIPS_32.v
*Date:     October 4th, 2018
*Version:  1.3
*
*Notes: 
*
* This module will take two inputs: S and T.
* S and T are 32 bit values and we use them to execute most of
* our operations. The operation we perform will depend on our 
* function select, which is a 5 bit hex value. This module will
* assign the carry and overflow status flags for each operation. 
* If the status flag does not apply to the operation then it will 
* be assigned an X. All operations are signed operations except for
* ADDU, SUBU, and SLTU. The output Y is a 32 bit value, which will be
* assigned to Y_lo in the alu_32 module. 
*
*
***********************************************************/
module MIPS_32( F_Sel, S, T, Y, C, V );
	
	// Inputs
	input      [5:0]  F_Sel;
	input      [31:0] S, T;
	
	// Outputs
	output     [31:0] Y;
	output            C, V;
	
	reg        [31:0] Y, Y_hi;
	reg               C, V;
	
	// Integers
	integer           int_s, int_t; 
		
	// Always Block
	always @ ( S or T or F_Sel ) begin 
	
		// Case statement
		case ( F_Sel )
		
			//******************Pass S******************// 
			6'h00: begin 
						{C, Y} = {1'bx, S};   
                      V  =  1'bx;						
					 end 
					 
			//***************** PASS T *****************//		 
			6'h01: begin 
						{C, Y} = {1'bx, T};  
						    V  =  1'bx;
					 end 
			
			//****************** ADD *******************//
			6'h02: begin                                                        
						{C, Y} = S + T;
						    V  = ( S[31] != T[31] ) ? 0 : ( T[31] == Y[31] ) ? 0 : 1;
					 end
			
			//****************** SUB *******************//
			6'h03: begin                                                          
						{C, Y} = S - T;
						    V  = ( S[31] == T[31] ) ? 0 : ( T[31] == Y[31] ) ? 1 : 0;
					 end 
					 
			//****************** ADDU ******************//
			6'h04: begin                                                          
						{C, Y} = S + T;
						    V  = C; 
					 end
					 
			//****************** SUBU ******************//
			6'h05: begin                                                            
						{C, Y} = S - T;
						    V  = C;
					 end
					 
			//****************** SLT *******************//
			6'h06: begin                                                      
						int_s = S;
						int_t = T;
						if ( int_s < int_t )
							{C, Y} = {1'bx, 32'b1};
						else 
							{C, Y} = {1'bx, 32'b0};
						V = 1'bx;
					 end 
					 
			//****************** SLTU ******************//
			6'h07: begin    
						if ( S < T )
							{C, Y} = {1'bx, 32'b1};
						else 
							{C, Y} = {1'bx, 32'b0};
						V = 1'bx;
					 end 
			
			//****************** AND *******************//
			6'h08: begin 
						{C, Y} = {1'bx, S & T}; 
						    V  =  1'bx;
					 end 
					 
			//****************** OR ********************//
			6'h09: begin 
						{C, Y} = {1'bx, S | T};   
                      V  =  1'bx;
                end 
         
         //****************** XOR *******************//			
			6'h0A: begin 
			         {C, Y} = {1'bx, S ^ T};   
                      V  =  1'bx;						
                end

			//****************** NOR *******************//
			6'h0B: begin 
			         {C, Y} = {1'bx, ~{S | T}};    
						    V  =  1'bx;
                end		
					 
         //****************** SLL *******************//					 
			6'h0C: begin  
						C = T[31];
						Y = T << 1;
						V = 1'bx;
					 end 
					 
			//****************** SRL *******************//	
			6'h0D: begin                                                          
						C = T[0];
						Y = T >> 1;
						V = 1'bx;
					 end
			
			//****************** SRA *******************//	
			6'h0E: begin
			         C = T[0];
						Y = { T[31], T[31:1] };
						V = 1'bx;
			       end
					 
			//****************** INC *******************//	
			6'h0F: begin                                                          
						{C, Y} = S + 1;
						    V  = C; 
					 end 
					 
			//****************** DEC *******************//	
			6'h10: begin                                                          
						{C, Y} = S - 1;
						    V  = C;
					 end 
					 
			//****************** INC4 ******************//	
			6'h11: begin 			                                                 
			         {C, Y} = S + 4;
						    V  = C;
			       end 
			
			//****************** DEC4 ******************//	
			6'h12: begin                                                           
			         {C, Y} = S - 4;
						    V  = C;
			       end 
			
			//***************** ZEROS ******************//	
			6'h13: begin 
			         {C, Y} = {1'bx, 32'h0};  
                      V  =  1'bx;						
                end 
			
			//****************** ONES ******************//	
			6'h14: begin 
			         {C, Y} = {1'bx, 32'hFFFFFFFF};   
						    V  =  1'bx;
                end		
         
         //**************** SP_INIT *****************//				
			6'h15: begin 
			         {C, Y} = {1'bx, 32'h3FC};  
						    V  =  1'bx;
                end	

         //****************** ANDI ******************//						 
			6'h16: begin 
			         {C, Y} = {1'bx, S & { 16'h0, T[15:0] }};  
						    V  =  1'bx;
                end		
					 
         //****************** ORI *******************//						 
			6'h17: begin 
			         {C, Y} = {1'bx, S | { 16'h0, T[15:0] }};   
						    V  =  1'bx;
                end	
					 
         //****************** LUI *******************//						 
			6'h18: begin 
			         {C, Y} = {1'bx, { T[15:0], 16'h0 }};  
						    V  =  1'bx;
                end
					 
         //****************** XORI *******************//						 
			6'h19: begin 
			         {C, Y} = {1'bx, S ^ { 16'h0, T[15:0] }};  
						    V  =  1'bx;
                end	
			
			//****************** BIC ********************//						 
			6'h1A: begin 
			         {C, Y} = {1'bx, S & ~T};  
						    V  =  1'bx;
                end	
					 
			//****************** CHS ********************//						 
			6'h1B: begin 
			         {C, Y} = {1'bx, ((~T) + 1)};  
						    V  =  1'bx;
                end	
					 
         //***************** DEFAULT *****************//						 
			default: begin 
			           {C, Y} = {1'bx, S};  
						      V  =  1'bx;
                  end						  
		endcase
		
	end 
	
endmodule

`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: MIPS_CU_TB.v
*Date:     October 25th, 2018
*Version:  1.3
*
*Notes: 
*
* This top level testbench instantiates the MIPS Control Unit (MCU), 
* integer datapath, data memory module, and the Instruction Unit.
* They are interconnected through multiple wires. The MCU produces
* the control signals that are to be passed into the IDP, Data Memory,
* and Instruction Unit. The IDP will receive outputs from the 
* Instruction Unit and Data Memory will receive outputs from the IDP.
* Instruction and Data Memory are initialized given two .dat files
* written in hexadecimal. The register file of the IDP is not initialized,
* but will be updated according to the program being run. The contents
* of the register file are to be displayed upon program termination.
*
***********************************************************/
module MIPS_CU_TB;

	// Inputs
	reg         sys_clk, reset;
	
	// Interrupt from IO
	wire		   intr, int_ack;
	
	// CPU Outputs
	wire        dm_cs, dm_rd, dm_wr;
	wire        io_cs, io_rd, io_wr;
	
	wire [31:0] Alu_out;
	wire [31:0] D_out;
	
	// Data Memory Outputs
	wire [31:0] D_out_mem;
	
	// I/O Memory Outputs
	wire [31:0] io_out;

	// Instantiate the Unit Under Test (UUT) 
	CPU         uut1 (
		.sys_clk(sys_clk)      , .reset(reset)     , 
		.intr(intr)            , .int_ack(int_ack) , 
		.Alu_out(Alu_out)      , .D_out(D_out)     , 
		.dm_cs(dm_cs)          , .dm_rd(dm_rd)     , .dm_wr(dm_wr),
		.io_cs(io_cs)          , .io_rd(io_rd)     , .io_wr(io_wr),
		.Data_Mem_In(D_out_mem), .IO_Mem_In(io_out)
	);
	
	memory1kx32 uut0 (
		.clk(sys_clk)                ,
		.dm_cs(dm_cs)                , .dm_rd(dm_rd), .dm_wr(dm_wr)         ,
		.addr({20'b0, Alu_out[11:0]}), .D_in(D_out) , .D_out_mem(D_out_mem)
	);
	
	inputOutput uut2 ( 
	   .clk(sys_clk), 
	   .io_cs(io_cs), .io_rd(io_rd)  , .io_wr(io_wr)  , 
		.addr({20'b0 , Alu_out[11:0]}), .D_in_IO(D_out), .D_out_IO(io_out),
		.int_ack(int_ack)             , .intr(intr)
	);
	
	// Generate the Clock
	always 
		#5 sys_clk = ~sys_clk;
		
	// Integer for For Loop
	integer i;
	
	// Dump_Registers Task
	task Dump_Registers;
		for( i = 0; i < 16; i = i + 1 )
			begin
				#1 $display(
				   "T = %t  Reg Addr = %0h - Contents = %h || Reg Addr = %0h - Contents = %h",
				    $time, i, uut1.uut1.u7.register[i], i+16, uut1.uut1.u7.register[i+16] 
			   );
			end
	endtask

	// Dump_PC_and_IR Task
	task Dump_PC_and_IR;
		#1 $display("T = %t   Program Counter = %h  ||  IR = %h", 
		            $time, uut1.uut2.PC_out, uut1.uut2.IR_out);
	endtask
	
	initial begin
		// Display Time
		$timeformat(-9, 1, "ns", 9);
		
		// Initialize Registers and Memory
		
		// ENHANCED MEMORY MODULES
		
		// CHS & BIC
		//$readmemh("iMemEnhanced1.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMemEnhanced1.dat", uut0.DMem         );
	
		// ADDT & SUBT
		//$readmemh("iMemEnhanced2.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMemEnhanced2.dat", uut0.DMem         );
			
		// SLLI, SRLI, SRAI
		//$readmemh("iMemEnhanced3.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMemEnhanced3.dat", uut0.DMem         );
		
		// ANDT, ORT, XORT, SWAP
		$readmemh("iMemEnhanced4.dat", uut1.uut2.u1.DMem );
		$readmemh("dMemEnhanced4.dat", uut0.DMem         );
		
		// MEMORY MODULES
		//$readmemh("iMem01_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem01_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem02_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem02_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem03_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem03_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem04_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem04_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem05_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem05_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem06_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem06_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem07_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem07_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem08_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem08_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem09_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem09_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem10_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem10_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem11_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem11_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem12_Fa18.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem12_Fa18.dat", uut0.DMem         );
		
		// NOTE: Must uncomment and generate interrupt to run these
		// 	   modules. This is done in the inputOutput.v module.
		//       Module 13 will not work as expected because the 
		//       interrupt is set to save the return address on the stack.
		//$readmemh("iMem13_Fa18_w_isr.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem13_Fa18.dat", uut0.DMem         );
		//$readmemh("iMem14_Fa18_w_isr.dat", uut1.uut2.u1.DMem );
		//$readmemh("dMem14_Fa18.dat", uut0.DMem         );
		
		// Initialize Inputs
		sys_clk = 0;
		reset   = 0;
		
		@(negedge sys_clk)
			reset = 1;
		@(negedge sys_clk)
			reset = 0;
		
	end
      
endmodule


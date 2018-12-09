`timescale 1ns / 1ps
/***********************************************************************************
* Author: Raman Kooner, James Gojit
*  Email: ramankooner9@gmail.com, jamesjrgojit@gmail.com
*   Date: November 20th, 2018
*   File: MCU.v
*
* A state machine implementing the MIPS Control Unit (MCU) for the 
* cycles of fetch, execute and some MIPS instructions from memory, 
* including checking for interrupts.
*
*-----------------------------------------------------------------------------------
*                        MCU    C O N T R O L     W O R D
*-----------------------------------------------------------------------------------
*
* {pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
* {im_cs, im_rd, im_wr} = 3'b0_0_0;
* {d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010; FS = s_pass;
* {e_sel, s_mux, dout_sel} = 5'b0_00_00; 
* flag_sel = 1'b0;
* {dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                    int_ack = 1'b0;
* {io_cs, io_rd, io_wr} = 3'b0_0_0; 
* {memmux, mempc} = 2'b0_0;
* #1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = 5'b00;
* 
************************************************************************************/

// *********************************************************************************
module MCU(sys_clk, reset, intr,                    // system inputs
           C, N, Z, V,                              // ALU status inputs
			  IR,                                      // Instruction Register input
			  int_ack, FS,                             // output to I/O subsystem
			  pc_sel, pc_ld, pc_inc, dout_sel,         // Insturction Unit
			  ir_ld, im_cs, im_rd, im_wr,              // Instruction Memory
			  d_en, da_sel, t_sel, hilo_ld, y_sel,     // Integer Datapath
			  dm_cs, dm_rd, dm_wr,                     // Data Memory
			  io_cs, io_rd, io_wr,                     // I/O Memory
			  memmux, mempc,                           // Memory Select
			  flag_sel,                                // Flags Register
 			  e_sel, s_mux   );                        // Enhanced Instructions                     
// *********************************************************************************	
		  
	input         sys_clk, reset, intr;    // system clock, reset, and interrupt request
	input         C, N, Z, V;              // Integer ALU status inputs
	input  [31:0] IR;                      // Instruction Register input from IU
	 
	output        int_ack;                 // interrupt acknowledge
	output        pc_ld, pc_inc, ir_ld;    // Instruction Unit
	output        im_cs, im_rd, im_wr;     // Instruction Memory
	output        d_en, hilo_ld;           // Integer Datapath
	output  [1:0] dout_sel, t_sel, s_mux;
	output        e_sel;                   // Enhanced Instructions
	output        dm_cs, dm_rd, dm_wr;     // Data Memory
	output        io_cs, io_rd, io_wr;     // I/O Memory
	output        mempc, memmux;           // Memory Select   
	output        flag_sel;                // Flags Select
	
	output  [1:0] pc_sel;          // Mux selects
	output  [2:0] y_sel, da_sel;
	output  [5:0] FS;                      // Function Select                        
	
	reg           int_ack;                 // Interrupt Acknowledge
	reg     [5:0] FS;                      // FS
	reg     [1:0] pc_sel, dout_sel; 
	reg     [1:0] t_sel, s_mux;            // Mux Selects
	reg     [2:0] y_sel, da_sel;
	reg           pc_ld, pc_inc, ir_ld;		// Instruction Unit	  
	reg           im_cs, im_rd, im_wr;     // Instruction Memory
	reg           d_en, hilo_ld, sa_sel;   // Integer Datapath
	reg           dm_cs, dm_rd, dm_wr;     // Data Memory
	reg           io_cs, io_rd, io_wr;     // I/O Memory
	reg           memmux, mempc;           // Memory Select
	reg           flag_sel;                // Flags Select
	reg           e_sel;                   // Enhanced Instruction Immediate
	
	//****************************
	//  internal data structures 
	//****************************

	// state assignments
	parameter
		RESET     =   00, FETCH   =  01, DECODE =  02, 
		ADD       =   10, ADDU    =  11, SUB    =  12, SUBU  = 13, 
		JR_1      =   15, JR_2    =  16, JMP    =  17, JAL   = 18,
		ORI       =   20, LUI     =  21, SW     =  23,
		LW        =   24, LW_2    =  25, LW_3   =  26,
		WB_alu    =   30, WB_imm  =  31, WB_Din =  32, WB_hi = 33, 
		WB_lo     =   34, WB_mem  =  35,
		BEQ       =   36, BEQ_2   =  37, BNE    =  38, BNE_2 = 39, 
		ADDI      =   40,
		SRL       =   50, SRA     =  51, SLL    =  52,
		SLT       =   54, SLTI    =  55, SLTU   =  56, SLTIU = 57,
		MFHI      =   58, MFLO    =  59,
		MULT      =   60, DIV     =  61,
		XOR       =   66, XORI    =  67, AND    =  68, ANDI  = 69, 
		OR        =   70, NOR     =  71, 
		BLEZ      =   80, BLEZ_2  =  81, BGTZ   =  82, BGTZ_2= 83,
		INPUT     =  100, INPUT_2 = 101, INPUT_3= 102, 
		OUTPUT    =  103, OUTPUT_2= 104,
		JC        =  200, JN      = 201, JZ     = 202, JV    =203,
		SWAP_1    =  210, SWAP_2  = 211, SWAP_3 = 212,
		ANDT_1    =  216, ANDT_2  = 217, 
		ORT_1     =  218, ORT_2   = 219,
		XORT_1    =  220, XORT_2  = 221,
		CHS       =  302, BIC     = 303,
		ADDT_1    =  304, ADDT_2  = 305, SUBT_1 = 306, SUBT_2=307,
		SLLI      =  310, SRLI    = 311, SRAI   = 312, WB_ALU_E = 313,
		RETI_1    =  413, RETI_2  = 414, RETI_3 = 415, 
		RETI_4    =  416, RETI_5  = 417,
		SETIE     =  504,
		INTR_1    =  501, INTR_2  = 502, INTR_3 = 503, INTR_4=505, 
		INTR_5    =  506, INTR_6  = 507, INTR_7 = 508,
		BREAK     =  510,
		ILLEGAL_OP=  511;

	// Alu functions
	parameter 
		s_pass = 6'h00, t_pass = 6'h01, 
		add    = 6'h02, sub    = 6'h03, addu    = 6'h04, subu = 6'h05, 
		slt    = 6'h06, sltu   = 6'h07, 
		andL   = 6'h08, orL    = 6'h09, xorL    = 6'h0A, norL = 6'h0B,
		sll    = 6'h0C, srl    = 6'h0D, sra     = 6'h0E, 
		inc    = 6'h0F, dec    = 6'h10, inc4    = 6'h11, dec4 = 6'h12,
		zeros  = 6'h13, ones   = 6'h14, sp_init = 6'h15,
		andi   = 6'h16, ori    = 6'h17, lui     = 6'h18, xori = 6'h19,
		bic    = 6'h1A, chs    = 6'h1B, 
		slli   = 6'h2C, srli   = 6'h2D, srai    = 6'h2E, 
		mult   = 6'h1E, div    = 6'h1F;
		
	// state register (up to 512 states)
	reg [8:0] state;
	reg       ps_C, ps_N, ps_Z, ps_V, ps_I;
	reg       ns_C, ns_N, ns_Z, ns_V, ns_I;
	
	/************************************************
	 * 440 MIPS CONTROL UNIT (Finite State Machine) *
    ************************************************/
	always @ (posedge sys_clk, posedge reset)
		if (reset)
			{ps_C, ps_N, ps_Z, ps_V, ps_I} = 5'b0;
		else
			{ps_C, ps_N, ps_Z, ps_V, ps_I} = {ns_C, ns_N, ns_Z, ns_V, ns_I};
	 
	always @ (posedge sys_clk, posedge reset)
		if (reset)
			begin
			@(negedge sys_clk)
				// control word assignments for the reset condition
				{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
				{im_cs, im_rd, im_wr} = 3'b0_0_0;
				{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010; FS = sp_init;
				{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
				flag_sel = 1'b0;
				{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                    int_ack = 1'b0;
				{io_cs, io_rd, io_wr} = 3'b0_0_0; 
				{memmux, mempc} = 2'b0_0;
				#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = 5'b00;
				state = RESET;
			end
		else
			case (state)
				FETCH:
				@(negedge sys_clk)
					if (int_ack==0 & intr==1 & ps_I == 1) 
						begin //*** new interrupt pending: prepare for ISR ***
						// control word assignments for "deasserting" everything
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_000;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INTR_1;
						end
					
					else
						begin //*** no new interrupt pending; fetch and instruction***
						if (int_ack==1 & intr==0) int_ack=1'b0;
							// control word assignments for IR <- iM[PC]; PC <- PC + 4
							{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_1_1;
							{im_cs, im_rd, im_wr} = 3'b1_1_0;
							{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_000;FS = s_pass;
							{e_sel, s_mux, dout_sel} = 5'b0_00_00;
							flag_sel = 1'b0;
							{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
							{io_cs, io_rd, io_wr} = 3'b0_0_0; 
							{memmux, mempc} = 2'b0_0;
							#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
							state = DECODE;
						end
						
				RESET:
					begin 
					@(negedge sys_clk)
						// control word assignments for $sp <- ALU_Out(32'h3FC)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_011_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = 5'b00;
						state = FETCH;
					end
					
				DECODE:
					begin
					@(negedge sys_clk)
					if ( IR[31:26] == 6'h0 ) // check for MIPS format
						begin // it is an R-type format
								// control word assignments: RS <- $rs RT <- $rt (default)
							{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
							{im_cs, im_rd, im_wr} = 3'b0_0_0;
							{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_000;FS = s_pass;
							{e_sel, s_mux, dout_sel} = 5'b0_00_00;
							flag_sel = 1'b0;
							{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
							{io_cs, io_rd, io_wr} = 3'b0_0_0; 
							{memmux, mempc} = 2'b0_0;
							#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
							case ( IR[5:0] )
								6'h00  : {state, t_sel} = {SLL  , 2'b00};
								6'h02  : {state, t_sel} = {SRL  , 2'b00};
								6'h03  : {state, t_sel} = {SRA  , 2'b00};
								6'h08  : {state, t_sel} = {JR_1 , 2'b00};
								6'h10  : {state, t_sel} = {MFHI , 2'b00};
								6'h12  : {state, t_sel} = {MFLO , 2'b00};
								6'h18  : {state, t_sel} = {MULT , 2'b00};
								6'h1A  : {state, t_sel} = {DIV  , 2'b00};
								6'h20  : {state, t_sel} = {ADD  , 2'b00};
								6'h22  : {state, t_sel} = {SUB  , 2'b00};
								6'h24  : {state, t_sel} = {AND  , 2'b00};
								6'h25  : {state, t_sel} = {OR   , 2'b00};
								6'h26  : {state, t_sel} = {XOR  , 2'b00};
								6'h27  : {state, t_sel} = {NOR  , 2'b00};
								6'h2A  : {state, t_sel} = {SLT  , 2'b00};
								6'h2B  : {state, t_sel} = {SLTU , 2'b00};
								6'h0D  : {state, t_sel} = {BREAK, 2'b00};
								6'h1F  : {state, t_sel} = {SETIE, 2'b00};
								default: {state, t_sel} = {ILLEGAL_OP, 2'bxx};
							endcase
						end   // end of if for R-type format
						
					else if ( IR[31:26] == 6'h1F ) // check for MIPS format
							// it is an Enhanced type instruction
							if (IR[1:0] == 2'b00)
								begin
									// ENHANCED TYPE INSTRUCTION STATES
									{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
									{im_cs, im_rd, im_wr} = 3'b0_0_0;
									{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_000;FS = s_pass;
									{e_sel, s_mux, dout_sel} = 5'b0_00_00;
									flag_sel = 1'b0;
									{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
									{io_cs, io_rd, io_wr} = 3'b0_0_0;
									{memmux, mempc} = 2'b0_0;
									#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
									case ( IR[5:0] )
										6'h04:   {state, t_sel} = {ANDT_1, 2'b00};
										6'h08:   {state, t_sel} = {ORT_1 , 2'b00};
										6'h0C:   {state, t_sel} = {XORT_1, 2'b00};
										6'h10:   {state, t_sel} = {CHS   , 2'b00};
										6'h14:   {state, t_sel} = {ADDT_1, 2'b00};
										6'h18:   {state, t_sel} = {SUBT_1, 2'b00};
										6'h1C:   {state, t_sel} = {BIC   , 2'b00};
										6'h20:   {state, t_sel} = {JC    , 2'b00};
										6'h24:   {state, t_sel} = {JN    , 2'b00};
										6'h28:   {state, t_sel} = {JZ    , 2'b00};
										6'h2C:   {state, t_sel} = {JV    , 2'b00};
										6'h34:   {state, t_sel} = {SWAP_1, 2'b00};
										default: {state, t_sel} = {ILLEGAL_OP, 2'bxx};
									endcase
								end
							else
								begin
									// ENHANCED SHIFT IMMEDIATE STATES
									{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
									{im_cs, im_rd, im_wr} = 3'b0_0_0;
									{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_000;FS = s_pass;
									{e_sel, s_mux, dout_sel} = 5'b1_00_00;
									flag_sel = 1'b0;
									{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
									{io_cs, io_rd, io_wr} = 3'b0_0_0; 
									{memmux, mempc} = 2'b0_0;
									#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
									case ( IR[1:0] )
										2'b01:   {state, t_sel} = {SLLI, 2'b11};
										2'b10:   {state, t_sel} = {SRLI, 2'b11};
										2'b11:   {state, t_sel} = {SRAI, 2'b11};
										default: {state, t_sel} = {ILLEGAL_OP, 2'bxx};
									endcase
								end
					else
						begin // it is an I-type or J-type format
								// control word assignments: RS <- $rs RT <- DT(se_16)
							{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
							{im_cs, im_rd, im_wr} = 3'b0_0_0;
							{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_11_0_000;FS = s_pass;
							{e_sel, s_mux, dout_sel} = 5'b0_00_00;
							flag_sel = 1'b0;
							{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
							{io_cs, io_rd, io_wr} = 3'b0_0_0; 
							{memmux, mempc} = 2'b0_0;
							#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
							case ( IR[31:26] )
								6'h02 :  {state, t_sel} = {JMP   , 2'b00};
								6'h03 :  {state, t_sel} = {JAL   , 2'b00};
								6'h04 :  {state, t_sel} = {BEQ   , 2'b00};
								6'h05 :  {state, t_sel} = {BNE   , 2'b00};
								6'h06 :  {state, t_sel} = {BLEZ  , 2'b00};
								6'h07 :  {state, t_sel} = {BGTZ  , 2'b00};
								6'h08 :  {state, t_sel} = {ADDI  , 2'b11};
								6'h0A :  {state, t_sel} = {SLTI  , 2'b11};
								6'h0B :  {state, t_sel} = {SLTIU , 2'b11};
								6'h0C :  {state, t_sel} = {ANDI  , 2'b11};
								6'h0D :  {state, t_sel} = {ORI   , 2'b11};
								6'h0E :  {state, t_sel} = {XORI  , 2'b11};
								6'h0F :  {state, t_sel} = {LUI   , 2'b11};
								6'h1C :  {state, t_sel} = {INPUT , 2'b11};
								6'h1D :  {state, t_sel} = {OUTPUT, 2'b11};
								6'h1E :  {state, t_sel} = {RETI_1, 2'b00};
								6'h23 :  {state, t_sel} = {LW    , 2'b11};
								6'h2B :  {state, t_sel} = {SW    , 2'b11};
								default: {state, t_sel} = {ILLEGAL_OP, 1'bx};
							endcase
						end // end of else for I-type or J-type formats
					end // end of DECODE
				
				SLL: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RT($rt) << IR[10:6]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sll;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				SRL: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RT($rt) >> 1
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = srl;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				SRA: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RT($rt) >> IR[10:6]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sra;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				JR_1: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_010_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = JR_2;
					end
				
				JR_2: 
					begin
					@(negedge sys_clk)
						// control word assignments: PC <- ALU_Out($rs)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b10_1_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				MFHI: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rd] <- HI[63:32]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_000_00_0_000;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
				MFLO: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rd] <- LO[31:0]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_000_00_0_001;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				MULT: 
					begin
					@(negedge sys_clk)
						// control word assignments: {HI, LO} <- RS($rs)*RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_1_010;FS = mult;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = FETCH;
					end
					
				DIV: 
					begin
					@(negedge sys_clk)
						// control word assignments: {HI, LO} <- RS($rs)/RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_1_010;FS = div;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = FETCH;
					end
				
				ADD: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) + RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = WB_alu;
					end
				
				SUB: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) - RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub; 
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = WB_alu;
					end
				
				AND: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- (RS($rs) & RT($rt))
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = andL;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
					
				OR: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- (RS($rs) | RT($rt))
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = orL;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				XOR: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) ^ RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = xorL;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				NOR: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- ~(RS($rs) | RT($rt))
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = norL;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				SLT: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- (RS($rs) < RT($rt)) ? 1:0
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = slt;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				SLTU: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- (RS($rs) < RT($rt)) ? 1:0
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sltu;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				SETIE: 
					begin
					@(negedge sys_clk)
						// control word assignments: intr = 1
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, 1'b1};
						state = FETCH;
					end
				
				BEQ: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) - RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = BEQ_2;
					end
				
				BEQ_2: 
					begin
					@(negedge sys_clk)
						// control word assignments: if($rs == $rt) PC <- PC + {SE_16[29:0], 00}
						{pc_sel, pc_ld, pc_inc, ir_ld} = (ps_Z == 1'b1) ? 5'b00_1_0_0 : 
						                                                  5'b10_0_0_0 ;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				BNE: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) - RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = BNE_2;
					end
				
				BNE_2: 
					begin
					@(negedge sys_clk)
						// control word assignments: if($rs != $rt) PC <- PC + {SE_16[29:0], 00}
						{pc_sel, pc_ld, pc_inc, ir_ld} = (ps_Z == 1'b0) ? 5'b00_1_0_0 : 
						                                                  5'b10_0_0_0 ;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				BLEZ: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) - RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = BLEZ_2;
					end
				
				BLEZ_2: 
					begin
					@(negedge sys_clk)
						// control word assignments: if($rs == $rt) PC <- PC + {SE_16[29:0], 00}
						{pc_sel, pc_ld, pc_inc, ir_ld} = ((ps_Z == 1'b1) || (ps_N == 1'b1)) ? 5'b00_1_0_0 : 
																													 5'b10_0_0_0 ;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
				BGTZ: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) - RT($rt) ($r0)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = BGTZ_2;
					end
				
				BGTZ_2: 
					begin
					@(negedge sys_clk)
						// control word assignments: if($rs == $rt) PC <- PC + {SE_16[29:0], 00}
						{pc_sel, pc_ld, pc_inc, ir_ld} = ({ps_Z, ps_N} == 2'b00) ? 5'b00_1_0_0 : 
																									  5'b10_0_0_0 ;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				ADDI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) + SE_16
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_11_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = WB_imm;
					end
				
				SLTI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- (RS($rs) < SE_16) ? 1:0
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = slt;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_imm;
					end
				
				SLTIU: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- (RS($rs) < SE_16) ? 1:0
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_11_0_010;FS = sltu;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_imm;
					end
				
				ANDI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs)&{16'h0, RT[15:0]}
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_11_0_010;FS = andi;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_imm;
					end
				
				ORI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) | {16'h0, RT[15:0]}
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_11_0_010;FS = ori;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = WB_imm;
					end
				
				XORI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs)^{16'h0, RT[15:0]}
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_11_0_010;FS = xori;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_imm;
					end
				
				LUI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- { RT[15:0], 16'h0 }
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_11_0_010;FS = lui;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_imm;
					end
				
				LW: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) + SE_16
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = LW_2;
					end
					
				LW_2: 
					begin
					@(negedge sys_clk)
						// control word assignments: D_In <- ALU_Out(M[$rs + SE_16])
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b1_1_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = LW_3;
					end
				
				LW_3: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rt] <- D_In
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_001_00_0_011;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
				SW: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs)+RT(se_16), RT <- $rt
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = WB_mem;
					end
				
				JMP: 
					begin
					@(negedge sys_clk)
						// control word assignments: PC <- {PC[31:28],IR[25:0],00}
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b01_1_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
				JAL: 
					begin
					@(negedge sys_clk)
						// control word assignments: $ra <- PC, PC <- {PC[31:28],IR[25:0],00}
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b01_1_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_010_00_0_100;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0;
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				INPUT: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs) + SE_16
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b1_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INPUT_2;
					end
					
				INPUT_2: 
					begin
					@(negedge sys_clk)
						// control word assignments: D_In <- ALU_Out(M[$rs + SE_16])
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b1_1_0; 
						{memmux, mempc} = 2'b1_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INPUT_3;
					end
					
				INPUT_3: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rt] <- D_In
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_001_00_0_011;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b1_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end

				OUTPUT: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS($rs)+RT(se_16), RT <- $rt
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b1_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = OUTPUT_2;
					end
				
				OUTPUT_2:
					begin
					@(negedge sys_clk)
						// control word assignments: M[ALU_Out($rs + se_16)] <- RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b1_0_1; 
						{memmux, mempc} = 2'b1_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				WB_alu: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rd] <- ALU_Out
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				WB_imm: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rt] <- ALU_Out
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_001_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				WB_mem: 
					begin
					@(negedge sys_clk)
						// control word assignments: M[ ALU_Out($rs + se_16) ] <- RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b1_0_1;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
				WB_ALU_E: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rd] <- ALU_Out
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_100_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b1_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
				/*ENHANCEMENT SECTION*/

				ANDT_1:
					begin
					@(negedge sys_clk)
						// control word assignments: // RT <- RS($rs) & RT($rt)
						                             // RS <- $ru
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_01_0_010;FS = andL;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = ANDT_2;
					end
					
				ANDT_2:
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_out <- RS($ru) & RT(rs&rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = andL;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				ORT_1:
					begin
					@(negedge sys_clk)
						// control word assignments: // RT <- RS($rs) | RT($rt)
						                             // RS <- $ru
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_01_0_010;FS = orL;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = ORT_2;
					end
					
				ORT_2:
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_out <- RS($ru) | RT(rs|rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = orL;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
					
				XORT_1:
					begin
					@(negedge sys_clk)
						// control word assignments: // RT <- RS($rs) ^ RT($rt)
						                             // RS <- $ru
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_01_0_010;FS = xorL;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = XORT_2;
					end
					
				XORT_2:
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_out <- RS($ru) ^ RT(rs^rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = xorL;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, N, Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				CHS:
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_out <- ~RS($rs) + 1
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = chs;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = WB_alu;
					end
					
				ADDT_1:
					begin
					@(negedge sys_clk)
						// control word assignments: // RT <- RS($rs) + RT($rt)
						                             // RS <- $ru
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_01_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = ADDT_2;
					end
					
				ADDT_2:
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_out <- RS($ru) + RT(rs+rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = add;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = WB_alu;
					end
				
				SUBT_1:
					begin
					@(negedge sys_clk)
						// control word assignments: // RT <- RS($rs) - RT($rt)
						                             // RS <- $ru
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_01_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = SUBT_2;
					end
					
				SUBT_2:
					begin
					@(negedge sys_clk)
			    		// control word assignments: ALU_out <- RS($ru) - RT(rs-rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = sub;
						{e_sel, s_mux, dout_sel} = 5'b0_11_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, V, ps_I};
						state = WB_alu;
					end
				
				BIC:
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_out <- RS($rs) & ~RT($rt)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = bic;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = WB_alu;
					end
				
				JC: 
					begin
					@(negedge sys_clk)
						// control word assignments: if(c) PC <- {PC[31:28],IR[25:6],00000000}
						{pc_sel, pc_ld, pc_inc, ir_ld} = (ps_C == 1) ? 5'b11_1_0_0:
						                                               5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
				JN: 
					begin
					@(negedge sys_clk)
						// control word assignments: if(n) PC <- {PC[31:28],IR[25:6],00000000}
						{pc_sel, pc_ld, pc_inc, ir_ld} = (ps_N == 1) ? 5'b11_1_0_0:
						                                               5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				JZ: 
					begin
					@(negedge sys_clk)
						// control word assignments: if(z) PC <- {PC[31:28],IR[25:6],00000000}
						{pc_sel, pc_ld, pc_inc, ir_ld} = (ps_Z == 1) ? 5'b11_1_0_0:
						                                               5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
				JV: 
					begin
					@(negedge sys_clk)
						// control word assignments: if(v) PC <- {PC[31:28],IR[25:6],00000000}
						{pc_sel, pc_ld, pc_inc, ir_ld} = (ps_V == 1) ? 5'b11_1_0_0:
						                                               5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				SWAP_1: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RS
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = SWAP_2;
					end	

				SWAP_2: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rt] <- ALU_Out(S)
						//                           ALU_Out <- RT
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_001_00_0_010;FS = t_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = SWAP_3;
					end	
				
				SWAP_3: 
					begin
					@(negedge sys_clk)
						// control word assignments: R[rs] <- ALU_Out(T)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_100_00_0_010;FS = t_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00;
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end	
				
				SLLI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RT($rt) << IR[4:2]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = slli;
						{e_sel, s_mux, dout_sel} = 5'b1_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, ps_V, ps_I};
						state = WB_ALU_E;
					end
					
				SRLI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RT($rt) >> IR[4:2]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = srli;
						{e_sel, s_mux, dout_sel} = 5'b1_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, ps_V, ps_I};
						state = WB_ALU_E;
					end
					
				SRAI: 
					begin
					@(negedge sys_clk)
						// control word assignments: ALU_Out <- RT($rt) >> IR[10:6]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = srai;
						{e_sel, s_mux, dout_sel} = 5'b1_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {C, N, Z, ps_V, ps_I};
						state = WB_ALU_E;
					end
					
				/*PROGRAM RUNTIME*/
				BREAK: 
					begin
					@(negedge sys_clk)
						$display("BREAK INSTRUCTION FETCHED %t", $time);
						// control word assignments for "deasserting" everything
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_000;FS = 6'h00;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; 
						{memmux, mempc} = 2'b0_0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						$display(" R E G I S T E R ' S    A F T E R    B R E A K");
						$display(" ");
						MIPS_CU_TB.Dump_Registers; // task to output MIPS RegFile
						$display(" ");
						$display(" DATA MEMORY ");
						$display(" ");
						$display("time=%t M[0C0]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0C0],
																		 MIPS_CU_TB.uut0.DMem[12'h0C1],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0C2],
																		 MIPS_CU_TB.uut0.DMem[12'h0C3]});
						$display("time=%t M[0C4]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0C4],
																		 MIPS_CU_TB.uut0.DMem[12'h0C5],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0C6],
																		 MIPS_CU_TB.uut0.DMem[12'h0C7]});
						$display("time=%t M[0C8]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0C8],
																		 MIPS_CU_TB.uut0.DMem[12'h0C9],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0CA],
																		 MIPS_CU_TB.uut0.DMem[12'h0CB]});
						$display("time=%t M[0CC]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0CC],
																		 MIPS_CU_TB.uut0.DMem[12'h0CD],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0CE],
																		 MIPS_CU_TB.uut0.DMem[12'h0CF]});
						$display("time=%t M[0D0]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0D0],
																		 MIPS_CU_TB.uut0.DMem[12'h0D1],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0D2],
																		 MIPS_CU_TB.uut0.DMem[12'h0D3]});
						$display("time=%t M[0D4]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0D4],
																		 MIPS_CU_TB.uut0.DMem[12'h0D5],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0D6],
																		 MIPS_CU_TB.uut0.DMem[12'h0D7]});
						$display("time=%t M[0D8]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0D8],
																		 MIPS_CU_TB.uut0.DMem[12'h0D9],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0DA],
																		 MIPS_CU_TB.uut0.DMem[12'h0DB]});
						$display("time=%t M[0DC]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0DC],
																		 MIPS_CU_TB.uut0.DMem[12'h0DD],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0DE],
																		 MIPS_CU_TB.uut0.DMem[12'h0DF]});
						$display("time=%t M[0E0]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0E0],
																		 MIPS_CU_TB.uut0.DMem[12'h0E1],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0E2],
																		 MIPS_CU_TB.uut0.DMem[12'h0E3]});
						$display("time=%t M[0E4]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0E4],
																		 MIPS_CU_TB.uut0.DMem[12'h0E5],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0E6],
																		 MIPS_CU_TB.uut0.DMem[12'h0E7]});
						$display("time=%t M[0E8]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0E8],
																		 MIPS_CU_TB.uut0.DMem[12'h0E9],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0EA],
																		 MIPS_CU_TB.uut0.DMem[12'h0EB]});
						$display("time=%t M[0EC]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0EC],
																		 MIPS_CU_TB.uut0.DMem[12'h0ED],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0EE],
																		 MIPS_CU_TB.uut0.DMem[12'h0EF]});
						$display("time=%t M[0F0]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0F0],
																		 MIPS_CU_TB.uut0.DMem[12'h0F1],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0F2],
																		 MIPS_CU_TB.uut0.DMem[12'h0F3]});
						$display("time=%t M[0F4]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0F4],
																		 MIPS_CU_TB.uut0.DMem[12'h0F5],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0F6],
																		 MIPS_CU_TB.uut0.DMem[12'h0F7]});
						$display("time=%t M[0F8]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0F8],
																		 MIPS_CU_TB.uut0.DMem[12'h0F9],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0FA],
																		 MIPS_CU_TB.uut0.DMem[12'h0FB]});
						$display("time=%t M[0FC]=%h", $time,{MIPS_CU_TB.uut0.DMem[12'h0FC],
																		 MIPS_CU_TB.uut0.DMem[12'h0FD],
											 						 	 MIPS_CU_TB.uut0.DMem[12'h0FE],
																		 MIPS_CU_TB.uut0.DMem[12'h0FF]});
						$display(" ");
						$display(" INPUT/OUTPUT MEMORY ");
						$display(" ");
						$display("time=%t M[0C0]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0C0],
																		 MIPS_CU_TB.uut2.IOMem[12'h0C1],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0C2],
																		 MIPS_CU_TB.uut2.IOMem[12'h0C3]});
						$display("time=%t M[0C4]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0C4],
																		 MIPS_CU_TB.uut2.IOMem[12'h0C5],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0C6],
																		 MIPS_CU_TB.uut2.IOMem[12'h0C7]});
						$display("time=%t M[0C8]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0C8],
																		 MIPS_CU_TB.uut2.IOMem[12'h0C9],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0CA],
																		 MIPS_CU_TB.uut2.IOMem[12'h0CB]});
						$display("time=%t M[0CC]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0CC],
																		 MIPS_CU_TB.uut2.IOMem[12'h0CD],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0CE],
																		 MIPS_CU_TB.uut2.IOMem[12'h0CF]});
						$display("time=%t M[0D0]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0D0],
																		 MIPS_CU_TB.uut2.IOMem[12'h0D1],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0D2],
																		 MIPS_CU_TB.uut2.IOMem[12'h0D3]});
						$display("time=%t M[0D4]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0D4],
																		 MIPS_CU_TB.uut2.IOMem[12'h0D5],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0D6],
																		 MIPS_CU_TB.uut2.IOMem[12'h0D7]});
						$display("time=%t M[0D8]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0D8],
																		 MIPS_CU_TB.uut2.IOMem[12'h0D9],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0DA],
																		 MIPS_CU_TB.uut2.IOMem[12'h0DB]});
						$display("time=%t M[0DC]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0DC],
																		 MIPS_CU_TB.uut2.IOMem[12'h0DD],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0DE],
																		 MIPS_CU_TB.uut2.IOMem[12'h0DF]});
						$display("time=%t M[0E0]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0E0],
																		 MIPS_CU_TB.uut2.IOMem[12'h0E1],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0E2],
																		 MIPS_CU_TB.uut2.IOMem[12'h0E3]});
						$display("time=%t M[0E4]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0E4],
																		 MIPS_CU_TB.uut2.IOMem[12'h0E5],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0E6],
																		 MIPS_CU_TB.uut2.IOMem[12'h0E7]});
						$display("time=%t M[0E8]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0E8],
																		 MIPS_CU_TB.uut2.IOMem[12'h0E9],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0EA],
																		 MIPS_CU_TB.uut2.IOMem[12'h0EB]});
						$display("time=%t M[0EC]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0EC],
																		 MIPS_CU_TB.uut2.IOMem[12'h0ED],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0EE],
																		 MIPS_CU_TB.uut2.IOMem[12'h0EF]});
						$display("time=%t M[0F0]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0F0],
																		 MIPS_CU_TB.uut2.IOMem[12'h0F1],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0F2],
																		 MIPS_CU_TB.uut2.IOMem[12'h0F3]});
						$display("time=%t M[0F4]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0F4],
																		 MIPS_CU_TB.uut2.IOMem[12'h0F5],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0F6],
																		 MIPS_CU_TB.uut2.IOMem[12'h0F7]});
						$display("time=%t M[0F8]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0F8],
																		 MIPS_CU_TB.uut2.IOMem[12'h0F9],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0FA],
																		 MIPS_CU_TB.uut2.IOMem[12'h0FB]});
						$display("time=%t M[0FC]=%h", $time,{MIPS_CU_TB.uut2.IOMem[12'h0FC],
																		 MIPS_CU_TB.uut2.IOMem[12'h0FD],
											 						 	 MIPS_CU_TB.uut2.IOMem[12'h0FE],
																		 MIPS_CU_TB.uut2.IOMem[12'h0FF]});
						$finish;
					end
				
				ILLEGAL_OP:
					begin
					@(negedge sys_clk)
						$display("ILLEGAL OPCODE FETCHED %t", $time);
						// control word assignments for "deasserting" everything
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_000;FS = 6'h00;
						{e_sel, s_mux, dout_sel} = 5'b0_00_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						MIPS_CU_TB.Dump_Registers;
						MIPS_CU_TB.Dump_PC_and_IR;
					end
				
				
				/*INTERRUPT SECTION*/
				INTR_1:
					begin
					@(negedge sys_clk)
						//RS <- $29 (0x3FC)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_011_00_0_010;FS = 6'h15;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INTR_2;
					end
					
				INTR_2:
					begin
					@(negedge sys_clk)
						//ALU_Out <- RS(0x3FC) - 4
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_011_00_0_010;FS = dec4;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INTR_3;
					end
				
				INTR_3:
					begin
					@(negedge sys_clk)
						//D_Mem[ALU_Out(0x3F8)] <- Flags
						//$29 <- ALU_Out(0x3F8)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_011_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_01_10;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b1_0_1;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INTR_4;
					end
				
				INTR_4:
					begin
					@(negedge sys_clk)
						//RS <- $29(0x3F8)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_011_00_0_010;FS = dec4;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INTR_5;
					end
					
				INTR_5:
					begin
					@(negedge sys_clk)
						//ALU_Out <- RS(0x3F8) - 4
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_011_00_0_010;FS = dec4;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INTR_6;
					end
				
				INTR_6:
					begin
					@(negedge sys_clk)
						//DMem[ALU_Out(0x3F4)] <- PC_In
						//$29 <- ALU_Out(0x3F4), ALU_Out <- 0x3FC
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_011_00_0_010;FS = sp_init;
						{e_sel, s_mux, dout_sel} = 5'b0_01_01;  
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b1_0_1;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b0;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = INTR_7;
					end
					
				INTR_7:
					begin
					@(negedge sys_clk)
						//PC <- DMem[ALU_out(0x3FC)]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b10_1_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_011_00_0_010;FS = sp_init;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00; 
						flag_sel = 1'b0;
						{dm_cs, dm_rd, dm_wr} = 3'b1_1_0;                  int_ack = 1'b1;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b1;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
				
				RETI_1:
					begin
					@(negedge sys_clk)
						//ALU_Out <- RS(0x3F4) [stack pointer after interrupt]
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b10_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_000_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00; 
						flag_sel = 1'b1;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b1;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = RETI_2;
					end
				
				RETI_2:
					begin
					@(negedge sys_clk)
						//PC <- DMem[ALU_out(0x3F4)]
						//ALU_Out <- RS(0x3F4) +4 (Post-Increment)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b10_1_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_011_00_0_010;FS = inc4;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00;  
						flag_sel = 1'b1;
						{dm_cs, dm_rd, dm_wr} = 3'b1_1_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b1;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = RETI_3;
					end
				
				RETI_3:
					begin
					@(negedge sys_clk)
						//$29 <- ALU_Out(0x3F8)
						//Din <- DMem[ALU_out(0x3F8)] // Flags 
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_011_00_0_010;FS = inc4;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00;  
						flag_sel = 1'b1;
						{dm_cs, dm_rd, dm_wr} = 3'b1_1_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b1;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = RETI_4;
					end
					
				RETI_4:
					begin
					@(negedge sys_clk)
						//Flag Registers (in IDP) <- Din[3:0] 
						//ALU_Out <- 0x3FC
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b0_011_00_0_010;FS = sp_init;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00;  
						flag_sel = 1'b1;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b1;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = RETI_5;
					end
					
				RETI_5:
					begin
					@(negedge sys_clk)
						//$29 <- ALU_Out(0x3FC) (Updates stack pointer in CPU register file)
						{pc_sel, pc_ld, pc_inc, ir_ld} = 5'b00_0_0_0;
						{im_cs, im_rd, im_wr} = 3'b0_0_0;
						{d_en, da_sel, t_sel, hilo_ld, y_sel} = 10'b1_011_00_0_010;FS = s_pass;
						{e_sel, s_mux, dout_sel} = 5'b0_01_00; 
						flag_sel = 1'b1;
						{dm_cs, dm_rd, dm_wr} = 3'b0_0_0;                  int_ack = 1'b0;
						{io_cs, io_rd, io_wr} = 3'b0_0_0; memmux = 1'b0; mempc = 1'b1;
						#1 {ns_C, ns_N, ns_Z, ns_V, ns_I} = {ps_C, ps_N, ps_Z, ps_V, ps_I};
						state = FETCH;
					end
					
			endcase // end of FSM logic	
		
endmodule

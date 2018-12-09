`timescale 1ns / 1ps
/**********************************************************
*
*Author:   Raman Kooner, James Gojit
*Email:    ramankooner9@gmail.com, jamesjrgojit@gmail.com
*Filename: CPU.v
*Date:     November 20th, 2018
*Version:  1.3
*
*Notes: 
*
* The CPU modules instantiates the control unit module,
* instruction unit module and the datapath module. 
*
***********************************************************/
module CPU(sys_clk, reset, intr, int_ack,  
			  Alu_out, D_out,
			  dm_cs, dm_rd, dm_wr,
           io_cs, io_rd, io_wr,
           Data_Mem_In, IO_Mem_In );
	
	// Inputs
	input         sys_clk, reset, intr;
	input [31:0]  Data_Mem_In, IO_Mem_In;
		
	// Outputs
	output        int_ack;
	output        dm_cs, dm_rd, dm_wr;
	output        io_cs, io_rd, io_wr;
	output [31:0] Alu_out, D_out;
		
	// Wires
	wire          C, N, Z, V;
	wire   [4:0]  S_address;
	wire   [5:0]  FS;
	wire   [2:0]  y_sel, da_sel;
	wire   [1:0]  pc_sel, dout_sel, s_mux, t_sel;
	wire          e_sel;
	wire          pc_ld, pc_inc, ir_ld;
	wire          im_cs, im_rd, im_wr;
	wire          d_en, hilo_ld;
	wire          dm_cs, dm_rd, dm_wr;
	wire          io_cs, io_rd, io_wr;
	wire   [31:0] DT, DY;
	wire   [31:0] into_PC, PC_out, IR_out, SE_16;
	wire          mem_mux, mem_pc, flagsel;
	
 
	// Instantiate Modules
	MCU              uut3 (
		.sys_clk(sys_clk), .reset(reset)  , .intr(intr)     , 
		.C(C)            , .N(N)          , .Z(Z)           , .V(V)             , 
		.IR(IR_out)      , 
		.int_ack(int_ack), 
		.FS(FS)          , 
		.pc_sel(pc_sel)  , .pc_ld(pc_ld)  , .pc_inc(pc_inc) , .dout_sel(dout_sel),
		.ir_ld(ir_ld)    , .im_cs(im_cs)  , .im_rd(im_rd)   , .im_wr(im_wr)      , 
		.d_en(d_en)      , .da_sel(da_sel), .t_sel(t_sel)   , .hilo_ld(hilo_ld)  , 
		.y_sel(y_sel)    , .dm_cs(dm_cs)  , .dm_rd(dm_rd)   , .dm_wr(dm_wr)      , 
		.io_cs(io_cs)    , .io_rd(io_rd)  , .io_wr(io_wr)   , 
		.memmux(mem_mux) , .mempc(mem_pc) , .flag_sel(flagsel) ,
		.e_sel(e_sel)    , .s_mux(s_mux)
	);
	
	Instruction_Unit uut2 ( 
		.clk(sys_clk)   , .reset(reset)     ,
		.pc_sel(pc_sel) , .pc_ld(pc_ld)     , .pc_inc(pc_inc) ,
		.im_cs(im_cs)   , .im_wr(im_wr)     , .im_rd(im_rd)   ,
		.ir_ld(ir_ld)   , .PC_in_IU(into_PC), .PC_out(PC_out) ,
		.IR_out(IR_out) , .SE_16(SE_16)     , .e_sel(e_sel)
	);
	
	Integer_Datapath uut1 (
		.clk(sys_clk)         , .reset(reset)         ,
		.d_en(d_en)           , .hilo_ld(hilo_ld)     , .t_sel(t_sel)         , 
		.PC_in(PC_out)        , .y_sel(y_sel)         , 
		.S_Addr(S_address)    , .D_Addr(IR_out[15:11]), .T_Addr(IR_out[20:16]),
		.FS(FS)               , .DT(SE_16)            , .DY(DY)               , .shamt(IR_out[10:2]),
		.C(C)                 , .V(V)                 , .N(N)                 , .Z(Z)               , 
		.flag_sel(flagsel)    ,
		.Alu_out(Alu_out)     , .D_out(D_out)         , .D_out_sel(dout_sel)  , .da_sel(da_sel)  
	);
	
	// S_Address Select (S-Mux)
	assign S_address = (s_mux == 2'b11) ? (IR_out[10:6]) : // RU
	                   (s_mux == 2'b01) ? 5'h1D          : // stack pointer
	                   (s_mux == 2'b00) ? (IR_out[25:21]): // RS
							                    (IR_out[25:21]);
	
	// Memory Select
	assign DY      = (mem_mux)? IO_Mem_In  : Data_Mem_In;
	
	assign into_PC = (mem_pc) ? Data_Mem_In: Alu_out    ;
	
endmodule

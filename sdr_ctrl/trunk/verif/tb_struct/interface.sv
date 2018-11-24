/////////////////////////////////////////////////////////
//   Proyecto1. Curso MP6134 Verificacion Funcional    //
//   Archivo: interface.sv                             //
//   Autores: Esteban Martinez                         //
//            Kaleb Alfaro                             //
//            Felipe Dengo                             //
/////////////////////////////////////////////////////////

interface intf_wishbone
  #(parameter dw=32)
  (input logic sys_clk, output logic RESETN);
  //declaring the signals
	logic             wb_stb_i           ;
	logic            wb_ack_o           ;
	logic  [25:0]     wb_addr_i          ;
	logic             wb_we_i            ; // 1 - Write, 0 - Read
	logic  [dw-1:0]   wb_dat_i           ;
	logic  [dw/8-1:0] wb_sel_i           ; // Byte enable
	logic  [dw-1:0]  wb_dat_o           ;
	logic             wb_cyc_i           ;
	logic   [2:0]     wb_cti_i           ;
endinterface

interface intf_sdram16
	(input logic sdram_clk,RESETN);
	//declaring the signals
	wire  [15:0]			Dq                 ;
	logic  [11:0]     sdr_addr	    		 ;
	logic  [1:0]       sdr_ba        		 ;
	wire  #(2.0)     sdram_clk_d  = sdram_clk     ;
	logic             sdr_cke            ;
	logic             sdr_cs_n           ;
	logic             sdr_ras_n          ;
	logic             sdr_cas_n          ;
	logic             sdr_we_n           ;
	logic [1:0]        sdr_dqm            ;
	logic             sdr_init_done			 ;
endinterface




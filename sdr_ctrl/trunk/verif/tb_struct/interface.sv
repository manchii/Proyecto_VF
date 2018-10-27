interface intf_wishbone 
#(
	parameter dw=32;
)  
(
	input logic sys_clk,RESETN
);

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

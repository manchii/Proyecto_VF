/////////////////////////////////////////////////////////
//   Proyecto1. Curso MP6134 Verificacion Funcional    //
//   Archivo: whitebox.sv                              //
//   Autores: Esteban Martinez                         //
//            Kaleb Alfaro                             //
//            Felipe Dengo                             //
/////////////////////////////////////////////////////////

`ifndef DESIGN_INSTANCE
	`define DESIGN_INSTANCE tbench_top.u_dut
`endif

interface whitebox
    #(
parameter      APP_AW   = 26,  // Application Address Width
parameter      APP_DW   = 32,  // Application Data Width
parameter      APP_BW   = 4,   // Application Byte Width
parameter      APP_RW   = 9,   // Application Request Width

parameter      SDR_DW   = 16,  // SDR Data Width
parameter      SDR_BW   = 2,   // SDR Byte Width

parameter      dw       = 32,  // data width
parameter      tw       = 8,   // tag id width
parameter      bl       = 9   // burst_lenght_width
    );


//-----------------------------------------------
// Global Variable
// ----------------------------------------------
logic                   sdram_clk          ; // SDRAM Clock
logic                   sdram_resetn       ; // Reset Signal
logic [1:0]             cfg_sdr_width      ; // 2'b00 - 32 Bit SDR, 2'b01 - 16 Bit SDR, 2'b1x - 8 Bit
logic [1:0]             cfg_colbits        ; // 2'b00 - 8 Bit column address,
                                             // 2'b01 - 9 Bit, 10 - 10 bit, 11 - 11Bits

assign sdram_clk          = `DESIGN_INSTANCE.sdram_clk; // SDRAM Clock
assign sdram_resetn       = `DESIGN_INSTANCE.sdram_resetn; // Reset Signal
assign cfg_sdr_width      = `DESIGN_INSTANCE.cfg_sdr_width; // 2'b00 - 32 Bit SDR, 2'b01 - 16 Bit SDR, 2'b1x - 8 Bit
assign cfg_colbits        = `DESIGN_INSTANCE.cfg_colbits; // 2'b00 - 8 Bit column address,
                                             // 2'b01 - 9 Bit, 10 - 10 bit, 11 - 11Bits


//--------------------------------------
// Wish Bone Interface
// -------------------------------------
logic                   wb_rst_i           ;
logic                   wb_clk_i           ;
logic                   wb_stb_i           ;
logic                  wb_ack_o           ;
logic [APP_AW-1:0]            wb_addr_i          ;
logic                   wb_we_i            ; // 1 - Write, 0 - Read
logic [dw-1:0]          wb_dat_i           ;
logic [dw/8-1:0]        wb_sel_i           ; // Byte enable
logic [dw-1:0]         wb_dat_o           ;
logic                   wb_cyc_i           ;
logic  [2:0]            wb_cti_i           ;


assign wb_rst_i  = `DESIGN_INSTANCE.wb_rst_i          ;
assign wb_clk_i  = `DESIGN_INSTANCE.wb_clk_i          ;
assign wb_stb_i  = `DESIGN_INSTANCE.wb_stb_i          ;
assign wb_ack_o  = `DESIGN_INSTANCE.wb_ack_o          ;
assign wb_addr_i  = `DESIGN_INSTANCE.wb_addr_i         ;
assign wb_we_i  = `DESIGN_INSTANCE.wb_we_i            ; // 1 - Write, 0 - Read
assign wb_dat_i  = `DESIGN_INSTANCE.wb_dat_i           ;
assign wb_sel_i  = `DESIGN_INSTANCE.wb_sel_i          ; // Byte enable
assign wb_dat_o  = `DESIGN_INSTANCE.wb_dat_o           ;
assign wb_cyc_i  = `DESIGN_INSTANCE.wb_cyc_i           ;
assign wb_cti_i  = `DESIGN_INSTANCE.wb_cti_i           ;



//------------------------------------------------
// Interface to SDRAMs
//------------------------------------------------
logic                  sdr_cke             ; // SDRAM CKE
logic 			sdr_cs_n            ; // SDRAM Chip Select
logic                  sdr_ras_n           ; // SDRAM ras
logic                  sdr_cas_n           ; // SDRAM cas
logic			sdr_we_n            ; // SDRAM write enable
logic [SDR_BW-1:0] 	sdr_dqm             ; // SDRAM Data Mask
logic [1:0] 		sdr_ba              ; // SDRAM Bank Enable
logic [12:0] 		sdr_addr            ; // SDRAM Address
wire [SDR_DW-1:0] 	sdr_dq              ; // SDRA Data Input/output

assign sdr_cke   = `DESIGN_INSTANCE.sdr_cke           ; // SDRAM CKE
assign sdr_cs_n  = `DESIGN_INSTANCE.sdr_cs_n           ; // SDRAM Chip Select
assign sdr_ras_n = `DESIGN_INSTANCE.sdr_ras_n           ; // SDRAM ras
assign sdr_cas_n = `DESIGN_INSTANCE.sdr_cas_n          ; // SDRAM cas
assign sdr_we_n  = `DESIGN_INSTANCE.sdr_we_n          ; // SDRAM write enable
assign	sdr_dqm  = `DESIGN_INSTANCE.sdr_dqm           ; // SDRAM Data Mask
assign sdr_ba    = `DESIGN_INSTANCE.sdr_ba          ; // SDRAM Bank Enable
assign sdr_addr  = `DESIGN_INSTANCE.sdr_addr          ; // SDRAM Address
assign sdr_dq    = `DESIGN_INSTANCE.sdr_dq           ; // SDRA Data Input/output

//--------------------------------------------
// SDRAM controller Interface
//--------------------------------------------
logic                  app_req            ; // SDRAM request
logic [APP_AW-1:0]     app_req_addr       ; // SDRAM Request Address
logic [bl-1:0]         app_req_len        ;
logic                  app_req_wr_n       ; // 0 - Write, 1 -> Read
logic                  app_req_ack        ; // SDRAM request Accepted
logic                  app_busy_n         ; // 0 -> sdr busy
logic [dw/8-1:0]       app_wr_en_n        ; // Active low sdr byte-wise write data valid
logic                  app_wr_next_req    ; // Ready to accept the next write
logic                  app_rd_valid       ; // sdr read valid
logic                  app_last_rd        ; // Indicate last Read of Burst Transfer
logic                  app_last_wr        ; // Indicate last Write of Burst Transfer
logic [dw-1:0]         app_wr_data        ; // sdr write data
logic  [dw-1:0]        app_rd_data        ; // sdr read data

assign app_req            = `DESIGN_INSTANCE.app_req; // SDRAM request
assign app_req_addr       = `DESIGN_INSTANCE.app_req_addr; // SDRAM Request Address
assign app_req_len        = `DESIGN_INSTANCE.app_req_len ;
assign app_req_wr_n       = `DESIGN_INSTANCE.app_req_wr_n; // 0 - Write, 1 -> Read
assign app_req_ack        = `DESIGN_INSTANCE.app_req_ack; // SDRAM request Accepted
assign app_busy_n         = `DESIGN_INSTANCE.app_busy_n; // 0 -> sdr busy
assign app_wr_en_n        = `DESIGN_INSTANCE.app_wr_en_n; // Active low sdr byte-wise write data valid
assign app_wr_next_req    = `DESIGN_INSTANCE.app_wr_next_req; // Ready to accept the next write
assign app_rd_valid       = `DESIGN_INSTANCE.app_rd_valid; // sdr read valid
assign app_last_rd        = `DESIGN_INSTANCE.app_last_rd; // Indicate last Read of Burst Transfer
assign app_last_wr        = `DESIGN_INSTANCE.app_last_wr; // Indicate last Write of Burst Transfer
assign app_wr_data        = `DESIGN_INSTANCE.app_wr_data; // sdr write data
assign app_rd_data        = `DESIGN_INSTANCE.app_rd_data; // sdr read data


/****************************************
*  These logic has to be implemented using Pads
*  **************************************/
logic  [SDR_DW-1:0]    pad_sdr_din         ; // SDRA Data Input
logic  [SDR_DW-1:0]    sdr_dout            ; // SDRAM Data Output
logic  [SDR_BW-1:0]    sdr_den_n           ; // SDRAM Data Output enable

assign pad_sdr_din         = `DESIGN_INSTANCE.pad_sdr_din; // SDRA Data Input
assign sdr_dout            = `DESIGN_INSTANCE.sdr_dout; // SDRAM Data Output
assign sdr_den_n           = `DESIGN_INSTANCE.sdr_den_n; // SDRAM Data Output enable


/****************************************
*  Signal for get cmds
*  **************************************/

logic  [1:0] b2xcmd;
assign b2xcmd = `DESIGN_INSTANCE.u_sdrc_core.b2x_cmd;


endinterface


module assertions;

  whitebox i_wb();
// ***************************
// RULE 3.00 All WISHBONE interfaces MUST initialize themselves at the rising [CLK_I] edge following the assertion of [RST_I]. They MUST stay in the initialized state until the rising [CLK_I]edge that follows the negation of [RST_I].
// ***************************
//             BEGIN
// ***************************

// Sync clk, if rst rose then
property rule3_00;
  @(posedge i_wb.wb_clk_i) $rose(i_wb.wb_rst_i )
  |-> ##[1:100] ((i_wb.wb_stb_i ==0) && (i_wb.wb_dat_i==0) && (i_wb.wb_addr_i==0) && (i_wb.wb_we_i==0) && (i_wb.wb_sel_i==0) && (i_wb.wb_cyc_i==0)
              )
  |-> ##[1:$] $fell(i_wb.wb_rst_i) ;
endproperty

  assert property(rule3_00) begin $display("SUCCESS assert RULE 3_00"); end else $error("ERROR: RULE 3.00 Violation");


// ***************************
//             END
// ***************************


// ***************************
// RULE 3.05 [RST_I] MUST be asserted for at least one complete clock cycle on all WISHBONE Interfaces.
// ***************************
//             BEGIN
// ***************************

// Sync clk, if rst rose then
property rule3_05;
  @(posedge i_wb.wb_clk_i) $rose(i_wb.wb_rst_i)
  |-> ##1 $stable(i_wb.wb_rst_i);
endproperty

    assert property(rule3_05) begin $display("SUCCESS assert RULE 3_05"); end else $error("ERROR: RULE 3.05 Violation");


// ***************************
//             END
// ***************************

// ***************************
// RULE 3.10 [RST_I] MUST be asserted for at least one complete clock cycle on all WISHBONE Interfaces.
// ***************************
//             BEGIN
// ***************************

// Sync clk, if rst rose then
property rule3_10;
  @(posedge i_wb.wb_clk_i) $rose(i_wb.wb_rst_i)
  |-> ##[1:10] ((i_wb.wb_stb_i ==0) && (i_wb.wb_dat_i==0) && (i_wb.wb_addr_i==0) && (i_wb.wb_we_i==0) && (i_wb.wb_sel_i==0) && (i_wb.wb_cyc_i==0) && (i_wb.wb_ack_o==0)
               );
endproperty

      assert property(rule3_10) begin $display("SUCCESS assert RULE 3_10"); end else $error("ERROR: RULE 3.10 Violation");


// ***************************
//             END
// ***************************

// ***************************
// RULE 3.15 All self-starting state machines and counters in WISHBONE interfaces MUST initialize themselves at the rising [CLK_I] edge following the assertion of [RST_I]. They MUST stay in the initialized state until the rising [CLK_I] edge that follows the negation of [RST_I].
// ***************************
//             BEGIN
// ***************************

// Sync clk, if rst rose then
property rule3_15;
  @(posedge i_wb.wb_clk_i) $rose(i_wb.wb_rst_i)
  |-> ##[1:10] ~(i_wb.sdram_resetn);
endproperty

        assert property(rule3_15) begin $display("SUCCESS assert RULE 3_15"); end else $error("ERROR: RULE 3.15 Violation");


// ***************************
//             END
// ***************************

// ***************************
// RULE 3.25 MASTER interfaces MUST assert [CYC_O] for the duration of SINGLE READ / WRITE, BLOCK and RMW cycles. [CYC_O] MUST be asserted no later than the rising [CLK_I] edge that qualifies the assertion of [STB_O]. [CYC_O] MUST be negated no earlier than the rising [CLK_I] edge that qualifies the negation of [STB_O].
// ***************************
//             BEGIN
// ***************************

// Sync clk, if rst rose then
property rule3_25;
  @(posedge i_wb.wb_clk_i) $rose(i_wb.wb_cyc_i)
  |-> $rose(i_wb.wb_stb_i)
  |-> ##[1:100] $fell(i_wb.wb_cyc_i)
  |-> $fell(i_wb.wb_stb_i);
endproperty

 assert property(rule3_25) begin $display("SUCCESS assert RULE 3_25"); end else $error("ERROR: RULE 3.25 Violation");


// ***************************
//             END
// ***************************


// ***************************
// RULE 3.35 In standard mode the cycle termination signals [ACK_O], [ERR_O], and [RTY_O] must be generated in response to the logical AND of [CYC_I] and [STB_I]
// ***************************
//             BEGIN
// ***************************

// Sync clk, if rst rose then
property rule3_35;
  @(posedge i_wb.wb_clk_i) $rose(i_wb.wb_cyc_i) && $rose(i_wb.wb_stb_i)
  |-> ##[1:$] $rose(i_wb.wb_ack_o);
endproperty

   assert property(rule3_35) begin $display("SUCCESS assert RULE 3_35"); end else $error("ERROR: RULE 3.35 Violation");


// ***************************
//             END
// ***************************

// ***************************
// RULE SDR_CTRL
// ***************************
//             BEGIN
// ***************************
logic [3:0] cmd;
logic precharge;
logic nop;
logic refresh;
assign cmd = {i_wb.sdr_cs_n,i_wb.sdr_ras_n,i_wb.sdr_cas_n,i_wb.sdr_we_n};
assign precharge = (cmd == 4'b0010);
assign nop = (cmd == 4'b1111);
assign refresh = (cmd== 4'b0001);

property sdr_ctrl_01;
  @(posedge i_wb.wb_clk_i) $rose(i_wb.wb_rst_i)
  |-> ##[1:10] nop;
endproperty

     assert property (sdr_ctrl_01) begin $display("SUCCESS assert RULE sdr_ctrl_01"); end else $error("ERROR: RULE sdr_ctrl_01 Violation");

property sdr_ctrl_02;
  @(posedge i_wb.wb_clk_i) $fell(i_wb.wb_rst_i)
  |-> ##[0:10] $rose(precharge)
  |-> ##[0:10] $rose(refresh)
  |-> ##[0:10] $rose(refresh);
endproperty

       assert property (sdr_ctrl_02) begin $display("SUCCESS assert RULE sdr_ctrl_02"); end else $error("ERROR: RULE sdr_ctrl_02 Violation");

// ***************************
//             END
// ***************************


endmodule

//////////////////////////////////////////////////////////////////////////////////////////////
//                      Proyecto1. Curso MP6134 Verificacion Funcional                      //
//                                                                                          //
//                             Autores: Esteban Martinez                                    //
//                                      Kaleb Alfaro                                        //
//                                      Felipe Dengo                                        //
//  El Proyecto consiste en la restructuracion del testbench para el controlador de SDRAM.  //
//  Se descompone el archivo tb_top.sv, de forma mas ordenada de manera que sea facil de    //
//  mantener y de reutlizar. El nuevo testbench se estrucuta asi:                           //
//                                                                                          //
//                                    testbench.sv                                          //
//                                    Interface.sv                                          //
//                                    random_test.sv                                        //
//                                    environment.sv                                        //
//                                    driver.sv                                             //
//                                    scoreboard.sv                                         //
//                                    monitor.sv                                            //
//////////////////////////////////////////////////////////////////////////////////////////////


`include "IS42VM16400K.V"
`define SDR_16BIT
//-------------------------------------------------------------------------
//tbench_top or testbench top, this is the top most file, in which DUT(Design Under Test) and Verification environment are connected.
//-------------------------------------------------------------------------

//including interfcae and testcase files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "random_test.sv"
//`include "directed_test.sv"
//----------------------------------------------------------------

module tbench_top;

parameter P_SYS  = 10;     //    200MHz
parameter P_SDR  = 20;     //    100MHz

// General

reg            sdram_clk;
reg            sys_clk;

initial sys_clk = 0;
initial sdram_clk = 0;

always #(P_SYS/2) sys_clk = !sys_clk;
always #(P_SDR/2) sdram_clk = !sdram_clk;

parameter      dw              = 32;  // data width
parameter      tw              = 8;   // tag id width
parameter      bl              = 5;   // burst_lenght_width


//creatinng instance of interface, inorder to connect DUT and testcase
intf_wishbone #(.dw(dw)) i_intf_wishbone(sys_clk,RESETN);
  intf_sdram16 i_intf_sdrwam16(sdram_clk,RESETN);

  // RAM

   IS42VM16400K u_sdram16 (
          .dq                 (i_intf_sdrwam16.Dq                 ),
          .addr               (i_intf_sdrwam16.sdr_addr           ),
          .ba                 (i_intf_sdrwam16.sdr_ba             ),
          .clk                (i_intf_sdrwam16.sdram_clk_d        ),
          .cke                (i_intf_sdrwam16.sdr_cke            ),
          .csb                (i_intf_sdrwam16.sdr_cs_n           ),
          .rasb               (i_intf_sdrwam16.sdr_ras_n          ),
          .casb               (i_intf_sdrwam16.sdr_cas_n          ),
          .web                (i_intf_sdrwam16.sdr_we_n           ),
          .dqm                (i_intf_sdrwam16.sdr_dqm            )
    );




  //Testcase instance, interface handle is passed to test as an argument


  test t1(i_intf_wishbone,i_intf_sdrwam16); //--- when ready




  //DUT instance, interface signals are connected to the DUT ports
 sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
	 .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
     .cfg_colbits        (2'b00              ), // 8 Bit Column Address
/* WISH BONE */
          .wb_rst_i           (!i_intf_wishbone.RESETN            ),
          .wb_clk_i           (i_intf_wishbone.sys_clk            ),

          .wb_stb_i           (i_intf_wishbone.wb_stb_i           ),
          .wb_ack_o           (i_intf_wishbone.wb_ack_o           ),
          .wb_addr_i          (i_intf_wishbone.wb_addr_i          ),
          .wb_we_i            (i_intf_wishbone.wb_we_i            ),
          .wb_dat_i           (i_intf_wishbone.wb_dat_i           ),
          .wb_sel_i           (i_intf_wishbone.wb_sel_i           ),
          .wb_dat_o           (i_intf_wishbone.wb_dat_o           ),
          .wb_cyc_i           (i_intf_wishbone.wb_cyc_i           ),
          .wb_cti_i           (i_intf_wishbone.wb_cti_i           ),

/* Interface to SDRAMs */
          .sdram_clk          (i_intf_sdrwam16.sdram_clk          ),
          .sdram_resetn       (i_intf_sdrwam16.RESETN             ),
          .sdr_cs_n           (i_intf_sdrwam16.sdr_cs_n           ),
          .sdr_cke            (i_intf_sdrwam16.sdr_cke            ),
          .sdr_ras_n          (i_intf_sdrwam16.sdr_ras_n          ),
          .sdr_cas_n          (i_intf_sdrwam16.sdr_cas_n          ),
          .sdr_we_n           (i_intf_sdrwam16.sdr_we_n           ),
          .sdr_dqm            (i_intf_sdrwam16.sdr_dqm            ),
          .sdr_ba             (i_intf_sdrwam16.sdr_ba             ),
          .sdr_addr           (i_intf_sdrwam16.sdr_addr           ),
          .sdr_dq             (i_intf_sdrwam16.Dq                 ),
          .sdr_init_done      (i_intf_sdrwam16.sdr_init_done      ),
          /* Parameters */
          .cfg_req_depth      (2'h3               ),	        //how many req. buffer should hold
          .cfg_sdr_en         (1'b1               ),
          .cfg_sdr_mode_reg   (13'h033            ),
          .cfg_sdr_tras_d     (4'h4               ),
          .cfg_sdr_trp_d      (4'h2               ),
          .cfg_sdr_trcd_d     (4'h2               ),
          .cfg_sdr_cas        (3'h3               ),
          .cfg_sdr_trcar_d    (4'h7               ),
          .cfg_sdr_twr_d      (4'h1               ),
          .cfg_sdr_rfsh       (12'h100            ), // reduced from 12'hC35
          .cfg_sdr_rfmax      (3'h6               )

);


  //enabling the wave dump
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end

endmodule

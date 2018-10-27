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
reg            RESETN;
reg            sdram_clk;
reg            sys_clk;

initial sys_clk = 0;
initial sdram_clk = 0;

always #(P_SYS/2) sys_clk = !sys_clk;
always #(P_SDR/2) sdram_clk = !sdram_clk;

parameter      dw              = 32;  // data width
parameter      tw              = 8;   // tag id width
parameter      bl              = 5;   // burst_lenght_width 




  // RAM

   IS42VM16400K u_sdram16 (
          .dq                 (Dq                 ), 
          .addr               (sdr_addr[11:0]     ), 
          .ba                 (sdr_ba             ), 
          .clk                (sdram_clk_d        ), 
          .cke                (sdr_cke            ), 
          .csb                (sdr_cs_n           ), 
          .rasb               (sdr_ras_n          ), 
          .casb               (sdr_cas_n          ), 
          .web                (sdr_we_n           ), 
          .dqm                (sdr_dqm            )
    );



  //creatinng instance of interface, inorder to connect DUT and testcase
	intf_wishbone #(.dw(dw)) i_intf_wishbone(sys_clk,RESETN);
  
  //Testcase instance, interface handle is passed to test as an argument


//  test t1(i_intf); --- when ready
  



  //DUT instance, interface signals are connected to the DUT ports
 sdrc_top #(.SDR_DW(16),.SDR_BW(2)) u_dut(
	 .cfg_sdr_width      (2'b01              ), // 16 BIT SDRAM
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
          .sdram_clk          (sdram_clk          ),
          .sdram_resetn       (RESETN             ),
          .sdr_cs_n           (sdr_cs_n           ),
          .sdr_cke            (sdr_cke            ),
          .sdr_ras_n          (sdr_ras_n          ),
          .sdr_cas_n          (sdr_cas_n          ),
          .sdr_we_n           (sdr_we_n           ),
          .sdr_dqm            (sdr_dqm            ),
          .sdr_ba             (sdr_ba             ),
          .sdr_addr           (sdr_addr           ), 
          .sdr_dq             (Dq                 ),

    /* Parameters */
          .sdr_init_done      (sdr_init_done      ),
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

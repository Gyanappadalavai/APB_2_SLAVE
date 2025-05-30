
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_top.sv
// Developers   : Team 1
// Created Date : 28 /10/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------


import uvm_pkg::*;
`include "uvm_macros.svh"
`include "apb_defines.svh"
`include "apb_package.sv"
`include "apb_interface.sv"
//`include "apb_slave.sv"
module apb_top;

  //declaring clock and reset
  bit pclk;
  bit presetn;
	
  //defining clock generation
  initial
  begin
    pclk <= 0;
      forever #5 pclk = ~pclk;  
  end

  //driving reset
  initial
    begin
    presetn = 0;
    #10;  presetn = 1;
    #10; presetn = 0;
    #10; presetn = 1;
  end
/*
  //Instantiating DUT
   apb_slave#(32,5) DUT (
		 .pclk(PCLK),
		 .presetn(PRST),
		.i_paddr(intf_inst.i_paddr),
		.i_pwrite(intf_inst.i_pwrite),
		.i_psel(intf_inst.i_psel),
		.i_penable(intf_inst.i_penable),
		.i_pwdata(intf_inst.i_pwdata),
		.i_pstrb(intf_inst.i_pstrb),
		.o_prdata(intf_inst.o_prdata),
		.o_pslverr(intf_inst.o_pslverr),
		.o_pready(intf_inst.o_pready),
		.o_hw_ctl(intf_inst.o_hw_ctl),
		.i_hw_sts(intf_inst.i_hw_sts)
	         );
*/
  //Instantiating Interface
  apb_interface intf_inst(
	  .pclk(pclk),
	  .presetn(presetn));

  //defining config db to access variables inside testbench components
  initial
    begin
	    uvm_config_db#(virtual apb_interface.drv_mp)::set(null, "*", "vif", intf_inst);
	   
             $dumpfile("dump.vcd");
             $dumpvars();
      
    end

  //Initiating the testbench
  initial
    begin
      run_test();
    end

endmodule :apb_top

//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_test.sv
//Developers   : Team 1
// Created Date : 28 /10/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------
class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
   apb_environment env_h;

  function new(string name = "apb_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create the env
    env_h = apb_environment::type_id::create("env_h", this);

  endfunction : build_phase

  virtual function void end_of_elaboration();
     uvm_top.print_topology();
  endfunction

 function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);

   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction

endclass:apb_test

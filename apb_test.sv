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


class write_test extends apb_test;
  `uvm_component_utils(apb_test)
   writesl0 seq1_h;

  function new(string name = "apb_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      seq1_h = writesl0::type_id::create("seq1_h");
  endfunction : build_phase
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("write sel1 ","Inside  writesel 0 RUN _PHASE",UVM_HIGH)
   `uvm_info(get_type_name(),$sformatf("------ !!  apb_rr_test  !! -------"),UVM_LOW)
          seq1_h.start(env_h.a_agent_h.seqr_h);
    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase
  endfunction

                             


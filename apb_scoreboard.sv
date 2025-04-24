
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_scoreboard.sv
// Developers   : Team 1
// Created Date : 28 /10/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

`uvm_analysis_imp_decl(_ip)
`uvm_analysis_imp_decl(_op)

class apb_scoreboard extends uvm_scoreboard;

  // Registering scoreboard with factory
  `uvm_component_utils(apb_scoreboard)

  // Declaring virtual interface
  virtual apb_interface ip_vif;

  // Declaring analysis port for scoreboard to input monitor communication
  uvm_analysis_imp_ip #(apb_sequence_item, apb_scoreboard) ip_scb_imp;

  // Declaring analysis port for scoreboard to output monitor communication
  uvm_analysis_imp_op #(apb_sequence_item, apb_scoreboard) op_scb_imp;

  // Declaring variables for storing match and mismatch count
  apb_sequence_item expected_op[$];
  apb_sequence_item actual_op[$];

  static int match, mismatch;

  extern function new(string name = "apb_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void write_ip(apb_sequence_item in_mon);
  extern function void write_op(apb_sequence_item out_mon);
  extern function void value_display(apb_sequence_item in_pkt, apb_sequence_item out_pkt);
  extern task run_phase(uvm_phase phase);
endclass

// Defining class constructor
function apb_scoreboard::new(string name = "apb_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction

// Defining build phase
function void apb_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  ip_scb_imp = new("ip_scb_imp", this);
  op_scb_imp = new("op_scb_imp", this);
	if (!uvm_config_db#(virtual apb_interface.mon_ip_mp)::get(this,"", "vif",ip_vif))
      `uvm_fatal("APB_SB", "APB interf.CE handle not found in config database!")

endfunction

// Defining write method for output monitor port
function void apb_scoreboard::write_op(apb_sequence_item out_mon);
  actual_op.push_back(out_mon);
endfunction

// Defining write method for input monitor port
function void apb_scoreboard::write_ip(apb_sequence_item in_mon);    
  expected_op.push_back(in_mon);
endfunction

function void apb_scoreboard::value_display(apb_sequence_item in_pkt, apb_sequence_item out_pkt);
  `uvm_info("Check_start", "-----------------------------Start Check-----------------------", UVM_LOW);

  // Printing the expected values
  `uvm_info("expected", "Expected Packet Values: ", UVM_LOW);
  in_pkt.print();
 `uvm_info("PRST_CHECK", $sformatf("-----------PRST = %0d-----------",ip_vif.PRST), UVM_LOW);
 
  // Printing the actual values
  `uvm_info("actual", "Actual Packet Values: ", UVM_LOW);
  out_pkt.print();

	  `uvm_info("VALUE_MATCH", $sformatf("-----------match = %0d, mismatch = %0d-----------",match, mismatch), UVM_LOW);
  // Check for mismatches and report them
  if (mismatch) begin
	  `uvm_error("MISMATCH", $sformatf("-----------Sequence Mismatched-----------"));
	   mismatch = 0;
  end

  // Check for matches and report them
  if (match) begin
	  `uvm_info("MATCH", $sformatf("-----------Sequence matched-----------"), UVM_LOW);
            match = 0;
  end


  `uvm_info("Check_stop", "-----------------------------Stop Check-----------------------", UVM_LOW);
endfunction


task apb_scoreboard::run_phase(uvm_phase phase);
  apb_sequence_item in_mon;
  apb_sequence_item out_mon;
  
	bit [7:0]mem0[4:0];
	bit [7:0]mem1[4:0];
 
  forever begin
         
    `uvm_info("scb", $sformatf("###################### inside scb ##########################"), UVM_LOW)
    `uvm_info("scb", $sformatf("##############EXPECTED_OP_SIZE=%0d#####ACTUAL_OP_SIZE=%0D####################",expected_op.size, actual_op.size), UVM_LOW)
    wait(expected_op.size > 0 && actual_op.size > 0) begin
      in_mon = expected_op.pop_front();
      out_mon = actual_op.pop_front();
        

	if (!(ip_vif.presetn)) begin
       

        // APB read ports
        in_mon.transfer = 0;
        in_mon.read_write = 0;
        value_display(in_mon,out_mon);
      end
      else begin
	      if(in_mon.read_write)begin
		      mem[in_mon.apb_write_paddr]=in_mon.apb_write_data;
	      end
	      else begin
		      apb_read_paddr=in_mon.apb_write_paddr;
		      in_mon.apb_read_data_out=mem[in_mon.apb_read_paddr];
		      
                  end
      end

    
endtask

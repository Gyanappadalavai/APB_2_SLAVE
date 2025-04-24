
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_op_monitor.sv
// Developers   : Team 1
// Created Date : 05/11/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights i_pwriteerved.
//------------------------------------------------------------------------------
class apb_op_monitor extends uvm_monitor;

	//Registering output monitor of active agent to factory
	`uvm_component_utils(apb_op_monitor)
   
	//Declaring virtual interface
	virtual apb_interface.mon_op_mp vif;

	//declaring analysis port for output monitor to coverage/scoreboard connection
	uvm_analysis_port #(apb_sequence_item) op_mon_port;

	//declaring handle for sequence item
	apb_sequence_item packet;

	extern function new(string name = "apb_op_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

	//defining class constructor
	function apb_op_monitor::new(string name = "apb_op_monitor", uvm_component parent);
		super.new(name, parent);
		op_mon_port = new("op_mon_port", this);
	endfunction

	//defining build phase
	function void apb_op_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(virtual apb_interface.mon_op_mp) :: get(this, "", "vif", vif))
			`uvm_fatal("monitor", "Unable to  virtual interface")
	endfunction

	//defining run phase
	task apb_op_monitor::run_phase(uvm_phase phase);
		repeat(2) @(vif.mon_op_cb);
	
		forever
		begin
		packet = apb_sequence_item::type_id::create("packet", this);

			@(vif.mon_op_cb)
			begin	
				packet.transfer = vif.mon_op_cb.transfer;
				packet.read_write = vif.mon_op_cb.read_write;
				packet.apb_write_paddr = vif.mon_op_cb.apb_write_paddr;
				packet.apb_write_data = vif.mon_op_cb.apb_write_data;
				packet.apb_read_paddr = vif.mon_op_cb.apb_read_paddr;
				packet. apb_read_data_out = vif.mon_op_cb.apb_read_data_out;

				`uvm_info("output monitor", $sformatf("---Output monitor---"), UVM_LOW);	
				 packet.print();
				`uvm_info("output monitor", $sformatf("--------------------"), UVM_LOW);	
				
				op_mon_port.write(packet);
			end	
		end
	endtask

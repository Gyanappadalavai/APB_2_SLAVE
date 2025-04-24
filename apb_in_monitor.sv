//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_ip_monitor.sv
// Developers   : Team 1
// Created Date : 05 /11/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------
class apb_ip_monitor extends uvm_monitor;

	//Registering input monitor of active agent to factory
	`uvm_component_utils(apb_ip_monitor)

	//declaring virtual interface 
	virtual apb_interface.mon_op_mp vif;


	//declaring analysis port for input monitor to coverage/scoreboard
	uvm_analysis_port #(apb_sequence_item) ip_mon_port;

	//declaring handle for sequence item
	apb_sequence_item packet;

	extern function new(string name = "apb_ip_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass	

	//defining class constructor
	function apb_ip_monitor::new(string name = "apb_ip_monitor", uvm_component parent);
		super.new(name, parent);
	endfunction

	//defining build phase
	function void apb_ip_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(virtual apb_interface.mon_op_mp) :: get(this, "", "vif", vif))
			`uvm_fatal("Input_Monitor", "Unable to get virtual interface")

		ip_mon_port = new("ip_mon_port", this);

	endfunction

	//defining run task
	task apb_ip_monitor::run_phase(uvm_phase phase);
		repeat(2) @(vif.mon_in_cb);
		forever
		begin	
			packet = apb_sequence_item::type_id::create("packet", this);

			@(vif.mon_in_cb)
			begin
			    packet.transfer <= vif.mon_op_cb.transfer;
			    packet.read_write <= vif.mon_op_cb.read_write;
			    packet.apb_write_paddr  <= vif.mon_op_cb.apb_write_paddr ;
			    packet.apb_write_data   <= vif.mon_op_cb.apb_write_data  ;
                            packet.apb_read_paddr    <= vif.mon_op_cb.apb_read_paddr   ;
			    `uvm_info("input monitor", $sformatf("---Input monitor---"), UVM_LOW);	
		            packet.print();
			    `uvm_info("input monitor", $sformatf("-------------------"), UVM_LOW);	

			    ip_mon_port.write(packet);
			end	
		end
	endtask

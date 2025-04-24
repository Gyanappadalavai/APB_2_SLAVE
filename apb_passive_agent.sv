
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_passive_agent.sv
// Developers   : Team 1
// Created Date : 05 /11/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------
class apb_passive_agent extends uvm_agent;

	`uvm_component_utils(apb_passive_agent)

	apb_op_monitor out_mon_h;

	extern function new(string name = "apb_passive_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

	function apb_passive_agent::new(string name = "apb_passive_agent", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void apb_passive_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		out_mon_h = apb_op_monitor::type_id::create("out_mon_h", this);
	endfunction

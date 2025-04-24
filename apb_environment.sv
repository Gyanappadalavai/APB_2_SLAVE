
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_environment.sv
// Developers   : Team 1
// Created Date : 05 / 11 / 2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------
class apb_environment extends uvm_env;

	//registering environment class with factory
	`uvm_component_utils(apb_environment)

	//declaring handles for testbench components under environment
	apb_active_agent a_agent_h;
	apb_passive_agent p_agent_h;
	apb_coverage cvg_h;
	apb_scoreboard scb_h;

	//declaring functions
	extern function new(string name = "apb_environment", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

//defining class constructor
function apb_environment::new(string name = "apb_environment", uvm_component parent);
	super.new(name, parent);
endfunction

//defining build phase
function void apb_environment::build_phase(uvm_phase phase);
	super.build_phase(phase);
	a_agent_h = apb_active_agent::type_id::create("a_agent_h", this);
	p_agent_h = apb_passive_agent::type_id::create("p_agent_h", this);
	cvg_h = apb_coverage::type_id::create("cvg_h", this);
	scb_h = apb_scoreboard::type_id::create("scb_h", this);
endfunction

//defining connect phase
function void apb_environment::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	a_agent_h.in_mon_h.ip_mon_port.connect(cvg_h.ip_cvg_imp);
	a_agent_h.in_mon_h.ip_mon_port.connect(scb_h.ip_scb_imp);
	p_agent_h.out_mon_h.op_mon_port.connect(cvg_h.op_cvg_imp);
	p_agent_h.out_mon_h.op_mon_port.connect(scb_h.op_scb_imp);
endfunction

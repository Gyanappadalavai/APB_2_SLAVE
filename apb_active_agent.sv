
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_active_agent.sv
// Developers   : Team 1
// Created Date : 28 /10/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------
class apb_active_agent extends uvm_agent;

        `uvm_component_utils(apb_active_agent)

        apb_sequencer seqr_h;
        apb_driver drv_h;
        apb_ip_monitor in_mon_h;

        extern function new(string name = "apb_active_agent", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
endclass        

function apb_active_agent::new(string name = "apb_active_agent", uvm_component parent);
        super.new(name, parent);
endfunction

function void apb_active_agent::build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr_h = apb_sequencer::type_id::create("seqr_h", this);
        drv_h = apb_driver::type_id::create("drv_h", this);
        in_mon_h = apb_ip_monitor::type_id::create("in_mon_h", this);
endfunction

function void apb_active_agent::connect_phase(uvm_phase phase);
        drv_h.seq_item_port.connect(seqr_h.seq_item_export);
endfunction

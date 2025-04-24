
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "apb_seq_item.sv"
class apb_sequencer extends uvm_sequencer#(apb_sequence_item);

	//Factory registration
	`uvm_component_utils(apb_sequencer)
 
	//Constructor
	function new (string name="apb_sequencer",uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass: apb_sequencer

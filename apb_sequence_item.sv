
class apb_sequence_item extends uvm_sequence_item;
  
  rand bit transfer;
  rand bit read_write;
  rand bit [`DW-1:0] apb_write_paddr;
  rand bit [`AW-1:0]apb_read_paddr;
  rand bit [`DW-1:0] apb_write_data;
  bit [`DW-1:0]apb_read_data_out;


  //Registering sequence_item class with factory
  `uvm_object_utils_begin(apb_sequence_item)

  `uvm_field_int(transfer,UVM_ALL_ON)
  `uvm_field_int(read_write,UVM_ALL_ON)
  `uvm_field_int(apb_write_paddr,UVM_ALL_ON)
  `uvm_field_int(apb_read_paddr,UVM_ALL_ON)
  `uvm_field_int(apb_write_data,UVM_ALL_ON)
  `uvm_field_int(apb_read_data_out,UVM_ALL_ON)
  
  `uvm_object_utils_end

  extern function new(string name = "apb_sequence_item");

  //defining general constraints
    constraint slbfr{ transfer==1;}
  
endclass

  //defining class constructor
  function apb_sequence_item::new(string name = "apb_sequence_item");
    super.new(name);
  endfunction

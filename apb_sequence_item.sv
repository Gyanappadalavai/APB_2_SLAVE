
class apb_sequence_item extends uvm_sequence_item;
  
  rand logic[`AW-1:0]i_paddr;
  rand logic i_pwrite;
  logic i_psel;
  logic i_penable;
  rand logic [`DW-1:0] i_pwdata;
  rand logic [`SW-1:0]i_pstrb ;

  logic [`DW-1:0]o_prdata;
  logic o_pslverr;
  logic o_pready;
  
  logic o_hw_ctl;
  logic i_hw_sts;

  //Registering sequence_item class with factory
  `uvm_object_utils_begin(apb_sequence_item)

  `uvm_field_int(i_paddr,UVM_ALL_ON)
  `uvm_field_int(i_pwrite,UVM_ALL_ON)
  `uvm_field_int(i_psel,UVM_ALL_ON)
  `uvm_field_int(i_penable,UVM_ALL_ON)
  `uvm_field_int(i_pwdata,UVM_ALL_ON)
  `uvm_field_int(i_pstrb,UVM_ALL_ON)
  `uvm_field_int(o_prdata,UVM_ALL_ON)
  `uvm_field_int(o_pslverr,UVM_ALL_ON)
  `uvm_field_int(o_pready,UVM_ALL_ON)

  `uvm_object_utils_end

  extern function new(string name = "apb_sequence_item");

  //defining general constraints
    constraint slbfr{ solve i_pwrite before i_paddr;}
  constraint gen{ soft i_pwrite==1 ->(i_pstrb == 'hF && (i_paddr[`AW-1:`ADDR_LSB]==0 || i_paddr[`AW-1:`ADDR_LSB]==1  || i_paddr[`AW-1:`ADDR_LSB]==2)); 
                  soft i_pwrite==0 -> (i_pstrb == 0 && (i_paddr[`AW-1:`ADDR_LSB]==0 || i_paddr[`AW-1:`ADDR_LSB]==2 || i_paddr[`AW-1:`ADDR_LSB]==3 || i_paddr[`AW-1:`ADDR_LSB]==4));}

constraint c_4 {soft i_pwrite == 0->
                 i_paddr[`AW-1:`ADDR_LSB] dist {0:=2,[2:4]:=2};}
endclass

  //defining class constructor
  function apb_sequence_item::new(string name = "apb_sequence_item");
    super.new(name);
  endfunction

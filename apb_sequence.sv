class apb_sequence extends uvm_sequence #(apb_sequence_item);

   `uvm_object_utils(apb_sequence)
   virtual apb_interface.drv_mp mvif;
   function new(string name = "apb_sequence");
      super.new(name);
   endfunction

virtual task body();
  apb_sequence_item item;
  repeat(2)begin
   item = apb_sequence_item::type_id::create("item");
   wait_for_grant();
   item.randomize();
   send_request(item);
   wait_for_item_done();
  end
   endtask :body
endclass

class apb_enb_0 extends apb_sequence;
  `uvm_object_utils(apb_enb_0)
  apb_sequence_item item;

  function new(string name = "apb_enb_0");
		super.new();
	endfunction

 task body();
   repeat(2)begin
     item = apb_sequence_item::type_id::create("item");
     wait_for_grant();
     item.i_penable = 0;
     item.randomize() ;
     send_request(item);
     wait_for_item_done();
   end
endtask

endclass: apb_enb_0

//1 Write then read to w/r register
class apb_wr_seq extends apb_sequence;

  `uvm_object_utils(apb_wr_seq)
  apb_sequence_item  item;

  function new (string name= "apb_wr_seq");
    super.new(name);
  endfunction: new

  task body();
     `uvm_do_with(item, {item.i_pwrite == 1; item.i_paddr[`AW-1:`ADDR_LSB] ==  2;})
     `uvm_do_with(item, {item.i_pwrite == 0; item.i_paddr[`AW-1:`ADDR_LSB] ==  2;}) 
     `uvm_do_with(item, {item.i_pwrite == 1; item.i_paddr[`AW-1:`ADDR_LSB] ==  0;})
     `uvm_do_with(item, {item.i_pwrite == 0; item.i_paddr[`AW-1:`ADDR_LSB] ==  0;}) 
 endtask: body
endclass: apb_wr_seq


//2 Write two times to same register and read from that register
class apb_wwr_seq extends apb_sequence;

  `uvm_object_utils(apb_wwr_seq)
  apb_sequence_item  item;

  function new (string name= "apb_wwr_seq");
    super.new(name);
  endfunction: new

  task body();
     
     `uvm_do_with(item,{item.i_pwrite == 1; item.i_paddr[`AW-1:`ADDR_LSB] ==  2; i_pwdata==32'h09;})
     item.i_pwdata.rand_mode(0);
     `uvm_do_with(item,{item.i_pwrite == 1; item.i_paddr[`AW-1:`ADDR_LSB] ==  2; i_pwdata==32'h07;}) 
    
     `uvm_do_with(item,{item.i_pwrite == 0; item.i_paddr[`AW-1:`ADDR_LSB] ==  2;}) 
  endtask: body
endclass: apb_wwr_seq



//3 Write two times to same register

class apb_ww_seq extends apb_sequence;

  `uvm_object_utils(apb_ww_seq)
  apb_sequence_item  item;

  function new (string name= "apb_ww_seq");
    super.new(name);
  endfunction: new

  task body();
     
     `uvm_do_with(item,{item.i_pwrite == 1; item.i_paddr[`AW-1:`ADDR_LSB] inside {[0:2]}; })
     
     
  endtask: body
endclass: apb_ww_seq




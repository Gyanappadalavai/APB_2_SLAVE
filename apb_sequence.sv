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

class writesl0 extends apb_sequence;
  `uvm_object_utils(writesl0)
  apb_sequence_item item;

  function new(string name = "writesl0");
		super.new();
	endfunction

 task body();
	 `uvm_do_with(item, {item.transfer == 1; item.read_write==1  ,item.apb_write_paddr[8]==0;})    
 endtask: body
endtask

endclass: writesl0

//read from slave 0
class readsl0 extends apb_sequence;

  `uvm_object_utils(readsl0)
  apb_sequence_item  item;

  function new (string name= "readsl0");
    super.new(name);
  endfunction: new

   task body();
	   `uvm_do_with(item, {item.transfer == 1; item.read_write==0  ,item.apb_write_paddr[8]==0;})    
 endtask: body
endclass: readsl0


//2 Write two times to same register and read from that register
class writesl1 extends apb_sequence;

  `uvm_object_utils(writesl1)
  apb_sequence_item  item;

  function new (string name= "writesl1");
    super.new(name);
  endfunction: new

   task body();
	   `uvm_do_with(item, {item.transfer == 1; item.read_write==1  ,item.apb_write_paddr[8]==1;})    
 endtask: body
endclass: writesl1



//3 Write two times to same register

class readsel1 extends apb_sequence;

  `uvm_object_utils(readsel1)
  apb_sequence_item  item;

  function new (string name= "readsel1");
    super.new(name);
  endfunction: new

 task body();
	 `uvm_do_with(item, {item.transfer == 1; item.read_write==0  ,item.apb_write_paddr[8]==1;})    
 endtask: body
endclass: readsel1



class writeread0 extends apb_sequence;

  `uvm_object_utils(writeread0)
  apb_sequence_item  item;

  function new (string name= "writeread0");
    super.new(name);
  endfunction: new

 task body();
	 `uvm_do_with(item, {item.transfer == 1; item.read_write==1  ,item.apb_write_paddr[8]==0;}) 
	 `uvm_do_with(item, {item.transfer == 1; item.read_write==0  ,item.apb_write_paddr[8]==0;})    

 endtask: body
endclass: writeread0

class writeread1 extends apb_sequence;

 `uvm_object_utils(writeread1)
  apb_sequence_item  item;

  function new (string name= "writeread0");
    super.new(name);
  endfunction: new

 task body();
	 `uvm_do_with(item, {item.transfer == 1; item.read_write==1  ,item.apb_write_paddr[8]==1;}) 
	 `uvm_do_with(item, {item.transfer == 1; item.read_write==0  ,item.apb_write_paddr[8]==1;})    

 endtask: body
endclass: writeread1



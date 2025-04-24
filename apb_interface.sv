interface apb_intf(input bit pclk, presetn);
  logic  transfer;
  logic read_write;
  logic apb_write_paddr[`AW-1:0];
  logic apb_read_paddr[`AW-1:0];
  logic apb_write_data[`DW-1:0];
  logic apb_read_data_out[`DW-1:0];

  clocking drv_cb @(posedge PCLK);
   default input #0 output #0;
   input  presetn;  // Resetn
   output  transfer ;  
   output  read_write  ;  
   output  apb_write_paddr ; 
   output apb_read_paddr;
   output  apb_write_data  ;  
 
  endclocking

  

  clocking mon_op_cb @(posedge PCLK);
   default input #0 output #0;
   input  apb_read_data_out  ;  
   input  transfer ;  
   input  read_write  ;  
   input  apb_write_paddr  ;
   input  apb_read_paddr   ;   
   input  apb_write_data  ;  
  endclocking
  
  modport drv_mp (clocking drv_cb);
  modport mon_0p_mp (clocking mon_op_cb);
    
endinterface


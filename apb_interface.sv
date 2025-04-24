interface apb_intf(input bit pclk, presetn);
  logic  transfer;
  logic read_write;
  logic apb_write_paddr[`AW-1:0];
  logic apb_read_paddr[`AW-1:0];
  logic apb_write_data[`DW-1:0];
  logic apb_read_data_out[`DW-1:0];


endinterface


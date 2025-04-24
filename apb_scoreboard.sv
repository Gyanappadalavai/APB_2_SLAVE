
//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_scoreboard.sv
// Developers   : Team 1
// Created Date : 28 /10/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

`uvm_analysis_imp_decl(_ip)
`uvm_analysis_imp_decl(_op)

class apb_scoreboard extends uvm_scoreboard;

  // Registering scoreboard with factory
  `uvm_component_utils(apb_scoreboard)

  // Declaring virtual interface
  virtual apb_interface ip_vif;

  // Declaring analysis port for scoreboard to input monitor communication
  uvm_analysis_imp_ip #(apb_sequence_item, apb_scoreboard) ip_scb_imp;

  // Declaring analysis port for scoreboard to output monitor communication
  uvm_analysis_imp_op #(apb_sequence_item, apb_scoreboard) op_scb_imp;

  // Declaring variables for storing match and mismatch count
  apb_sequence_item expected_op[$];
  apb_sequence_item actual_op[$];

  static int match, mismatch;

  extern function new(string name = "apb_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void write_ip(apb_sequence_item in_mon);
  extern function void write_op(apb_sequence_item out_mon);
  extern function void value_display(apb_sequence_item in_pkt, apb_sequence_item out_pkt);
  extern task run_phase(uvm_phase phase);
endclass

// Defining class constructor
function apb_scoreboard::new(string name = "apb_scoreboard", uvm_component parent);
  super.new(name, parent);
endfunction

// Defining build phase
function void apb_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  ip_scb_imp = new("ip_scb_imp", this);
  op_scb_imp = new("op_scb_imp", this);
 if (!uvm_config_db#(virtual apb_interface.mon_ip_mp)::get(this,"", "vif_mon_in",ip_vif))
      `uvm_fatal("APB_SB", "APB interf.CE handle not found in config database!")

endfunction

// Defining write method for output monitor port
function void apb_scoreboard::write_op(apb_sequence_item out_mon);
  actual_op.push_back(out_mon);
endfunction

// Defining write method for input monitor port
function void apb_scoreboard::write_ip(apb_sequence_item in_mon);    
  expected_op.push_back(in_mon);
endfunction

function void apb_scoreboard::value_display(apb_sequence_item in_pkt, apb_sequence_item out_pkt);
  `uvm_info("Check_start", "-----------------------------Start Check-----------------------", UVM_LOW);

  // Printing the expected values
  `uvm_info("expected", "Expected Packet Values: ", UVM_LOW);
  in_pkt.print();
 `uvm_info("PRST_CHECK", $sformatf("-----------PRST = %0d-----------",ip_vif.PRST), UVM_LOW);
 
  // Printing the actual values
  `uvm_info("actual", "Actual Packet Values: ", UVM_LOW);
  out_pkt.print();

	  `uvm_info("VALUE_MATCH", $sformatf("-----------match = %0d, mismatch = %0d-----------",match, mismatch), UVM_LOW);
  // Check for mismatches and report them
  if (mismatch) begin
	  `uvm_error("MISMATCH", $sformatf("-----------Sequence Mismatched-----------"));
	   mismatch = 0;
  end

  // Check for matches and report them
  if (match) begin
	  `uvm_info("MATCH", $sformatf("-----------Sequence matched-----------"), UVM_LOW);
            match = 0;
  end


  `uvm_info("Check_stop", "-----------------------------Stop Check-----------------------", UVM_LOW);
endfunction


task apb_scoreboard::run_phase(uvm_phase phase);
  apb_sequence_item in_mon;
  apb_sequence_item out_mon;
  
  localparam N_REG = 2**(`AW-`ADDR_LSB);  // Max. number of registers supported in the address space
  logic [`DW-1:0] apb_reg[N_REG];
 

 // Assign all RO/RO+ registers
   apb_reg[3] = 32'hDEAD_BEEF ;  // Constant value
 
  forever begin
         
    `uvm_info("scb", $sformatf("###################### inside scb ##########################"), UVM_LOW)
    `uvm_info("scb", $sformatf("##############EXPECTED_OP_SIZE=%0d#####ACTUAL_OP_SIZE=%0D####################",expected_op.size, actual_op.size), UVM_LOW)
    wait(expected_op.size > 0 && actual_op.size > 0) begin
      in_mon = expected_op.pop_front();
      out_mon = actual_op.pop_front();
        

      if (!(ip_vif.PRST)) begin
        apb_reg[0] = 0;
        apb_reg[1] = 0;
        apb_reg[2] = 0;

        // APB read ports
        in_mon.o_prdata = 0;
        in_mon.o_pready = 0;
        value_display(in_mon,out_mon);
      end

     else if( out_mon.o_pslverr && out_mon.o_pready)begin
	in_mon.o_pslverr = in_mon.i_pwrite?((in_mon.i_paddr[`AW-1:`ADDR_LSB]==3 || in_mon.i_paddr[`AW-1:`ADDR_LSB] == 4)?1:0) :((in_mon.i_paddr[`AW-1:`ADDR_LSB]==1)?1:0);
        if(in_mon.i_pwrite == out_mon.i_pwrite && in_mon.i_paddr == out_mon.i_paddr && in_mon.o_pslverr == out_mon.o_pslverr) 
	        match++;
	else
	        mismatch++;
	value_display(in_mon,out_mon);
     end
	    
     else begin
       if(in_mon.i_psel && in_mon.i_penable  && !out_mon.o_pready) begin
        in_mon.o_pready = 1;
        case (in_mon.i_pwrite)
          0:  // read operation 
           begin
	      if (in_mon.i_paddr [`AW-1:`ADDR_LSB] >= 0 && in_mon.i_paddr [`AW-1:`ADDR_LSB] != 1 && in_mon.i_paddr [`AW-1:`ADDR_LSB] <= 4) 
                 begin
                  in_mon.o_prdata = apb_reg[in_mon.i_paddr[`AW-1:`ADDR_LSB]];
                  `uvm_info("RDATA", $sformatf("apb_Reg[%0d] = %0h", in_mon.i_paddr[`AW-1:`ADDR_LSB], apb_reg[in_mon.i_paddr[`AW-1:`ADDR_LSB]]),UVM_LOW)
                  in_mon.o_pslverr = 0;
		 
                end

	      else if (in_mon.i_paddr [`AW-1:`ADDR_LSB] == 1)
		       begin in_mon.o_prdata = 0; in_mon.o_pslverr = 1; end

	       
	       else
		 begin `uvm_error("i_paddr is a reserved address","I_PADDR") end
 
              in_mon.o_pslverr = 0;
		  in_mon.o_pready = 0;
              if(in_mon.i_paddr == out_mon.i_paddr && in_mon.o_prdata == out_mon.o_prdata && in_mon.o_pslverr == out_mon.o_pslverr && in_mon.o_pready == out_mon.o_pready) 
	       in_mon.o_pready = 0;
               if(in_mon.i_paddr == out_mon.i_paddr && in_mon.o_prdata == out_mon.o_prdata && in_mon.o_pslverr == out_mon.o_pslverr && in_mon.o_pready == out_mon.o_pready) 
	              match++;
	      else
	              mismatch++;
            end    

	  1: begin
	       if (in_mon.i_paddr[`AW-1:`ADDR_LSB] <= 2) begin
                   foreach (in_mon.i_pstrb[i])  begin
		     if (in_mon.i_pstrb[i]) 
		       for (int j = 8 * i; j <= (8 * i) + 7; j++)begin 
			       apb_reg[in_mon.i_paddr[`AW-1:`ADDR_LSB]][j] = in_mon.i_pwdata[j];
				`uvm_info("check_wdata", $sformatf("i_strb[%0d] = %0d --> apb_reg[%0d][%0d] = %0h", i, in_mon.i_pstrb[i],in_mon.i_paddr[`AW-1:`ADDR_LSB], j,apb_reg[i][j]), UVM_LOW)		
		
		     end
                  end
                  
                  `uvm_info("WDATA", $sformatf("apb_Reg[%0d] = %0h", in_mon.i_paddr[`AW-1:`ADDR_LSB], apb_reg[in_mon.i_paddr[`AW-1:`ADDR_LSB]]),UVM_LOW)
		    in_mon.o_pslverr = 0;
	         end

	       else if (in_mon.i_paddr[`AW-1:`ADDR_LSB] == 3 || in_mon.i_paddr[`AW-1:`ADDR_LSB] == 4 )
		       begin in_mon.o_prdata = 0; in_mon.o_pslverr = 1; end

	       else 
	        begin  `uvm_error("i_paddr is a reserved address","I_PADDR") end     
             
                
	      in_mon.o_pready = 0;
              in_mon.o_pslverr = 0;
              if(in_mon.i_paddr == out_mon.i_paddr && in_mon.i_pwrite == out_mon.i_pwrite && in_mon.i_pstrb == out_mon.i_pstrb && in_mon.o_pslverr == out_mon.o_pslverr && in_mon.o_pready == out_mon.o_pready) 
	              match++;
	      else 
	              mismatch++;
 
              end
	default : $display("P_write is invalid !!");       
        endcase

//   apb_reg[4] = in_mon.i_hw_sts ;  // Driven by HW interface status signal...

   // Drive all HW interface control signals
 //  in_mon.o_hw_ctl = apb_reg[0] ;

	      value_display(in_mon,out_mon);
       end // end of if -> signal check
      end
    end // end of wait
  end // end of forever
endtask

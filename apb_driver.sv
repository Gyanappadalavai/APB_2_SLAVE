//------------------------------------------------------------------------------
// Project      : APB
// File Name    : apb_driver.sv
// Developers   : Protocol Pioneers
// Created Date : 05/11/2024
// Version      : V1.0
//------------------------------------------------------------------------------
// Copyright    : 2024(c) Manipal Center of Excellence. All rights reserved.
//------------------------------------------------------------------------------

//`include "apb_sequence.sv"
class apb_driver extends uvm_driver #(apb_sequence_item);

        //Registering driver class in factory
        `uvm_component_utils(apb_driver)

        //declaring a virtual interface for driver
        virtual apb_interface.drv_mp vif;
	virtual apb_interface apb_vif;
        //declaring a handle for sequence item
        apb_sequence_item packet;

        extern function new(string name = "apb_driver", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task drive();

endclass

        //defining class constructor
        function apb_driver::new(string name = "apb_driver", uvm_component parent);
                super.new(name, parent);
        endfunction

        //defining build phase
        function void apb_driver::build_phase(uvm_phase phase);
                super.build_phase(phase);

                if(!uvm_config_db #(virtual apb_interface.drv_mp) :: get (this, "", "vif_drv", vif))
                begin
                        `uvm_fatal(get_type_name(), "Unable to get the virtual interface");
                end

                packet = apb_sequence_item::type_id::create("packet", this);
        endfunction

        //defining run phase
        task apb_driver::run_phase(uvm_phase phase);
                repeat(1) @(posedge vif.drv_cb);
               forever
                begin
			
                        seq_item_port.get_next_item(packet);

			`uvm_info("driver", $sformatf("---Sending packets from Driver to DUT---"), UVM_LOW);	
                        drive();
                        seq_item_port.item_done();
                end
        endtask

        //driving inputs to DUT
        task apb_driver::drive();
                @(posedge vif.drv_cb);

                begin
	          if(vif.drv_cb.PRST == 1)begin
			// IDLE PHASE
			vif.drv_cb.i_psel <= 0;
			vif.drv_cb.i_penable <= 0;
			
		//	packet.print();
		 	repeat(1)@(vif.drv_cb);
			
			// SETUP PHASE 
			vif.drv_cb.i_psel <= 1;
			vif.drv_cb.i_penable <= 0;
			vif.drv_cb.i_paddr <= packet.i_paddr;
			vif.drv_cb.i_pwrite <= packet.i_pwrite;
			vif.drv_cb.i_pwdata <= packet.i_pwdata;
			vif.drv_cb.i_pstrb <= packet.i_pstrb;
			
		 	repeat(1)@(vif.drv_cb);
			
			// ACCESS PHASE 
			vif.drv_cb.i_psel <= 1;
			vif.drv_cb.i_penable <= 1;
			vif.drv_cb.i_paddr <= packet.i_paddr;
			vif.drv_cb.i_pwrite <= packet.i_pwrite;
			vif.drv_cb.i_pwdata <= packet.i_pwdata;
			vif.drv_cb.i_pstrb <= packet.i_pstrb;
			
			while(!vif.drv_cb.o_pready) begin
          			@(posedge vif.drv_cb);
           			 `uvm_info("WDRIVER",$sformatf("Wating for ready signal"),UVM_LOW)
            		 end
                        
			@(negedge vif.drv_cb.o_pready)	begin			
			vif.drv_cb.i_psel <= 0;
			vif.drv_cb.i_penable <= 0;
			vif.drv_cb.i_paddr <= packet.i_paddr;
			vif.drv_cb.i_pwrite <= packet.i_pwrite;
			vif.drv_cb.i_pwdata <= packet.i_pwdata;
			vif.drv_cb.i_pstrb <= packet.i_pstrb;
			end
			`uvm_info("driver", $sformatf("---Packet driven by Driver---"), UVM_LOW);	
			packet.print();
                     
                    end 	
		
                   else begin

			vif.drv_cb.i_psel <= 1;
			vif.drv_cb.i_penable <= 1;
			vif.drv_cb.i_paddr <= packet.i_paddr;
			vif.drv_cb.i_pwrite <= packet.i_pwrite;
			vif.drv_cb.i_pwdata <= packet.i_pwdata;
			vif.drv_cb.i_pstrb <= packet.i_pstrb;
		   end	
                end
        endtask

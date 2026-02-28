/* Code: DDR5 PHY Interface code
   Author: 
   Course: ECE-593 Fundamentals of Pre-Silicon Validation
*/

class ddr5_agent extends uvm_agent;

    //--- UVM Factory Registration (Components because this is static throughout the entire simulation.)
    `uvm_component_utils(ddr5_agent)

    //--- Instantiate sub components of the Agent (DRV-> MON-> SEQR)
    ddr5_driver drv;
    ddr5_mon mon;
    ddr5_seqr seqr;

    //--- Standard UVM Constructor to extend function from the parent uvm_component
    function new(string name = "ddr_agent", uvm_component parent); 
        super.new(name, parent);
        `uvm_info("AGT: [%0t] Agent Class Started", $time)
    endfunction //new()

    //--- Build Phase 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AGT: [%0t] Build Phase!", $time)
        
        //--- Create UVM factory object for all the sub components in the build phase 
        drv = ddr5_driver::type_id::create("drv", this);
        mon = ddr5_mon::type_id::create("mon", this);
        seqr = ddr5_seqr::type_id::create("seqr", this);
    endfunction

    //--- Connect Phase 
    //--- Export and import port connection
    //--- In build ports for driver and sequencer that connect each other for the transfer of the data
    function void connect_phase;
        super.connect_phase(phase);
        `uvm_info("AGT: [%0t] Connect Phase", $time)

        //--- Connecting the sequencer and the driver (import and export) The driver asks the data and the sequencer provides the data (exports it)
        drv.seq_item_port.connect(seq_item_port_export);
    endfunction 

    function run_phase(uvm_phase phase);
        super.run_phase(phase);
        
    endfunction

    task <task_name> (arguments);
        

       `uvm_info("AGT: [%0t] Agent Class Ended", $time) 
    endtask //
endclass //ddr5_agent extends uvm_agent

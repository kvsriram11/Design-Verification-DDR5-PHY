class ddr5_monitor extends uvm_monitor;

    //--- UVM registration of the monitor class
    `uvm_component_utils(ddr5_monitor)

    //--- We need to access virtual interface to interact with the DUT
    virtual ddr5_if vif;
    ddr5_packet item;

    //--- TLM analysis port needs to be created for monitor
    //--- Create handle for the analysis port
    uvm_analysis_port #(ddr5_packet) monitor_port;

    function new(string_name="ddr5_monitor", uvm_component parent);
        super.new(name, parent);
        `uvm_info("MON: [%0t] Monitor Class Started", $time)
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MON: [%0t] Build Phase", $time)
        
        monitor_port = new("monitor_port", this);

        if(!(uvm_config_db #(virtual ddr5_if)::get(this, "*", "vif", vif))) begin
            `uvm_error("MON: [%0t] Failed to get Virtual Interface from inbuilt config_db", $time)
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("MON: [%0t] Connect Phase", $time)
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("MON: [%0t] Run Phase", $time)

        forever begin
            item = ddr5_packet::type_id::create("item");            //--- Create factory object for the transaction to be observed 

        //--- Use write method from monitor analysis port to boradcast the transactions
        monitor_port.write(item);
        end
    endtask //
endclass //ddr5_monitor extends superClass

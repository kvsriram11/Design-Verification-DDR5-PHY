class ddr5_driver extends superClass;

    //--- UVM Factory Registration (Components because this is static throughout the entire simulation.)
    `uvm_component_utils(ddr5_driver)

    //--- Handles for Interface and Sequence 
    virtual ddr5_if vif;
    ddr5_packet item;

    //--- Standard UVM Constructor
    function new(string name = "ddr5_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info("DRV: [%0t] Driver Class Started", $time)
    `uvm_info("DRV: [%0t] Inside Constructor!", $time)
    endfunction //new()

    //--- Build Phase
    function void build_phase(uvm_build phase);
        super.build_phase(phase);
        `uvm_info("DRV: [%0t] Inside Build Phase!", $time)

        //---Driver needs access to virtual interface from the centralized config_db
        //--- Error if we are not able to access the virtual interface through centralized config_db 
        if(!(uvm_config_db #(virtual ddr5_if)::get(this, "*", "vif", vif))) begin
            `uvm_error("DRV: [%0t] Failed to get Virtual Interface from inbuilt config_db", $time)
        end
    endfunction

    task <task_name>(arguments);
        `uvm_info("DRV: [%0t] Driver Class Ended", $time)
    endtask //
endclass //className extends superClass

class ddr5_test extends uvm_test;

    `uvm_component_utils(ddr5_test)

    //--- Instantiate the sub-components class
    ddr5_environment env;


    function new(string name="ddr5_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("TST: [%0t] Test Class Started", $time)
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TST: [%0t] Build Phase", $time)
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("TST: [%0t] Connect Phase", $time)
    endfunction

    task run_phase(run_phase phase);
        super.run_phase(phase);
        `uvm_info("TST: [%0t] Test Class, Run Phase", $time)

    endtask //
endclass //ddr5_test extends uvm_test

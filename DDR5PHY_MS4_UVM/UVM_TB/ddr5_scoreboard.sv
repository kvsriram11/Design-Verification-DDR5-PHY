class ddr5_scoreboard extends uvm_scoreboard;

    //--- Factory Registration
    `uvm_component_utils(ddr5_scoreboard)

    //--- Define Analysis TLM interface Port
    uvm_analysis_imp #(ddr5_packet, ddr5_scoreboard) scoreboard_port;

    //Queue for the sequential items from sequencer to scoreboard
    ddr5_packet transactions[$];

    function new(string name = "ddr5_scoreboard", parent);
        super.new(name, parent);
        `uvm_info("SCB: [%0t] Monitor Class Started", $time)
        
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SCB: [%0t] Build Phase!", $time)
        scoreboard_port = new("scoreboard_port", this);
    endfunction

    function connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("SCB: [%0t] Connect Phase!", $time)
    endfunction

    function void write(ddr5_packet item);
        transactions.push_back(item);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("SCB: [%0t] Run Phase!", $time)
    endtask //
    
endclass //ddr5_scoreboard extends uvm_scoreboard

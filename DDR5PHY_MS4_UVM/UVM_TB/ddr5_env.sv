/*
-------------------------------------------------------------------------------
File        : ddr5_environment.sv
Class       : ddr5_environment
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Naga Vinayaka Sunnyhith

Description :
    Top-level environment integrating agent and scoreboard.

Responsibilities:
    - Instantiate DDR5 agent
    - Instantiate scoreboard
    - Connect monitor to scoreboard

-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"
class ddr5_environment extends uvm_env;

    //--- UVM Factory Registration
    `uvm_component_utils(ddr5_environment)

    //--- Sub-component handles
    ddr5_agent      agt;
    ddr5_scoreboard scb;

    //--- Standard UVM Constructor
    function new(string name = "ddr5_environment", uvm_component parent);
        super.new(name, parent);
    endfunction

    //--- Build Phase: construct agent and scoreboard
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ENV", "Build Phase", UVM_LOW)

        agt = ddr5_agent::type_id::create("agt", this);
        scb = ddr5_scoreboard::type_id::create("scb", this);
    endfunction

    //--- Connect Phase: wire monitor analysis port -> scoreboard analysis import
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("ENV", "Connect Phase", UVM_LOW)

        agt.mon.monitor_port.connect(scb.scoreboard_port);
    endfunction

endclass //ddr5_environment extends uvm_env

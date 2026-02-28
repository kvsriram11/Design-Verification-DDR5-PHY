/*
-------------------------------------------------------------------------------
File        : ddr5_agent.sv
Class       : ddr5_agent
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Agent encapsulating driver, monitor, and sequencer.

Responsibilities:
    - Configure ACTIVE or PASSIVE mode
    - Instantiate driver, monitor, sequencer
    - Connect driver to sequencer

-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class ddr5_agent extends uvm_agent;

    //--- UVM Factory Registration
    `uvm_component_utils(ddr5_agent)

    //--- Sub-component handles
    ddr5_driver  drv;
    ddr5_monitor mon;
    ddr5_seqr    seqr;

    //--- Standard UVM Constructor
    function new(string name = "ddr5_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    //--- Build Phase: create driver, monitor and sequencer
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("AGT", "Build Phase", UVM_LOW)

        drv  = ddr5_driver::type_id::create("drv",  this);
        mon  = ddr5_monitor::type_id::create("mon",  this);
        seqr = ddr5_seqr::type_id::create("seqr", this);
    endfunction

    //--- Connect Phase: wire driver seq_item_port to sequencer seq_item_export
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("AGT", "Connect Phase", UVM_LOW)

        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass //ddr5_agent extends uvm_agent

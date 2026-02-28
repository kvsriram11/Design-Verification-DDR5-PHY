/*
-------------------------------------------------------------------------------
File        : ddr5_test.sv
Class       : ddr5_test
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Naga Vinayaka Sunnyhith, Venkata Sriram Kamarajugadda

Description :
    Top-level test that configures the environment and
    initiates the DDR5 packet sequence.

Responsibilities:
    - Build verification environment
    - Start randomized DDR5 packet sequence
    - Manage UVM phase objections
    - Terminate simulation cleanly

-------------------------------------------------------------------------------
*/
import uvm_pkg::*;
`include "uvm_macros.svh"

class ddr5_test extends uvm_test;

    `uvm_component_utils(ddr5_test)

    // Environment handle
    ddr5_environment env;

    // Constructor
    function new(string name = "ddr5_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    // -------------------------
    // Build Phase
    // -------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("TST", "Build Phase", UVM_LOW)

        env = ddr5_environment::type_id::create("env", this);

        if (env == null)
            `uvm_fatal("TST", "Environment creation failed")
    endfunction

    // -------------------------
    // End of Elaboration
    // -------------------------
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);

        `uvm_info("TST", "Printing UVM Topology", UVM_LOW)
        uvm_top.print_topology();
    endfunction

    // -------------------------
    // Run Phase
    // -------------------------
    task run_phase(uvm_phase phase);

        ddr5_packet_seq #(4,2) seq;

        `uvm_info("TST", "Run Phase - Raising Objection", UVM_LOW)
        phase.raise_objection(this);

        // Create sequence via factory
        seq = ddr5_packet_seq #(4,2)::type_id::create("seq");

        if (seq == null)
            `uvm_fatal("TST", "Sequence creation failed")

        `uvm_info("TST", "Starting DDR5 sequence", UVM_LOW)

        seq.start(env.agt.seqr);

        `uvm_info("TST", "Sequence completed", UVM_LOW)

        phase.drop_objection(this);
        `uvm_info("TST", "Run Phase - Dropped Objection", UVM_LOW)

        // ----------------------------------------
        // CRITICAL: Request clean simulation stop
        // ----------------------------------------
        uvm_top.stop_request();

    endtask

    // -------------------------
    // Final Phase (optional but clean)
    // -------------------------
    function void final_phase(uvm_phase phase);
        `uvm_info("TST", "Simulation Finished Cleanly", UVM_LOW)
    endfunction

endclass : ddr5_test
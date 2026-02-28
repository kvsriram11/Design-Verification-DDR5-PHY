/*
-------------------------------------------------------------------------------
File        : ddr5_sequencer.sv
Class       : ddr5_sequencer
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Naga Vinayaka Sunnyhith

Description :
    Sequencer coordinating transaction flow between
    sequence and driver.

Responsibilities:
    - Provide arbitration for sequences
    - Handle sequence item pull interface

-------------------------------------------------------------------------------
*/
import uvm_pkg::*;
`include "uvm_macros.svh"

class ddr5_seqr extends uvm_sequencer #(ddr5_packet);

    // UVM Factory Registration
    `uvm_component_utils(ddr5_seqr)

    // Constructor
    function new(string name = "ddr5_seqr", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase (optional but good practice for logging)
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SQR", "Build Phase", UVM_LOW)
    endfunction

    // End of elaboration (helps show hierarchy in logs cleanly)
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("SQR", "Sequencer Created and Ready", UVM_LOW)
    endfunction

endclass : ddr5_seqr
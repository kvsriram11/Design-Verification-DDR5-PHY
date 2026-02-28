/*
-------------------------------------------------------------------------------
File        : ddr5_packet_seq.sv
Class       : ddr5_packet_seq #(pDRAM_SIZE, pNUM_RANK)
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Amogh Thakur

Description :
    UVM sequence responsible for generating randomized DDR5 packets
    and sending them to the driver through the sequencer.

Responsibilities:
    - Generate randomized DDR5 transactions
    - Apply constrained-random stress scenarios
    - Initiate driver handshake using start_item/finish_item

-------------------------------------------------------------------------------
*/
import uvm_pkg::*;
`include "uvm_macros.svh"

class ddr5_packet_seq #(parameter pDRAM_SIZE = 4,
                        parameter pNUM_RANK  = 2)
  extends uvm_sequence #(ddr5_packet #(pDRAM_SIZE, pNUM_RANK));

    `uvm_object_param_utils(ddr5_packet_seq #(pDRAM_SIZE, pNUM_RANK))

    ddr5_packet #(pDRAM_SIZE, pNUM_RANK) req;

    function new(string name = "ddr5_packet_seq");
        super.new(name);
    endfunction

    virtual task body();

        `uvm_info("SEQ", "Starting DDR5 Sequence", UVM_LOW)

        repeat (50) begin

            req = ddr5_packet #(pDRAM_SIZE, pNUM_RANK)::type_id::create("req");

            if (req == null)
                `uvm_fatal("SEQ", "Failed to create packet via factory")

            start_item(req);

            if (!req.randomize()) begin
                `uvm_error("SEQ", "Packet randomization failed")
            end
            else begin
                `uvm_info("SEQ",
                          $sformatf("Generated Packet | Mode=%s | Ratio=%0b",
                                    req.testMode.name(),
                                    req.current_ratio),
                          UVM_HIGH)
            end

            finish_item(req);
        end

        `uvm_info("SEQ", "DDR5 Sequence Ended", UVM_LOW)

    endtask

endclass

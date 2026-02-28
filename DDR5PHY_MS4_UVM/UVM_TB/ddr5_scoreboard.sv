/*
-------------------------------------------------------------------------------
File        : ddr5_scoreboard.sv
Class       : ddr5_scoreboard
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Scoreboard component that checks protocol correctness and
    validates DUT output behavior.

Responsibilities:
    - Perform protocol compliance checks
    - Detect X/Z data violations
    - Verify DQ/DQS handshake consistency
    - Report PASS/FAIL summary

-------------------------------------------------------------------------------
*/
import uvm_pkg::*;
`include "uvm_macros.svh"
class ddr5_scoreboard extends uvm_scoreboard;

    //--- Factory Registration
    `uvm_component_utils(ddr5_scoreboard)

    //--- Define Analysis TLM interface Port
    uvm_analysis_imp #(ddr5_packet, ddr5_scoreboard) scoreboard_port;

    // Queue of transactions sampled by monitor
    ddr5_packet transactions[$];

    int unsigned txn_count;
    int unsigned err_count;

    function new(string name = "ddr5_scoreboard", uvm_component parent);
        super.new(name, parent);
        `uvm_info("SCB", $sformatf("[%0t] Scoreboard constructed", $time), UVM_LOW)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("SCB", "Build Phase", UVM_LOW)
        scoreboard_port = new("scoreboard_port", this);
    endfunction

    function void write(ddr5_packet item);
        transactions.push_back(item);
        txn_count++;

        // Protocol sanity check: write enable must be low when CS_n is idle for that phase.
        foreach (item.dfi_cs_n_pN[i]) begin
            if ((item.dfi_cs_n_pN[i] != '0) && (item.dfi_wrdata_en_pN[i] == 1'b1)) begin
                err_count++;
                `uvm_error("SCB", $sformatf("Protocol violation @txn %0d phase %0d: CS_n=%0h with wr_en=1",
                           txn_count, i, item.dfi_cs_n_pN[i]))
            end
        end

        // Output sanity check: DQ bus should not carry X/Z when dq_valid is asserted.
        if (item.obs_dq_valid && (^item.obs_dq === 1'bx)) begin
            err_count++;
            `uvm_error("SCB", $sformatf("Invalid DQ state @txn %0d: DQ has X/Z while DQ_valid=1", txn_count))
        end

        // Output handshake sanity check.
        if (item.obs_dq_valid !== item.obs_dqs_valid) begin
            err_count++;
            `uvm_error("SCB", $sformatf("DQ/DQS valid mismatch @txn %0d: dq_valid=%0b dqs_valid=%0b",
                       txn_count, item.obs_dq_valid, item.obs_dqs_valid))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        if (err_count == 0)
            `uvm_info("SCB", $sformatf("PASS: %0d transactions checked, 0 errors", txn_count), UVM_LOW)
        else
            `uvm_error("SCB", $sformatf("FAIL: %0d transactions checked, %0d errors", txn_count, err_count))
    endfunction

endclass


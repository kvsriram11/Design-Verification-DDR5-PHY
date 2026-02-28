/*
-------------------------------------------------------------------------------
File        : ddr5_test_top.sv
Module      : top
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Amogh Thakur

Description :
    Top-level testbench module that instantiates the DUT,
    interface, clock/reset generation, and starts the UVM test.

Responsibilities:
    - Instantiate DDR5 PHY DUT
    - Instantiate DDR5 interface
    - Generate clock and reset
    - Call run_test() to start UVM simulation

-------------------------------------------------------------------------------
*/
`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

//--- Include all UVM testbench files in dependency order
`include "ddr5_if.sv"
`include "ddr5_packet.sv"
`include "ddr5_packet_seq.sv"
`include "ddr5_sequencer.sv"
`include "ddr5_driver.sv"
`include "ddr5_monitor.sv"
`include "ddr5_agent.sv"
`include "ddr5_scoreboard.sv"
`include "ddr5_env.sv"
`include "ddr5_test.sv"

module top;

    //--- Clock declaration
    logic clk_i;

    //--- Clock generation: 10ns period (100 MHz)
    initial clk_i = 0;
    always #5 clk_i = ~clk_i;

    //--- Interface instantiation
    ddr5_if intf(clk_i);

    //--- DUT instantiation with explicit port connections to interface
    ddr5_phy_top dut (
        .clk_i            (intf.clk_i),
        .rst_i            (intf.rst_i),
        .enable_i         (intf.enable_i),
        // Chip select — 4 phases
        .dfi_cs_n_p0      (intf.dfi_cs_n_p0),
        .dfi_cs_n_p1      (intf.dfi_cs_n_p1),
        .dfi_cs_n_p2      (intf.dfi_cs_n_p2),
        .dfi_cs_n_p3      (intf.dfi_cs_n_p3),
        // DDR reset — 4 phases
        .dfi_reset_n_p0   (intf.dfi_reset_n_p0),
        .dfi_reset_n_p1   (intf.dfi_reset_n_p1),
        .dfi_reset_n_p2   (intf.dfi_reset_n_p2),
        .dfi_reset_n_p3   (intf.dfi_reset_n_p3),
        // Address — 4 phases
        .dfi_address_p0   (intf.dfi_address_p0),
        .dfi_address_p1   (intf.dfi_address_p1),
        .dfi_address_p2   (intf.dfi_address_p2),
        .dfi_address_p3   (intf.dfi_address_p3),
        // Write enable — 4 phases
        .dfi_wrdata_en_p0 (intf.dfi_wrdata_en_p0),
        .dfi_wrdata_en_p1 (intf.dfi_wrdata_en_p1),
        .dfi_wrdata_en_p2 (intf.dfi_wrdata_en_p2),
        .dfi_wrdata_en_p3 (intf.dfi_wrdata_en_p3),
        // Write data — 4 phases
        .dfi_wrdata_p0    (intf.dfi_wrdata_p0),
        .dfi_wrdata_p1    (intf.dfi_wrdata_p1),
        .dfi_wrdata_p2    (intf.dfi_wrdata_p2),
        .dfi_wrdata_p3    (intf.dfi_wrdata_p3),
        // Write mask — 4 phases
        .dfi_wrdata_mask_p0 (intf.dfi_wrdata_mask_p0),
        .dfi_wrdata_mask_p1 (intf.dfi_wrdata_mask_p1),
        .dfi_wrdata_mask_p2 (intf.dfi_wrdata_mask_p2),
        .dfi_wrdata_mask_p3 (intf.dfi_wrdata_mask_p3),
        // DRAM outputs
        .RESET_n          (intf.RESET_n),
        .CS_n             (intf.CS_n),
        .CA               (intf.CA),
        .DQ               (intf.DQ),
        .DQ_valid         (intf.DQ_valid),
        .DM               (intf.DM),
        .DQS              (intf.DQS),
        .DQS_valid        (intf.DQS_valid)
    );

    //--- Pass interface handle to all UVM components via config_db
    initial begin
        uvm_config_db #(virtual ddr5_if)::set(null, "*", "vif", intf);
    end

    //--- Start the UVM test
    initial begin
        run_test("ddr5_test");
    end

endmodule


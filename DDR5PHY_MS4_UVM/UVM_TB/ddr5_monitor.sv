/*
-------------------------------------------------------------------------------
File        : ddr5_monitor.sv
Class       : ddr5_monitor
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Naga Vinayaka Sunnyhith

Description :
    Passive monitor that samples DUT interface signals
    and converts them into transaction-level objects.

Responsibilities:
    - Observe DFI command/address/data signals
    - Capture DUT output responses
    - Publish transactions to scoreboard

-------------------------------------------------------------------------------
*/
import uvm_pkg::*;
`include "uvm_macros.svh"

class ddr5_monitor extends uvm_monitor;

    //--- UVM Factory Registration
    `uvm_component_utils(ddr5_monitor)

    //--- Virtual interface and packet handles
    virtual ddr5_if vif;
    ddr5_packet     item;

    //--- TLM Analysis Port: broadcasts sampled transactions to scoreboard
    uvm_analysis_port #(ddr5_packet) monitor_port;

    //--- Standard UVM Constructor
    function new(string name = "ddr5_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    //--- Build Phase: create analysis port and grab virtual interface
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MON", "Build Phase", UVM_LOW)

        monitor_port = new("monitor_port", this);

        if (!uvm_config_db #(virtual ddr5_if)::get(this, "*", "vif", vif))
            `uvm_fatal("MON", "Failed to get virtual interface from config_db")
    endfunction

    //--- Run Phase: passively sample the DFI interface every clock cycle
    //--- Skips sampling while reset is active
    //--- Broadcasts each captured transaction via monitor_port
    task run_phase(uvm_phase phase);
        `uvm_info("MON", "Run Phase Started", UVM_LOW)

        forever begin
            @(posedge vif.clk_i);

            //--- Do not capture during reset
            if (vif.rst_i) continue;

            item = ddr5_packet#()::type_id::create("item");

            //--- Capture all 4 DFI input phases
            // CS_n
            item.dfi_cs_n_pN[0]         = vif.dfi_cs_n_p0;
            item.dfi_cs_n_pN[1]         = vif.dfi_cs_n_p1;
            item.dfi_cs_n_pN[2]         = vif.dfi_cs_n_p2;
            item.dfi_cs_n_pN[3]         = vif.dfi_cs_n_p3;

            // Address
            item.dfi_address_pN[0]      = vif.dfi_address_p0;
            item.dfi_address_pN[1]      = vif.dfi_address_p1;
            item.dfi_address_pN[2]      = vif.dfi_address_p2;
            item.dfi_address_pN[3]      = vif.dfi_address_p3;

            // Write data
            item.dfi_wrdata_pN[0]       = vif.dfi_wrdata_p0;
            item.dfi_wrdata_pN[1]       = vif.dfi_wrdata_p1;
            item.dfi_wrdata_pN[2]       = vif.dfi_wrdata_p2;
            item.dfi_wrdata_pN[3]       = vif.dfi_wrdata_p3;

            // Write mask
            item.dfi_wrdata_mask_pN[0]  = vif.dfi_wrdata_mask_p0;
            item.dfi_wrdata_mask_pN[1]  = vif.dfi_wrdata_mask_p1;
            item.dfi_wrdata_mask_pN[2]  = vif.dfi_wrdata_mask_p2;
            item.dfi_wrdata_mask_pN[3]  = vif.dfi_wrdata_mask_p3;

            // Write enable
            item.dfi_wrdata_en_pN[0]    = vif.dfi_wrdata_en_p0;
            item.dfi_wrdata_en_pN[1]    = vif.dfi_wrdata_en_p1;
            item.dfi_wrdata_en_pN[2]    = vif.dfi_wrdata_en_p2;
            item.dfi_wrdata_en_pN[3]    = vif.dfi_wrdata_en_p3;            
            // Observed DUT outputs
            item.obs_reset_n            = vif.RESET_n;
            item.obs_cs_n               = vif.CS_n;
            item.obs_ca                 = vif.CA;
            item.obs_dq                 = vif.DQ;
            item.obs_dm                 = vif.DM;
            item.obs_dqs                = vif.DQS;
            item.obs_dq_valid           = vif.DQ_valid;
            item.obs_dqs_valid          = vif.DQS_valid;

            // Frequency ratio is fixed in RTL by top parameter pFREQ_RATIO = 2'b00
            item.current_ratio          = 2'b00;

            `uvm_info("MON", $sformatf("[%0t] Transaction sampled | ratio: %0b | wr_en: p0=%0b p1=%0b p2=%0b p3=%0b",
                        $time,
                        item.current_ratio,
                        item.dfi_wrdata_en_pN[0], item.dfi_wrdata_en_pN[1],
                        item.dfi_wrdata_en_pN[2], item.dfi_wrdata_en_pN[3]), UVM_HIGH)

            //--- Broadcast to scoreboard
            monitor_port.write(item);
        end
    endtask

endclass //ddr5_monitor extends uvm_monitor






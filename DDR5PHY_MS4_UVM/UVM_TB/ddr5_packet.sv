/*
-------------------------------------------------------------------------------
File        : ddr5_packet.sv
Class       : ddr5_packet #(pDRAM_SIZE, pNUM_RANK)
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Amogh Thakur

Description :
    Sequence item representing a DDR5 DFI transaction.
    Encapsulates command, address, data, and control information.

Responsibilities:
    - Randomize DDR5 phase-based write transactions
    - Apply constrained stress scenarios (Integrity, Collision, B2B)
    - Provide logging via post_randomize()

-------------------------------------------------------------------------------
*/
import uvm_pkg::*;
`include "uvm_macros.svh"

class ddr5_packet #(parameter pDRAM_SIZE = 4,
                    parameter pNUM_RANK = 2) extends uvm_sequence_item;

    //--- UVM Factory Registration (Objects because they are transient or dynamic in nature)
    //--- Using the param utils as we are using the parameters for the pDRAM_size and pNUM_RANK
    `uvm_object_param_utils(ddr5_packet #(pDRAM_SIZE, pNUM_RANK))

    // ---Initialize the input signals as random 
    rand bit [pNUM_RANK-1:0] dfi_cs_n_pN[4];
    rand bit [13:0] dfi_address_pN[4];
    rand bit [(pDRAM_SIZE/4)-1:0] dfi_wrdata_mask_pN[4];
    rand bit [2*pDRAM_SIZE-1:0] dfi_wrdata_pN[4];
    rand bit dfi_wrdata_en_pN[4];
    rand bit [1:0] current_ratio;

    bit [pNUM_RANK-1:0] dfi_cs_n;
    
    //--- Observed DUT outputs sampled by monitor
    bit [pNUM_RANK-1:0] obs_reset_n;
    bit [pNUM_RANK-1:0] obs_cs_n;
    bit [13:0] obs_ca;
    bit [2*pDRAM_SIZE-1:0] obs_dq;
    bit [(pDRAM_SIZE/4)-1:0] obs_dm;
    bit [1:0] obs_dqs;
    bit obs_dq_valid;
    bit obs_dqs_valid;

    //--- Control Knobs
    typedef enum {DATA_INTEGRITY, SAME_RANK_COLLISION, B2B_PHASE_HIT} testModeState;
    rand testModeState testMode;

    task print_start ();
        `uvm_info("PKT", "Packet Sequence Item Started", UVM_LOW)
    endtask //

    //--- This prints the unique data for each phase to the log
    function void post_randomize();
        `uvm_info("PKT", $sformatf("Packet Generated | Mode: %s | Ratio: %0b", 
                  testMode.name(), current_ratio), UVM_LOW)
        foreach(dfi_address_pN[i]) begin
            `uvm_info("PKT", $sformatf("Phase[%0d]: Addr=0x%h, Data=0x%h, CS_n=0x%h", 
                      i, dfi_address_pN[i], dfi_wrdata_pN[i], dfi_cs_n_pN[i]), UVM_HIGH)
        end
    endfunction

    constraint stress_weights {
        testMode dist {
            DATA_INTEGRITY      := 20,
            SAME_RANK_COLLISION := 50,
            B2B_PHASE_HIT       := 30
        };
        current_ratio == 2'b10;             //--- Force 1:4 ratio for maximum bandwidth stress
    }

    //--- Check the data integrity 
    //--- Forces a walking-1 so that the scoreboard can detect MUX phase-swap
    constraint c_integrity {
        if (testMode == DATA_INTEGRITY) {
            foreach (dfi_wrdata_pN[i]) {
                dfi_wrdata_pN[i] == (1 << i); 
                dfi_wrdata_mask_pN[i] == 0;
            }
        }
    }

    //--- Same Rank Collision
    //--- Forces multiple phases to target the exact same chip select
    constraint c_collision {
        if (testMode == SAME_RANK_COLLISION) {
            foreach (dfi_cs_n_pN[i]) {
                dfi_cs_n_pN[i] == 0;      // Force Rank 0 Active in all phases
                dfi_wrdata_en_pN[i] == 1;   // Force writes active
            }
            unique {dfi_address_pN};        //Unique Address to check MUX switching speed
        }
    }

    //--- Back to Back Read/Write(Sequential Phase Hit)
    //--- Forces the MUX transition from Phase N to Phase N+1 with no idle time
    constraint c_b2b_logic {
        if (testMode == B2B_PHASE_HIT) {
            foreach(dfi_wrdata_en_pN[i]) {
                dfi_wrdata_en_pN[i] == 1;       // Pipe is 100% full
                dfi_cs_n_pN[i] == 0;

                //--- Check address unique to next phase to prevent "Ping-pong effect"
                if (i < 3) {
                    dfi_address_pN[i] != dfi_address_pN[i+1];
                }
            }
        }
    }

    constraint s_protocol {
        foreach (dfi_cs_n_pN[i]) {
            (dfi_cs_n_pN[i] != 0) -> (dfi_wrdata_en_pN[i] == 0);    // Disable write if CS is idle 
        }
    }

    task print_end ();
        `uvm_info("PKT", "Packet Sequence Item Ended", UVM_LOW)
    endtask //

    function new(string name = "ddr5_packet");
        super.new(name);
    endfunction: new
//new()
endclass //ddr5_packet extends superClass



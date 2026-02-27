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
    bit [13:0] dfi_address;

    //--- Control Knobs
    typedef enum {DATA_INTEGRITY, SAME_RANK_COLLISION, B2B_PHASE_HIT} testModeState;
    rand testModeState testMode;

    constraint stress_weights {
        testMode dist{
            DATA_INTEGRITY:= 20,
            SAME_RANK_COLLISION:= 50,
            B2B_PHASE_HIT:= 30
        };
        current_ratio == 2'b10;             //--- Force 1:4 ratio for maximum bandwidth stress
    }

    //--- Check the data integrity 
    //--- Forces a walking-1 so that the scoreboard can detect MUX phase-swap
    constraint c_integrity{
        if (testMode == DATA_INTEGRITY) {
            foreach (dfi_wrdata_pN[i]) {
                dfi_wrdata_pN[i] == (1 << i); 
                dfi_wrdata_mask_pN[i] == 0;
            }
        }
    }

    //--- Same Rank Collision
    //--- Forces multiple phases to target the exact same chip select
    constraint c_collision{
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

            //--- Check address unique to next phase to prevent "Ping-pon effect"
            if (i<3) {
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

    function new(string name = "ddr5_packet");
        super.new(name);
        `uvm_info("PKT: [%0t] Packet Class Started", $time)

        `uvm_info("PKT: [%0t] Packet Class Ended", $time)
    endfunction: new
 //new()
endclass //ddr5_packet extends superClass

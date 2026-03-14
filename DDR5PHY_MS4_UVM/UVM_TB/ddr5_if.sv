/*
-------------------------------------------------------------------------------
File        : ddr5_if.sv
Interface   : ddr5_if
Project     : DDR5 PHY Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Amogh Thakur

Description :
    SystemVerilog interface encapsulating DDR5 DFI signals
    between the DUT and UVM verification components.

Responsibilities:
    - Define DFI command, address, and data signals
    - Provide clock and reset connections
    - Serve as communication bridge between DUT and driver/monitor
    - Support virtual interface binding inside UVM environment

-------------------------------------------------------------------------------
*/
interface ddr5_if #(parameter pDRAM_SIZE = 4,                //Size(Width) of DRAM data bus 
                    parameter pNUM_RANK = 2)                 //Number of DRAM Ranks 
                    (input logic clk_i);

    // Reset and Enable
    logic rst_i;
    logic enable_i;

    //  ---Input Signals to the PHY block ---
    logic [pNUM_RANK-1:0] dfi_cs_n_p0, dfi_cs_n_p1, dfi_cs_n_p2, dfi_cs_n_p3;                                    //Chip-Select per Rank for each phases - Selects which rank received command
    logic [pNUM_RANK-1:0] dfi_reset_n_p0, dfi_reset_n_p1, dfi_reset_n_p2, dfi_reset_n_p3;                        //Active low Reset to DRAM ranks
    logic [13:0] dfi_address_p0, dfi_address_p1, dfi_address_p2, dfi_address_p3;                                 //Represents the row /column/ command address bit -  Carries DDR5 command/ address bits
    logic [pDRAM_SIZE/4-1:0] dfi_wrdata_mask_p0, dfi_wrdata_mask_p1, dfi_wrdata_mask_p2, dfi_wrdata_mask_p3;     //Denotes which bits are valid during write - Controls byte masking during writes 
    logic [2*pDRAM_SIZE-1:0] dfi_wrdata_p0, dfi_wrdata_p1, dfi_wrdata_p2, dfi_wrdata_p3;                         //Write data for each phase from controller
    logic dfi_wrdata_en_p0, dfi_wrdata_en_p1, dfi_wrdata_en_p2, dfi_wrdata_en_p3;                                //Write Enable for each phase - To indicate the phase contains valid data

    // ---PHY Internal Signals ---
    //From Register File
    logic [1:0] dfi_freq_ratio;                                                                                  //Controls the PHY frequency Ratio configuration 
    logic phy_CRC_mode;                                                                                          //Enables PHY-generated CRC for DDR5 write data.

    //Output from Frequency Ratio
    logic [pNUM_RANK-1:0] dfi_cs_n;                                                                              //Selected Chip
    logic [13:0] dfi_address;                                                                                    //Command/Address for current PHY Cycle
    logic [pDRAM_SIZE/4-1:0] dfi_wrdata_mask;                                                                    //Masking Bits
    logic dfi_wrdata_en;                                                                                         //Write Enable 
    logic [2*pDRAM_SIZE-1:0] dfi_wrdata;                                                                         //Write data after phase seletion

    //Output from Command Address
    logic [1:0] burst_length;                                                                                     //DDR5 burst size (BL16 or BL32)
    logic [7:0] preamble_pattern;                                                                                 //Pattern used for DQS preamble before data burst.
    logic [2:0] num_preamble_cycle;                                                                               //Number of cycles before write data where DQS toggles.
    logic [1:0] num_postable_cycle;                                                                               //Cycles after the burst.
    logic DRAM_CRC_en;                                                                                            //Enable CRC generation for the DRAM device.

    //Output from Write Data
    logic crc_en;                                                                                                 //Enable CRC computation.
    logic [2*pDRAM_SIZE-1:0] crc_in_data;                                                                         //Data that will be fed into the CRC generator.

    //Output from CRC
    logic [2*pDRAM_SIZE-1:0] crc_code;                                                                            //DDR5 uses CRC to detect data corruption.

    // ---Output Signals from the PHY ---
    logic [pNUM_RANK-1:0] CS_n;                                                                                    //Rank select line to DRAM. (Active Low)
    logic [13:0] CA;                                                                                               //Command Address carrying commands and addresses
    logic [(pDRAM_SIZE/4)-1:0] DM ;                                                                                //Data Mask-Same as controller mask but aligned to DRAM timing.
    logic [pNUM_RANK-1:0] RESET_n;                                                                                 //Reset line to DRAM device.
    logic [2*pDRAM_SIZE-1:0] DQ;                                                                                   //Actual write data sent to DRAM.
    logic DQ_valid;                                                                                                //Indicates that DQ contains valid write data.
    logic [1:0] DQS;                                                                                               //Used by DRAM to capture DQ data.
    logic DQS_valid;                                                                                               //Indicates when the strobe should toggle.


// ---FrequencyRatio Modport
modport frequencyRatio (
input clk_i, rst_i, enable_i, dfi_freq_ratio,                                                                    
input dfi_cs_n_p0, dfi_cs_n_p1, dfi_cs_n_p2, dfi_cs_n_p3,
input dfi_address_p0, dfi_address_p1, dfi_address_p2, dfi_address_p3,
input dfi_wrdata_p0, dfi_wrdata_p1, dfi_wrdata_p2, dfi_wrdata_p3,
input dfi_wrdata_en_p0, dfi_wrdata_en_p1, dfi_wrdata_en_p2, dfi_wrdata_en_p3,
output dfi_cs_n, dfi_address, dfi_wrdata_mask, dfi_wrdata_en, dfi_wrdata
);
  

// ---WriteData
modport WriteData (
input clk_i, rst_i, enable_i, dfi_freq_ratio,
input burst_length, preamble_pattern, num_preamble_cycle, num_postable_cycle, DRAM_CRC_en, phy_CRC_mode, dfi_wrdata_mask, dfi_wrdata_en, dfi_wrdata, crc_code,
output DQ, DQ_valid, DM, DQS, DQS_valid, crc_en, crc_in_data
);

endinterface

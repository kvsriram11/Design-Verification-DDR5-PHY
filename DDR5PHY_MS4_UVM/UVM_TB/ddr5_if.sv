interface ddr5_if #(parameter pDRAM_SIZE = 4,
                    parameter pNUM_RANK = 2)
                    (input logic clk_i);

    // Reset and Enable
    logic rst_i;
    logic enable_i;

    //  ---Input Signals to the PHY block ---
    logic [pNUM_RANK:0] dfi_cs_n_p0, dfi_cs_n_p1, dfi_cs_n_p2, dfi_cs_n_p3;
    logic [pNUM_RANK:0] dfi_reset_n_p0, dfi_reset_n_p1, dfi_reset_n_p2, dfi_reset_n_p3;
    logic [13:0] dfi_address_p0, dfi_address_p1, dfi_address_p2, dfi_address_p3;
    logic [pDRAM_SIZE/4-1:0] dfi_wrdata_mask_p0, dfi_wrdata_mask_p1, dfi_wrdata_mask_p2, dfi_wrdata_mask_p3;
    logic [2*pDRAM_SIZE/4-1:0] dfi_wrdata_p0,dfi_wrdata_p1, dfi_wrdata_p2, dfi_wrdata_p3;
    logic dfi_wrdata_en_p0, dfi_wrdata_en_p1, dfi_wrdata_en_p2, dfi_wrdata_en_p3;

    // ---PHY Internal Signals ---
    //From Register File
    logic [1:0] dfi_freq_ratio;
    logic phy_CRC_mode;

    //Output from Frequency Ratio
    logic [pNUM_RANK-1:0] dfi_cs_n;
    logic [13:0] dfi_address;
    logic [pDRAM_SIZE/4-1:0] dfi_wrdata_mask;
    logic dfi_wrdata_en;
    logic [2*pDRAM_SIZE-1:0] dfi_wrdata;

    //Output from Command Address
    logic [1:0] burst_length;
    logic [7:0] preamble_pattern;
    logic [2:0] num_preamble_cycle;
    logic [1:0] num_postable_cycle;
    logic DRAM_CRC_en;

    //Output from Write Data
    logic crc_en;
    logic [2*pDRAM_SIZE-1:0] crc_in_data;

    //Output from CRC
    logic [2*pDRAM_SIZE-1:0] crc_code;

    // ---Output Signals from the PHY ---
    logic [pNUM_RANK-1:0] CS_n;
    logic [13:0] CA;
    logic [(pDRAM_SIZE/4)-1:0] DM ;
    logic [pNUM_RANK-1:0] RESET_n;
    logic [2*pDRAM_SIZE-1:0] DQ;
    logic DQ_valid;
    logic [1:0] DQS;
    logic DQS_valid;


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

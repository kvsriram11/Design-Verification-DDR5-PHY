interface ddr5_if #(
    //  ---Input Signals to the PHY block ---
    logic [n:0] dfi_cs_n_pN;
    logic [n:0] dfi_address_pN;
    logic [n:0] dfi_wrdata_mask_pN;
    logic [n:0] dfi_reset_n_pN;
    logic [n:0] dfi_wrdata_pN;
    logic dfi_wrdata_en_pN;

    // ---PHY Internal Signals ---

    //From Register File
    logic dfi_freq_ratio;
    logic phy_CRC_mode;

    //Output from Frequency Ratio
    logic dfi_cs_n;
    logic dfi_address;
    logic dfi_wrdata_mask;
    logic dfi_wrdata_en;
    logic dfi_wrdata;

    //Output from Command Address
    logic [n:0] burst_length;
    logic [n:0] preamble_pattern;
    logic num_preamble_cycle;
    logic [n:0]num_postable_cycle;
    logic [n:0]DRAM_CRC_en;

    //Output from Write Data
    logic CRC_en;
    logic [n:0] CRC_in_data;

    //Output from CRC
    logic [n:0] CRC_code

    // ---Output Signals from the PHY ---
    logic CS_n;
    logic [13:0] CA;
    logic [n:0] DM ;
    logic RESET_n;
    logic [n:0] DQ;
    logic DQ_valid;
    logic [n:0] DQS;
    logic DQS_valid;
);

// ---RegisterFile Modport
modport registerFile (
output dfi_freq_ratio, phy_CRC_mode
);

// ---FrequencyRatio Modport
modport frequencyRatio (
input dfi_cs_n_pN, dfi_address_pN, dfi_wrdata_mask_pN, dfi_reset_n_pN, dfi_wrdata_pN, dfi_wrdata_en_pN, dfi_freq_ratio,
output dfi_cs_n, dfi_address, dfi_wrdata_mask, dfi_wrdata_en, dfi_wrdata
);

// ---CommandAddress
modport CommandAddress (
input dfi_cs_n, dfi_address,
output burst_length, preamble_pattern, num_preamble_cycle, num_postable_cycle, DRAM_CRC_en
);   

// ---WriteData
modport WriteData (
input burst_length, preamble_pattern, num_preamble_cycle, num_postable_cycle, DRAM_CRC_en, phy_CRC_mode, dfi_wrdata_mask, dfi_wrdata_en, dfi_wrdata,
output DQ, DQ_valid, DM, DQS, DQS_valid, CRC_en, CRC_in_data
);

// ---CRC 
modport CRC (
input CRC_in_data, CRC_en,
output CRC_code
);
endinterface

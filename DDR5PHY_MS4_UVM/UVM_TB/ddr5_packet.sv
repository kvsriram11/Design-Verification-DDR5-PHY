class ddr5_packet extends uvm_sequence_item;

    //--- UVM Factory Registration (Objects because they are transient or dynamic in nature)
    `uvm_object_utils(ddr5_packet)

    // ---Initialize the input signals as random 
    rand bit [pNUM_RANK-1:0] dfi_cs_n_pN[4];
    rand bit [13:0] dfi_address_pN[4];
    rand bit [(pDRAM_SIZE/4)-1:0] dfi_wrdata_mask_pN[4];
    rand bit [2*pDRAM_SIZE-1:0] dfi_wrdata_pN[4];
    rand bit dfi_wrdata_en_pN[4];

    bit [pNUM_RANK-1:0] dfi_cs_n;
    bit [13:0] dfi_address;

    // ---Constraints for directed test-cases
     constraint valid_write_en {
        foreach (dfi_wrdata_en_pN[i]) {
            // Keep wr_en low if chip select is inactive (1)
            (dfi_cs_n_pN[i] == '1) -> (dfi_wrdata_en_pN[i] == 0);
        }
    }

    function new(string name = "ddr5_packet");
        super.new(name);
        `uvm_info("PKT: [%0t] Packet Class Started", $time)

        `uvm_info("PKT: [%0t] Packet Class Ended", $time)
    endfunction: new //new()
endclass //ddr5_packet extends superClass

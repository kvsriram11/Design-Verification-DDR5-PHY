class transaction #(parameter int n = 7;);
    rand bit [pNUM:_RANK-1:0] dfi_cs_n_pN[4];
    rand bit [13:0] dfi_address_pN[4];
    rand bit [mask_w:0] dfi_wrdata_mask_pN[4];
    rand bit [n:0] dfi_wrdata_pN[4];
    rand bit dfi_wrdata_en_pN[4];

    bit [pNUM_RANK-1:0] dfi_cs_n;
    bit [13:0] dfi_address;

    function void printTrx();
        $display("Addr: %h | Data: %h | En: %b", dfi_address_[0], dfi_wrdata[0], dfi_wrdata_en_p[0]);
    endfunction
endclass //transaction

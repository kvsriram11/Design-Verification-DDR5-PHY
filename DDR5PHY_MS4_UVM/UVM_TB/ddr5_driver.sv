class ddr5_driver extends uvm_driver #(ddr5_packet);

    //--- UVM Factory Registration
    `uvm_component_utils(ddr5_driver)

    //--- Virtual interface handle
    virtual ddr5_if vif;

    //--- Standard UVM Constructor
    function new(string name = "ddr5_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    //--- Build Phase: grab the virtual interface from config_db
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("DRV", "Build Phase", UVM_LOW)

        if (!uvm_config_db #(virtual ddr5_if)::get(this, "*", "vif", vif))
            `uvm_fatal("DRV", "Failed to get virtual interface from config_db")
    endfunction

    //--- Run Phase: apply reset, then drive items from sequencer forever
    task run_phase(uvm_phase phase);
        ddr5_packet item;
        `uvm_info("DRV", "Run Phase Started", UVM_LOW)

        // --- Apply reset and hold safe defaults
        vif.rst_i             <= 1;
        vif.enable_i          <= 0;
        vif.dfi_cs_n_p0       <= '1;   // CS deasserted (active low)
        vif.dfi_cs_n_p1       <= '1;
        vif.dfi_cs_n_p2       <= '1;
        vif.dfi_cs_n_p3       <= '1;
        vif.dfi_reset_n_p0    <= 1;    // DDR reset deasserted (active low)
        vif.dfi_reset_n_p1    <= 1;
        vif.dfi_reset_n_p2    <= 1;
        vif.dfi_reset_n_p3    <= 1;
        vif.dfi_address_p0    <= '0;
        vif.dfi_address_p1    <= '0;
        vif.dfi_address_p2    <= '0;
        vif.dfi_address_p3    <= '0;
        vif.dfi_wrdata_p0     <= '0;
        vif.dfi_wrdata_p1     <= '0;
        vif.dfi_wrdata_p2     <= '0;
        vif.dfi_wrdata_p3     <= '0;
        vif.dfi_wrdata_mask_p0 <= '0;
        vif.dfi_wrdata_mask_p1 <= '0;
        vif.dfi_wrdata_mask_p2 <= '0;
        vif.dfi_wrdata_mask_p3 <= '0;
        vif.dfi_wrdata_en_p0  <= 0;
        vif.dfi_wrdata_en_p1  <= 0;
        vif.dfi_wrdata_en_p2  <= 0;
        vif.dfi_wrdata_en_p3  <= 0;

        // Hold reset for 2 clock cycles
        repeat(2) @(posedge vif.clk_i);

        // --- Release reset
        vif.rst_i    <= 0;
        vif.enable_i <= 1;
        @(posedge vif.clk_i);

        // --- Main driver loop
        forever begin
            seq_item_port.get_next_item(item);
            `uvm_info("DRV", $sformatf("[%0t] Driving item | testMode: %s | ratio: %0b",
                        $time, item.testMode.name(), item.current_ratio), UVM_LOW)
            drive_item(item);
            seq_item_port.item_done();
        end
    endtask

    //--- drive_item: apply one transaction to the DFI interface on the next posedge
    task drive_item(ddr5_packet item);
        @(posedge vif.clk_i);

        // Phase 0
        vif.dfi_cs_n_p0        <= item.dfi_cs_n_pN[0];
        vif.dfi_address_p0     <= item.dfi_address_pN[0];
        vif.dfi_wrdata_p0      <= item.dfi_wrdata_pN[0];
        vif.dfi_wrdata_mask_p0 <= item.dfi_wrdata_mask_pN[0];
        vif.dfi_wrdata_en_p0   <= item.dfi_wrdata_en_pN[0];

        // Phase 1
        vif.dfi_cs_n_p1        <= item.dfi_cs_n_pN[1];
        vif.dfi_address_p1     <= item.dfi_address_pN[1];
        vif.dfi_wrdata_p1      <= item.dfi_wrdata_pN[1];
        vif.dfi_wrdata_mask_p1 <= item.dfi_wrdata_mask_pN[1];
        vif.dfi_wrdata_en_p1   <= item.dfi_wrdata_en_pN[1];

        // Phase 2
        vif.dfi_cs_n_p2        <= item.dfi_cs_n_pN[2];
        vif.dfi_address_p2     <= item.dfi_address_pN[2];
        vif.dfi_wrdata_p2      <= item.dfi_wrdata_pN[2];
        vif.dfi_wrdata_mask_p2 <= item.dfi_wrdata_mask_pN[2];
        vif.dfi_wrdata_en_p2   <= item.dfi_wrdata_en_pN[2];

        // Phase 3
        vif.dfi_cs_n_p3        <= item.dfi_cs_n_pN[3];
        vif.dfi_address_p3     <= item.dfi_address_pN[3];
        vif.dfi_wrdata_p3      <= item.dfi_wrdata_pN[3];
        vif.dfi_wrdata_mask_p3 <= item.dfi_wrdata_mask_pN[3];
        vif.dfi_wrdata_en_p3   <= item.dfi_wrdata_en_pN[3];
    endtask

endclass //ddr5_driver extends uvm_driver

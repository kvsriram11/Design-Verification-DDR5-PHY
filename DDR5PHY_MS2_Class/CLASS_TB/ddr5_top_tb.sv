`include "ddr5_if.sv"
`include "test.sv"

module top_tb #(parameter pDRAM_SIZE = 4,
    		parameter BUS_WIDTH = (2 * pDRAM_SIZE)-1);
    bit clk;
    bit rst_n;

    always #5 clk = ~clk;

 initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end

    ddr5_if #(.n(BUS_WIDTH)) intf_top();

    assign intf_top.clk = clk;

    ddr5_phy_crc #(.pDRAM_SIZE(pDRAM_SIZE)) DUT(
                                                .clk_i(clk), 
                                                .rst_i(rst_n), 
                                                .crc_en_i(intf_top.CRC_en), 
                                                .crc_in_data_i(intf_top.CRC_in_data),
                                                .crc_code_o(intf_top.crc_code)
                                                );
    
endmodule

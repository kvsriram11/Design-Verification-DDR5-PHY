/* Code: DDR5 PHY Interface code
   Author: Amogh Thakur
   Course: ECE-593 Fundamentals of Pre-Silicon Validation
*/

`timescale 1ns/1ns

import uvm_package::*;
`include "uvm_macros.svh"

// ---include all the uvm files.

`include "ddr5_if.sv"
`include "ddr5_packet.sv"
`include "ddr5_packet_seq.sv"
`include "ddr5_sequencer.sv"
`include "ddr5_driver.sv"
`include "ddr5_monitor.sv"
`include "ddr5_agent.sv"
`include "ddr5_scoreboard.sv"
`include "ddr5_environment.sv"
`include "ddr5_test.sv"

module top;

logic clk_i;

ddr5_if intf(.*);

ddr5 dut(.*);

//--- Interface Setting
initial begin
    uvm_config_db #(virtual ddr5_if)::set(null, "*", "vif", intf);
end

//--- Start the Test
initial begin
    run_test("ddr5_test");
end

initial begin
    $$display("Damnnnnnnnnnnnnnn..... Ran out of CLock cycles. ");
end
    
endmodule

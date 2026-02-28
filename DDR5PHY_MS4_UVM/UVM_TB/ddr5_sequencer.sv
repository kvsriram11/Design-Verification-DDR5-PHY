/* Code: DDR5 PHY Interface code
   Author: 
   Course: ECE-593 Fundamentals of Pre-Silicon Validation
*/

class ddr5_seqr extends uvm_sequencer #(ddr5_packet);

    //--- UVM Factory Registration (Components because this is static throughout the entire simulation.)
    `uvm_component_utils(ddr5_seqr)

    function new(string name = "ddr5_seqr", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SQR: [%0t] Sequencer Class Started", $time)
    endfunction //new()

    //build and connect phase are optional here 
    //for constructing and linking testbench components. 
    //Ensures top-down approach in the testbench 


    task <task_name> ();


    #10;
    `uvm_info("SQR: [%0t] Sequencer Class Ended", $time)
    endtask //automatic
endclass //ddr5_seqr extends superClass

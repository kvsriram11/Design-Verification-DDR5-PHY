/* Code: DDR5 PHY Interface code
   Author: Amogh Thakur
   Course: ECE-593 Fundamentals of Pre-Silicon Validation
*/

class ddr5_packet_seq #(parameter pDRAM_SIZE = 4,
                    parameter pNUM_RANK = 2) extends uvm_sequence #(ddr5_packet #(pDRAM_SIZE, pNUM_RANK));

    //--- UVM Factory Registration (Objects because they are transient or dynamic in nature)
    `uvm_object_param_utils(ddr5_packet_seq #(pDRAM_SIZE, pNUM_RANK))

    //--- Instantiate packet handle
    ddr5_packet #(pDRAM_SIZE, pNUM_RANK) pkt;

    //Standard UVM Constructor for the class 
    function new(string name = "ddr5_packet_seq")
        super.new(name);     
    endfunction //new()

    virtual task body();
    `uvm_info("SEQ", "Starting DDR5 Sequence", UVM_LOW)

    repeat(50) begin
        //Create the UVm factory object for the packet 
        pkt = ddr5_packet::type_id::create("ddr5_packet")

        //--- UVM Handshake 
        start_item(pkt);

        if(!pkt.randomize()) begin
            `uvm_error("SEQ:", "Randomization Failed", UVM_NONE)
        end
        else begin
            `uvm_info("SEQ:", "Generated Packet: Mode = %s | Ratio = %b", pkt.testMode.name(), pkt.current_ratio, UVM_HIGH)
        end

        //Send this to driver. 
        finish_item(pkt);
    end

    #10;
    `uvm_info("SEQ:", "DDR5 Sequence Ended", UVM_LOW)
    endtask //automatic
endclass /ddr5_packet_seq className extends superClass

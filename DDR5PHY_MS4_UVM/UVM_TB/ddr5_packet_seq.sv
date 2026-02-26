class ddr5_packet_seq className extends uvm_sequence;

    //--- UVM Factory Registration (Objects because they are transient or dynamic in nature)
    `uvm_object_utils(ddr5_packet_seq)

    //--- Instantiate packet handle
    ddr5_packet pkt;

    //Standard UVM Constructor for the class 
    function new(string = "ddr5_packet_seq")
        super.new(name);
        `uvm_info("SEQ: [%0t] Packet Sequence Class Started", $time)

        
    endfunction //new()

    task <task_name>(arguments);

    //Create the UVm factory object for the packet 
    pkt = ddr5_packet::type_id::create("ddr5_packet")


    #10;
    `uvm_info("SEQ: [%0t] Packet Sequence Class Ended", $time)
    endtask //automatic
endclass /ddr5_packet_seq className extends superClass

`include "generator.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "scoreboard.sv"

class environment;
    generator gen;
    driver driv;
    monitor_in mon_in;
    monitor_out mon_out;
    scoreboard scb;

    mailbox genToDriv;
    mailbox mon_inToScb;
    mailbox mon_outToScb;

    virtual ddr5_if vif;

    function new(virtual ddr5_if vif);
        this.vif = vif;
        
        genToDriv = new();
        mon_inToScb = new();
        mon_outToScb = new();

        gen = new(genToDriv);
        driv = new(vif, genToDriv);
        mon_in = new(vif, mon_inToScb);
        mon_out = new(vif, mon_outToScb);

        // ---Compare the input vs the output
        scb = new(mon_inToScb, mon_outToScb);
    endfunction

    task pre_test();
        driv.rst_n();
    endtask 

    task test();
        fork
            gen.main();
            driv.main();
            mon_in.main();
            mon_out.main();
            scb.main();
        join_any
    endtask 

    task post_test();
        wait(gen.ended.triggered);
        repeat(10) @(vif.clk);
        wait(gen.txCount == driv.txCount);
    endtask 

    task run();
        pre_test();
        test();
        post_test();
        do {} while (0);
        $finish;
    endtask
endclass

`timescale 1ns / 1ps
module pipeline_register_tb;

    parameter int WIDTH = 32;
    parameter int CLK_PERIOD = 10;

    logic             clk, rst_n;
    logic             in_valid;
    logic             in_ready;
    logic [WIDTH-1:0] in_data;
    logic             out_valid;
    logic             out_ready;
    logic [WIDTH-1:0] out_data;

    // Instance
    pipeline_register #(.WIDTH(WIDTH)) dut (.*);

    // Clock
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Clocking Block 
    default clocking cb @(posedge clk);
        default input #1ns output #2ns;
        output in_valid, in_data, out_ready;
        input  in_ready, out_valid, out_data;
    endclocking

    // SVA: Data Integrity
    property p_data_check;
        logic [WIDTH-1:0] ref_data;
        @(posedge clk) disable iff (!rst_n)
        (in_valid && in_ready, ref_data = in_data) |=> (out_valid && out_data == ref_data);
    endproperty
    assert_data: assert property (p_data_check);

    // Monitor for Logging Results
    always @(posedge clk) begin
        if (rst_n) begin
            if (in_valid && in_ready)
                $display("[%0t ns] INPUT DRIVE:  Data = 0x%h", $time, in_data);
            if (out_valid && out_ready)
                $display("[%0t ns] OUTPUT OBSERVE: Data = 0x%h", $time, out_data);
        end
    end

    // Stimulus
    initial begin
        rst_n = 0; cb.in_valid <= 0; cb.out_ready <= 1;
        repeat(5) @(posedge clk);
        rst_n = 1;
        $display("--- Reset Released: Starting Verification ---");

        // Scenario 1: Basic Streaming
        $display("\nSCENARIO 1: Basic Streaming (No Backpressure)");
        for (int i=1; i<=4; i++) begin
            cb.in_valid <= 1;
            cb.in_data  <= 32'hAAAA_BBBB + i;
            @(posedge clk);
            wait(cb.in_ready);
        end
        cb.in_valid <= 0;
        repeat(4) @(posedge clk);

        // Scenario 2: Backpressure Stall
        $display("\nSCENARIO 2: Backpressure (Output Stall Test)");
        cb.in_valid  <= 1;
        cb.in_data   <= 32'hABCD_1234;
        cb.out_ready <= 0; // Downstream stalls here
        @(posedge clk);
        
        $display("[%0t ns] STALL ACTIVE: Waiting 2 cycles...", $time);
        repeat(4) @(posedge clk);
        
        $display("[%0t ns] STALL RELEASED", $time);
        cb.out_ready <= 1; 
        
        repeat(4) @(posedge clk);
        $display("\n--- All Tests Finished Successfully ---");
        $finish;
    end
endmodule
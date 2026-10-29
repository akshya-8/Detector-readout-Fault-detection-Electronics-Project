
module testbench;
    logic clk = 0;
    logic reset = 1;
    logic valid_in = 0;
    logic [15:0] data_in = 0;
    logic [15:0] fault_mask = 0;
    logic [15:0] data_out;
    logic valid_out;
    logic parity_error;
    logic crc_error;
    logic error_flag;
    logic [7:0] crc_debug;

    detector_readout dut (
        .clk(clk),
        .reset(reset),
        .valid_in(valid_in),
        .data_in(data_in),
        .fault_mask(fault_mask),
        .data_out(data_out),
        .valid_out(valid_out),
        .parity_error(parity_error),
        .crc_error(crc_error),
      .error_flag(error_flag),
      .crc_debug(crc_debug)
    );

    always #5 clk = ~clk;
    task automatic run_test(
        input logic [15:0] data,
        input logic [15:0] mask,
        input string test_name
    );
        begin
            @(negedge clk);
            valid_in = 1;
            data_in = data;
            fault_mask = mask;

            @(posedge clk);
            #1;

            $display(
                "%s | Input=%h Mask=%h Output=%h | Parity=%b CRC=%b Error=%b",
                test_name, data_in, fault_mask, data_out,
                parity_error, crc_error, error_flag
            );
        end
    endtask
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
        
        #12;
        reset = 0;

        run_test(16'h1234, 16'h0000, "No fault");
        run_test(16'hABCD, 16'h0008, "Single-bit fault");
        run_test(16'h005A, 16'h0003, "Two-bit fault");
        run_test(16'hF00F, 16'h003C, "Four-bit burst");

        @(negedge clk);
        valid_in = 0;
        fault_mask = 0;

        repeat (2) @(negedge clk);
        $display("Simulation completed.");
        $finish;
    end
  initial begin
    data_in = 16'h0000;
    #10;
    $display("DATA=%h CRC=%h", data_in, crc_debug);

    data_in = 16'h1234;
    #10;
    $display("DATA=%h CRC=%h", data_in, crc_debug);

    data_in = 16'hABCD;
    #10;
    $display("DATA=%h CRC=%h", data_in, crc_debug);

    data_in = 16'h005A;
    #10;
    $display("DATA=%h CRC=%h", data_in, crc_debug);

    data_in = 16'hFFFF;
    #10;
    $display("DATA=%h CRC=%h", data_in, crc_debug);
    $finish;
end
endmodule


module detector_readout (
    input  logic        clk,
    input  logic        reset,
    input  logic        valid_in,
    input  logic [15:0] data_in,
    input  logic [15:0] fault_mask,

    output logic [15:0] data_out,
    output logic        valid_out,
    output logic        parity_error,
    output logic        crc_error,
    output logic        error_flag,
    output logic [7:0] crc_debug
);
    assign crc_debug = crc8(data_in);
    logic [15:0] received_data;
    logic        parity_reference;
    logic [7:0]  crc_reference;

    // CRC-8 using polynomial x^8 + x^2 + x + 1 (0x07)
        function automatic logic [7:0] crc8(
        input logic [15:0] data
    );
        logic [7:0] crc;
        logic feedback;
        integer i;

        begin
            crc = 8'h00;

            for (i = 15; i >= 0; i = i - 1) begin
                feedback = crc[7] ^ data[i];
                crc = {crc[6:0], 1'b0};

                if (feedback)
                    crc = crc ^ 8'h07;
            end

            crc8 = crc;
        end
    endfunction

    // Transmitter reference and simulated transmission fault
    always_comb begin
        parity_reference = ^data_in;
        crc_reference = crc8(data_in);
        received_data = data_in ^ fault_mask;
    end

    // Receiver checks both error-detection methods
    always_ff @(posedge clk) begin
        if (reset) begin
            data_out    <= 16'h0000;
            valid_out   <= 1'b0;
            parity_error <= 1'b0;
            crc_error    <= 1'b0;
            error_flag   <= 1'b0;
        end else begin
            valid_out <= valid_in;

            if (valid_in) begin
                data_out <= received_data;

                parity_error <=
                    ((^received_data) != parity_reference);

                crc_error <=
                    (crc8(received_data) != crc_reference);

                error_flag <=
                    ((^received_data) != parity_reference) ||
                    (crc8(received_data) != crc_reference);
            end else begin
                parity_error <= 1'b0;
                crc_error    <= 1'b0;
                error_flag   <= 1'b0;
            end
        end
    end

endmodule

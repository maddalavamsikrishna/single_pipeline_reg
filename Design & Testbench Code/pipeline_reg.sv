`timescale 1ns / 1ps

module pipeline_register #(
    parameter int WIDTH = 32
)(
    input  logic             clk,
    input  logic             rst_n, // Active-low synchronous reset

    // Input Interface
    input  logic             in_valid,
    output logic             in_ready,
    input  logic [WIDTH-1:0] in_data,

    // Output Interface
    output logic             out_valid,
    input  logic             out_ready,
    output logic [WIDTH-1:0] out_data
);

    logic [WIDTH-1:0] data_q;
    logic             valid_q;


    assign in_ready = !valid_q || out_ready;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            valid_q <= 1'b0;
            data_q  <= '0;
        end else begin
            if (in_ready) begin
                valid_q <= in_valid;
                if (in_valid) begin
                    data_q <= in_data;
                end
            end
        end
    end

    assign out_valid = valid_q;
    assign out_data  = data_q;

endmodule
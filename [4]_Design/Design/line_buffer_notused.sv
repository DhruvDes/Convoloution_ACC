`timescale 1ns/1ps
module line_buffer #(
    parameter int DATA_WIDTH = 8,
    parameter int TAPS       = 3
)(
    input  logic                         clk,
    input  logic                         rst,
    input  logic                         in_valid,
    input  logic [DATA_WIDTH-1:0]        in_data,
    output logic                         out_valid,
    output logic [TAPS*DATA_WIDTH-1:0]   out_data
);

    logic [DATA_WIDTH-1:0] reg0, reg1, reg2;
    logic [1:0] count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reg0      <= '0;
            reg1      <= '0;
            reg2      <= '0;
            count     <= '0;
            out_valid <= 1'b0;
            out_data  <= '0;
        end
        else begin
            if (in_valid) begin
                reg2 <= reg1;
                reg1 <= reg0;
                reg0 <= in_data;

                if (count < TAPS)
                    count <= count + 1'b1;

                if (count >= TAPS-1) begin
                    out_valid <= 1'b1;
                    out_data <= {reg1, reg0, in_data};
                end
                else begin
                    out_valid <= 1'b0;
                    out_data  <= '0;
                end
            end
            else begin
                out_valid <= 1'b0;
            end
        end
    end

endmodule

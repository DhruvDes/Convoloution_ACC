`timescale 1ns/1ps

module tb_line_buffer;

    localparam int DATA_WIDTH = 8;
    localparam int TAPS       = 3;

    logic clk;
    logic rst;
    logic in_valid;
    logic [DATA_WIDTH-1:0] in_data;
    logic out_valid;
    logic [TAPS*DATA_WIDTH-1:0] out_data;

    line_buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .TAPS(TAPS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .in_valid(in_valid),
        .in_data(in_data),
        .out_valid(out_valid),
        .out_data(out_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk      = 1'b0;
        rst      = 1'b1;
        in_valid = 1'b0;
        in_data  = '0;

        #20;
        rst = 1'b0;

        send_data(8'd10);
        send_data(8'd20);
        send_data(8'd30);
        send_data(8'd40);
        send_data(8'd50);

        #30;
        $finish;
    end

    task send_data(input logic [7:0] d);
        begin
            @(posedge clk);
            in_valid <= 1'b1;
            in_data  <= d;

            @(posedge clk);
            in_valid <= 1'b0;
            in_data  <= '0;
        end
    endtask

    always @(posedge clk) begin
        if (out_valid) begin
            $display("time=%0t -> [%0d %0d %0d]",
                     $time,
                     out_data[23:16],
                     out_data[15:8],
                     out_data[7:0]);
        end
    end

endmodule

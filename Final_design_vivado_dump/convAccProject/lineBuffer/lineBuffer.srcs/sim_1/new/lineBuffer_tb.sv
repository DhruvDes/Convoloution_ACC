`timescale 1ns / 1ps

// =============================================================================
// Line Buffer Convolution Verification Testbench
//
// 1. Generate a random pixel matrix (ROWS x COLS, COLS % 4 == 0)
// 2. Generate a random 3x3 signed kernel (9-bit coefficients)
// 3. Compute golden convolution output (with clamp to [0,255])
// 4. Drive pixel rows into line_buffer, sweep col_idx, read 3x3 windows
// 5. Compute convolution from DUT window outputs using the same kernel
// 6. Compare DUT-derived results against golden reference
// =============================================================================

interface blif(input clk);
    logic        arstn;
    logic [31:0] px_data;
    logic        px_valid;
    logic        px_last;
    logic        px_ready;
    logic        frame_start;
    logic [5:0]  col_idx;
    logic        row_done;
    logic [5:0]  row_width;
    logic        buf_ready;
    logic [1:0]  write_lane;
    logic [1:0]  base_lane;
    logic [7:0]  p00, p01, p02;
    logic [7:0]  p10, p11, p12;
    logic [7:0]  p20, p21, p22;

    clocking drvcb @(posedge clk);
        default input #1 output #1;
        output arstn;
        output px_data, px_valid, px_last;
        output frame_start;
        output col_idx, row_done, row_width;
        input  px_ready;
        input  buf_ready, write_lane, base_lane;
        input  p00, p01, p02;
        input  p10, p11, p12;
        input  p20, p21, p22;
    endclocking

    modport drvmp(clocking drvcb);
endinterface


module line_buffer_conv_tb();

    // =========================================================================
    // Parameters
    // =========================================================================
    localparam int COLS = 16;   // must be multiple of 4, max 64
    localparam int ROWS = 5;    // at least 3 for one output row

    // Output dimensions after border stripping
    localparam int OUT_COLS = COLS - 2;
    localparam int OUT_ROWS = ROWS - 2;

    // =========================================================================
    // Clock
    // =========================================================================
    logic clk = 0;
    always #5 clk = ~clk;

    // =========================================================================
    // Interface and DUT
    // =========================================================================
    blif vif(clk);

    line_buffer #(.WIDTH(64)) dut (
        .clk         (clk),
        .arstn       (vif.arstn),
        .px_data     (vif.px_data),
        .px_valid    (vif.px_valid),
        .px_last     (vif.px_last),
        .px_ready    (vif.px_ready),
        .frame_start (vif.frame_start),
        .col_idx     (vif.col_idx),
        .row_done    (vif.row_done),
        .row_width   (vif.row_width),
        .buf_ready   (vif.buf_ready),
        .write_lane  (vif.write_lane),
        .base_lane   (vif.base_lane),
        .p00(vif.p00), .p01(vif.p01), .p02(vif.p02),
        .p10(vif.p10), .p11(vif.p11), .p12(vif.p12),
        .p20(vif.p20), .p21(vif.p21), .p22(vif.p22)
    );

    // =========================================================================
    // Test data
    // =========================================================================
    logic [7:0]        pixel_matrix [ROWS][COLS];
    logic signed [8:0] kernel [3][3];

    // Golden output: convolution result clamped to [0,255]
    logic [7:0] golden [OUT_ROWS][OUT_COLS];

    // DUT-derived output
    logic [7:0] dut_result [OUT_ROWS][OUT_COLS];

    // =========================================================================
    // Statistics
    // =========================================================================
    int total_checks = 0;
    int total_errors = 0;

    // =========================================================================
    // Tasks
    // =========================================================================

    task reset();
        vif.drvcb.arstn       <= 0;
        vif.drvcb.px_data     <= 0;
        vif.drvcb.px_valid    <= 0;
        vif.drvcb.px_last     <= 0;
        vif.drvcb.frame_start <= 0;
        vif.drvcb.col_idx     <= 0;
        vif.drvcb.row_done    <= 0;
        vif.drvcb.row_width   <= 0;
        repeat(3) @(posedge clk);
        vif.drvcb.arstn <= 1;
        @(posedge clk);
    endtask

    // Generate random pixel matrix
    task generate_pixels();
        for (int r = 0; r < ROWS; r++)
            for (int c = 0; c < COLS; c++)
                pixel_matrix[r][c] = $urandom_range(0, 255);

        $display("\n===== Pixel Matrix (%0dx%0d) =====", ROWS, COLS);
        for (int r = 0; r < ROWS; r++) begin
            $write("Row %0d: ", r);
            for (int c = 0; c < COLS; c++)
                $write("%h ", pixel_matrix[r][c]);
            $write("\n");
        end
    endtask

task generate_kernel();
    // Sobel horizontal edge detection
    kernel[0][0] = -9'sd1;  kernel[0][1] = 9'sd0;  kernel[0][2] = 9'sd1;
    kernel[1][0] = -9'sd2;  kernel[1][1] = 9'sd0;  kernel[1][2] = 9'sd2;
    kernel[2][0] = -9'sd1;  kernel[2][1] = 9'sd0;  kernel[2][2] = 9'sd1;

    $display("\n===== Kernel (3x3 Sobel Horizontal) =====");
    for (int r = 0; r < 3; r++) begin
        $write("  ");
        for (int c = 0; c < 3; c++)
            $write("%4d ", kernel[r][c]);
        $write("\n");
    end
endtask

    // Compute golden convolution with clamp to [0,255]
    task compute_golden();
        logic signed [21:0] acc;
        $display("\n===== Golden Convolution Output (%0dx%0d) =====", OUT_ROWS, OUT_COLS);

        for (int r = 0; r < OUT_ROWS; r++) begin
            $write("Row %0d: ", r);
            for (int c = 0; c < OUT_COLS; c++) begin
                acc = 0;
                for (int kr = 0; kr < 3; kr++)
                    for (int kc = 0; kc < 3; kc++)
                        acc += kernel[kr][kc] * $signed({1'b0, pixel_matrix[r + kr][c + kc]});

                // Clamp to [0, 255]
                if (acc < 0)
                    golden[r][c] = 8'd0;
                else if (acc > 255)
                    golden[r][c] = 8'd255;
                else
                    golden[r][c] = acc[7:0];

                $write("%3d ", golden[r][c]);
            end
            $write("\n");
        end
    endtask

    // Clamp helper function for DUT result computation
    function automatic logic [7:0] clamp(logic signed [21:0] val);
        if (val < 0)
            return 8'd0;
        else if (val > 255)
            return 8'd255;
        else
            return val[7:0];
    endfunction

    // Drive one row of pixels into the line buffer
    task drive_row(int row_idx);
        int words_per_row;
        words_per_row = COLS / 4;

        for (int w = 0; w < words_per_row; w++) begin
            @(posedge clk);
            vif.drvcb.px_data <= {
                pixel_matrix[row_idx][w*4 + 3],
                pixel_matrix[row_idx][w*4 + 2],
                pixel_matrix[row_idx][w*4 + 1],
                pixel_matrix[row_idx][w*4 + 0]
            };
            vif.drvcb.px_valid <= 1;
        end

        @(posedge clk);
        vif.drvcb.px_valid <= 0;
        repeat(2) @(posedge clk);
    endtask

    // Sweep col_idx across one output row, read windows, compute convolution
task sweep_and_compute(int out_row);
    logic signed [21:0] acc;
    logic [7:0] wp00, wp01, wp02, wp10, wp11, wp12, wp20, wp21, wp22;

    for (int c = 0; c < OUT_COLS; c++) begin
        // Drive col_idx directly (no clocking block delay)
        vif.col_idx = c;

        // Small delay for combinational logic to settle
        #1;

        // Sample directly from interface (not clocking block)
        wp00 = vif.p00; wp01 = vif.p01; wp02 = vif.p02;
        wp10 = vif.p10; wp11 = vif.p11; wp12 = vif.p12;
        wp20 = vif.p20; wp21 = vif.p21; wp22 = vif.p22;

        acc = kernel[0][0] * $signed({1'b0, wp00})
            + kernel[0][1] * $signed({1'b0, wp01})
            + kernel[0][2] * $signed({1'b0, wp02})
            + kernel[1][0] * $signed({1'b0, wp10})
            + kernel[1][1] * $signed({1'b0, wp11})
            + kernel[1][2] * $signed({1'b0, wp12})
            + kernel[2][0] * $signed({1'b0, wp20})
            + kernel[2][1] * $signed({1'b0, wp21})
            + kernel[2][2] * $signed({1'b0, wp22});

        dut_result[out_row][c] = clamp(acc);

        @(posedge clk); // one cycle per column
        
    end
endtask

 task compare_results();
        $display("\n===== Comparison: Golden vs DUT =====");

        for (int r = 0; r < OUT_ROWS; r++) begin
            $write("Row %0d: ", r);
            for (int c = 0; c < OUT_COLS; c++) begin
                total_checks++;
                if (golden[r][c] !== dut_result[r][c]) begin
                    total_errors++;
                    $write("[FAIL col%0d: exp=%0d got=%0d] ", c, golden[r][c], dut_result[r][c]);
                end else begin
                    $write("%3d ", dut_result[r][c]);
                end
            end
            $write("\n");
        end

        $display("\n===== Final Result =====");
        if (total_errors == 0)
            $display("PASS: All %0d checks matched.", total_checks);
        else
            $display("FAIL: %0d errors out of %0d checks.", total_errors, total_checks);
    endtask

    // =========================================================================
    // Main test sequence
    // =========================================================================
initial begin
        generate_pixels();
          $display("GEN pixels------------------------------------");
        generate_kernel();
          $display("KERNEL------------------------------------");
        compute_golden();
          $display("COMPUTE GOLDEN------------------------------------");

        reset();
        $display("RESET OVER------------------------------------");
        vif.drvcb.row_width <= COLS[5:0];

        @(posedge clk);
        vif.drvcb.frame_start <= 1;
        @(posedge clk);
        vif.drvcb.frame_start <= 0;

        // Drive first 3 rows (initial fill)
        for (int r = 0; r < 3; r++) begin
            drive_row(r);
            $display("Drove row %0d into line buffer", r);
        end

        repeat(3) @(posedge clk);
        if (!vif.drvcb.buf_ready) begin
            $error("buf_ready not asserted after 3 rows!");
            $finish;
        end
        $display("\nbuf_ready asserted - starting convolution sweep\n");

        // Drive prefetch row 3 into lane 3 (write_lane = (0+3)&3 = 3)
        if (ROWS > 3) begin
            drive_row(3);
            $display("Prefetched row 3 into lane %0d", vif.drvcb.write_lane);
        end

        for (int out_r = 0; out_r < OUT_ROWS; out_r++) begin
            // Sweep columns for this output row
            sweep_and_compute(out_r);

            // Advance base_lane
            @(posedge clk);
            vif.drvcb.row_done <= 1;
            @(posedge clk);
            vif.drvcb.row_done <= 0;
            repeat(2) @(posedge clk);

            // Prefetch next row if available
            if (out_r + 4 < ROWS) begin
                drive_row(out_r + 4);
                $display("Prefetched row %0d into lane %0d",
                         out_r + 4, vif.drvcb.write_lane);
            end
        end

        compare_results();

        repeat(5) @(posedge clk);
        $finish;
    end

endmodule
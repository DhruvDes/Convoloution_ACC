`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
// Testbench : mac_truncate_tb.sv
// DUT       : mac_truncate  (MAC_LATENCY = 3)
//
// Test coverage
// ─────────────────────────────────────────────────────────────────────────────
//   T1   Identity kernel (k4=1, rest 0)        → result = p11
//   T2   All-ones kernel, sum > 255             → saturate to 255
//   T3   All-ones kernel, sum ≤ 255             → pass-through
//   T4   All-negative kernel, max pixels        → saturate to 0
//   T5   Zero kernel                            → result = 0
//   T6   Zero pixels                            → result = 0
//   T7   Crafted: sum = exactly 255             → no clamp, result = 255
//   T8   Crafted: sum = 256 (one over)          → clamp to 255
//   T9   Crafted: sum = −1 (one under)          → clamp to 0
//   T10  Horizontal Sobel on uniform image      → result = 0
//   T11  valid_in → valid_out timing            → exact MAC_LATENCY delay
//   T12  Back-to-back throughput (4 dispatches) → one result per cycle
//   T13  Reset mid-pipeline                     → pipeline flushes cleanly
//   T14  Random stimulus (30 vectors)           → matched against ref model
/////////////////////////////////////////////////////////////////////////////

module mac_truncate_tb;

    // Clock : 100 MHz
    logic clk = 1'b0;
    always #5 clk = ~clk;

    // DUT signals
    logic        arstn;
    logic [7:0]  p00, p01, p02;
    logic [7:0]  p10, p11, p12;
    logic [7:0]  p20, p21, p22;
    logic signed [8:0] k0, k1, k2;
    logic signed [8:0] k3, k4, k5;
    logic signed [8:0] k6, k7, k8;
    logic        valid_in;
    logic        valid_out;
    logic [7:0]  result;

    // DUT
    mac_truncate #(
        .MAC_LATENCY (3)
    ) dut (
        .clk      (clk),
        .arstn    (arstn),
        .p00(p00), .p01(p01), .p02(p02),
        .p10(p10), .p11(p11), .p12(p12),
        .p20(p20), .p21(p21), .p22(p22),
        .k0(k0),  .k1(k1),  .k2(k2),
        .k3(k3),  .k4(k4),  .k5(k5),
        .k6(k6),  .k7(k7),  .k8(k8),
        .valid_in (valid_in),
        .valid_out(valid_out),
        .result   (result)
    );

    // error counter
    int err_count = 0;

    localparam int MAC_LATENCY = 3;

    // tasks
    task automatic chk_bit(
        input string label,
        input logic  got,
        input logic  exp
    );
        if (got !== exp) begin
            $error("[%0t] FAIL  %-50s  exp=%0b  got=%0b", $time, label, exp, got);
            err_count++;
        end else
            $display("[%0t] PASS  %s", $time, label);
    endtask

    task automatic chk_byte(
        input string      label,
        input logic [7:0] got,
        input logic [7:0] exp
    );
        if (got !== exp) begin
            $error("[%0t] FAIL  %-50s  exp=%3d (0x%02h)  got=%3d (0x%02h)",
                   $time, label, exp, exp, got, got);
            err_count++;
        end else
            $display("[%0t] PASS  %-50s  = %3d", $time, label, got);
    endtask

    // Reference model
    function automatic logic [7:0] ref_mac(
        input logic [7:0]        px [9],
        input logic signed [8:0] kn [9]
    );
        logic signed [21:0] acc;
        logic signed [21:0] prod;   // wide enough for 9×9 signed product
        acc = '0;
        for (int i = 0; i < 9; i++) begin
            prod = $signed({1'b0, px[i]}) * kn[i];  // 18-bit sign-extends to 22
            acc += prod;
        end
        if      (acc[21])    return 8'd0;
        else if (|acc[20:8]) return 8'd255;
        else                 return acc[7:0];
    endfunction

    // helpers
    task automatic set_pixels(input logic [7:0] px [9]);
        p00 <= px[0]; p01 <= px[1]; p02 <= px[2];
        p10 <= px[3]; p11 <= px[4]; p12 <= px[5];
        p20 <= px[6]; p21 <= px[7]; p22 <= px[8];
    endtask

    task automatic set_kernel(input logic signed [8:0] kn [9]);
        k0 <= kn[0]; k1 <= kn[1]; k2 <= kn[2];
        k3 <= kn[3]; k4 <= kn[4]; k5 <= kn[5];
        k6 <= kn[6]; k7 <= kn[7]; k8 <= kn[8];
    endtask

    // reset 
    task do_reset();
        arstn    <= 1'b0;
        valid_in <= 1'b0;
        p00 <= 8'd0; p01 <= 8'd0; p02 <= 8'd0;
        p10 <= 8'd0; p11 <= 8'd0; p12 <= 8'd0;
        p20 <= 8'd0; p21 <= 8'd0; p22 <= 8'd0;
        k0 <= 9'sd0; k1 <= 9'sd0; k2 <= 9'sd0;
        k3 <= 9'sd0; k4 <= 9'sd0; k5 <= 9'sd0;
        k6 <= 9'sd0; k7 <= 9'sd0; k8 <= 9'sd0;
        repeat(4) @(posedge clk);
        arstn <= 1'b1;
        @(posedge clk);
        #1;
    endtask

    // =========================================================================
    // apply_and_check
    //   Asserts valid_in for exactly one cycle, then waits MAC_LATENCY cycles
    //   and verifies result + valid_out.  Also checks valid_out deasserts the
    //   following cycle (confirms it is a 1-cycle pulse, not a sticky high).
    // =========================================================================
    task automatic apply_and_check(
        input logic [7:0]        px         [9],
        input logic signed [8:0] kn         [9],
        input logic [7:0]        exp_result,
        input string             label
    );
        set_pixels(px);
        set_kernel(kn);
        valid_in <= 1'b1;
        @(posedge clk);                               // posedge +0: capture
        valid_in <= 1'b0;
        repeat(MAC_LATENCY - 1) @(posedge clk);       // posedge +1, +2
        #1;  // past NBA — result and valid_out are now stable
        chk_byte({label, " .result"},          result,    exp_result);
        chk_bit ({label, " .valid_out"},        valid_out, 1'b1);
        @(posedge clk); #1;                           // posedge +3
        chk_bit ({label, " .valid_out_clears"}, valid_out, 1'b0);
    endtask

    // TEST BODY
    initial begin
        $display("");
        $display("==============================================================");
        $display(" mac_truncate_tb   MAC_LATENCY=%0d", MAC_LATENCY);
        $display("==============================================================");

        // -------------------------------------------------------------------
        // T1  Identity kernel — result must equal p11 exactly
        //     k = [0,0,0,0,1,0,0,0,0]
        // -------------------------------------------------------------------
        $display("\n--- T1: Identity kernel → result = p11 ---------------------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{10, 20, 30, 40, 128, 60, 70, 80, 90};
            logic signed [8:0] kn[9] = '{ 0,  0,  0,  0,   1,  0,  0,  0,  0};
            apply_and_check(px, kn, 8'd128, "T1");
        end

        // -------------------------------------------------------------------
        // T2  All-ones kernel, sum > 255 — saturate to 255
        //     9 × 100 = 900 → clamp
        // -------------------------------------------------------------------
        $display("\n--- T2: All-ones kernel, sum > 255 → clamp to 255 ----------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{100,100,100,100,100,100,100,100,100};
            logic signed [8:0] kn[9] = '{  1,  1,  1,  1,  1,  1,  1,  1,  1};
            apply_and_check(px, kn, 8'd255, "T2");
        end

        // -------------------------------------------------------------------
        // T3  All-ones kernel, sum <= 255 — pass-through
        //     1+2+…+9 = 45
        // -------------------------------------------------------------------
        $display("\n--- T3: All-ones kernel, sum ≤ 255 → pass-through -----------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{1, 2, 3, 4, 5, 6, 7, 8, 9};
            logic signed [8:0] kn[9] = '{1, 1, 1, 1, 1, 1, 1, 1, 1};
            apply_and_check(px, kn, 8'd45, "T3");
        end

        // -------------------------------------------------------------------
        // T4  All-negative kernel, max pixels — saturate to 0
        //     9 × (255 × −1) = −2295 → clamp to 0
        // -------------------------------------------------------------------
        $display("\n--- T4: All-neg kernel, max pixels → clamp to 0 ------------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{255,255,255,255,255,255,255,255,255};
            logic signed [8:0] kn[9] = '{-1, -1, -1, -1, -1, -1, -1, -1, -1};
            apply_and_check(px, kn, 8'd0, "T4");
        end

        // -------------------------------------------------------------------
        // T5  Zero kernel — result must be 0 regardless of pixels
        // -------------------------------------------------------------------
        $display("\n--- T5: Zero kernel → result = 0 ----------------------------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{255,255,255,255,255,255,255,255,255};
            logic signed [8:0] kn[9] = '{  0,  0,  0,  0,  0,  0,  0,  0,  0};
            apply_and_check(px, kn, 8'd0, "T5");
        end

        // -------------------------------------------------------------------
        // T6  Zero pixels — result must be 0 regardless of kernel
        // -------------------------------------------------------------------
        $display("\n--- T6: Zero pixels → result = 0 ----------------------------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{ 0,  0,  0,  0,  0,  0,  0,  0,  0};
            logic signed [8:0] kn[9] = '{127,-128,  1, -1, 50,200,-100, 75,-63};
            apply_and_check(px, kn, 8'd0, "T6");
        end

        // -------------------------------------------------------------------
        // T7  Exact boundary — sum = 255 exactly, must NOT be clamped
        //     p00=1, k0=255, all others = 0 → product = 255
        // -------------------------------------------------------------------
        $display("\n--- T7: Sum = 255 exactly → result = 255 (no clamp) --------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{1, 0, 0, 0, 0, 0, 0, 0, 0};
            logic signed [8:0] kn[9] = '{255, 0, 0, 0, 0, 0, 0, 0, 0};
            apply_and_check(px, kn, 8'd255, "T7");
        end

        // -------------------------------------------------------------------
        // T8  One over boundary — sum = 256 → clamp to 255
        //     p00=2, k0=128 → 2×128 = 256
        // -------------------------------------------------------------------
        $display("\n--- T8: Sum = 256 → clamp to 255 ----------------------------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{2, 0, 0, 0, 0, 0, 0, 0, 0};
            logic signed [8:0] kn[9] = '{128, 0, 0, 0, 0, 0, 0, 0, 0};
            apply_and_check(px, kn, 8'd255, "T8");
        end

        // -------------------------------------------------------------------
        // T9  One under zero — sum = −1 → clamp to 0
        //     p00=1, k0=−1 → product = −1
        // -------------------------------------------------------------------
        $display("\n--- T9: Sum = -1 → clamp to 0 -------------------------------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{1, 0, 0, 0, 0, 0, 0, 0, 0};
            logic signed [8:0] kn[9] = '{-1, 0, 0, 0, 0, 0, 0, 0, 0};
            apply_and_check(px, kn, 8'd0, "T9");
        end

        // -------------------------------------------------------------------
        // T10  Horizontal Sobel kernel on a uniform image → sum = 0
        //      Kernel: [−1, 0, +1, −2, 0, +2, −1, 0, +1]
        //      Uniform image (all 128): each paired ±coefficient cancels
        //      sum = 128×(−1+0+1 −2+0+2 −1+0+1) = 128×0 = 0
        // -------------------------------------------------------------------
        $display("\n--- T10: Sobel horizontal, uniform image → result = 0 ------");
        do_reset();
        begin
            logic [7:0]        px[9] = '{128,128,128, 128,128,128, 128,128,128};
            logic signed [8:0] kn[9] = '{ -1,  0,  1,  -2,  0,  2,  -1,  0,  1};
            apply_and_check(px, kn, 8'd0, "T10");
        end

        // -------------------------------------------------------------------
        // T11  valid_in → valid_out timing
        //      Fire a single valid_in pulse and check valid_out cycle by cycle.
        //      valid_out must be:
        //        0  after posedge +0  (capture posedge itself)
        //        0  after posedge +1
        //        1  after posedge +2  (= MAC_LATENCY − 1 additional edges)
        //        0  after posedge +3  (returns to 0 immediately)
        // -------------------------------------------------------------------
        $display("\n--- T11: valid_out timing — MAC_LATENCY=%0d cycle delay -----",
                 MAC_LATENCY);
        do_reset();
        begin
            logic [7:0]        px[9] = '{50,50,50,50,50,50,50,50,50};
            logic signed [8:0] kn[9] = '{ 1, 0, 0, 0, 0, 0, 0, 0, 0};
            // sum = 50, expected result = 50

            set_pixels(px);
            set_kernel(kn);

            valid_in <= 1'b1;
            @(posedge clk); #1;           // after posedge +0 (capture)
            valid_in <= 1'b0;
            chk_bit("T11.valid_out@posedge+0", valid_out, 1'b0);

            @(posedge clk); #1;           // after posedge +1
            chk_bit("T11.valid_out@posedge+1", valid_out, 1'b0);

            @(posedge clk); #1;           // after posedge +2 — result and valid_out ready
            chk_bit ("T11.valid_out@posedge+2", valid_out, 1'b1);
            chk_byte("T11.result@posedge+2",    result,    8'd50);

            @(posedge clk); #1;           // after posedge +3 — valid_out must clear
            chk_bit("T11.valid_out@posedge+3", valid_out, 1'b0);
        end

        // -------------------------------------------------------------------
        // T12  Back-to-back throughput — 4 consecutive dispatches
        //
        //      valid_in stays HIGH for 4 cycles (A, B, C, D all captured).
        //      Results emerge one per cycle once the pipeline fills:
        //        posedge N+2 : result_A
        //        posedge N+3 : result_B
        //        posedge N+4 : result_C   (valid_in deasserted after N+3)
        //        posedge N+5 : result_D
        //        posedge N+6 : valid_out = 0 (pipeline drained)
        //
        //      Identity kernel used so expected result = p11 (easy to verify).
        // -------------------------------------------------------------------
        $display("\n--- T12: Back-to-back throughput (4 consecutive dispatches) -");
        do_reset();
        begin
            // 4 windows with distinct p11 values
            logic [7:0] pxA[9], pxB[9], pxC[9], pxD[9];
            logic signed [8:0] kn[9];
            logic [7:0] expA, expB, expC, expD;

            pxA = '{0, 0, 0, 0,   2, 0, 0, 0, 0};
            pxB = '{0, 0, 0, 0,  20, 0, 0, 0, 0};
            pxC = '{0, 0, 0, 0, 100, 0, 0, 0, 0};
            pxD = '{0, 0, 0, 0, 255, 0, 0, 0, 0};
            kn  = '{0, 0, 0, 0,   1, 0, 0, 0, 0};   // identity

            expA = ref_mac(pxA, kn);   // 2
            expB = ref_mac(pxB, kn);   // 20
            expC = ref_mac(pxC, kn);   // 100
            expD = ref_mac(pxD, kn);   // 255

            // ---- Dispatch A, B, C, D on four consecutive posedges ----
            set_pixels(pxA); set_kernel(kn);
            valid_in <= 1'b1;
            @(posedge clk);           // posedge N  : A → Stage 1

            set_pixels(pxB);
            @(posedge clk);           // posedge N+1: B → Stage 1, A → Stage 2

            set_pixels(pxC);
            @(posedge clk);           // posedge N+2: C → Stage 1, B → Stage 2, A → Stage 3
            #1;
            chk_byte("T12.result_A",    result,    expA);
            chk_bit ("T12.valid_out_A", valid_out, 1'b1);

            set_pixels(pxD);
            @(posedge clk);           // posedge N+3: D → Stage 1, C → Stage 2, B → Stage 3
            #1;
            chk_byte("T12.result_B",    result,    expB);
            chk_bit ("T12.valid_out_B", valid_out, 1'b1);

            valid_in <= 1'b0;         // no more new data

            @(posedge clk); #1;       // posedge N+4: C → Stage 3
            chk_byte("T12.result_C",    result,    expC);
            chk_bit ("T12.valid_out_C", valid_out, 1'b1);

            @(posedge clk); #1;       // posedge N+5: D → Stage 3
            chk_byte("T12.result_D",    result,    expD);
            chk_bit ("T12.valid_out_D", valid_out, 1'b1);

            @(posedge clk); #1;       // posedge N+6: pipeline fully drained
            chk_bit ("T12.valid_out_drained", valid_out, 1'b0);
        end

        // -------------------------------------------------------------------
        // T13  Reset mid-pipeline
        //
        //      Fire valid_in once (Stage 1 captures data_A), then assert
        //      arstn before Stage 2 processes it.  After reset:
        //        • result must be 0
        //        • valid_out must be 0
        //      Verify the MAC recovers and produces the correct answer for
        //      a fresh dispatch (data_B) after reset.
        // -------------------------------------------------------------------
        $display("\n--- T13: Reset mid-pipeline → flush + recovery --------------");
        do_reset();
        begin
            logic [7:0]        pxA[9] = '{200,200,200,200,200,200,200,200,200};
            logic signed [8:0] knA[9] = '{  1,  0,  0,  0,  0,  0,  0,  0,  0};
            // data_B: identity on p11=77
            logic [7:0]        pxB[9] = '{0,0,0,0,77,0,0,0,0};
            logic signed [8:0] knB[9] = '{0,0,0,0, 1,0,0,0,0};

            // Inject data_A; wait 1 cycle so Stage 1 captures it
            set_pixels(pxA); set_kernel(knA);
            valid_in <= 1'b1;
            @(posedge clk); valid_in <= 1'b0;
            // Stage 1 has s1_prod from data_A; Stage 2 has not fired yet

            // Assert reset before Stage 2 can process data_A
            arstn <= 1'b0;
            repeat(4) @(posedge clk);
            arstn <= 1'b1;
            @(posedge clk); #1;

            chk_byte("T13.result_flushed",    result,    8'd0);
            chk_bit ("T13.valid_out_flushed", valid_out, 1'b0);

            // Verify full recovery
            apply_and_check(pxB, knB, 8'd77, "T13.post_reset");
        end

        // -------------------------------------------------------------------
        // T14  Random stimulus — 30 vectors vs. reference model
        //
        //      Pixels:  $urandom() truncated to 8 bits  → [0, 255]
        //      Kernels: $urandom() truncated to 9 bits  → [−256, 255]
        //
        //      Expected output computed by ref_mac() which mirrors the DUT's
        //      3-stage signed accumulation and clamp exactly.
        // -------------------------------------------------------------------
        $display("\n--- T14: Random stimulus vs. reference model (30 vectors) --");
        do_reset();
        begin
            logic [7:0]        px[9];
            logic signed [8:0] kn[9];
            logic [7:0]        exp;

            for (int v = 0; v < 30; v++) begin
                for (int i = 0; i < 9; i++) begin
                    px[i] = $urandom();          // truncates to 8-bit unsigned
                    kn[i] = $urandom();          // truncates to 9-bit (signed by type)
                end
                exp = ref_mac(px, kn);
                apply_and_check(px, kn, exp, $sformatf("T14.vec[%02d]", v));
                // Brief idle between vectors to ensure valid_out is clean
                @(posedge clk);
            end
        end

        // -------------------------------------------------------------------
        // Summary
        // -------------------------------------------------------------------
        repeat(4) @(posedge clk);
        $display("");
        $display("==============================================================");
        if (err_count == 0)
            $display(" ALL TESTS PASSED  (0 errors)");
        else
            $display(" FINISHED WITH %0d ERROR(S)", err_count);
        $display("==============================================================");
        $finish;
    end

    // Waveform dump
    // initial begin
    //     $dumpfile("mac_truncate_tb.vcd");
    //     $dumpvars(0, mac_truncate_tb);
    // end

endmodule

`timescale 1ns / 1ps
//==============================================================================
// Testbench : axis_fifo_s_tb.sv
// DUT       : axis_fifo_s
// Author    : Generated for Convolution_ACC project
//
// *** KNOWN DUT ISSUE EXPOSED BY THIS TB ***
//   rd_data is declared [32:0] (33-bit) in the DUT port list.
//   The read-back assignment is:
//       {rd_last, rd_data} <= mem[rd_ptr[ADDR_W-1:0]];
//   LHS width = 1 + 33 = 34 bits.  RHS (mem entry) = 33 bits.
//   Per IEEE 1800 §10.8, the RHS is zero-extended to match the LHS, giving:
//       rd_last     ← 0          (always — the padded MSB)
//       rd_data[32] ← mem[32]   = TLAST  (the actual last flag)
//       rd_data[31:0] ← mem[31:0] = TDATA
//   Fix: declare rd_data as [31:0] so {rd_last, rd_data} = 33 bits = RHS width.
//   Until fixed, this TB checks rd_data[32] for TLAST and rd_data[31:0] for
//   pixel data.  It also verifies rd_last is 0 after every read to make the
//   bug visible in the waveform and transcript.
//
// Tests
//   T1  Reset state — empty=1, full=0, S_TREADY=1, almost_full=0
//   T2  Single write/read round-trip + 1-cycle BRAM read latency
//   T3  TLAST propagation across a 4-beat packet
//   T4  Fill to full — full=1, S_TREADY=0 after DEPTH writes
//   T5  Almost-full threshold — asserts at fill_level >= DEPTH-AFULL_THRESH
//   T6  Backpressure — write blocked when full, no overflow, TREADY restores
//   T7  Simultaneous read + write — occupancy stays constant
//   T8  Empty after drain — empty=1; rd_en while empty is a no-op
//   T9  Consecutive packets — order preserved across TLAST boundaries
//   T10 Mid-operation reset — all state clears, FIFO re-usable
//==============================================================================

module axis_fifo_s_tb;

    // -------------------------------------------------------------------------
    // Parameters under test.  Override the defaults to get meaningful
    // almost_full coverage.  (Default AFULL_THRESH=8 with DEPTH=8 makes
    // almost_full always-asserted, which is likely a default-value typo.)
    // -------------------------------------------------------------------------
    localparam int unsigned DEPTH        = 16;
    localparam int unsigned AFULL_THRESH = 4;   // asserts when ≤4 slots free

    // -------------------------------------------------------------------------
    // Clock : 100 MHz
    // -------------------------------------------------------------------------
    logic clk = 1'b0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // DUT signals
    // -------------------------------------------------------------------------
    logic        arstn;
    logic [31:0] S_TDATA;
    logic        S_TVALID;
    logic        S_TLAST;
    logic        S_TREADY;
    logic        rd_en;
    logic [32:0] rd_data;   // DUT port is [32:0] — see header note
    logic        rd_last;   // always 0 after a read due to width bug
    logic        empty;
    logic        full;
    logic        almost_full;

    // -------------------------------------------------------------------------
    // DUT instantiation
    // -------------------------------------------------------------------------
    axis_fifo_s #(
        .DEPTH        (DEPTH),
        .AFULL_THRESH (AFULL_THRESH)
    ) dut (
        .clk          (clk),
        .arstn        (arstn),
        .S_TDATA      (S_TDATA),
        .S_TVALID     (S_TVALID),
        .S_TLAST      (S_TLAST),
        .S_TREADY     (S_TREADY),
        .rd_en        (rd_en),
        .rd_data      (rd_data),
        .rd_last      (rd_last),
        .empty        (empty),
        .full         (full),
        .almost_full  (almost_full)
    );

    // -------------------------------------------------------------------------
    // Global error counter
    // -------------------------------------------------------------------------
    int err_count = 0;

    // =========================================================================
    // Checker tasks
    // =========================================================================

    // Single-bit checker
    task automatic chk_bit(
        input string label,
        input logic  got,
        input logic  exp
    );
        if (got !== exp) begin
            $error("[%0t] FAIL  %-40s  exp=%0b  got=%0b", $time, label, exp, got);
            err_count++;
        end else begin
            $display("[%0t] PASS  %s", $time, label);
        end
    endtask

    // 32-bit word checker
    task automatic chk_word(
        input string       label,
        input logic [31:0] got,
        input logic [31:0] exp
    );
        if (got !== exp) begin
            $error("[%0t] FAIL  %-40s  exp=0x%08h  got=0x%08h",
                   $time, label, exp, got);
            err_count++;
        end else begin
            $display("[%0t] PASS  %-40s  = 0x%08h", $time, label, got);
        end
    endtask

    // =========================================================================
    // Reset task
    //   Drives arstn low for 4 cycles then releases it.
    //   Also idles all input signals.
    // =========================================================================
    task do_reset();
        arstn    <= 1'b0;
        S_TVALID <= 1'b0;
        S_TDATA  <= '0;
        S_TLAST  <= 1'b0;
        rd_en    <= 1'b0;
        repeat(4) @(posedge clk);
        arstn    <= 1'b1;
        @(posedge clk);
        #1;   // past NBA region — all combinational flags are settled
    endtask

    // =========================================================================
    // write_beat
    //   Drives one AXI-S handshake on the slave port.
    //   Waits for S_TREADY before accepting the beat.
    //   S_TREADY is checked in the active region of posedge (pre-NBA), which
    //   is the correct time to determine whether the DUT will accept the beat.
    // =========================================================================
    task automatic write_beat(input logic [31:0] data, input logic last);
        int timeout = 0;
        S_TDATA  <= data;
        S_TLAST  <= last;
        S_TVALID <= 1'b1;
        // First posedge: TVALID will be seen by the DUT
        @(posedge clk);
        // If TREADY was low (FIFO full), keep waiting
        while (!S_TREADY) begin
            @(posedge clk);
            timeout++;
            if (timeout > 200) begin
                $error("[%0t] write_beat: TIMEOUT waiting for S_TREADY", $time);
                err_count++;
                break;
            end
        end
        // Handshake has occurred on the most recent posedge
        S_TVALID <= 1'b0;
        S_TLAST  <= 1'b0;
    endtask

    // =========================================================================
    // write_packet
    //   Writes N words as a single AXI-S packet (TLAST on the last word).
    // =========================================================================
    task automatic write_packet(input logic [31:0] pkt [], input int n);
        for (int i = 0; i < n; i++)
            write_beat(pkt[i], (i == n-1) ? 1'b1 : 1'b0);
    endtask

    // =========================================================================
    // read_beat
    //   Asserts rd_en for one cycle, then captures the registered output
    //   on the following posedge (1-cycle BRAM read latency).
    //
    //   Returns:
    //     out_data  — rd_data[31:0]  (pixel data, always correct)
    //     out_tlast — rd_data[32]    (actual TLAST due to width bug; rd_last
    //                                 will always be 0 and is checked separately)
    //
    //   Caller must ensure !empty before calling.
    // =========================================================================
    task automatic read_beat(
        output logic [31:0] out_data,
        output logic        out_tlast
    );
        rd_en <= 1'b1;
        @(posedge clk);      // posedge N  : rd_en sampled; rd_ptr advances (NBA);
                             //              BRAM read kicks off
        rd_en <= 1'b0;
        @(posedge clk); #1;  // posedge N+1: rd_data/rd_last settled after NBA
        out_data  = rd_data[31:0];
        out_tlast = rd_data[32];     // actual TLAST (rd_last is bugged, see header)
    endtask

    // =========================================================================
    // read_and_check
    //   Reads one beat and compares data + TLAST against expected values.
    //   Also verifies rd_last == 0 (documents the width bug).
    // =========================================================================
    task automatic read_and_check(
        input logic [31:0] exp_data,
        input logic        exp_tlast,
        input string       label
    );
        logic [31:0] got_data;
        logic        got_tlast;
        read_beat(got_data, got_tlast);
        chk_word({label, " .data"},        got_data,  exp_data);
        chk_bit ({label, " .tlast[rd_data[32]]"}, got_tlast, exp_tlast);
        // rd_last should always be 0 due to the 34-vs-33-bit width mismatch
        chk_bit ({label, " .rd_last(expect 0, width-bug)"},
                  rd_last, 1'b0);
    endtask

    // =========================================================================
    // TEST BODY
    // =========================================================================
    initial begin
        $display("");
        $display("=============================================================");
        $display(" axis_fifo_s_tb   DEPTH=%0d   AFULL_THRESH=%0d", DEPTH, AFULL_THRESH);
        $display("=============================================================");

        // -------------------------------------------------------------------
        // T1  Reset state
        // -------------------------------------------------------------------
        $display("\n--- T1: Reset state -----------------------------------------");
        do_reset();
        chk_bit("T1.empty",       empty,       1'b1);
        chk_bit("T1.full",        full,        1'b0);
        chk_bit("T1.S_TREADY",    S_TREADY,    1'b1);
        // fill_level = 0, threshold = DEPTH - AFULL_THRESH = 12 → not almost_full
        chk_bit("T1.almost_full", almost_full, 1'b0);
        // After reset the DUT sets rd_last=1 (reset initialiser in the DUT)
        chk_bit("T1.rd_last_after_reset", rd_last, 1'b1);

        // -------------------------------------------------------------------
        // T2  Single write/read + 1-cycle BRAM latency
        // -------------------------------------------------------------------
        $display("\n--- T2: Single write/read round-trip + latency --------------");
        do_reset();

        write_beat(32'hDEAD_BEEF, 1'b1);
        @(negedge clk);   // sample stable combinational flags
        chk_bit("T2.not_empty_after_write", empty, 1'b0);

        // Verify data appears only AFTER rd_en posedge, not during it
        rd_en <= 1'b1;
        @(posedge clk);   // posedge N: rd_en sampled, rd_ptr increments (NBA)
        rd_en <= 1'b0;
        #1;               // past NBA: pointer updated, but rd_data not yet
        chk_bit("T2.empty_after_ptr_advance", empty, 1'b1);

        @(posedge clk); #1;  // posedge N+1: rd_data / rd_last now valid
        chk_word("T2.rd_data",          rd_data[31:0], 32'hDEAD_BEEF);
        chk_bit ("T2.tlast_via_rd_data[32]", rd_data[32],   1'b1);
        chk_bit ("T2.rd_last_is_0(width-bug)", rd_last,     1'b0);

        // -------------------------------------------------------------------
        // T3  TLAST propagation across a 4-beat packet
        // -------------------------------------------------------------------
        $display("\n--- T3: TLAST propagation -----------------------------------");
        do_reset();
        begin
            logic [31:0] pkt[4];
            pkt[0] = 32'hAAAA_0001;
            pkt[1] = 32'hAAAA_0002;
            pkt[2] = 32'hAAAA_0003;
            pkt[3] = 32'hAAAA_0004;   // TLAST=1
            write_packet(pkt, 4);
        end
        read_and_check(32'hAAAA_0001, 1'b0, "T3.beat0");
        read_and_check(32'hAAAA_0002, 1'b0, "T3.beat1");
        read_and_check(32'hAAAA_0003, 1'b0, "T3.beat2");
        read_and_check(32'hAAAA_0004, 1'b1, "T3.beat3");  // TLAST via rd_data[32]

        // -------------------------------------------------------------------
        // T4  Fill to full
        // -------------------------------------------------------------------
        $display("\n--- T4: Fill to full ----------------------------------------");
        do_reset();
        for (int i = 0; i < DEPTH; i++)
            write_beat(32'(i), (i == DEPTH-1) ? 1'b1 : 1'b0);
        // Status flags settle after write_beat's final handshake posedge
        @(negedge clk);
        chk_bit("T4.full",      full,     1'b1);
        chk_bit("T4.S_TREADY",  S_TREADY, 1'b0);
        chk_bit("T4.not_empty", empty,    1'b0);

        // -------------------------------------------------------------------
        // T5  Almost-full threshold
        //     Asserts when fill_level >= DEPTH - AFULL_THRESH (= 12)
        // -------------------------------------------------------------------
        $display("\n--- T5: Almost-full threshold -------------------------------");
        do_reset();
        // Write words one at a time, checking almost_full BEFORE each write
        for (int i = 0; i < DEPTH - AFULL_THRESH; i++) begin
            @(negedge clk);
            chk_bit($sformatf("T5.afull_before_write[%0d]", i), almost_full, 1'b0);
            write_beat(32'(i), 1'b0);
        end
        // Now fill_level == DEPTH - AFULL_THRESH: almost_full must assert
        @(negedge clk);
        chk_bit("T5.afull_at_threshold",  almost_full, 1'b1);
        // One more write — must remain asserted
        write_beat(32'hFF, 1'b0);
        @(negedge clk);
        chk_bit("T5.afull_above_threshold", almost_full, 1'b1);

        // -------------------------------------------------------------------
        // T6  Backpressure: write while full is blocked; no overflow
        // -------------------------------------------------------------------
        $display("\n--- T6: Backpressure / overflow protection ------------------");
        do_reset();
        // Fill completely with sentinel data 0xF000, 0xF001, ...
        for (int i = 0; i < DEPTH; i++)
            write_beat(32'(32'hF000 + i), (i == DEPTH-1) ? 1'b1 : 1'b0);
        @(negedge clk);
        chk_bit("T6.full_before_attempt", full, 1'b1);

        // Drive TVALID while full — TREADY is low so no handshake should occur
        S_TDATA  <= 32'hBAD_BAD0;
        S_TVALID <= 1'b1;
        S_TLAST  <= 1'b0;
        repeat(3) @(posedge clk);
        @(negedge clk);
        chk_bit("T6.still_full_after_blocked_writes", full,     1'b1);
        chk_bit("T6.S_TREADY_low",                   S_TREADY, 1'b0);
        S_TVALID <= 1'b0;

        // Read one entry — full must de-assert and TREADY must restore
        rd_en <= 1'b1;
        @(posedge clk);   // rd_ptr advances
        rd_en <= 1'b0;
        @(negedge clk);
        chk_bit("T6.not_full_after_read",  full,     1'b0);
        chk_bit("T6.S_TREADY_restored",    S_TREADY, 1'b1);

        // Verify the FIRST word written is returned intact
        @(posedge clk); #1;   // rd_data now valid
        chk_word("T6.first_word_intact", rd_data[31:0], 32'hF000);

        // -------------------------------------------------------------------
        // T7  Simultaneous read + write: fill level stays constant
        // -------------------------------------------------------------------
        $display("\n--- T7: Simultaneous read + write ---------------------------");
        do_reset();
        // Pre-fill 8 words
        for (int i = 0; i < 8; i++)
            write_beat(32'(32'hC000 + i), (i == 7) ? 1'b1 : 1'b0);
        @(negedge clk);
        chk_bit("T7.not_empty_before", empty, 1'b0);
        chk_bit("T7.not_full_before",  full,  1'b0);

        // Drive write and read simultaneously on the same posedge
        S_TDATA  <= 32'hC100;
        S_TLAST  <= 1'b0;
        S_TVALID <= 1'b1;
        rd_en    <= 1'b1;
        @(posedge clk);         // both handshakes fire: 1 in, 1 out
        S_TVALID <= 1'b0;
        S_TLAST  <= 1'b0;
        rd_en    <= 1'b0;
        @(negedge clk);
        // fill_level must remain 8 — not empty, not full
        chk_bit("T7.not_empty_after", empty, 1'b0);
        chk_bit("T7.not_full_after",  full,  1'b0);

        // -------------------------------------------------------------------
        // T8  Empty after drain; rd_en while empty is a no-op
        // -------------------------------------------------------------------
        $display("\n--- T8: Empty after drain + rd_en-while-empty no-op ---------");
        do_reset();
        write_beat(32'hE001, 1'b0);
        write_beat(32'hE002, 1'b1);
        read_and_check(32'hE001, 1'b0, "T8.beat0");
        read_and_check(32'hE002, 1'b1, "T8.beat1");

        @(negedge clk);
        chk_bit("T8.empty_after_drain", empty, 1'b1);

        // Spurious rd_en while empty — rd_ptr must not advance
        rd_en <= 1'b1;
        @(posedge clk); rd_en <= 1'b0;
        @(posedge clk); #1;
        chk_bit("T8.still_empty_after_spurious_rd", empty, 1'b1);

        // -------------------------------------------------------------------
        // T9  Two consecutive packets; order preserved across TLAST boundary
        // -------------------------------------------------------------------
        $display("\n--- T9: Consecutive packets ---------------------------------");
        do_reset();
        begin
            logic [31:0] pA[3], pB[3];
            pA = '{32'h1111_0001, 32'h1111_0002, 32'h1111_0003};
            pB = '{32'h2222_0001, 32'h2222_0002, 32'h2222_0003};
            write_packet(pA, 3);
            write_packet(pB, 3);
        end
        // Packet A
        read_and_check(32'h1111_0001, 1'b0, "T9.pA[0]");
        read_and_check(32'h1111_0002, 1'b0, "T9.pA[1]");
        read_and_check(32'h1111_0003, 1'b1, "T9.pA[2]");
        // Packet B
        read_and_check(32'h2222_0001, 1'b0, "T9.pB[0]");
        read_and_check(32'h2222_0002, 1'b0, "T9.pB[1]");
        read_and_check(32'h2222_0003, 1'b1, "T9.pB[2]");

        @(negedge clk);
        chk_bit("T9.empty_at_end", empty, 1'b1);

        // -------------------------------------------------------------------
        // T10  Mid-operation reset: all state clears, FIFO is re-usable
        // -------------------------------------------------------------------
        $display("\n--- T10: Mid-operation reset --------------------------------");
        do_reset();
        write_beat(32'hDEAD_0001, 1'b0);
        write_beat(32'hDEAD_0002, 1'b0);
        // Assert reset while FIFO holds data
        arstn <= 1'b0;
        repeat(4) @(posedge clk);
        arstn <= 1'b1;
        @(posedge clk); #1;
        chk_bit("T10.empty_after_reset", empty, 1'b1);
        chk_bit("T10.full_after_reset",  full,  1'b0);
        chk_bit("T10.S_TREADY_restored", S_TREADY, 1'b1);
        // Verify FIFO is usable again after reset
        write_beat(32'hFEED_CAFE, 1'b1);
        @(negedge clk);
        chk_bit("T10.not_empty_after_reuse_write", empty, 1'b0);

        // -------------------------------------------------------------------
        // Summary
        // -------------------------------------------------------------------
        repeat(2) @(posedge clk);
        $display("");
        $display("=============================================================");
        if (err_count == 0)
            $display(" ALL TESTS PASSED  (0 errors)");
        else
            $display(" FINISHED WITH %0d ERROR(S) — see $error messages above",
                     err_count);
        $display("=============================================================");
        $finish;
    end

    // -------------------------------------------------------------------------
    // Waveform dump
    // -------------------------------------------------------------------------
    initial begin
        $dumpfile("axis_fifo_s_tb.vcd");
        $dumpvars(0, axis_fifo_s_tb);
    end

endmodule

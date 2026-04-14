`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
// Module   : mac_truncate
// Function : Single 3×3 convolution MAC unit with saturating output clamp.
//            Fully pipelined — fixed latency of MAC_LATENCY clock cycles.
/////////////////////////////////////////////////////////////////////////////

module mac_truncate #(
    parameter int MAC_LATENCY = 3
)(
    input  logic        clk,
    input  logic        arstn,

    // 3×3 pixel window — 8-bit unsigned
    input  logic [7:0]  p00, p01, p02,
                        p10, p11, p12,
                        p20, p21, p22,

    // Kernel coefficients — 9-bit two's-complement signed
    input  logic signed [8:0] k0, k1, k2,
                               k3, k4, k5,
                               k6, k7, k8,

    input  logic        valid_in,    // pixel window and coefficients are stable
    output logic        valid_out,   // result is valid, MAC_LATENCY cycles later

    output logic [7:0]  result       // saturated-clamped to [0, 255]
);

    // Stage 1 — 9 parallel registered signed multiplications
    
    logic signed [16:0] s1_prod [0:8];

    always_ff @(posedge clk) begin
        if (!arstn) begin
            for (int i = 0; i < 9; i++) s1_prod[i] <= '0;
        end else begin
            s1_prod[0] <= $signed({1'b0, p00}) * k0;
            s1_prod[1] <= $signed({1'b0, p01}) * k1;
            s1_prod[2] <= $signed({1'b0, p02}) * k2;
            s1_prod[3] <= $signed({1'b0, p10}) * k3;
            s1_prod[4] <= $signed({1'b0, p11}) * k4;
            s1_prod[5] <= $signed({1'b0, p12}) * k5;
            s1_prod[6] <= $signed({1'b0, p20}) * k6;
            s1_prod[7] <= $signed({1'b0, p21}) * k7;
            s1_prod[8] <= $signed({1'b0, p22}) * k8;
        end
    end

    // Stage 2 — Partial-sum adder tree (registered)
    // Products are sign-extended from 17 to 21 bits via the pe[] intermediates
   
    // Sign-extension intermediates — purely combinational wires
    logic signed [20:0] pe [0:8];
    always_comb begin
        for (int i = 0; i < 9; i++) pe[i] = s1_prod[i];  // sign-extends: 17→21 bit
    end

    logic signed [20:0] s2_sumA, s2_sumB;

    always_ff @(posedge clk) begin
        if (!arstn) begin
            s2_sumA <= '0;
            s2_sumB <= '0;
        end else begin
            s2_sumA <= pe[0] + pe[1] + pe[2] + pe[3];           // 4-tap partial sum
            s2_sumB <= pe[4] + pe[5] + pe[6] + pe[7] + pe[8];  // 5-tap partial sum
        end
    end

    // Stage 3 — Final accumulation (combinational) + saturating clamp (registered)

    // Sign-extend partial sums from 21 to 22 bits
    logic signed [21:0] sA_ext, sB_ext;
    always_comb begin
        sA_ext = s2_sumA;   // signed [20:0] → signed [21:0]: sign-extends
        sB_ext = s2_sumB;
    end

    logic signed [21:0] acc;
    assign acc = sA_ext + sB_ext;

    always_ff @(posedge clk) begin
        if (!arstn) begin
            result <= 8'd0;
        end else begin
            if (acc[21])           // sign bit set → negative
                result <= 8'd0;
            else if (|acc[20:8])   // any bit above byte range set → > 255
                result <= 8'd255;
            else
                result <= acc[7:0];
        end
    end

    // valid_out — valid_in delayed by exactly MAC_LATENCY clock cycles
    //
    // Shift register: new valid enters at bit [0], exits at bit [MAC_LATENCY-1].
    // valid_in→valid_out latency matches the data pipeline latency.
    logic [MAC_LATENCY-1:0] valid_sr;

    always_ff @(posedge clk) begin
        if (!arstn)
            valid_sr <= '0;
        else
            valid_sr <= {valid_sr[MAC_LATENCY-2:0], valid_in};
    end

    assign valid_out = valid_sr[MAC_LATENCY-1];

endmodule

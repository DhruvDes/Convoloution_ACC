`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 10:19:00 PM
// Design Name: 
// Module Name: macTrunCore
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

(* use_dsp = "yes" *)
module mac_truncate #(
    parameter int MAC_LATENCY = 2
) (
    input  logic              clk,
    input  logic              arstn,
    input  logic        [7:0]   p00,
                                p01,
                                p02,
                                p10,
                                p11,
                                p12,
                                p20,
                                p21,
                                p22,
    input  logic signed [8:0]   k0,
                                k1,
                                k2,
                                k3,
                                k4,
                                k5,
                                k6,
                                k7,
                                k8,
    input  logic              valid_in,
    output logic              valid_out,
    output logic        [7:0] result
);

  // Stage 1 - Register all inputs
  logic [7:0] p00_r, p01_r, p02_r, p10_r, p11_r, p12_r, p20_r, p21_r, p22_r;
  logic signed [8:0] k0_r, k1_r, k2_r, k3_r, k4_r, k5_r, k6_r, k7_r, k8_r;

  always_ff @(posedge clk) begin
    if (!arstn) begin
      {p00_r, p01_r, p02_r} <= '0;
      {p10_r, p11_r, p12_r} <= '0;
      {p20_r, p21_r, p22_r} <= '0;
      {k0_r, k1_r, k2_r} <= '0;
      {k3_r, k4_r, k5_r} <= '0;
      {k6_r, k7_r, k8_r} <= '0;
    end else if (valid_in) begin
      p00_r <= p00;
      p01_r <= p01;
      p02_r <= p02;
      p10_r <= p10;
      p11_r <= p11;
      p12_r <= p12;
      p20_r <= p20;
      p21_r <= p21;
      p22_r <= p22;
      k0_r  <= k0;
      k1_r  <= k1;
      k2_r  <= k2;
      k3_r  <= k3;
      k4_r  <= k4;
      k5_r  <= k5;
      k6_r  <= k6;
      k7_r  <= k7;
      k8_r  <= k8;
    end
  end

  // Combinational multiplications
  
  logic signed [17:0] s1_prod[0:8];
  
  always_ff @(posedge clk) begin
    s1_prod[0] <= $signed({1'b0, p00_r}) * k8_r;
    s1_prod[1] <= $signed({1'b0, p01_r}) * k7_r;
    s1_prod[2] <= $signed({1'b0, p02_r}) * k6_r;
    s1_prod[3] <= $signed({1'b0, p10_r}) * k5_r;
    s1_prod[4] <= $signed({1'b0, p11_r}) * k4_r;
    s1_prod[5] <= $signed({1'b0, p12_r}) * k3_r;
    s1_prod[6] <= $signed({1'b0, p20_r}) * k2_r;
    s1_prod[7] <= $signed({1'b0, p21_r}) * k1_r;
    s1_prod[8] <= $signed({1'b0, p22_r}) * k0_r;
  end



  // Combinational partial sums
  logic signed [20:0] s2_sumA, s2_sumB;
  
  always_ff @ (posedge clk) begin
    s2_sumA <= s1_prod[0] + s1_prod[1] + s1_prod[2] + s1_prod[3];
    s2_sumB <= s1_prod[4] + s1_prod[5] + s1_prod[6] + s1_prod[7] + s1_prod[8];
  end



  logic signed [21:0] acc;
 
  assign acc = s2_sumA + s2_sumB;

  // Stage 2 - Registered saturating clamp
  always_ff @(posedge clk) begin
    if (!arstn) result <= 8'd0;
    else if (acc[21]) result <= 8'd0;
    else if (|acc[20:8]) result <= 8'd255;
    else result <= acc[7:0];
  end

  // Valid pipeline
  logic valid_s1, valid_s2, valid_s3, valid_s4;

  always_ff @(posedge clk) begin
    if (!arstn) begin
      valid_s1 <= 1'b0;
      valid_s2 <= 1'b0;
    end else begin
      valid_s1 <= valid_in;  // aligns with stage 1 (input regs)
      valid_s2 <= valid_s1;  // aligns with stage 2 (result reg)
      valid_s3 <= valid_s2;
      valid_s4 <= valid_s3;

    end
  end

  assign valid_out = valid_s4;
endmodule












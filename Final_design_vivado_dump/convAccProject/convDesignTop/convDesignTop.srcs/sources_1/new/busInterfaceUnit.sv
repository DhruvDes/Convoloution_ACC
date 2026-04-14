`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 07:44:21 PM
// Design Name: 
// Module Name: busInterfaceUnit
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


module busInterfaceUnit #(
    parameter int unsigned CFG_PKTS     = 3,
    parameter int unsigned IN_DEPTH     = 512,
    parameter int unsigned RES_DEPTH    = 256,
    parameter int unsigned AFULL_THRESH = 8
)(
    input  logic        clk,
    input  logic        arstn,
 
    // AXI-S slave in (from AXI DMA MM2S)
    input  logic [31:0] S_TDATA,
    input  logic        S_TVALID,
    input  logic        S_TLAST,
    output logic        S_TREADY,
 
    // AXI-S master out - pixel data → line_buffer
    output logic [31:0] M_PX_TDATA,
    output logic        M_PX_TVALID,
    output logic        M_PX_TLAST,
    input  logic        M_PX_TREADY,
 
    // Config write port → cf_mem
    output logic [31:0] cfg_data,
    output logic        cfg_valid,
    input  logic        cfg_ready,
 
    // Result write port (32-bit, from external packer)
    input  logic [31:0] res_wdata,
    input  logic        res_wlast,
    input  logic        res_wvalid,
 
    // AXI-S master out - results → AXI DMA S2MM
    output logic [31:0] M_RES_TDATA,
    output logic        M_RES_TVALID,
    output logic        M_RES_TLAST,
    input  logic        M_RES_TREADY,
 
    // Status
    output logic        px_almost_full,
    output logic        res_almost_full,
    output logic        frame_start
);
 
    // =========================================================================
    // Shared input FIFO
    // =========================================================================
    logic        in_fifo_empty;
    logic        in_fifo_full;
    logic [32:0] in_fifo_rd_data;
    logic        in_fifo_rd_last;
    logic        in_rd_en;
 
    axis_fifo_s #(
        .DEPTH        (IN_DEPTH),
        .AFULL_THRESH (AFULL_THRESH)
    ) u_in_fifo (
        .clk      (clk),
        .arstn    (arstn),
        .S_TDATA  (S_TDATA),
        .S_TVALID (S_TVALID),
        .S_TLAST  (S_TLAST),
        .S_TREADY (S_TREADY),
        .rd_en    (in_rd_en),
        .rd_data  (in_fifo_rd_data),
        .rd_last  (in_fifo_rd_last),
        .empty    (in_fifo_empty),
        .full     (in_fifo_full),
        .almost_full (px_almost_full)
    );
 
    // =========================================================================
    // Read-side packet counter - config vs. pixel demux
    // =========================================================================
    localparam int unsigned CNT_W = $clog2(CFG_PKTS + 1);
 
    logic [CNT_W-1:0] txn_cnt;
    logic              is_cfg;
 
    assign is_cfg = (txn_cnt < CFG_PKTS[CNT_W-1:0]);
 
    // =========================================================================
    // Read-side control - handles 1-cycle BRAM read latency
    // =========================================================================
    logic rd_pending;
 
    // Config: drain when FIFO has data and output can accept
    logic cfg_rd_en;
    logic cfg_data_valid;
 
    assign cfg_rd_en = is_cfg && !in_fifo_empty && !rd_pending
                       && (!cfg_data_valid || (cfg_valid && cfg_ready));
 
    // Pixel: drain when FIFO has data and output can accept
    logic px_rd_en;
    logic px_data_valid;
 
    assign px_rd_en = !is_cfg && !in_fifo_empty && !rd_pending
                      && (!px_data_valid || (M_PX_TVALID && M_PX_TREADY));
 
    assign in_rd_en = cfg_rd_en | px_rd_en;
 
    always_ff @(posedge clk) begin
        if (!arstn)
            rd_pending <= 1'b0;
        else
            rd_pending <= in_rd_en;
    end
 
    // =========================================================================
    // Config valid/ready handshake - one cycle after cfg_rd_en
    // =========================================================================
    logic rd_was_cfg;
 
    always_ff @(posedge clk) begin
        if (!arstn)
            rd_was_cfg <= 1'b0;
        else
            rd_was_cfg <= cfg_rd_en;
    end
 
    always_ff @(posedge clk) begin
        if (!arstn)
            cfg_data_valid <= 1'b0;
        else if (rd_was_cfg)
            cfg_data_valid <= 1'b1;
        else if (cfg_valid && cfg_ready)
            cfg_data_valid <= 1'b0;
        else if (txn_cnt == 4) // Deassert valid after last config word
            cfg_data_valid <= 1'b0;
    end
 
    assign cfg_data  = in_fifo_rd_data[31:0];
    assign cfg_valid = cfg_data_valid;
 
    always_ff @(posedge clk) begin
        if (!arstn)
            txn_cnt <= '0;
        else if (cfg_valid && cfg_ready && is_cfg)
            txn_cnt <= txn_cnt + 1'b1;
    end
 
    // =========================================================================
    // Pixel AXI-S master bridge
    // =========================================================================
    // rd_pending is asserted the same cycle BRAM data appears on in_fifo_rd_data.
    // Use it (qualified to the pixel path) instead of a second pipeline stage
    // so that M_PX_TVALID rises one cycle earlier than the original rd_was_px.
    logic rd_is_px;
    assign rd_is_px = rd_pending && !is_cfg;
 
    always_ff @(posedge clk) begin
        if (!arstn)
            px_data_valid <= 1'b0;
        else if (rd_is_px)
            px_data_valid <= 1'b1;
        else if (M_PX_TVALID && M_PX_TREADY && !rd_is_px)
            px_data_valid <= 1'b0;
    end
 
    assign M_PX_TDATA  = in_fifo_rd_data[31:0];
    assign M_PX_TLAST  = in_fifo_rd_last;
    assign M_PX_TVALID = px_data_valid;
 
    // =========================================================================
    // frame_start - pulses once on first pixel word out
    // =========================================================================
    // Now derived from rd_is_px (1 cycle earlier than previous rd_was_px).
    logic frame_start_sent;
 
    always_ff @(posedge clk) begin
        if (!arstn)
            frame_start_sent <= 1'b0;
        else if (rd_is_px && !frame_start_sent)
            frame_start_sent <= 1'b1;
    end
 
    assign frame_start = rd_is_px && !frame_start_sent;
 
    // =========================================================================
    // Result output FIFO - 32-bit words written directly, no packing
    // =========================================================================
    logic res_fifo_full;
 
    axis_fifo_m #(
        .DEPTH        (RES_DEPTH),
        .AFULL_THRESH (AFULL_THRESH)
    ) u_res_fifo (
        .clk      (clk),
        .arstn    (arstn),
        .wr_data  (res_wdata),
        .wr_last  (res_wlast),
        .wr_en    (res_wvalid & ~res_fifo_full),
        .M_TDATA  (M_RES_TDATA),
        .M_TVALID (M_RES_TVALID),
        .M_TLAST  (M_RES_TLAST),
        .M_TREADY (M_RES_TREADY),
        .full     (res_fifo_full),
        .empty    (),
        .almost_full (res_almost_full)
    );
 
endmodule
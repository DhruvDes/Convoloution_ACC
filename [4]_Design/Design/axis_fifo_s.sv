`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 09:58:45 AM
// Design Name: 
// Module Name: axis_fifo_s
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


module axis_fifo_s #(
    parameter int unsigned DEPTH        = 8,
    parameter int unsigned AFULL_THRESH = 8
)(
    input  logic        clk,
    input  logic        arstn,
 
    // -------------------------------------------------------------------------
    // Slave port  -  AXI-S from AXI DMA MM2S
    // -------------------------------------------------------------------------
    input  logic [31:0] S_TDATA,
    input  logic        S_TVALID,
    input  logic        S_TLAST,
    output logic        S_TREADY,       // combinational ~full
 
    // -------------------------------------------------------------------------
    // Read port  -  simple FWFT interface to internal BUI logic
    // -------------------------------------------------------------------------
    input  logic        rd_en,          // consume current word; advance pointer
    output logic [32:0] rd_data,        // registered BRAM output
    output logic        rd_last,        // TLAST associated with rd_data
    output logic        empty,          // no valid data available
 
    // -------------------------------------------------------------------------
    // Status
    // -------------------------------------------------------------------------
    output logic        full,
    output logic        almost_full
);
 
    // =========================================================================
    // Local parameters
    // =========================================================================
    localparam int unsigned ADDR_W = $clog2(DEPTH);
    localparam int unsigned PTR_W  = ADDR_W + 1;   // extra MSB for full/empty
 
    // =========================================================================
    // BRAM storage  -  33-bit words: {TLAST, TDATA[31:0]}
    // Xilinx SDP (simple dual-port) BRAM inference:
    //   - One synchronous write port
    //   - One synchronous read port (registered output = 1-cycle latency)
    //   - "read-first" mode on address collision (safe, never intentional here)
    // =========================================================================
    (* ram_style = "block" *)
    logic [32:0] mem [0:DEPTH-1];
 
    // =========================================================================
    // Pointers  -  (ADDR_W+1)-bit binary counters
    // =========================================================================
    logic [PTR_W-1:0] wr_ptr;
    logic [PTR_W-1:0] rd_ptr;
 
    // =========================================================================
    // Status flags
    // =========================================================================
    logic [PTR_W-1:0] fill_level;
 
    assign empty       = (wr_ptr == rd_ptr);
    assign full        = (wr_ptr[PTR_W-1]    != rd_ptr[PTR_W-1]) &&
                         (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);
    assign fill_level  =  wr_ptr - rd_ptr;
    assign almost_full = (fill_level >= (DEPTH - AFULL_THRESH));
    assign S_TREADY    = ~full;
 
    // =========================================================================
    // Handshake strobes
    // =========================================================================
    logic wr_en;
    assign wr_en = S_TVALID & S_TREADY;
 
    // =========================================================================
    // Write path  -  synchronous BRAM write
    // =========================================================================
    always_ff @(posedge clk) begin
        if (wr_en) begin
            mem[wr_ptr[ADDR_W-1:0]] <= {S_TLAST, S_TDATA};
        end
    end
 
    always_ff @(posedge clk) begin
        if (!arstn) wr_ptr <= '0;
        else if (wr_en) wr_ptr <= wr_ptr + 1'b1;
    end
 
    // =========================================================================
    // Read path  -  synchronous BRAM read (registered output)
    //
    // The BRAM read port is clocked: rd_data/rd_last are valid the cycle
    // AFTER rd_en is asserted. The read pointer advances on rd_en so the
    // next address is presented to the BRAM in the same cycle, and the
    // result appears one cycle later - standard FWFT behaviour.
    //
    // The caller (BUI logic) must qualify rd_data with !empty. Because
    // empty is based on pointers (not the BRAM output register), it reflects
    // the true occupancy and can be used as-is for flow control.
    // =========================================================================
    always_ff @(posedge clk) begin
        if (!arstn) begin
            rd_ptr <= '0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1'b1;
        end
    end
 
    // Synchronous BRAM read - no reset on output register (BRAM primitive
    // does not support reset on the output register in most Xilinx families).
    always_ff @(posedge clk) begin
        if(!arstn) rd_last <= 1; else begin
        if (rd_en && !empty) begin
            {rd_last, rd_data} <= mem[rd_ptr[ADDR_W-1:0]];
            end
        end
    end
 
//     // =========================================================================
//     // Simulation assertions
//     // =========================================================================
// `ifndef SYNTHESIS
//     initial begin : param_check
//         assert ((DEPTH & (DEPTH - 1)) == 0)
//             else $fatal(1, "axis_fifo_s: DEPTH=%0d must be a power of 2", DEPTH);
//         assert (AFULL_THRESH < DEPTH)
//             else $fatal(1, "axis_fifo_s: AFULL_THRESH=%0d must be < DEPTH=%0d",
//                         AFULL_THRESH, DEPTH);
//         assert (DEPTH >= 2)
//             else $fatal(1, "axis_fifo_s: DEPTH=%0d must be >= 2", DEPTH);
//     end
 
//     no_overflow_chk: assert property (
//         @(posedge clk) disable iff (!arstn)
//         full |-> !wr_en
//     ) else $error("axis_fifo_s: overflow - write while full");
 
//     no_underflow_chk: assert property (
//         @(posedge clk) disable iff (!arstn)
//         (rd_en && empty) |-> 1'b0
//     ) else $error("axis_fifo_s: underflow - rd_en while empty");
// `endif
 
endmodule
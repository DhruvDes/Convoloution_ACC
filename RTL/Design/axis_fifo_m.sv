// Code your design here
module axis_fifo_m #(
    parameter int unsigned DEPTH        = 256,
    parameter int unsigned AFULL_THRESH = 8
)(
    input  logic        clk,
    input  logic        arstn,
 
    // -------------------------------------------------------------------------
    // Write port  -  from internal BUI result packer
    // -------------------------------------------------------------------------
    input  logic [31:0] wr_data,        // 32-bit result word
    input  logic        wr_last,        // TLAST flag for this word
    input  logic        wr_en,          // write strobe (caller must check ~full)
 
    // -------------------------------------------------------------------------
    // Master port  -  AXI-S to AXI DMA S2MM
    // -------------------------------------------------------------------------
    output logic [31:0] M_TDATA,
    output logic        M_TVALID,
    output logic        M_TLAST,
    input  logic        M_TREADY,
 
    // -------------------------------------------------------------------------
    // Status
    // -------------------------------------------------------------------------
    output logic        full,
    output logic        empty,
    output logic        almost_full
);
 
    // =========================================================================
    // Local parameters
    // =========================================================================
    localparam int unsigned ADDR_W = $clog2(DEPTH);
    localparam int unsigned PTR_W  = ADDR_W + 1;       // extra MSB for full/empty
 
    // =========================================================================
    // BRAM storage  -  33-bit words: {TLAST, TDATA[31:0]}
    // Xilinx SDP (simple dual-port) BRAM inference:
    //   - One synchronous write port
    //   - One synchronous read port (registered output = 1-cycle latency)
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
 
    // =========================================================================
    // Write path  -  synchronous BRAM write
    // =========================================================================
    always_ff @(posedge clk) begin
        if (wr_en && !full) begin
            mem[wr_ptr[ADDR_W-1:0]] <= {wr_last, wr_data};
        end
    end
 
    always_ff @(posedge clk) begin
        if (!arstn)
            wr_ptr <= '0;
        else if (wr_en && !full)
            wr_ptr <= wr_ptr + 1'b1;
    end
 
    // =========================================================================
    // AXI-S master read path  -  FWFT with registered BRAM output
    //
    // Because the BRAM output is registered (1-cycle read latency), we use a
    // small output register stage to present true FWFT behaviour on the AXI-S
    // master port:
    //
    //   BRAM[rd_ptr] ---(1 clk)---> pipe_data/pipe_valid
    //                                      |
    //                               M_TDATA / M_TVALID / M_TLAST
    //                                      |
    //                               M_TREADY (consumer handshake)
    //
    // The pipe stage decouples the BRAM read latency from the AXI-S handshake
    // so that M_TVALID asserts combinationally based on pipe occupancy, and
    // M_TREADY acknowledgement triggers the next BRAM read.
    // =========================================================================
 
    // --- BRAM read port signals ---
    logic        bram_rd_en;
    logic [31:0] bram_dout;
    logic        bram_dlast;
    logic        bram_dvalid;           // tracks whether bram output is fresh
 
    // --- Output pipeline register ---
    logic [31:0] pipe_data;
    logic        pipe_last;
    logic        pipe_valid;
 
    // BRAM read: issue a read when the pipe is empty (or being consumed) and
    // the FIFO has data.  We read from rd_ptr; the data appears next cycle.
    assign bram_rd_en = !empty && (!pipe_valid || (M_TVALID && M_TREADY));
 
    // Synchronous BRAM read - registered output
    always_ff @(posedge clk) begin
        if (!arstn) begin
            bram_dvalid <= 1'b0;
        end else begin
            bram_dvalid <= bram_rd_en;
        end
    end
 
    always_ff @(posedge clk) begin
        if (bram_rd_en) begin
            {bram_dlast, bram_dout} <= mem[rd_ptr[ADDR_W-1:0]];
        end
    end
 
    // Read pointer advances when we issue a BRAM read
    always_ff @(posedge clk) begin
        if (!arstn)
            rd_ptr <= '0;
        else if (bram_rd_en)
            rd_ptr <= rd_ptr + 1'b1;
    end
 
    // --- Output pipe register ---
    // Loads from BRAM output when bram_dvalid, drains on AXI-S handshake.
    always_ff @(posedge clk) begin
        if (!arstn) begin
            pipe_valid <= 1'b0;
            pipe_data  <= '0;
            pipe_last  <= 1'b0;
        end else begin
            if (bram_dvalid && (!pipe_valid || (M_TVALID && M_TREADY))) begin
                // Load new data from BRAM output
                pipe_valid <= 1'b1;
                pipe_data  <= bram_dout;
                pipe_last  <= bram_dlast;
            end else if (M_TVALID && M_TREADY && !bram_dvalid) begin
                // Consumed but no new data arriving - pipe goes empty
                pipe_valid <= 1'b0;
            end
        end
    end
 
    // --- AXI-S master outputs ---
    assign M_TDATA  = pipe_data;
    assign M_TLAST  = pipe_last;
    assign M_TVALID = pipe_valid;
 
 
endmodule
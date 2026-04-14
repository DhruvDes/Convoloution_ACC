
`timescale 1 ns / 1 ps

//	module lpbk_tst #
//	(
//		// Users to add parameters here

//		// User parameters ends
//		// Do not modify the parameters beyond this line


//		// Parameters of Axi Slave Bus Interface S01_AXIS
//		parameter integer C_S01_AXIS_TDATA_WIDTH	= 32,

//		// Parameters of Axi Master Bus Interface M00_AXIS
//		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
//		parameter integer C_M00_AXIS_START_COUNT	= 32
//	)
//	(
//		// Users to add ports here

//		// User ports ends
//		// Do not modify the ports beyond this line


//		// Ports of Axi Slave Bus Interface S01_AXIS
//		input wire  s01_axis_aclk,
//		input wire  s01_axis_aresetn,
//		output wire  s01_axis_tready,
//		input wire [C_S01_AXIS_TDATA_WIDTH-1 : 0] s01_axis_tdata,
//		input wire [(C_S01_AXIS_TDATA_WIDTH/8)-1 : 0] s01_axis_tstrb,
//		input wire  s01_axis_tlast,
//		input wire  s01_axis_tvalid,

//		// Ports of Axi Master Bus Interface M00_AXIS
//		input wire  m00_axis_aclk,
//		input wire  m00_axis_aresetn,
//		output wire  m00_axis_tvalid,
//		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
//		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
//		output wire  m00_axis_tlast,
//		input wire  m00_axis_tready
//	);

//    // =========================================================================
//    // Internal clock / reset aliases
//    // =========================================================================
//    wire clk   = s01_axis_aclk;
//    wire arstn = s01_axis_aresetn;
 
//    // TSTRB not stored - master side all bytes valid
//    assign m00_axis_tstrb = {(C_M00_AXIS_TDATA_WIDTH/8){1'b1}};
 
//    // =========================================================================
//    // IN FIFO  :  axis_fifo_s
//    //   Write port  - wired directly to S01_AXIS slave signals
//    //   Read port   - raw rd_en / rd_data / rd_last / empty → bridge FSM
//    // =========================================================================
//    wire        in_rd_en;
//    wire [32:0] in_rd_data;  // {TLAST, TDATA[31:0]} per axis_fifo_s storage format
//    wire        in_rd_last;
//    wire        in_empty;
//    wire        in_full;
//    wire        in_almost_full;
 
//    axis_fifo_s  u_in_fifo (
//        .clk         (clk),
//        .arstn       (arstn),
 
//        // Slave write port - straight through from S01_AXIS
//        .S_TDATA     (s01_axis_tdata),
//        .S_TVALID    (s01_axis_tvalid),
//        .S_TLAST     (s01_axis_tlast),
//        .S_TREADY    (s01_axis_tready),   // backpressure to DMA MM2S
 
//        // Raw read port → bridge FSM
//        .rd_en       (in_rd_en),
//        .rd_data     (in_rd_data),
//        .rd_last     (in_rd_last),
//        .empty       (in_empty),
 
//        .full        (in_full),
//        .almost_full (in_almost_full)
//    );
 
//    // =========================================================================
//    // OUT FIFO  :  axis_fifo_m
//    //   Write port  - driven by bridge FSM (wr_en / wr_data / wr_last)
//    //   Master port - wired directly to M00_AXIS master signals
//    //                 axis_fifo_m handles its own skid buffer internally,
//    //                 so no master FSM is needed here.
//    // =========================================================================
//    wire        out_wr_en;
//    wire [31:0] out_wr_data;
//    wire        out_wr_last;
//    wire        out_full;
//    wire        out_empty;
//    wire        out_almost_full;
 
//    axis_fifo_m  u_out_fifo (
//        .clk         (clk),
//        .arstn       (arstn),
 
//        // Write port - driven by bridge FSM
//        .wr_en       (out_wr_en),
//        .wr_data     (out_wr_data),
//        .wr_last     (out_wr_last),
 
//        // AXI-S master port - straight through to M00_AXIS
//        .M_TDATA     (m00_axis_tdata),
//        .M_TVALID    (m00_axis_tvalid),
//        .M_TLAST     (m00_axis_tlast),
//        .M_TREADY    (m00_axis_tready),  // backpressure from DMA S2MM
 
//        .full        (out_full),
//        .empty       (out_empty),
//        .almost_full (out_almost_full)
//    );
 

//    localparam [1:0] BR_IDLE    = 2'b00,
//                     BR_PENDING = 2'b01,
//                     BR_WRITE   = 2'b10;
 
//    reg [1:0]  br_state;
//    reg [31:0] br_data;
//    reg        br_last;
 
//    always @(posedge clk) begin
//        if (!arstn) begin
//            br_state <= BR_IDLE;
//            br_data  <= 32'd0;
//            br_last  <= 1'b0;
//        end else begin
//            case (br_state)
 
//                // Wait for data available AND space in OUT FIFO
//                BR_IDLE: begin
//                    if (!in_empty && !out_full)
//                        br_state <= BR_PENDING;
//                end
 
//                // in_rd_data / in_rd_last are valid this cycle - capture them
//                BR_PENDING: begin
//                    br_data  <= in_rd_data[31:0];
//                    br_last  <= in_rd_last;
//                    br_state <= BR_WRITE;
//                end
 
//                // wr_en held for one cycle; return to IDLE
//                BR_WRITE: begin
//                    br_state <= BR_IDLE;
//                end
 
//                default: br_state <= BR_IDLE;
 
//            endcase
//        end
//    end
 
//    // in_rd_en : pulse in IDLE when both FIFOs are ready
//    assign in_rd_en   = (!in_empty && !out_full && (br_state == BR_IDLE));
 
//    // axis_fifo_m write port : push captured word during WRITE state
//    assign out_wr_en   = (br_state == BR_WRITE);
//    assign out_wr_data = br_data;
//    assign out_wr_last = br_last;
 
//endmodule

 
module lpbk_tst #(
    // ── AMD IP packager parameters - do not remove ───────────────────────────
    parameter integer C_S01_AXIS_TDATA_WIDTH = 32,
    parameter integer C_M00_AXIS_TDATA_WIDTH = 32,
    parameter integer C_M00_AXIS_START_COUNT = 32,    // unused, kept for compliance
 
    // ── FIFO depth parameters ─────────────────────────────────────────────────
    parameter integer DEPTH        = 512,
    parameter integer AFULL_THRESH = 8,
 
    // ── Frame configuration - sets where TLAST fires on the output ────────────
    // num_cols : output words per row
    //   Loopback pixel test : ROW_WIDTH / 4  (e.g. 64/4 = 16)
    //   Conv accel result   : ceil((ROW_WIDTH-2) / 4)  (e.g. ceil(62/4) = 16)
    parameter integer NUM_ROWS = 8,    // total output rows per frame
    parameter integer NUM_COLS = 16    // output words per row
)(
    // ── AXI-S Slave  S01_AXIS  (from AXI DMA MM2S) ───────────────────────────
    input  wire                                     s01_axis_aclk,
    input  wire                                     s01_axis_aresetn,
    output wire                                     s01_axis_tready,
    input  wire [C_S01_AXIS_TDATA_WIDTH-1 : 0]     s01_axis_tdata,
    input  wire [(C_S01_AXIS_TDATA_WIDTH/8)-1 : 0] s01_axis_tstrb,   // accepted, not stored
    input  wire                                     s01_axis_tlast,
    input  wire                                     s01_axis_tvalid,
 
    // ── AXI-S Master  M00_AXIS  (to AXI DMA S2MM) ────────────────────────────
    input  wire                                     m00_axis_aclk,    // tied to s01 domain
    input  wire                                     m00_axis_aresetn, // tied to s01 domain
    output wire                                     m00_axis_tvalid,
    output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0]     m00_axis_tdata,
    output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,   // driven all-ones
    output wire                                     m00_axis_tlast,
    input  wire                                     m00_axis_tready
);
 
    // =========================================================================
    // Internal clock / reset  -  single domain, s01 drives everything
    // =========================================================================
    wire clk   = s01_axis_aclk;
    wire arstn = s01_axis_aresetn;
 
    // TSTRB not stored - master side all bytes valid
    assign m00_axis_tstrb = {(C_M00_AXIS_TDATA_WIDTH/8){1'b1}};
 
    // =========================================================================
    // IN FIFO  :  axis_fifo_s
    //   Write port  - wired directly to S01_AXIS
    //   Read port   - raw rd_en / rd_data / rd_last / empty → bridge FSM
    // =========================================================================
    wire        in_rd_en;
    wire [32:0] in_rd_data;   // {TLAST, TDATA[31:0]}
    wire        in_rd_last;
    wire        in_empty;
    wire        in_full;
    wire        in_almost_full;
 
    axis_fifo_s #(
        .DEPTH        (DEPTH),
        .AFULL_THRESH (AFULL_THRESH)
    ) u_in_fifo (
        .clk         (clk),
        .arstn       (arstn),
 
        // Slave write port - straight through from S01_AXIS
        .S_TDATA     (s01_axis_tdata),
        .S_TVALID    (s01_axis_tvalid),
        .S_TLAST     (s01_axis_tlast),
        .S_TREADY    (s01_axis_tready),    // backpressure to DMA MM2S
 
        // Raw read port → bridge FSM
        .rd_en       (in_rd_en),
        .rd_data     (in_rd_data),
        .rd_last     (in_rd_last),
        .empty       (in_empty),
 
        .full        (in_full),
        .almost_full (in_almost_full)
    );
 
    // =========================================================================
    // OUT FIFO  :  axis_fifo_m
    //   Write port  - driven by bridge FSM
    //   Master port - wired directly to M00_AXIS
    //
    // num_rows / num_cols configure the internal TLAST counter.
    // The FIFO asserts M_TLAST only on word (num_rows × num_cols - 1),
    // giving the DMA S2MM exactly one end-of-frame signal per transfer.
    //
    // In loopback mode the bridge passes in_rd_last straight to wr_last.
    // The FIFO suppresses wr_last on all rows except the last (& last_row
    // guard inside axis_fifo_m) so intermediate TLAST edges from the input
    // stream do not close S2MM early.
    // =========================================================================
    wire        out_wr_en;
    wire [31:0] out_wr_data;
    wire        out_wr_last;
    wire        out_full;
    wire        out_empty;
    wire        out_almost_full;
 
    axis_fifo_m #(
        .DEPTH        (DEPTH),
        .AFULL_THRESH (AFULL_THRESH)
    ) u_out_fifo (
        .clk         (clk),
        .arstn       (arstn),
 
        // Frame configuration - controls internal TLAST counter
        .num_rows    (NUM_ROWS[9:0]),
        .num_cols    (NUM_COLS[5:0]),
 
        // Write port - driven by bridge FSM
        .wr_en       (out_wr_en),
        .wr_data     (out_wr_data),
        .wr_last     (out_wr_last),        // from in_rd_last via bridge
 
        // AXI-S master port - straight through to M00_AXIS
        .M_TDATA     (m00_axis_tdata),
        .M_TVALID    (m00_axis_tvalid),
        .M_TLAST     (m00_axis_tlast),
        .M_TREADY    (m00_axis_tready),    // backpressure from DMA S2MM
 
        .full        (out_full),
        .empty       (out_empty),
        .almost_full (out_almost_full)
    );
 
    // =========================================================================
    // Bridge FSM  :  axis_fifo_s (IN) → axis_fifo_m (OUT)
    //
    // axis_fifo_s has a 1-cycle registered BRAM read latency:
    //   cycle N   : in_rd_en asserted, rd_ptr advances, address presented
    //   cycle N+1 : in_rd_data / in_rd_last valid on output register
    //
    // States
    //   BR_IDLE    : wait for data in IN FIFO and space in OUT FIFO (~out_full)
    //   BR_PENDING : rd_en fired, absorb 1-cycle BRAM latency
    //   BR_WRITE   : assert wr_en for one cycle, push word into axis_fifo_m
    // =========================================================================
    localparam [1:0] BR_IDLE    = 2'b00,
                     BR_PENDING = 2'b01,
                     BR_WRITE   = 2'b10;
 
    reg [1:0]  br_state;
    reg [31:0] br_data;
    reg        br_last;
 
    always @(posedge clk) begin
        if (!arstn) begin
            br_state <= BR_IDLE;
            br_data  <= 32'd0;
            br_last  <= 1'b0;
        end else begin
            case (br_state)
 
                // Wait for data in IN FIFO and at least one free slot in OUT FIFO
                BR_IDLE: begin
                    if (!in_empty && !out_full)
                        br_state <= BR_PENDING;
                end
 
                // in_rd_data / in_rd_last land this cycle - capture them
                // Note: in_rd_last is passed through to wr_last so axis_fifo_m
                // can use it for partial-word detection on the final row.
                // The FIFO suppresses it on non-final rows internally.
                BR_PENDING: begin
                    br_data  <= in_rd_data[31:0];
                    br_last  <= in_rd_last;
                    br_state <= BR_WRITE;
                end
 
                // wr_en asserted for exactly one cycle then return to IDLE
                BR_WRITE: begin
                    br_state <= BR_IDLE;
                end
 
                default: br_state <= BR_IDLE;
 
            endcase
        end
    end
 
    // in_rd_en pulses in IDLE when both FIFOs are ready
    assign in_rd_en   = (!in_empty && !out_full && (br_state == BR_IDLE));
 
    // axis_fifo_m write port driven from captured bridge registers
    assign out_wr_en   = (br_state == BR_WRITE);
    assign out_wr_data = br_data;
    assign out_wr_last = br_last;    // passed through; FIFO masks non-final rows
 
endmodule


module axis_fifo_s #(
    parameter DEPTH        = 8,
    parameter AFULL_THRESH = 8
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
    localparam int  ADDR_W = $clog2(DEPTH);
    localparam int  PTR_W  = ADDR_W + 1;   // extra MSB for full/empty
 
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

//module axis_fifo_m #(
//    parameter  DEPTH        = 16,
//    parameter  AFULL_THRESH = 2
//)(
//    input  logic        clk,
//    input  logic        arstn,
 
//    // -------------------------------------------------------------------------
//    // Write port  -  from bui result byte-packer (internal, not AXI-S slave)
//    // -------------------------------------------------------------------------
//    input  logic [31:0] wr_data,        // 32-bit packed result word
//    input  logic        wr_last,        // TLAST flag for this word (end of row)
//    input  logic        wr_en,          // push strobe - caller must not assert when full
 
//    // -------------------------------------------------------------------------
//    // AXI-S Master port  -  to PYNQ AXI DMA S2MM
//    // -------------------------------------------------------------------------
//    output logic [31:0] M_TDATA,
//    output logic        M_TVALID,
//    output logic        M_TLAST,
//    input  logic        M_TREADY,
 
//    // -------------------------------------------------------------------------
//    // Status
//    // -------------------------------------------------------------------------
//    output logic        full,
//    output logic        empty,
//    output logic        almost_full
//);
 
//    // =========================================================================
//    // Local parameters
//    // =========================================================================
//    localparam int  ADDR_W = $clog2(DEPTH);
//    localparam int  PTR_W  = ADDR_W + 1;    // extra MSB for full/empty
 
//    // =========================================================================
//    // BRAM storage  -  32-bit data words only.
//    // TLAST is stored separately in a lightweight register array (1 bit per
//    // entry) since it is a sideband flag and does not need to widen the BRAM.
//    // Xilinx SDP BRAM inference (registered read output, 1-cycle latency).
//    // =========================================================================
//    (* ram_style = "block" *)
//    logic [31:0] mem      [0:DEPTH-1];
//    logic        tlast_mem[0:DEPTH-1];   // 1-bit sideband, inferred as LUT/FF
 
//    // =========================================================================
//    // Pointers
//    // =========================================================================
//    logic [PTR_W-1:0] wr_ptr;
//    logic [PTR_W-1:0] rd_ptr;
 
//    // =========================================================================
//    // Status flags
//    // =========================================================================
//    logic [PTR_W-1:0] fill_level;
 
//    assign full        = (wr_ptr[PTR_W-1]    != rd_ptr[PTR_W-1]) &&
//                         (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);
//    assign empty       = (wr_ptr == rd_ptr);
//    assign fill_level  =  wr_ptr - rd_ptr;
//    assign almost_full = (fill_level >= (DEPTH - AFULL_THRESH));
 
//    // =========================================================================
//    // Write path
//    // =========================================================================
//    always_ff @(posedge clk) begin
//        if (wr_en && !full) begin
//            mem      [wr_ptr[ADDR_W-1:0]] <= wr_data;
//            tlast_mem[wr_ptr[ADDR_W-1:0]] <= wr_last;
//        end
//    end
 
//    always_ff @(posedge clk) begin
//        if (!arstn)              wr_ptr <= '0;
//        else if (wr_en && !full) wr_ptr <= wr_ptr + 1'b1;
//    end
 
//    // =========================================================================
//    // Read path  -  BRAM has a 1-cycle registered output latency.
//    //
//    // Strategy: issue a BRAM read whenever the FIFO is non-empty AND the
//    // output skid slot is free (or being consumed this cycle).  The result
//    // lands in the skid register one cycle later and drives the master port.
//    //
//    // This gives true cut-through (FWFT) behaviour on the AXI-S master port:
//    //   M_TVALID is high as long as skid_valid is set.
//    //   M_TREADY de-assertion is absorbed by holding skid_valid/skid_data.
//    // =========================================================================
 
//    // --- Read-pointer advance ---
//    // We advance rd_ptr (and issue the BRAM read) one cycle before we need
//    // the data: when the FIFO is non-empty AND the skid slot will be free
//    // next cycle (either it is currently empty, or it will be consumed).
//    logic rd_en;
//    logic skid_valid;   // output register holds live data
 
//    assign rd_en = !empty && (!skid_valid || (M_TVALID && M_TREADY));
 
//    always_ff @(posedge clk) begin
//        if (!arstn) rd_ptr <= '0;
//        else if (rd_en) rd_ptr <= rd_ptr + 1'b1;
//    end
 
//    // --- Output / skid register ---
//    // Loaded from BRAM one cycle after rd_en.
//    // Held when M_TREADY is low.
//    logic [31:0] skid_data;
//    logic        skid_last;
 
//    always_ff @(posedge clk) begin
//        if (!arstn) begin
//            skid_valid <= 1'b0;
//            skid_data  <= '0;
//            skid_last  <= 1'b0;
//        end else begin
//            // A new word arrives from BRAM the cycle after rd_en was asserted.
//            // We load it into the skid register unless the downstream consumed
//            // it in the same cycle (back-to-back throughput path).
//            if (rd_en) begin
//                // BRAM result will be available next cycle; mark slot occupied.
//                // The actual data is latched from mem[] below.
//                skid_data <= mem      [rd_ptr[ADDR_W-1:0]];
//                skid_last <= tlast_mem[rd_ptr[ADDR_W-1:0]];
//                skid_valid <= 1'b1;
//            end else if (M_TVALID && M_TREADY) begin
//                // Consumed and no new read in flight - slot becomes empty.
//                skid_valid <= 1'b0;
//            end
//        end
//    end
 

 
//    // =========================================================================
//    // AXI-S Master output  -  combinational from skid register
//    // =========================================================================
//    assign M_TDATA  = skid_data;
//    assign M_TLAST  = skid_last;
//    assign M_TVALID = skid_valid;
 

//endmodule


module axis_fifo_m #(
    parameter int unsigned DEPTH        = 256,
    parameter int unsigned AFULL_THRESH = 8
)(
    input  logic        clk,
    input  logic        arstn,
 
    // -------------------------------------------------------------------------
    // Frame configuration  -  from ctrl_reg, stable before first wr_en
    // -------------------------------------------------------------------------
    input  logic [9:0]  num_rows,      // total output rows in this frame
    input  logic [5:0]  num_cols,      // output pixels per row (row_width - 2)
 
    // -------------------------------------------------------------------------
    // Write port  -  from bui result byte-packer
    // -------------------------------------------------------------------------
    input  logic [31:0] wr_data,       // 32-bit packed result word
    input  logic        wr_last,       // TLAST from byte packer (partial flush)
    input  logic        wr_en,         // push strobe - must not assert when full
 
    // -------------------------------------------------------------------------
    // AXI-S Master port  -  to AXI DMA S2MM
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
    localparam int unsigned PTR_W  = ADDR_W + 1;
 
    // =========================================================================
    // BRAM storage
    // 32-bit data words in block RAM.
    // TLAST stored separately as a 1-bit register array per entry
    // (one bit wide - no need to consume BRAM width for a sideband flag).
    // =========================================================================
    (* ram_style = "block" *)
    logic [31:0] mem      [0:DEPTH-1];
    logic        tlast_mem[0:DEPTH-1];
 
    // =========================================================================
    // Pointers  -  (ADDR_W+1)-bit counters, MSB used for full/empty detect
    // =========================================================================
    logic [PTR_W-1:0] wr_ptr;
    logic [PTR_W-1:0] rd_ptr;
 
    // =========================================================================
    // Status flags
    // =========================================================================
    logic [PTR_W-1:0] fill_level;
 
    assign full        = (wr_ptr[PTR_W-1]    != rd_ptr[PTR_W-1]) &&
                         (wr_ptr[ADDR_W-1:0] == rd_ptr[ADDR_W-1:0]);
    assign empty       = (wr_ptr == rd_ptr);
    assign fill_level  =  wr_ptr - rd_ptr;
    assign almost_full = (fill_level >= (DEPTH - AFULL_THRESH));
 
    // =========================================================================
    // Internal frame-position counters
    //
    // pix_cnt  : which output pixel (0-based) within the current row
    //            we are writing.  Increments on every accepted write.
    //            Wraps to 0 after the last pixel of each row.
    //
    // row_cnt  : which output row (0-based) we are writing.
    //            Increments when pix_cnt wraps.
    //            Resets to 0 after the last row of the frame.
    //
    // frame_end: combinational flag - true on the write that carries the
    //            very last pixel of the very last row.
    // =========================================================================
    logic [5:0]  pix_cnt;   // max 62 pixels per row → 6 bits sufficient
    logic [9:0]  row_cnt;   // max 1023 rows          → 10 bits
 
    // Qualified write strobe (gate with !full so counters match BRAM pointer)
    logic wr_accepted;
    assign wr_accepted = wr_en && !full;
 
    // Last pixel of the current row
    logic last_pix_in_row;
    assign last_pix_in_row = (pix_cnt == num_cols - 1);
 
    // Last row of the frame
    logic last_row;
    assign last_row = (row_cnt == num_rows - 1);
 
    // Frame-end: last pixel of last row being written right now
    logic frame_end;
    assign frame_end = wr_accepted && last_pix_in_row && last_row;
 
    // pixel counter
    always_ff @(posedge clk) begin
        if (!arstn) begin
            pix_cnt <= '0;
        end else if (wr_accepted) begin
            if (last_pix_in_row)
                pix_cnt <= '0;          // wrap to start of next row
            else
                pix_cnt <= pix_cnt + 1'b1;
        end
    end
 
    // row counter
    always_ff @(posedge clk) begin
        if (!arstn) begin
            row_cnt <= '0;
        end else if (wr_accepted && last_pix_in_row) begin
            if (last_row)
                row_cnt <= '0;          // reset after frame completes
            else
                row_cnt <= row_cnt + 1'b1;
        end
    end
 
    // =========================================================================
    // Write path
    //
    // tlast_stored = frame_end | wr_last
    //
    //   frame_end  - internal detection: last pixel of last row this frame.
    //                Guarantees exactly one TLAST per frame on the last word.
    //
    //   wr_last    - byte-packer partial flush for the last word of any row
    //                when num_cols % 4 != 0.  On the final row this coincides
    //                with frame_end (OR is harmless).  On non-final rows
    //                wr_last would set TLAST mid-frame which we must suppress.
    //
    // IMPORTANT: wr_last on non-final rows is suppressed by masking with
    //            last_row.  This prevents mid-frame TLAST from closing S2MM.
    // =========================================================================
    logic tlast_stored;
    assign tlast_stored = frame_end | (wr_last & last_row);
 
    always_ff @(posedge clk) begin
        if (wr_accepted) begin
            mem      [wr_ptr[ADDR_W-1:0]] <= wr_data;
            tlast_mem[wr_ptr[ADDR_W-1:0]] <= tlast_stored;
        end
    end
 
    always_ff @(posedge clk) begin
        if (!arstn)        wr_ptr <= '0;
        else if (wr_accepted) wr_ptr <= wr_ptr + 1'b1;
    end
 
    // =========================================================================
    // Read path  -  1-cycle registered BRAM output latency
    //
    // rd_en fires when the FIFO is non-empty AND the skid slot is free or
    // will be freed this cycle.  The BRAM result lands one cycle later in
    // the skid register and drives the AXI-S master port directly.
    // =========================================================================
    logic rd_en;
    logic skid_valid;
 
    assign rd_en = !empty && (!skid_valid || (M_TVALID && M_TREADY));
 
    always_ff @(posedge clk) begin
        if (!arstn) rd_ptr <= '0;
        else if (rd_en) rd_ptr <= rd_ptr + 1'b1;
    end
 
    // =========================================================================
    // Output skid register
    // Holds the current output word until M_TREADY is seen.
    // =========================================================================
    logic [31:0] skid_data;
    logic        skid_last;
 
    always_ff @(posedge clk) begin
        if (!arstn) begin
            skid_valid <= 1'b0;
            skid_data  <= '0;
            skid_last  <= 1'b0;
        end else begin
            if (rd_en) begin
                skid_data  <= mem      [rd_ptr[ADDR_W-1:0]];
                skid_last  <= tlast_mem[rd_ptr[ADDR_W-1:0]];
                skid_valid <= 1'b1;
            end else if (M_TVALID && M_TREADY) begin
                skid_valid <= 1'b0;
            end
        end
    end
 
    // =========================================================================
    // AXI-S Master output  -  combinational from skid register
    // =========================================================================
    assign M_TDATA  = skid_data;
    assign M_TLAST  = skid_last;
    assign M_TVALID = skid_valid;
 
endmodule
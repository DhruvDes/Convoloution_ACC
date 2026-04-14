// Code your design here
module line_buffer #(
    parameter WIDTH = 64
)(
    input  logic        clk,
    input  logic        arstn,

    // ---- Write port (from BUI M_PX_*) ----
    input  logic [31:0] px_data,
    input  logic        px_valid,
    input  logic        px_last,
    output logic        px_ready,

    // ---- Frame control ----
    input  logic        frame_start,

    // ---- Read control (from control_logic) ----
    input  logic [5:0]  col_idx,
    input  logic        row_done,
    input  logic [5:0]  row_width,

    // ---- Status ----
    output logic        buf_ready,
    output logic [1:0]  write_lane,
    output logic [1:0]  base_lane,

    // ---- 3×3 window (combinational) ----
    output logic [7:0]  p00, p01, p02,
    output logic [7:0]  p10, p11, p12,
    output logic [7:0]  p20, p21, p22
);

    // =========================================================================
    // Storage - 4 lanes × 64 pixels × 8 bits = 2048 flip-flops
    // =========================================================================
    logic [7:0] mem [0:3][0:WIDTH-1];

    // =========================================================================
    // FSM
    // =========================================================================
    typedef enum logic [1:0] {IDLE, LDARR} state_t;
    state_t state;

    logic [5:0] wr_ptr;
    logic [1:0] wr_lane;
    logic [1:0] lanes_filled;
    logic       lane_full;

    // =========================================================================
    // Write lane select - wr_lane for initial fill, derived for prefetch
    // =========================================================================
    assign write_lane = (base_lane + 2'd3) & 2'b11;

    logic [1:0] active_wr_lane;
    assign active_wr_lane = buf_ready ? write_lane : wr_lane;

    // =========================================================================
    // base_lane management
    // =========================================================================
    always_ff @(posedge clk) begin
        if (!arstn)
            base_lane <= 0;
        else if (frame_start)
            base_lane <= 0;
        else if (row_done)
            base_lane <= base_lane + 1;
    end

// =========================================================================
    // Write pointer overflow-safe comparison
    // =========================================================================
    logic [6:0] next_wr_ptr;
    assign next_wr_ptr = {1'b0, wr_ptr} + 7'd4;

    // =========================================================================
    // Fill FSM
    // =========================================================================
    always_ff @(posedge clk) begin
        if (!arstn) begin
            state        <= IDLE;
            wr_ptr       <= 0;
            wr_lane      <= 0;
            lanes_filled <= 0;
            buf_ready    <= 0;
            lane_full    <= 0;
        end else begin
            if (row_done)
                lane_full <= 0;

            case (state)
                IDLE: begin
                    if (frame_start) begin
                        state        <= LDARR;
                        wr_ptr       <= 0;
                        wr_lane      <= 0;
                        lanes_filled <= 0;
                        buf_ready    <= 0;
                        lane_full    <= 0;
                    end
                end

                LDARR: begin
                    if (px_ready && px_valid) begin
                        mem[active_wr_lane][wr_ptr]     <= px_data[7:0];
                        mem[active_wr_lane][wr_ptr + 1] <= px_data[15:8];
                        mem[active_wr_lane][wr_ptr + 2] <= px_data[23:16];
                        mem[active_wr_lane][wr_ptr + 3] <= px_data[31:24];

                        if (next_wr_ptr >= {1'b0, row_width}) begin
                            wr_ptr    <= 0;
                            wr_lane   <= wr_lane + 1;
                            lane_full <= buf_ready;

                            if (lanes_filled == 2) begin
                                lanes_filled <= lanes_filled + 1;
                                buf_ready    <= 1;
                            end else begin
                                lanes_filled <= lanes_filled + 1;
                            end
                        end else begin
                            wr_ptr <= wr_ptr + 4;
                        end
                    end
                end
            endcase
        end
    end

    // =========================================================================
    // Backpressure
    // =========================================================================
    always_comb begin
        case (state)
            IDLE:    px_ready = 1'b0;
            LDARR:   px_ready = 1'b1;
            default: px_ready = 1'b0;
        endcase
    end

    // =========================================================================
    // 3×3 combinational window output
    // =========================================================================
    assign p00 = mem[(base_lane)        & 2'b11][col_idx    ];
    assign p01 = mem[(base_lane)        & 2'b11][col_idx + 1];
    assign p02 = mem[(base_lane)        & 2'b11][col_idx + 2];

    assign p10 = mem[(base_lane + 2'd1) & 2'b11][col_idx    ];
    assign p11 = mem[(base_lane + 2'd1) & 2'b11][col_idx + 1];
    assign p12 = mem[(base_lane + 2'd1) & 2'b11][col_idx + 2];

    assign p20 = mem[(base_lane + 2'd2) & 2'b11][col_idx    ];
    assign p21 = mem[(base_lane + 2'd2) & 2'b11][col_idx + 1];
    assign p22 = mem[(base_lane + 2'd2) & 2'b11][col_idx + 2];

endmodule
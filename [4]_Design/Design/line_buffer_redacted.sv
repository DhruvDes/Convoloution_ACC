`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2026 06:48:03 PM
// Design Name: 
// Module Name: line_buffer
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


//module line_buffer(
////  Required inputs
//    input logic clk, arstn,
    
////  AXI stream specifics
//    input logic S_TLAST,
//    input logic S_TVALID,
//    input logic [31:0] S_TDATA,
//    output logic S_TREADY,
    
////  This module to other signals
//    output logic buffer_loaded,
    
//// Memeory accest index
//    input logic [8:0] memIndex,
    
//    // line 0
//    output logic [7:0] lineBuff1px1,
//    output logic [7:0] lineBuff1px2,
//    output logic [7:0] lineBuff1px3,
    
//    // line 1
//    output logic [7:0] lineBuff2px1,
//    output logic [7:0] lineBuff2x2,
//    output logic [7:0] lineBuff2px3,
    
//    // line 2  
//    output logic [7:0] lineBuff3px1,
//    output logic [7:0] lineBuff3px2,
//    output logic [7:0] lineBuff3px3
//    );
    
//    //Memories

//        (* ram_style = "block" *) logic signed [9:0] control_buffer [15]; 
//        (* ram_style = "block" *) logic  [7:0] lnBuff [4][512];  
    
//    logic [31:0]stored_data;// to be removed in the end; 
    
//    // FSM enums
//    enum logic [15:0]{RESET = 16'h1, RUN = 16'h2, LOAD_CONF = 16'h3, LOAD_LINE = 16'h4 }state; 
//    enum logic [15:0]{Line0 = 'd1, Line2 = 'd2, Line3 = 'd3,Line4 = 'd4}loadLineSubStates; 
    
//    //Counters
//    logic [3:0] cf_count;
//    logic [9:0] rowCounter;
//    logic [1:0] lineIdx;      // 0-3, which lnBuff we're filling
//    logic [9:0] pixelCount;   // pixel position within current row
    
    

    
//    always_ff @(posedge clk) begin
      
//        if (!arstn) begin
//            state             <= RESET;
//            buffer_loaded     <= 0;
//            stored_data       <= '0;
//            cf_count          <= 0;
//            rowCounter        <= 0;
//            lineIdx           <= 0;
//            pixelCount        <= 0;
//            loadLineSubStates <= Line0;
//        end else begin
//            case (state)
            
//                RESET: begin
              
//                        state <= LOAD_CONF;
    
//                end
////------------------------------------------------------------------------                
//                RUN: begin
//                        state <= LOAD_CONF;
//                end// RUN
////------------------------------------------------------------------------                
//                LOAD_CONF: begin
//                    if (S_TVALID && S_TREADY) begin 
//                        // Common to both cases
//                        stored_data                    <= S_TDATA; 
//                        control_buffer [ cf_count]    <= S_TDATA[8:0];
//                        control_buffer [ cf_count + 1]<= S_TDATA[17:9];
//                        control_buffer [ cf_count + 2]<= S_TDATA[26:18];
                    
                
//                        if (S_TLAST) begin
//                            state <= LOAD_LINE;
//                        end else begin
//                            if (cf_count < 9) cf_count <= cf_count + 3;
//                        end
//                    end
//                end // LOAD_CONF
////------------------------------------------------------------------------                
//                LOAD_LINE : begin 
//                    if (S_TVALID && S_TREADY) begin 

//                        // Write 3 pixels from current word into current line buffer
//                        lnBuff[lineIdx][pixelCount]     <= S_TDATA[7:0];
//                        lnBuff[lineIdx][pixelCount + 1] <= S_TDATA[15:8];
//                        lnBuff[lineIdx][pixelCount + 2] <= S_TDATA[23:16];
//                        lnBuff[lineIdx][pixelCount + 3] <= S_TDATA[31:24];
//                        pixelCount <= pixelCount + 4;

//                        if (S_TLAST) begin
//                            pixelCount <= 0;

//                            case (lineIdx)
//                                0: begin
//                                    lineIdx          <= 1;
//                                    loadLineSubStates <= Line2;
//                                end
//                                1: begin
//                                    lineIdx          <= 2;
//                                    loadLineSubStates <= Line3;
//                                end
//                                2: begin
//                                    lineIdx          <= 3;
//                                    loadLineSubStates <= Line4;
//                                    buffer_loaded    <= 1;  // first 3 lines done, compute can start
//                                end
//                                3: begin
//                                    lineIdx          <= 0;  // wrap back around
//                                    loadLineSubStates <= Line0;
//                                end
//                            endcase
//                        end

//                    end
//                end // LOAD_LINE
////------------------------------------------------------------------------                
                
//            endcase // main FSM
//        end



//    end // always_ff @(posedge clk) begin

////------------------------------------------------------------------------      
//    always_comb begin
    
//      if(state == RESET) begin
//        S_TREADY = 0; 
//      end else begin
//        S_TREADY = 1; 
//      end


//    end
////------------------------------------------------------------------------      

//always_comb begin
//    // Default outputs
//    lineBuff1px1 = 8'h0;
//    lineBuff1px2 = 8'h0;
//    lineBuff1px3 = 8'h0;
//    lineBuff2px1 = 8'h0;
//    lineBuff2x2  = 8'h0;
//    lineBuff2px3 = 8'h0;
//    lineBuff3px1 = 8'h0;
//    lineBuff3px2 = 8'h0;
//    lineBuff3px3 = 8'h0;

//    if (buffer_loaded) begin
//        // Determine which 3 buffers are the valid output lines
//        // based on which buffer is currently being written (lineIdx)
//        // top    = lineIdx+1 mod 4  (oldest)
//        // middle = lineIdx+2 mod 4
//        // bottom = lineIdx+3 mod 4  (most recent complete line)
        
//        automatic logic [1:0] top_buf, mid_buf, bot_buf;
//        top_buf = (lineIdx + 1) % 4;
//        mid_buf = (lineIdx + 2) % 4;
//        bot_buf = (lineIdx + 3) % 4;

//        // Output 3 consecutive pixels starting at memIndex
//        // top line → lineBuff1
//        lineBuff1px1 = lnBuff[top_buf][memIndex];
//        lineBuff1px2 = lnBuff[top_buf][memIndex + 1];
//        lineBuff1px3 = lnBuff[top_buf][memIndex + 2];

//        // middle line → lineBuff2
//        lineBuff2px1 = lnBuff[mid_buf][memIndex];
//        lineBuff2x2  = lnBuff[mid_buf][memIndex + 1];
//        lineBuff2px3 = lnBuff[mid_buf][memIndex + 2];

//        // bottom line → lineBuff3
//        lineBuff3px1 = lnBuff[bot_buf][memIndex];
//        lineBuff3px2 = lnBuff[bot_buf][memIndex + 1];
//        lineBuff3px3 = lnBuff[bot_buf][memIndex + 2];
//    end
    
//end

//endmodule



module line_buffer(
    input  logic        clk, arstn,
    
    // AXI stream
    input  logic        S_TLAST,
    input  logic        S_TVALID,
    input  logic [31:0] S_TDATA,
    output logic        S_TREADY,
    
    // Control
    output logic        buffer_loaded,
    
    // Memory access index from compute unit (byte address 0-255)
    input  logic [7:0]  memIndex,
    
    // line 0
    output logic [7:0]  lineBuff1px1,
    output logic [7:0]  lineBuff1px2,
    output logic [7:0]  lineBuff1px3,
    
    // line 1
    output logic [7:0]  lineBuff2px1,
    output logic [7:0]  lineBuff2px2,
    output logic [7:0]  lineBuff2px3,
    
    // line 2
    output logic [7:0]  lineBuff3px1,
    output logic [7:0]  lineBuff3px2,
    output logic [7:0]  lineBuff3px3
);

    // ----------------------------------------------------------------
    // 4x 32-bit wide BRAMs, 64 words deep
    // 64 words × 4 bytes = 256 bytes = 256 pixels per buffer
    // ----------------------------------------------------------------
    (* ram_style = "block" *) logic [31:0] bram0 [0:63];
    (* ram_style = "block" *) logic [31:0] bram1 [0:63];
    (* ram_style = "block" *) logic [31:0] bram2 [0:63];
    (* ram_style = "block" *) logic [31:0] bram3 [0:63];

    // ----------------------------------------------------------------
    // FSM
    // ----------------------------------------------------------------
    enum logic [15:0] {
        RESET     = 16'h1,
        RUN       = 16'h2,
        LOAD_CONF = 16'h3,
        LOAD_LINE = 16'h4
    } state;

    enum logic [15:0] {
        Line0 = 'd1,
        Line1 = 'd2,
        Line2 = 'd3,
        Line3 = 'd4
    } loadLineSubStates;

    // ----------------------------------------------------------------
    // Registers
    // ----------------------------------------------------------------
    logic signed [9:0] control_buffer [15];

    logic [3:0]  cf_count;
    logic [7:0]  rowCounter;
    logic [1:0]  lineIdx;
    logic [5:0]  wordCount;     // word address 0-63

    // BRAM write
    logic        wr_en;
    logic [5:0]  wr_addr;       // word address 0-63
    logic [31:0] wr_data;

    // BRAM read - 2 adjacent words per BRAM for boundary crossing
    logic [5:0]  rd_word_addr;
    logic [1:0]  rd_byte_off;
    logic [1:0]  rd_byte_off_d1; // pipelined 1 cycle to match BRAM latency

    // Raw read data - 2 words from each BRAM
    logic [31:0] rd0_w0, rd0_w1;
    logic [31:0] rd1_w0, rd1_w1;
    logic [31:0] rd2_w0, rd2_w1;
    logic [31:0] rd3_w0, rd3_w1;

    // 64-bit windows for byte extraction
    logic [63:0] rd0_win, rd1_win, rd2_win, rd3_win;

    // Extracted pixels per BRAM
    logic [7:0]  rd0_px1, rd0_px2, rd0_px3;
    logic [7:0]  rd1_px1, rd1_px2, rd1_px3;
    logic [7:0]  rd2_px1, rd2_px2, rd2_px3;
    logic [7:0]  rd3_px1, rd3_px2, rd3_px3;

    // Delayed lineIdx for output mux (2 cycle latency: BRAM read + extraction)
    logic [1:0]  lineIdx_d1, lineIdx_d2;
    logic [1:0]  top_buf, mid_buf, bot_buf;

    // ----------------------------------------------------------------
    // BRAM write port - one 32-bit word per transfer
    // ----------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (wr_en) begin
            case (lineIdx)
                2'd0: bram0[wr_addr] <= wr_data;
                2'd1: bram1[wr_addr] <= wr_data;
                2'd2: bram2[wr_addr] <= wr_data;
                2'd3: bram3[wr_addr] <= wr_data;
            endcase
        end
    end

    // ----------------------------------------------------------------
    // BRAM read - read 2 adjacent words from all 4 BRAMs every cycle
    // ----------------------------------------------------------------
    assign rd_word_addr = memIndex[7:2];  // byte addr >> 2 = word addr (0-63)
    assign rd_byte_off  = memIndex[1:0];  // byte offset within word (0-3)

    always_ff @(posedge clk) begin
        rd0_w0 <= bram0[rd_word_addr];
        rd0_w1 <= bram0[rd_word_addr + 1];

        rd1_w0 <= bram1[rd_word_addr];
        rd1_w1 <= bram1[rd_word_addr + 1];

        rd2_w0 <= bram2[rd_word_addr];
        rd2_w1 <= bram2[rd_word_addr + 1];

        rd3_w0 <= bram3[rd_word_addr];
        rd3_w1 <= bram3[rd_word_addr + 1];

        // Pipeline byte offset to align with BRAM read latency
        rd_byte_off_d1 <= rd_byte_off;
    end

    // ----------------------------------------------------------------
    // 64-bit window - concat {next_word, curr_word} for boundary crossing
    // byte 0 of memIndex sits at [7:0] of curr_word
    // ----------------------------------------------------------------
    assign rd0_win = {rd0_w1, rd0_w0};
    assign rd1_win = {rd1_w1, rd1_w0};
    assign rd2_win = {rd2_w1, rd2_w0};
    assign rd3_win = {rd3_w1, rd3_w0};

    // Extract 3 consecutive bytes using pipelined byte offset
    always_comb begin
        rd0_px1 = rd0_win[rd_byte_off_d1*8    +: 8];
        rd0_px2 = rd0_win[rd_byte_off_d1*8+8  +: 8];
        rd0_px3 = rd0_win[rd_byte_off_d1*8+16 +: 8];

        rd1_px1 = rd1_win[rd_byte_off_d1*8    +: 8];
        rd1_px2 = rd1_win[rd_byte_off_d1*8+8  +: 8];
        rd1_px3 = rd1_win[rd_byte_off_d1*8+16 +: 8];

        rd2_px1 = rd2_win[rd_byte_off_d1*8    +: 8];
        rd2_px2 = rd2_win[rd_byte_off_d1*8+8  +: 8];
        rd2_px3 = rd2_win[rd_byte_off_d1*8+16 +: 8];

        rd3_px1 = rd3_win[rd_byte_off_d1*8    +: 8];
        rd3_px2 = rd3_win[rd_byte_off_d1*8+8  +: 8];
        rd3_px3 = rd3_win[rd_byte_off_d1*8+16 +: 8];
    end

    // ----------------------------------------------------------------
    // Delay lineIdx 2 cycles to match read + extraction latency
    // ----------------------------------------------------------------
    always_ff @(posedge clk) begin
        lineIdx_d1 <= lineIdx;
        lineIdx_d2 <= lineIdx_d1;
    end

    always_comb begin
        top_buf = (lineIdx_d2 + 1) % 4;
        mid_buf = (lineIdx_d2 + 2) % 4;
        bot_buf = (lineIdx_d2 + 3) % 4;
    end

    // ----------------------------------------------------------------
    // Output mux - registered, routes correct BRAM to each output
    // ----------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (!arstn) begin
            lineBuff1px1 <= 8'h0; lineBuff1px2 <= 8'h0; lineBuff1px3 <= 8'h0;
            lineBuff2px1 <= 8'h0; lineBuff2px2 <= 8'h0; lineBuff2px3 <= 8'h0;
            lineBuff3px1 <= 8'h0; lineBuff3px2 <= 8'h0; lineBuff3px3 <= 8'h0;
        end else if (buffer_loaded) begin

            case (top_buf)
                2'd0: begin lineBuff1px1<=rd0_px1; lineBuff1px2<=rd0_px2; lineBuff1px3<=rd0_px3; end
                2'd1: begin lineBuff1px1<=rd1_px1; lineBuff1px2<=rd1_px2; lineBuff1px3<=rd1_px3; end
                2'd2: begin lineBuff1px1<=rd2_px1; lineBuff1px2<=rd2_px2; lineBuff1px3<=rd2_px3; end
                2'd3: begin lineBuff1px1<=rd3_px1; lineBuff1px2<=rd3_px2; lineBuff1px3<=rd3_px3; end
            endcase

            case (mid_buf)
                2'd0: begin lineBuff2px1<=rd0_px1; lineBuff2px2<=rd0_px2; lineBuff2px3<=rd0_px3; end
                2'd1: begin lineBuff2px1<=rd1_px1; lineBuff2px2<=rd1_px2; lineBuff2px3<=rd1_px3; end
                2'd2: begin lineBuff2px1<=rd2_px1; lineBuff2px2<=rd2_px2; lineBuff2px3<=rd2_px3; end
                2'd3: begin lineBuff2px1<=rd3_px1; lineBuff2px2<=rd3_px2; lineBuff2px3<=rd3_px3; end
            endcase

            case (bot_buf)
                2'd0: begin lineBuff3px1<=rd0_px1; lineBuff3px2<=rd0_px2; lineBuff3px3<=rd0_px3; end
                2'd1: begin lineBuff3px1<=rd1_px1; lineBuff3px2<=rd1_px2; lineBuff3px3<=rd1_px3; end
                2'd2: begin lineBuff3px1<=rd2_px1; lineBuff3px2<=rd2_px2; lineBuff3px3<=rd2_px3; end
                2'd3: begin lineBuff3px1<=rd3_px1; lineBuff3px2<=rd3_px2; lineBuff3px3<=rd3_px3; end
            endcase
        end
    end

    // ----------------------------------------------------------------
    // Main FSM
    // ----------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (!arstn) begin
            state             <= RESET;
            buffer_loaded     <= 0;
            cf_count          <= 0;
            rowCounter        <= 0;
            lineIdx           <= 0;
            wordCount         <= 0;
            loadLineSubStates <= Line0;
            wr_en             <= 0;
            wr_addr           <= 0;
            wr_data           <= 0;
        end else begin
            wr_en <= 0;

            case (state)

                RESET: state <= LOAD_CONF;

                RUN:   state <= LOAD_CONF;

                LOAD_CONF: begin
                    if (S_TVALID && S_TREADY) begin
                        control_buffer[0 + cf_count] <= S_TDATA[8:0];
                        control_buffer[1 + cf_count] <= S_TDATA[17:9];
                        control_buffer[2 + cf_count] <= S_TDATA[26:18];

                        if (S_TLAST) begin
                            state <= LOAD_LINE;
                        end else begin
                            if (cf_count < 9) cf_count <= cf_count + 3;
                        end
                    end
                end

                LOAD_LINE: begin
                    if (S_TVALID && S_TREADY) begin
                        wr_en     <= 1;
                        wr_addr   <= wordCount;
                        wr_data   <= S_TDATA;
                        wordCount <= wordCount + 1;

                        if (S_TLAST) begin
                            wordCount <= 0;
                            wr_en     <= 0;

                            case (lineIdx)
                                0: begin lineIdx <= 1; loadLineSubStates <= Line1; end
                                1: begin lineIdx <= 2; loadLineSubStates <= Line2; end
                                2: begin
                                    lineIdx           <= 3;
                                    loadLineSubStates <= Line3;
                                    buffer_loaded     <= 1;
                                end
                                3: begin lineIdx <= 0; loadLineSubStates <= Line0; end
                            endcase
                        end
                    end
                end

            endcase
        end
    end

    // ----------------------------------------------------------------
    // S_TREADY
    // ----------------------------------------------------------------
    always_comb begin
        S_TREADY = (state != RESET);
    end

endmodule


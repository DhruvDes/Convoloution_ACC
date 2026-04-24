`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 03:37:18 PM
// Design Name: 
// Module Name: convAcc
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

(* fsm_encoding = "one_hot" *)
module convAcc #(

    parameter integer C_S00_AXIS_TDATA_WIDTH = 32,
    parameter integer C_M00_AXIS_TDATA_WIDTH = 32,
    parameter integer C_M00_AXIS_START_COUNT = 32
) (
    // Users to add ports here
    input logic axis_aclk,
    input logic axis_aresetn,


    output logic s00_axis_tready,
    input logic [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
    input logic s00_axis_tlast,
    input logic s00_axis_tvalid,


    output logic m00_axis_tvalid,
    output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
    output logic m00_axis_tlast,
    input logic m00_axis_tready



);


  ///// CFG connections
  logic        buiToCfg_valid;
  logic [31:0] buiToCfg_data;
  logic        cfgToBui_ready;
  logic        cfgToMainValid;
  logic        cfgToMainFull;
  logic [ 5:0] cfgToLbRowWidth;
  logic [ 9:0] cfgToMainRows;

  ///// Line Buffer Connections

  logic        buiToLbFrameStart;
  logic        buiToLbTready;
  logic        buiToLbTvalid;
  logic [31:0] buiToLbTData;
  logic        buiToLbTlast;
  logic [ 5:0] mainToLbIdx;
  logic [ 5:0] mainToLbIdx1;
  logic        lbToMainBuffReady;

  // global signals
  logic        mainToLbRowDone;
  logic        softReset;

  logic [31:0] resultSend;
  logic [ 1:0] whichBits;
  logic        emit_word;
  logic        emit_last;
  logic        mainToBuiTvalid;
  logic        mainToBuiTlast;
  logic [2:0] preCleanupCnt;
  logic        stopFifoAfterFrame;
  logic        stopFifoAfterFrame0;

  logic        tlast_received;
  logic        s_tready_int;  // BUI's native ready output

  logic pullMacValidLow;

  busInterfaceUnit #(
      .CFG_PKTS    (4),
      .IN_DEPTH    (512),
      .RES_DEPTH   (256),
      .AFULL_THRESH(8)
  ) bui0 (
      .clk  (axis_aclk),
      .arstn(softReset),

      // AXI-S slave in (from AXI DMA MM2S)
      .S_TDATA(s00_axis_tdata),
      .S_TVALID(s00_axis_tvalid),
      .S_TLAST(s00_axis_tlast),
      .S_TREADY(s00_axis_tready),
      .stop_input(tlast_received),
      // AXI-S master out - pixel data → line_buffer
      .M_PX_TDATA(buiToLbTData),
      .M_PX_TVALID(buiToLbTvalid),
      .M_PX_TLAST(buiToLbTlast),
      .M_PX_TREADY(buiToLbTready),

      // Config write port → cf_mem
      .cfg_data (buiToCfg_data),
      .cfg_valid(buiToCfg_valid),
      .cfg_ready(cfgToBui_ready),

      // Result write port (32-bit, from external packer)
      .res_wdata (resultSend),
      .res_wlast (mainToBuiTlast),
      .res_wvalid(mainToBuiTvalid),

      // AXI-S master out - results → AXI DMA S2MM
      .M_RES_TDATA (m00_axis_tdata),
      .M_RES_TVALID(m00_axis_tvalid),
      .M_RES_TLAST (m00_axis_tlast),
      .M_RES_TREADY(m00_axis_tready),

      // Status
      .px_almost_full(),
      .res_almost_full(),
      .frame_start(buiToLbFrameStart)
  );


  logic signed [8:0] krnlValues[9];
  cf_mem cf_mem0 (
      .clk (axis_aclk),
      .rstn(softReset),

      .write(buiToCfg_valid),
      .data (buiToCfg_data),
      .ready(cfgToBui_ready),
      .valid(cfgToMainValid),

      .row_size  (cfgToLbRowWidth),
      .no_of_rows(cfgToMainRows),

      .k00(krnlValues[0]),
      .k01(krnlValues[1]),
      .k02(krnlValues[2]),
      .k10(krnlValues[3]),
      .k11(krnlValues[4]),
      .k12(krnlValues[5]),
      .k20(krnlValues[6]),
      .k21(krnlValues[7]),
      .k22(krnlValues[8]),
      .cfg_full(cfgToMainFull)
  );


  line_buffer lb_core0 (
      .clk  (axis_aclk),
      .arstn(softReset),

      // ---- Write port (from BUI M_PX_*) ----
      .px_data(buiToLbTData),
      .px_valid(buiToLbTvalid),
//      .px_last(buiToLbTlast),
      .px_ready(buiToLbTready),
      // ---- Frame control ----
      .frame_start(buiToLbFrameStart),

      // ---- Read control (from control_logic) ----
      .col_idx (mainToLbIdx),
   

      .row_done (mainToLbRowDone),
      .row_width(cfgToLbRowWidth),

      // ---- Status ----
      .buf_ready (lbToMainBuffReady),
      .write_lane(),
      .base_lane (),

      // ---- 3×3 window (combinational) ----
      .p00(pxlValues[0]),  // fill with variables, 
      .p01(pxlValues[1]),
      .p02(pxlValues[2]),
      .p10(pxlValues[3]),
      .p11(pxlValues[4]),
      .p12(pxlValues[5]),
      .p20(pxlValues[6]),
      .p21(pxlValues[7]),
      .p22(pxlValues[8])

  );


  logic [7:0] pxlValues[9];
  logic [7:0] pxlValues1[9];
  logic coreToMainValid;
  logic [7:0] macResult;
  logic validForCore;


  mac_truncate core0 (
      .clk  (axis_aclk),
      .arstn(softReset),

      // 3×3 pixel window - 8-bit unsigned
      .p00(pxlValues[0]),
      .p01(pxlValues[1]),
      .p02(pxlValues[2]),
      .p10(pxlValues[3]),
      .p11(pxlValues[4]),
      .p12(pxlValues[5]),
      .p20(pxlValues[6]),
      .p21(pxlValues[7]),
      .p22(pxlValues[8]),

      // Kernel coefficients - 9-bit two's-complement signed
      .k0(krnlValues[0]),
      .k1(krnlValues[1]),
      .k2(krnlValues[2]),
      .k3(krnlValues[3]),
      .k4(krnlValues[4]),
      .k5(krnlValues[5]),
      .k6(krnlValues[6]),
      .k7(krnlValues[7]),
      .k8(krnlValues[8]),

      .valid_in((lbToMainBuffReady && cfgToMainValid) && pullMacValidLow),  // pixel window and coefficients are stable
      .valid_out(coreToMainValid),  // result is valid, MAC_LATENCY cycles later

      .result(macResult)  // saturated-clamped to [0, 255]
  );


  ////////////COntrol Logic-logic here

  enum logic [3:0] {
    Cleanup,
    Idle,
    Operational,
    preCleanup
  }
      state, nextState;
  logic [9:0] rowsdoneCount;
  logic [1:0] cleanupCount;


  always_ff @(posedge axis_aclk) begin
    if (!axis_aresetn) begin
      state <= Cleanup;
      cleanupCount <= 0;  
      pullMacValidLow <= 0;
       softReset <= 0;
    end else begin
      case (state)

        Cleanup: begin
          if (cleanupCount == 1)begin 
           state <= Idle;  
           cleanupCount <= 0;
            softReset <= 1;
          end else begin 
          cleanupCount <= cleanupCount + 1;
        
        
          end
        end

        Idle: begin
          state <= Idle;

          pullMacValidLow <= 0;
          
          if (s00_axis_tvalid == 1)begin  
          state <= Operational;
          pullMacValidLow <= 1;
          end 
        end

        Operational: begin
          // Transition when last row completes
          if (rowsdoneCount == ((cfgToMainRows - 2))) begin
            state <= preCleanup;  // or whatever your wrap-up state is
            pullMacValidLow <= 0;
          end else state <= Operational;

        end

        preCleanup: begin
          if (m00_axis_tvalid && m00_axis_tready && m00_axis_tlast)begin 
           state <= Cleanup;
            softReset <= 0;
           end
          else state <= preCleanup;
        end


        default: begin
          state <= Idle;

        end

      endcase
    end
  end

  


  localparam logic [1:0] ROW_WRAP_AROUND_OFFSET = 3;
  localparam logic [2:0] ROW_DONE_SIGNALING_OFFSET = 4;

  always_ff @(posedge axis_aclk) begin
    if (!axis_aresetn || state == Cleanup) begin
      mainToLbIdx     <= 0;
      rowsdoneCount   <= 0;
      mainToLbRowDone <= 0;
    end else if (state == Operational) begin
      mainToLbRowDone <= 0;
      if (lbToMainBuffReady && cfgToMainValid) begin
        // 1. Pulse logic
        if (mainToLbIdx == cfgToLbRowWidth - ROW_DONE_SIGNALING_OFFSET) begin
          mainToLbRowDone <= 1;
          rowsdoneCount   <= rowsdoneCount + 1;


        end
        // 2. Reset/Increment logic
        if (mainToLbIdx == cfgToLbRowWidth - ROW_WRAP_AROUND_OFFSET) begin
          mainToLbIdx <= 0;
        end else begin
          mainToLbIdx <= mainToLbIdx + 1;
        end
      end
    end
  end


  always_comb begin
    if (!axis_aresetn || state == Cleanup) begin
      mainToBuiTvalid = 1'b0;
      mainToBuiTlast  = 1'b0;

    end else begin
      // Stage 2: emit one cycle after packing completes
      mainToBuiTvalid = emit_word;
      mainToBuiTlast  = emit_last;
    end



  end


  always_ff @(posedge axis_aclk) begin
    if (!axis_aresetn || state == Cleanup) begin
      whichBits      <= 2'd0;
      resultSend     <= 32'd0;
      emit_word      <= 1'b0;
      emit_last      <= 1'b0;
      //        mainToBuiTvalid <= 1'b0;
      //        mainToBuiTlast  <= 1'b0;
      preCleanupCnt <= 2'd0;
    end else begin
      // Stage 2: emit one cycle after packing completes
      //        mainToBuiTvalid <= emit_word;
      //        mainToBuiTlast  <= emit_last;
      emit_word <= 1'b0;
      emit_last <= 1'b0;

      // Count cycles in preCleanup
      if (state != preCleanup) preCleanupCnt <= 2'd0;
      else if (coreToMainValid) preCleanupCnt <= preCleanupCnt + 1'b1;

      // Stage 1: pack bytes
      if (coreToMainValid) begin
        case (whichBits)
          2'd0: resultSend[7:0] <= macResult;
          2'd1: resultSend[15:8] <= macResult;
          2'd2: resultSend[23:16] <= macResult;
          2'd3: resultSend[31:24] <= macResult;
        endcase

        // Last valid result of frame
        if (state == preCleanup && preCleanupCnt == 2'd3) begin
          case (whichBits)
            2'd0: resultSend[31:8] <= 24'd0;
            2'd1: resultSend[31:16] <= 16'd0;
            2'd2: resultSend[31:24] <= 8'd0;
            2'd3: begin
            end
          endcase
          emit_word <= 1'b1;
          emit_last <= 1'b1;
          whichBits <= 2'd0;
        end  // Normal: 4th byte completes a word
        else if (whichBits == 2'd3) begin
          emit_word <= 1'b1;
          whichBits <= 2'd0;
        end else begin
          whichBits <= whichBits + 1'b1;
        end
      end
    end
  end



  always_ff @(posedge axis_aclk) begin
    if (!axis_aresetn) begin
      tlast_received <= 1'b0;
    end else begin
      if (state == Cleanup || state == Idle) tlast_received <= 1'b0;
      else if (s00_axis_tvalid && s00_axis_tready && s00_axis_tlast) tlast_received <= 1'b1;
    end
  end





endmodule

// Code your design here
module line_buffer #(
    parameter WIDTH = 64
)(
    input  logic        clk,
    input  logic        arstn,

    // ---- Write port (from BUI M_PX_*) ----
    input  logic [31:0] px_data,      // ← M_PX_TDATA
    input  logic        px_valid,     // ← M_PX_TVALID
    input  logic        px_last,      // ← M_PX_TLAST (end of row)
    output logic        px_ready,     // → M_PX_TREADY (backpressure)

    // ---- Frame control ----
    input  logic        frame_start,  // ← BUI frame_start

    // ---- Read control (from control_logic) ----
    input  logic [5:0]  col_idx,      // ← control_logic column pointer
    input  logic        row_done,     // ← control_logic pulse, advances base_lane

    // ---- Status ----
    output logic        buf_ready,    // → control_logic: 3 lanes loaded
    output logic [1:0]  write_lane,   // diagnostic / optional
    output logic [1:0]  base_lane,    // diagnostic / optional

    // ---- 3×3 window (combinational, → control_logic → MAC cores) ----
    output logic [7:0]  p00, p01, p02,
    output logic [7:0]  p10, p11, p12,
    output logic [7:0]  p20, p21, p22
);

  logic [5:0] width = 63;
  logic [9:0] height = 5;
  logic [1:0] row_buff = 3;
  logic [7:0] lane [0:3][0:63];
  logic [6:0] widthCount;
  
  enum logic [15:0] {IDLE = 'd1, LDARR = 'd2} state;  
  enum logic [15:0] {F1 = 'd1, F2 = 'd2, F3 = 'd4, F4 = 'd8} internalState;  
  
  
always @ (posedge clk) begin 
    if(!rstn)begin 
        state <= IDLE; 
        widthCount <= 0;

    end 

    case (state);
            IDLE : begin 
                if(frame_start == 1) state <= LDARR;
                else state <= IDLE;
            end
            
            LDARR : begin 
            if(px_ready == 1 && px_valid == 1) begin
                F1 : begin 
                    lane[0] <= px_data;
                    widthCount <= widthCount + 4;
                    if(widthCount == width) begin 
                        state <= F2;
                        widthCount <= 0;
                    end
                end  

            end
            end
        
    endcase




end
  
  
  
  
  
always_comb begin 
    case (state);
        IDLE : begin 
            px_ready = 0;
        end

    LDARR : begin 
        px_ready = 1; 
    end  	




    endcase



end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
endmodule 
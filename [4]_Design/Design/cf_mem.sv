`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 07:27:36 PM
// Design Name: 
// Module Name: cf_mem
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

 
module cf_mem(
    input  logic        clk, rstn, write,
    input  logic [31:0] data,
    output logic        ready,
    output logic        valid,
    output logic [5:0]  row_size,
    output logic [9:0]  no_of_rows,
    output logic signed [8:0]  k00, k01, k02,
                        k10, k11, k12,
                        k20, k21, k22,
    output logic cfg_full
);
 
    logic [2:0] mptr;
    logic [31:0] cfg_mem [4];
 
    assign ready = (mptr < 4);
    assign cfg_full = (mptr == 4);
    always_ff @(posedge clk) begin
        if (!rstn) begin
            mptr  <= 0;
            valid <= 0;
        end else if (write && ready) begin
            cfg_mem[mptr] <= data;
            mptr <= mptr + 1;
            if (mptr == 3)
                valid <= 1;
        end
    end
 
    always_comb begin
        row_size   = cfg_mem[0][5:0];
        no_of_rows = cfg_mem[0][15:6];
        k00 = cfg_mem[1][8:0];   k01 = cfg_mem[1][17:9];  k02 = cfg_mem[1][26:18];
        k10 = cfg_mem[2][8:0];   k11 = cfg_mem[2][17:9];  k12 = cfg_mem[2][26:18];
        k20 = cfg_mem[3][8:0];   k21 = cfg_mem[3][17:9];  k22 = cfg_mem[3][26:18];
    end
 
endmodule
 
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2026 01:40:11 PM
// Design Name: 
// Module Name: line_buff_tb
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
interface lbiff(input logic clk);

    logic S_TLAST = 0;
    logic S_TVALID = 0;
    logic [31:0] S_TDATA = '0;
    logic S_TREADY;
    logic arstn = 0;

    clocking lb_cb @(posedge clk);
    default input #0 output #0; 
 
    input S_TREADY;
    output S_TLAST, S_TVALID, S_TDATA, arstn;    
    endclocking


    modport lb_mb (clocking lb_cb);

endinterface 



module line_buff_tb(

    );

    logic clk = 0;
//    logic S_TLAST = 0;
//    logic S_TVALID = 0;
//    logic [31:0] S_TDATA = '0;
//    logic S_TREADY = 0;
    
    always #5 clk = ~clk;
    lbiff vif(clk);
    
    line_buffer dut(
        .clk(clk),
        .arstn(vif.arstn),
        .S_TLAST(vif.S_TLAST),
        .S_TVALID(vif.S_TVALID),
        .S_TDATA(vif.S_TDATA),
        .S_TREADY(vif.S_TREADY)
    );



   task reset_dut();
        begin
            vif.lb_cb.arstn <= 0;
            repeat(3)@(posedge clk);
            vif.lb_cb.arstn <= 1;
        end
   endtask : reset_dut


//task transfer_data();
//    logic [31:0] matrix_words[0:2];
//    begin
//        matrix_words[0] = 32'b00000_000000001_000000010_000000011;
//        matrix_words[1] = 32'b00000_000000100_000000101_000000110;
//        matrix_words[2] = 32'b00000_000000111_000001000_000001001;

//        // Wait for TREADY to be high FIRST before doing anything
//        while (!vif.lb_cb.S_TREADY) @(posedge clk);

//        // Now drive all 3 words, TREADY is already high
//        for (int i = 0; i < 3; i++) begin
//            vif.lb_cb.S_TVALID <= 1;
//            vif.lb_cb.S_TDATA  <= matrix_words[i];
//            vif.lb_cb.S_TLAST  <= (i == 2) ? 1 : 0;
//            @(posedge clk);
//        end

//        // Deassert
//        vif.lb_cb.S_TVALID <= 0;
//        vif.lb_cb.S_TLAST  <= 0;
//    end
//endtask

task transfer_config();
    logic [31:0] matrix_words[0:3];
    begin
        matrix_words[0] = 32'b00000_000000001_000000010_000000011;
        matrix_words[1] = 32'b00000_000000100_000000101_000000110;
        matrix_words[2] = 32'b00000_000000111_000001000_000001001;
        matrix_words[3] = 32'd32;

        for (int i = 0; i < 4; i++) begin
            vif.lb_cb.S_TVALID <= 1;
            vif.lb_cb.S_TDATA  <= matrix_words[i];
            vif.lb_cb.S_TLAST  <= (i == 3) ? 1 : 0;

            // Wait until TREADY is high, then wait for clock edge (handshake)
            wait(vif.S_TREADY == 1);
            @(posedge clk);
        end

        vif.lb_cb.S_TVALID <= 0;
        vif.lb_cb.S_TLAST  <= 0;
    end
endtask

parameter ROWS      = 32;
parameter COLS      = 32;
parameter TOTAL_PX  = ROWS * COLS;          // 1024
parameter NUM_WORDS = (TOTAL_PX + 2) / 3;  // 342

logic [7:0] image_mem [0:TOTAL_PX-1];

initial begin
    $readmemh("image_hex.txt", image_mem);
end

task transfer_image();
    logic [31:0] word;
    int px;
    int last_px_in_word;

    begin
        px = 0;
        for (int i = 0; i < NUM_WORDS; i++) begin
            word        = 32'h0;
            word[7:0] = (px     < TOTAL_PX) ? image_mem[px]     : 8'h0;
            word[15:8]  = (px + 1 < TOTAL_PX) ? image_mem[px + 1] : 8'h0;
            word[23:16]   = (px + 2 < TOTAL_PX) ? image_mem[px + 2] : 8'h0;

            // Index of the last valid pixel in this word
            last_px_in_word = (px + 2 < TOTAL_PX) ? px + 2 :
                              (px + 1 < TOTAL_PX) ? px + 1 : px;

            // TLAST high if any pixel in this word is the last pixel of a row
            // i.e. if crossing a row boundary: pixel index % COLS == COLS-1
            vif.lb_cb.S_TLAST <= ((px     % COLS == COLS - 1) ||
                                  (px + 1 < TOTAL_PX && (px + 1) % COLS == COLS - 1) ||
                                  (px + 2 < TOTAL_PX && (px + 2) % COLS == COLS - 1)) ? 1 : 0;

            vif.lb_cb.S_TVALID <= 1;
            vif.lb_cb.S_TDATA  <= word;

            wait(vif.S_TREADY == 1);
            @(posedge clk);
            px += 3;
        end
        vif.lb_cb.S_TVALID <= 0;
        vif.lb_cb.S_TLAST  <= 0;
    end
endtask





    initial begin

        reset_dut();
        transfer_config();
        transfer_image();

        #100;
       $finish();

    end // initial

    
endmodule
404: Not Found

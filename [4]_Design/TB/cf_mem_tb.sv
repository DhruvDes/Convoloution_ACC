`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 08:01:48 PM
// Design Name: 
// Module Name: tb
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
interface memif (input logic clk);

     logic        rstn, write;
     logic [31:0] data;
     logic valid;
     //outputs
     logic [5:0]  row_size;
     logic [9:0]  no_of_rows;
     logic signed [8:0]  k00, k01, k02,
                        k10, k11, k12,
                        k20, k21, k22;



clocking drvcb @ (posedge clk);
    default input #1 output #1;
    output write, data, rstn; 
    input row_size, no_of_rows, k00, k01, k02, k10, k11, k12, k20, k21, k22, valid;
endclocking

modport drvmp(clocking drvcb);

endinterface

// module cf_mem(
//     input  logic        clk, rstn, write,
//     input  logic [31:0] data,
//     output logic [5:0]  row_size,
//     output logic [9:0]  no_of_rows,
//     output logic [8:0]  k00, k01, k02,
//                         k10, k11, k12,
//                         k20, k21, k22
// );





module tb(

    );
    
    logic clk = 0;
    always #5 clk = ~clk;
    
 

     
     //outputs
     logic [5:0]  row_size;
     logic [9:0]  no_of_rows;
     logic signed [8:0]  k00, k01, k02,
                        k10, k11, k12,
                        k20, k21, k22;

    memif vif(clk);

cf_mem dut(
    .clk(clk),
    .rstn(vif.rstn),
    .write(vif.write),
    .data(vif.data),
    .row_size(vif.row_size),
    .no_of_rows(vif.no_of_rows),
    .k00(vif.k00), .k01(vif.k01), .k02(vif.k02),
    .k10(vif.k10), .k11(vif.k11), .k12(vif.k12),
    .k20(vif.k20), .k21(vif.k21), .k22(vif.k22),
    .valid(vif.valid)
);



    task test();
        $display("------------------Running Test----------------------");
        // generate values;
        k00 = $urandom_range(-256, 255);
        k01 = $urandom_range(-256, 255);
        k02 = $urandom_range(-256, 255);
        k10 = $urandom_range(-256, 255);
        k11 = $urandom_range(-256, 255);
        k12 = $urandom_range(-256, 255);
        k20 = $urandom_range(-256, 255);
        k21 = $urandom_range(-256, 255);
        k22 = $urandom_range(-256, 255);
        row_size = $urandom_range(1, 64);
        no_of_rows = $urandom_range(1, 1024);

        // rst 
        vif.drvcb.rstn <= 0;
        repeat(2) @(posedge clk);
        vif.drvcb.rstn <= 1;
     
        // drive 
            @(posedge clk);
            vif.drvcb.write <= 1;
            vif.drvcb.data <= 32'({no_of_rows, row_size});  // no_of_rows in [15:6], row_size in [5:0]
            @(posedge clk);
            vif.drvcb.data <= 32'({{k02, k01, k00}});
            @(posedge clk);
            vif.drvcb.data <= 32'({{k12, k11, k10}});
            @(posedge clk);
            vif.drvcb.data <= 32'({{k22, k21, k20}});
            @(posedge clk);
            vif.drvcb.write <= 0;   

            wait(vif.drvcb.valid);
            // make all these asserts to if statments to avoid simulation stop on failure and check all values
            if (vif.drvcb.no_of_rows != no_of_rows) begin
                $error("no_of_rows values not correct indexed exp %d, got : %d", no_of_rows, vif.drvcb.no_of_rows);
            end
            if (vif.drvcb.row_size != row_size) begin
                $error("row size not correct indexed");
            end
            if (vif.drvcb.k00 != k00) begin
                $error("k00 not correct indexed");
            end
            if (vif.drvcb.k01 != k01) begin
                $error("k01 not correct indexed");              
            end
            if (vif.drvcb.k02 != k02) begin
                $error("k02 not correct indexed");
            end
            if (vif.drvcb.k10 != k10) begin
                $error("k10 not correct indexed");      
            end
            if (vif.drvcb.k11 != k11) begin
                $error("k11 not correct indexed");
            end
            if (vif.drvcb.k12 != k12) begin
                $error("k12 not correct indexed");
            end
            if (vif.drvcb.k20 != k20) begin
                $error("k20 not correct indexed");
            end     
            if (vif.drvcb.k21 != k21) begin
                    $error("k21 not correct indexed");
                end
            if (vif.drvcb.k22 != k22) begin
                    $error("k22 not correct indexed");
                end
          
            $display("test passed for this set of values");
            


    endtask
    
    
    
    
    initial begin 
        repeat(5)test();
        $finish();
    end 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule

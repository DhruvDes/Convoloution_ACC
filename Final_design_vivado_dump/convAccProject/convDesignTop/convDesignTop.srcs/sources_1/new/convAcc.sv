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


module convAcc#
(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 32,
		parameter integer C_M00_AXIS_START_COUNT	= 32
	)
	(
		// Users to add ports here
		input logic  axis_aclk,
		input logic  axis_aresetn,
				// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXIS
		//input  logic  s00_axis_aclk,
		//input  logic  s00_axis_aresetn,
		output logic  s00_axis_tready,
		input  logic [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
		//input  logic [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
		input  logic  s00_axis_tlast,
		input  logic  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS
		//input  logic  m00_axis_aclk,
		//input  logic  m00_axis_aresetn,
		output logic  m00_axis_tvalid,
		output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		//output logic [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output logic  m00_axis_tlast,
		input  logic  m00_axis_tready
	);


///// CFG connections
logic 	     buiToCfg_valid;
logic [31:0] buiToCfg_data;
logic 		 cfgToBui_ready;
logic 		 cfgToMainValid;
logic 		 cfgToMainFull;
logic [5:0]  cfgToLbRowWidth;
logic [8:0]  cfgToMainRows;

///// Line Buffer Connections

logic        buiToLbFrameStart;
logic        buiToLbTready;
logic        buiToLbTvalid;
logic [31:0] buiToLbTData;
logic 	     buiToLbTlast;


busInterfaceUnit #(
     .CFG_PKTS      (4),
     .IN_DEPTH      (512),
     .RES_DEPTH     (256),
     .AFULL_THRESH  (8)
)bui0(
		.clk(axis_aclk),
		.arstn(axis_aresetn),

		// AXI-S slave in (from AXI DMA MM2S)
		.S_TDATA(s00_axis_tdata),
		.S_TVALID(s00_axis_tvalid),
		.S_TLAST(s00_axis_tlast),
		.S_TREADY(s00_axis_tready),

		// AXI-S master out - pixel data → line_buffer
		.M_PX_TDATA(buiToLbTData),
		.M_PX_TVALID(buiToLbTvalid),
		.M_PX_TLAST(buiToLbTlast),
		.M_PX_TREADY(buiToLbTready),

		// Config write port → cf_mem
		.cfg_data(buiToCfg_data),
		.cfg_valid(buiToCfg_valid),
		.cfg_ready(cfgToBui_ready),

		// Result write port (32-bit, from external packer)
		.res_wdata(),
		.res_wlast(),
		.res_wvalid(),

		// AXI-S master out - results → AXI DMA S2MM
		.M_RES_TDATA(m00_axis_tdata),
		.M_RES_TVALID(m00_axis_tvalid),
		.M_RES_TLAST(m00_axis_tlast),
		.M_RES_TREADY(m00_axis_tready),

		// Status
		.px_almost_full(),
		.res_almost_full(),
		.frame_start(buiToLbFrameStart)
);


cf_mem cf_mem0(
		.clk(axis_aclk), 
		.rstn(axis_aresetn), 
		.write(buiToCfg_valid),
		.data(buiToCfg_data),
		.ready(cfgToBui_ready),
		.valid(cfgToMainValid),
		.row_size(cfgToLbRowWidth),
		.no_of_rows(),
		.k00(), 
		.k01(), 
		.k02(),
		.k10(),
		.k11(),
		.k12(),
		.k20(),
		.k21(),
		.k22(),
		.cfg_full(cfgToMainFull)
);
 

	line_buffer lb_core0(
		.clk(axis_aclk),
		.arstn(axis_aresetn),

		// ---- Write port (from BUI M_PX_*) ----
		.px_data(buiToLbTData),      
		.px_valid(buiToLbTvalid),   
		.px_last(buiToLbTlast),     
		.px_ready(buiToLbTready),     
		// ---- Frame control ----
		.frame_start(buiToLbFrameStart),

		// ---- Read control (from control_logic) ----
		.col_idx(),
		.row_done(),
		.row_width(cfgToLbRowWidth),

		// ---- Status ----
		.buf_ready(),
		.write_lane(),
		.base_lane(),

		// ---- 3×3 window (combinational) ----
		.p00(), 
		.p01(), 
		.p02(),
		.p10(), 
		.p11(),
		.p12(),
		.p20(),
		.p21(),
		.p22()
	);



endmodule

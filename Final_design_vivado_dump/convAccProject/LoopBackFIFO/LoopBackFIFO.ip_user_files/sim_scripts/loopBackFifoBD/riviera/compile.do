transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/axi_datamover_v5_1_37
vlib riviera/axi_sg_v4_1_21
vlib riviera/axi_dma_v7_1_37
vlib riviera/xil_defaultlib
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_vip_v1_1_22
vlib riviera/processing_system7_vip_v1_0_24
vlib riviera/proc_sys_reset_v5_0_17
vlib riviera/generic_baseblocks_v2_1_2
vlib riviera/fifo_generator_v13_2_14
vlib riviera/axi_data_fifo_v2_1_36
vlib riviera/axi_register_slice_v2_1_36
vlib riviera/axi_protocol_converter_v2_1_37
vlib riviera/axi_clock_converter_v2_1_35
vlib riviera/blk_mem_gen_v8_4_12
vlib riviera/axi_dwidth_converter_v2_1_37

vmap xilinx_vip riviera/xilinx_vip
vmap axi_datamover_v5_1_37 riviera/axi_datamover_v5_1_37
vmap axi_sg_v4_1_21 riviera/axi_sg_v4_1_21
vmap axi_dma_v7_1_37 riviera/axi_dma_v7_1_37
vmap xil_defaultlib riviera/xil_defaultlib
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_22 riviera/axi_vip_v1_1_22
vmap processing_system7_vip_v1_0_24 riviera/processing_system7_vip_v1_0_24
vmap proc_sys_reset_v5_0_17 riviera/proc_sys_reset_v5_0_17
vmap generic_baseblocks_v2_1_2 riviera/generic_baseblocks_v2_1_2
vmap fifo_generator_v13_2_14 riviera/fifo_generator_v13_2_14
vmap axi_data_fifo_v2_1_36 riviera/axi_data_fifo_v2_1_36
vmap axi_register_slice_v2_1_36 riviera/axi_register_slice_v2_1_36
vmap axi_protocol_converter_v2_1_37 riviera/axi_protocol_converter_v2_1_37
vmap axi_clock_converter_v2_1_35 riviera/axi_clock_converter_v2_1_35
vmap blk_mem_gen_v8_4_12 riviera/blk_mem_gen_v8_4_12
vmap axi_dwidth_converter_v2_1_37 riviera/axi_dwidth_converter_v2_1_37

vlog -work xilinx_vip  -incr "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vcom -work axi_datamover_v5_1_37 -93  -incr \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/d44a/hdl/axi_datamover_v5_1_vh_rfs.vhd" \

vcom -work axi_sg_v4_1_21 -93  -incr \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/b193/hdl/axi_sg_v4_1_rfs.vhd" \

vcom -work axi_dma_v7_1_37 -93  -incr \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/7f6a/hdl/axi_dma_v7_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/loopBackFifoBD/ip/loopBackFifoBD_axi_dma_0/sim/loopBackFifoBD_axi_dma_0.vhd" \

vlog -work axi_infrastructure_v1_1_0  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_22  -incr "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/b16a/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_24  -incr "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../bd/loopBackFifoBD/ip/loopBackFifoBD_processing_system7_0_0/sim/loopBackFifoBD_processing_system7_0_0.v" \

vcom -work proc_sys_reset_v5_0_17 -93  -incr \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9438/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../bd/loopBackFifoBD/ip/loopBackFifoBD_rst_ps7_0_100M_0/sim/loopBackFifoBD_rst_ps7_0_100M_0.vhd" \

vlog -work generic_baseblocks_v2_1_2  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/0c28/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_14  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/d654/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_14 -93  -incr \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/d654/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_14  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/d654/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_36  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/fb46/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_36  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/bc4b/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work axi_protocol_converter_v2_1_37  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/d98a/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../bd/loopBackFifoBD/ip/loopBackFifoBD_axi_mem_intercon_imp_auto_pc_0/sim/loopBackFifoBD_axi_mem_intercon_imp_auto_pc_0.v" \

vlog -work axi_clock_converter_v2_1_35  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/e059/hdl/axi_clock_converter_v2_1_vl_rfs.v" \

vlog -work blk_mem_gen_v8_4_12  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/42f3/simulation/blk_mem_gen_v8_4.v" \

vlog -work axi_dwidth_converter_v2_1_37  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/21f8/hdl/axi_dwidth_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../bd/loopBackFifoBD/ip/loopBackFifoBD_axi_mem_intercon_imp_auto_us_0/sim/loopBackFifoBD_axi_mem_intercon_imp_auto_us_0.v" \
"../../../bd/loopBackFifoBD/ip/loopBackFifoBD_axi_mem_intercon_1_imp_auto_pc_0/sim/loopBackFifoBD_axi_mem_intercon_1_imp_auto_pc_0.v" \
"../../../bd/loopBackFifoBD/ip/loopBackFifoBD_ps7_0_axi_periph_imp_auto_pc_0/sim/loopBackFifoBD_ps7_0_axi_periph_imp_auto_pc_0.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../bd/loopBackFifoBD/ipshared/d30f/src/lpbk_tst.sv" \
"../../../bd/loopBackFifoBD/ip/loopBackFifoBD_lpbk_tst_0_0/sim/loopBackFifoBD_lpbk_tst_0_0.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/ec67/hdl" "+incdir+../../../../LoopBackFIFO.gen/sources_1/bd/loopBackFifoBD/ipshared/9a25/hdl" "+incdir+../../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+D:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l axi_datamover_v5_1_37 -l axi_sg_v4_1_21 -l axi_dma_v7_1_37 -l xil_defaultlib -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l proc_sys_reset_v5_0_17 -l generic_baseblocks_v2_1_2 -l fifo_generator_v13_2_14 -l axi_data_fifo_v2_1_36 -l axi_register_slice_v2_1_36 -l axi_protocol_converter_v2_1_37 -l axi_clock_converter_v2_1_35 -l blk_mem_gen_v8_4_12 -l axi_dwidth_converter_v2_1_37 \
"../../../bd/loopBackFifoBD/sim/loopBackFifoBD.v" \

vlog -work xil_defaultlib \
"glbl.v"


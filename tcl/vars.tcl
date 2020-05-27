# Common
set TOP_NAME jtag_drv

# SDK-specific
set SDK_PATH project/project.sdk
set HW_NAME hw
set SW_NAME sw
set PROC_NAME ps7_cortexa9_0
set CPU_FILTER "ARM*#0"
set FIRMWARE_DIR firmware 

# FPGA-specific
set PRJ_NAME project
set PRJ_DIR project
set FPGA_PART xc7z020clg400-1
set FPGA_BOARD www.digilentinc.com:pynq-z1:part0:1.0
set PS_VLNV xilinx.com:ip:processing_system7:5.5
set GPIO_VLNV xilinx.com:ip:axi_gpio:2.0
set SOURCE_FILES { \
    ../tap_core.edf \
    vlog/tap_core.sv \
    vlog/jtag_drv.sv \
}

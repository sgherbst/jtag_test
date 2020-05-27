# Common
set TOP_NAME jtag_drv

# FPGA_BOARD
if { [info exists ::env(FPGA_BOARD)] } {
    set FPGA_BOARD $::env(FPGA_BOARD)
} else {
    set FPGA_BOARD www.digilentinc.com:pynq-z1:part0:1.0
}

# FPGA_PART
if { [info exists ::env(FPGA_PART)] } {
    set FPGA_PART $::env(FPGA_PART)
} else {
    set FPGA_PART xc7z020clg400-1
}

# TAP_CORE_LOC
if { [info exists ::env(TAP_CORE_LOC)] } {
    set TAP_CORE_LOC $::env(TAP_CORE_LOC)
} else {
    set TAP_CORE_LOC ../tap_core.edf
}

# SDK-specific
set SDK_PATH project/project.sdk
set HW_NAME hw
set SW_NAME sw
set PROC_NAME ps7_cortexa9_0
set CPU_FILTER "ARM*#0"
set FIRMWARE_DIR firmware 

# Vivado-specific
set PRJ_NAME project
set PRJ_DIR project
set PS_VLNV xilinx.com:ip:processing_system7:5.5
set GPIO_VLNV xilinx.com:ip:axi_gpio:2.0
set SOURCE_FILES "$TAP_CORE_LOC vlog/tap_core.sv vlog/jtag_drv.sv"

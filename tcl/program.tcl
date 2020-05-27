# References:
# 1. https://www.xilinx.com/html_docs/xilinx2018_1/SDK_Doc/xsct/use_cases/xsdb_standalone_app_debug.html
# 2. https://github.com/Digilent/Arty-Z7-20-linux_bd/blob/master/sdk/.sdk/launch_scripts/xilinx_c-c%2B%2B_application_(system_debugger)/system_debugger_using_debug_video.elf_on_local.tcl

# connect to the HW server
puts "Connecting to the HW server..."
connect

# select the CPU (there are two on the Pynq)
puts "Selecting the CPU..."
targets -set -filter {name =~ "ARM*#0"}

# reset the system
puts "Resetting the system..."
rst

# program the FPGA
puts "Programming the FPGA..."
fpga project/project.sdk/hw/jtag_drv.bit

# make the debugger aware of the memory map
# TODO: is this needed?
puts "Setting up the debugger..."
loadhw project/project.sdk/jtag_drv.hdf

# initialize the processor
puts "Initializing the processor..."
source project/project.sdk/hw/ps7_init.tcl
ps7_init
ps7_post_config

# download the program
puts "Downloading the program..."
dow project/project.sdk/sw/Debug/sw.elf

# run program
puts "Starting the program..."
con

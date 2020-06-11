# References:
# 1. https://www.xilinx.com/html_docs/xilinx2018_1/SDK_Doc/xsct/use_cases/xsdb_standalone_app_debug.html
# 2. https://github.com/Digilent/Arty-Z7-20-linux_bd/blob/master/sdk/.sdk/launch_scripts/xilinx_c-c%2B%2B_application_(system_debugger)/system_debugger_using_debug_video.elf_on_local.tcl

# pull in user-defined variables
source tcl/vars.tcl

# connect to the HW server
puts "Connecting to the HW server..."
connect

# select the CPU (there are two on the Pynq)
puts "Selecting the CPU..."
targets -set -filter {name =~ $CPU_FILTER}

# reset the system
puts "Resetting the system..."
rst

# program the FPGA
puts "Programming the FPGA..."
fpga "$PRJ_DIR/$PRJ_NAME.runs/impl_1/$TOP_NAME.bit"

# make the debugger aware of the memory map
# TODO: is this needed?
puts "Setting up the debugger..."
loadhw "$PRJ_DIR/$PRJ_NAME.runs/impl_1/$TOP_NAME.xsa"

# initialize the processor
puts "Initializing the processor..."
source "$PRJ_DIR/$PRJ_NAME.runs/impl_1/ps7_init.tcl"
ps7_init
ps7_post_config

# download the program
puts "Downloading the program..."
dow "$SDK_PATH/$SW_NAME/Debug/$SW_NAME.elf"

# run program
puts "Starting the program..."
con

# print message for debugging purposes
puts "Program started."

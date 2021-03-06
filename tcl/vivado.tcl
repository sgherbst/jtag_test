##################################
# Pull in user-defined variables #
##################################

source tcl/vars.tcl

#############################
# Create the Vivado project #
#############################

create_project -force $PRJ_NAME $PRJ_DIR -part $FPGA_PART
set_property board_part $FPGA_BOARD [current_project]

############################
# Create the block diagram #
############################

# Initialize

create_bd_design "design_1"

# Instantiate IPs

create_bd_cell -type ip -vlnv $PS_VLNV processing_system7_0
create_bd_cell -type ip -vlnv $GPIO_VLNV axi_gpio_0

# Configure IPs

set_property \
    -dict [list \
        CONFIG.C_IS_DUAL {1} \
        CONFIG.C_ALL_INPUTS {1} \
        CONFIG.C_ALL_OUTPUTS_2 {1} \
    ] \
    [get_bd_cells axi_gpio_0]

# Create ports

create_bd_port -dir I -from 31 -to 0 gpio_in
create_bd_port -dir O -from 31 -to 0 gpio_out

# Wire up IPs

connect_bd_net \
    [get_bd_pins processing_system7_0/FCLK_CLK0] \
    [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]

connect_bd_net \
    [get_bd_ports gpio_in] \
    [get_bd_pins axi_gpio_0/gpio_io_i]

connect_bd_net \
    [get_bd_ports gpio_out] \
    [get_bd_pins axi_gpio_0/gpio2_io_o]

# Apply automation    

apply_bd_automation \
    -rule xilinx.com:bd_rule:processing_system7 \
    -config { \
        make_external "FIXED_IO, DDR" \
	apply_board_preset "1" \
	Master "Disable" \
	Slave "Disable" \
    } \
    [get_bd_cells processing_system7_0]

apply_bd_automation \
    -rule xilinx.com:bd_rule:axi4 \
    -config { \
        Clk_master {/processing_system7_0/FCLK_CLK0 (100 MHz)} \
	Clk_slave {Auto} \
	Clk_xbar {Auto} \
	Master {/processing_system7_0/M_AXI_GP0} \
	Slave {/axi_gpio_0/S_AXI} \
	intc_ip {New AXI Interconnect} \
	master_apm {0}\
    } \
    [get_bd_intf_pins axi_gpio_0/S_AXI]

validate_bd_design

####################
# Add source files #
####################

add_files $SOURCE_FILES

############################
# Set the top-level module #
############################

set_property -name top -value $TOP_NAME -objects [current_fileset]

##################################################
# Run synthesis, PnR, and generate the bitstream #
##################################################

launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1

###################
# Export hardware #
###################

write_hw_platform -fixed -include_bit -force -file "$PRJ_DIR/$PRJ_NAME.runs/impl_1/$TOP_NAME.xsa"

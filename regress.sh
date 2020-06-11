# upgrade pip
pip install -U pip

# set up tools
pip install pyserial

# build bitstream
vivado -mode batch -source tcl/vivado.tcl

# export hardware to SDK
mkdir -p project/project.sdk
cp project/project.runs/impl_1/jtag_drv.xsa project/project.sdk/jtag_drv.xsa

# build firmware
xsct tcl/sdk.tcl

# program firmware
xsct tcl/program.tcl

# run UART test
python uart_test.py

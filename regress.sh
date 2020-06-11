# upgrade pip
pip install -U pip

# set up tools
pip install pyserial

# build bitstream
vivado -mode batch -source tcl/vivado.tcl

# build firmware
xsct tcl/sdk.tcl

# program firmware
xsct tcl/program.tcl

# run UART test
python uart_test.py

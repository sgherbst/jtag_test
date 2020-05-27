# upgrade pip
pip install -U pip

# set up tools
pip install pyserial

# build bitstream
vivado -mode batch -source tcl/vivado.tcl

# build firmware
xsdk -batch -source tcl/sdk.tcl

# program firmware
xsdk -batch -source tcl/program.tcl

# run UART test
python uart_test.py

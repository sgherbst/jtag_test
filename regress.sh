# upgrade pip
pip install -U pip

# set up tools
pip install pyserial

# build bitstream
vivado -mode batch -source tcl/vivado.tcl
tree

# copy over source files
mkdir -p project/project.sdk/sw
cp -r firmware project/project.sdk/sw/src
tree

# build firmware
xsct tcl/sdk.tcl
tree

# program firmware
xsct tcl/program.tcl
tree

# run UART test
python uart_test.py

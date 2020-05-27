# jtag\_test
[![Build status](https://badge.buildkite.com/7bcc2c2e3867a8d42311bb69ec3aa66ac339038fac3f7f37ee.svg?branch=master)](https://buildkite.com/stanford-aha/jtag-test)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project is an example of automating Vivado and its SDK to exercise an emulated JTAG TAP controller.  It takes a synthesized TAP core, instantiates in a test harness that is driven by a CPU macro on the FPGA, and builds of bitstream for that design (DUT + test harness).  From that point, SDK automation is used to build firmware that stimulates the DUT according to user commands received over UART.  Finally, a small Python program is used to send UART commands and check the result.

As a result, this project covers a variety of features in Vivado + SDK workflow:
1. Importing pre-synthesized logic (EDIF / EDF)
2. Instantiating a CPU macro in user-written RTL.
3. Writing firmware that interacts with an AXI GPIO block connected to the CPU macro.
4. Writing firmware that reads and reacts to commands received over UART.
5. SDK automation to build firmware (ELF)
6. SDK automation to program the FPGA and CPU macro.

## Running the flow
1. You'll need a Zynq FPGA board.  I've tested this example with a PYNQ-Z1 board, but it should run on other Zynq boards with minimal changes (if any). 
2. Make sure that you have installed 

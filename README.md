# jtag\_test
[![Build status](https://badge.buildkite.com/7bcc2c2e3867a8d42311bb69ec3aa66ac339038fac3f7f37ee.svg?branch=master)](https://buildkite.com/stanford-aha/jtag-test)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project is an example of automating Vivado and its SDK to exercise an emulated JTAG TAP controller.  It takes a synthesized TAP core, instantiates in a test harness that is driven by a CPU macro on the FPGA, and builds of bitstream for that design (DUT + test harness).  From that point, SDK automation is used to build firmware that stimulates the DUT according to user commands received over UART.  Finally, a small Python program is used to send UART commands and check the result.

As a result, this project covers a variety of features in Vivado + SDK workflow that are relevant to text-based designs under revision control:
1. Describing a Vivado project with TCL commands rather than an XPR file.
2. Importing pre-synthesized logic (EDIF / EDF)
3. Creating a block diagram for a CPU macro and AXI peripherals using TCL, rather than using a BRD file.
4. Instantiating a CPU macro in user-written RTL.
5. Writing firmware that interacts with an AXI GPIO block connected to the CPU macro.
6. Writing firmware that reads and reacts to commands received over UART.
7. SDK automation to build firmware (ELF)
8. SDK automation to program the FPGA and CPU macro.

## Prerequisites
1. You'll need a Zynq FPGA board.  I've tested this example with PYNQ-Z1 and ZC702 boards, but it should run on other Zynq boards, too.  
2. Make sure that you have installed Vivado and its SDK.  Sample instructions are [here](https://gist.github.com/sgherbst/f73c31938d3483e6c72e3baf3443f66a).  If you're not using the PYNQ-Z1 board, you can skip the part about installing PYNQ board files.
3. Generate an EDIF for the TAP core.  Sample instructions are [here](https://gist.github.com/sgherbst/dbb9dfcd01afe0b187ee7263e0bd29d8).

## Running the flow
1. Set these environment variables:
    1. ``FPGA_BOARD``: Choose from options listed in ``get_board_parts`` in the Vivado TCL console.
    2. ``FPGA_PART``: Choose from options listed in ``get_parts`` in the Vivado TCL console.
    3. ``TAP_CORE_LOC``: Absolute path to the EDIF file for the TAP core.
    4. ``UART_DEV_NAME``: Name of the USB serial device (e.g., ``/dev/ttyUSB0``)
2. Build the FPGA bitstream:
```shell
> vivado -mode batch -source tcl/vivado.tcl
```
3. Copy over firmware files into the SDK work directory:
```shell
> mkdir -p project/project.sdk/sw
> cp -r firmware project/project.sdk/sw/src
```
4. Build the firmware:
```shell
> xsdk -batch -source tcl/sdk.tcl
```
5. Program the bitstream and firmware and start the program:
```shell
> xsdk -batch -source tcl/program.tcl
```
6. Interact with CPU over UART (need Python 3.7+ with ``pyserial`` installed)
```shell
> python uart_test.py
```

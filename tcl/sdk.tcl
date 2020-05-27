# set the work directory
setws project/project.sdk

# create the hardware configuration
createhw \
    -name hw \
    -hwspec project/project.sdk/jtag_drv.hdf \

# create the software configuration
createapp \
    -name sw \
    -hwproject hw \
    -proc ps7_cortexa9_0 \
    -app {Empty Application}

# import sources
importsources \
    -name sw \
    -path ./firmware

# build application
projects \
    -build \
    -type app \
    -name sw

# quit
exit

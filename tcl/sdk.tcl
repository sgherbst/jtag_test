# pull in user-defined variables
source tcl/vars.tcl

# set the work directory
setws $SDK_PATH

# create the hardware configuration
createhw \
    -name $HW_NAME \
    -hwspec "$SDK_PATH/$TOP_NAME.hdf"

# create the software configuration
createapp \
    -name $SW_NAME \
    -hwproject $HW_NAME \
    -proc $PROC_NAME \
    -app "Empty Application"

# import sources
importsources \
    -name $SW_NAME \
    -path $FIRMWARE_DIR

# build application
projects -build

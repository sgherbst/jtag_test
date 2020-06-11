# pull in user-defined variables
source tcl/vars.tcl

# set the work directory
setws $SDK_PATH

# create the app configuration
app create \
    -name $SW_NAME \
    -hw "$PRJ_DIR/$TOP_NAME.xsa" \
    -os standalone \
    -proc $PROC_NAME \
    -template "Empty Application"

# build application
app build -name $SW_NAME

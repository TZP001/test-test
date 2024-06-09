#!/bin/ksh

FullShellName=$(whence "$0")

# To get the name of the current script
ShellName=${FullShellName##*/}

# To get the name of the containing directory
ShellDir=${FullShellName%/*}

# To give the list of e-mail target guys. You can give a list of email.
export MAIL_ADDR_LIST="ygd@soleil"

# To launch the data transfer
whence adl_transfer_ws_v5.sh 2>&1 >/dev/null
if [ $? -ne 0 ]
then
  echo "adl_transfer_ws_v5.sh script file has not been found. Execute the AdeleMultiSite_profile before start the data transfer" 1>&2
  exit 2
fi 

if [ $(uname -s) = "Windows_NT" ]
then
	TCK_PROFILE=//lisa/tools/tck_init
	TRACE_DIR=//witness/temp/YGDROOT/ToolsData/MultiSite/YGD_T3
else
	TCK_PROFILE=/u/env/isl/tck_init
	TRACE_DIR=/u/users/ygd/YGDTREE3/YGDROOT3/ToolsData/MultiSite/YGD_T3
fi

echo "### DEBUG $(whence adl_transfer_ws_v5.sh)"
adl_transfer_ws_v5.sh \
	-tid YGD_T3 -p $TCK_PROFILE -tck TCK_ADM_ADLS1 \
	-rw YGDROOT -rtree YGDTREE -r_no_image \
	-all_fw \
	-lw YGDROOT3 -ltree YGDTREE3 \
	-r_collect -r_publish \
	-l_collect -l_publish \
	-keep_trace 10 2>&1 | tee $TRACE_DIR/adl_transfer_ws_v5.txt

rc=$?

exit $rc

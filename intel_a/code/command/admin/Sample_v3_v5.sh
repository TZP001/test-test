#!/bin/ksh

FullShellName=$(whence "$0")

# To get the name of the current script
ShellName=${FullShellName##*/}

# To get the name of the containing directory
ShellDir=${FullShellName%/*}

# To give the list of e-mail target guys. You can give a list of email.
export MAIL_ADDR_LIST="ygd@soleil"

# To launch the data transfer
whence adl_transfer_remote_ws.sh 2>&1 >/dev/null
if [ $? -ne 0 ]
then
  echo "adl_transfer_remote_ws.sh script file has not been found. Execute the AdeleMultiSite_profile before start the data transfer" 1>&2
  exit 2
fi 

echo "### DEBUG $(whence adl_transfer_remote_ws.sh)"
adl_transfer_remote_ws.sh -trace_adl_cmd -tid YGD_T1 -mail -http http://herrero:8016 -keep_trace 10 \
  -rhost prostdsy -rl 3 -rp ~adl/adl_profile -rw BSF -rb TEST3 -rproj YGDRSITE -rtmp /tmp\
  -fw Fw1 Fw2 Fw3 Fw31 Fw4 \
  -ll 5 -lp /u/env/isl/tck_init -lw YGDINT -lb USER_adls1 -ltree YGDTREE -ltmp /tmp\
  -r_collect -r_publish -l_sync -l_publish -l_promote 2>&1 | tee /u/users/ygd/YGDTREE/YGDINT/ToolsData/MultiSite/YGD_T1/adl_transfer_remote_ws.sh.out

rc=$?

exit $rc

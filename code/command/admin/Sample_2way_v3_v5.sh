#!/bin/ksh

FullShellName=$(whence "$0")

# To get the name of the current script
ShellName=${FullShellName##*/}

# To get the name of the containing directory
ShellDir=${FullShellName%/*}

# To give the list of e-mail target guys. You can give a list of email.
export MAIL_ADDR_LIST="cga@soleil"

# To launch the data transfer
whence adl_two_way_transfer.sh 2>&1 >/dev/null
if [ $? -ne 0 ]
then
  echo "adl_two_way_transfer.sh script file has not been found. Execute the AdeleMultiSite_profile before starting the data transfer" 1>&2
  exit 2
fi 

echo "### DEBUG $(whence adl_two_way_transfer.sh)"
adl_two_way_transfer.sh -trace_adl_cmd -tid CGA_T1 -mail -http http://herrero:8016 -keep_trace 10 \
  -rhost igor -rl 3 -rp ~adl/adl_profile -rw BSF -rb TEST7 -rproj CGARSITE -rtmp /tmp\
  -ll 5 -lp /u/env/isl/tck_init -lw ReportWS -lb USER_adls1 -ltree CGALSITE -ltmp /tmp\
  -l_sync -r_collect -l_collect -l_publish -l_promote -trace_adl_cmd 2>&1 | tee /u/users/cga/tmp/traces

rc=$?

exit $rc

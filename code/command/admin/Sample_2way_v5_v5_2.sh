#!/bin/ksh

FullShellName=$(whence "$0")

# To get the name of the current script
ShellName=${FullShellName##*/}

# To get the name of the containing directory
ShellDir=${FullShellName%/*}

# To have the html report for this data transfer
if [ -z "$ADL_MULTISITE_LOG_DIR" -a -f /u/lego/adele/util/AdeleMultiSite_Log ]
then
  export ADL_MULTISITE_LOG_DIR="/u/lego/adele/util/AdeleMultiSite_Log"
fi

# To give the list of e-mail target guys. You can give a list of email.
export MAIL_ADDR_LIST="ygd@soleil"

# To launch the data transfer
whence adl_two_way_transfer.sh 2>&1 >/dev/null
if [ $? -ne 0 ]
then
  echo "adl_two_way_transfer.sh script file has not been found. Execute the AdeleMultiSite_profile before starting the data transfer" 1>&2
  exit 2
fi 

echo "### DEBUG $(whence adl_two_way_transfer.sh)"
# -first_transfer_by_push \
adl_two_way_transfer.sh -trace_adl_cmd -tid YGD_T2 -mail -http http://herrero:8016 -keep_trace 10 \
  -rhost prostdsy -ru bsfr \
  -rl 5 -rp /u/env/isl/tck_init -rw YGD_2WAY_2_R_ROOT -rb USER_adls1 -rtree YGD_2WAY_2_R -rtmp /u/users/bsfr/tmpdir\
  -ll 5 -lp /u/env/isl/tck_init -lw YGD_2WAY_L_REPORT2 -lb USER_adls1 -ltree YGD_2WAY_L -ltmp /u/users/ygd/tmp\
  -l_sync -r_collect -l_collect -l_publish -l_promote -trace_adl_cmd 2>&1 | tee /u/users/ygd/tmp/2way2traces

rc=$?

exit $rc

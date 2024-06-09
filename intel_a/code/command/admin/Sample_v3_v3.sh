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

echo "Fw1
Fw1 # et pourquoi pas
Fw3 
Fw31
Fw4
Fw2" > /tmp/TempFilter$$
echo "### DEBUG $(whence adl_transfer_remote_ws.sh)"
#  -fw Fw1 Fw2 \
adl_transfer_remote_ws.sh -trace_adl_cmd -tid YGD_T2  -mail -http http://herrero:8016 -keep_trace 10 \
  -rhost beleme -rl 3 -rp ~adl/adl_profile -rw PRJ -rb TEST3 -rproj YGDRSITE -rtmp /tmp\
  -lfw /tmp/TempFilter$$ \
  -ll 3 -lp /u/env/adlbin/adl_profile -lw YGDPRJ -lb TEST2 -lproj YGDPROJ -ltmp /tmp\
  -r_collect -r_publish -l_publish -l_promote 2>&1 | tee /u/users/ygd/YGDPROJ/YGDPRJ/.Adele/MultiSite/YGD_T2/adl_transfer_remote_ws.sh.YGDRSITE

rc=$?

exit $rc

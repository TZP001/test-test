#! /bin/ksh
echo "************************" 
echo "StartVPMBatchFromV5Batch"
echo "************************"
#set -xv

. network_profile
set -x
~VPA/InitVPM16 -l VPM1rel -base dedieu -x VX0SERV -e Dev -fix
exit 0

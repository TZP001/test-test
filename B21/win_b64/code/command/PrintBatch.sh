#! /bin/ksh
#                                                       
# Execution of CATPrintBatch utility  
#                                                                          
# $1 ----> Optional XML Print File Parameters  
#

export PATH=../bin:$PATH

if [ -f "$1" ]
then
  CNEXT -batch -e CATPrintBatchUtility $1 -e FileExit
else
  CATPrintBatchUI
fi

rc=$?
exit $rc

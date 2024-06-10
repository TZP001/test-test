#! /bin/ksh
# CATPrintBatchUtility sample
#

CNEXT -batch -e CATPrintBatchUtility ./PrintBatchParameters.xml -e FileExit

rc=$?
exit $rc

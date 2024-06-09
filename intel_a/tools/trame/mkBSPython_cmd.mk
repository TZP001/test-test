# @(#) preprocess
# ----------------------
# Specifications for Build step mkBSPython
# ----------------------


PYC_COMPILER_W = smaPyCompile.bat 
PYC_COMPILER_U = smaPyCompile.sh 

PYC_OPTS = $(LOCAL_PYCFLAGS)
PYC_COMMAND_W = $(PYC_COMPILER_W) 
PYC_COMMAND_U = $(PYC_COMPILER_U) 
#
DGM_DEPEND =  PYC_PRESERVE_STRUCTURE LOCAL_PYCFLAGS PYC_COPY_SOURCE
#DGM_VERSION = 0.1
#

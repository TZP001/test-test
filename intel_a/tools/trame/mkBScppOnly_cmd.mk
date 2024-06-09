#
# Specifications for Build step mkBSCompil SunOS
# ----------------------
DGM_VERSION = 1.0
# ----------------------
include mkBSCompil_cmd.mk
#
PPROC_OPTS = $(CPP_TOOUPUT:-"/P") /nologo
#
CPP_COMMAND = "$(PPROC)" $(PPROC_OPTS) /TP $(CPP_OPTS) $(CorbaCppBuildROOT_PATH:+CORBA_INCPATH) $(CPP_INCLUDE)
CPP_SINGLEPASSCOMMAND = "$(PPROC)" $(PPROC_OPTS) /MP /TP @"$(CPP_RESPONSEFILE)" $(CorbaCppBuildROOT_PATH:+CORBA_INCPATH) $(CPP_INCLUDE)
#
C_COMMAND = "$(PPROC)" $(PPROC_OPTS) $(C_OPTS) $(CPP_INCLUDE)
C_SINGLEPASSCOMMAND = "$(PPROC)" $(PPROC_OPTS) /MP @"$(C_RESPONSEFILE)" $(CPP_INCLUDE)
#


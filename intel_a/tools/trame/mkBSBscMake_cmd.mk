#
# Specifications for Build step mkBSGlobalResource
# ----------------------
DGM_VERSION = 1.0
# ----------------------
include mkBSCompilersPathDecl.mk
#
LD_SBRLIST = FWmksbrlist
BSCMAKE_NAME = $(FWNAME).bsc
#
BSC_OPTS = /nologo /n
#
BSC = $(_MK_BSCMAKE_UTILPATH)
BSC_COMMAND = "$(BSC)" $(BSC_OPTS) /o "$(BSCMAKE_OBJPATH)\$(BSCMAKE_NAME)" @"$(LD_SBRLIST)"
#


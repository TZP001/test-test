#
# Specifications for Build step mkBSTIE
# ----------------------
DGM_VERSION = 1.0
# ----------------------
include mkBSCompil_cmd.mk
#
PPROC_OPTS = /EP $(CPP_DYNOPTS) $(CPP_MKOPTS) $(LOCAL_POST_CCFLAGS) /DIUnknown_H /D__CATMacForIUnknown /DCATSysTSMacForIUnknown_h /D__AFXWIN_H__ /D_WINDOWS_ /D__AFX_H__
#
PPROC_COMMAND = "$(PPROC)" /nologo $(PPROC_OPTS) $(PPROC_INCLUDE)
#
TIE = JS0OLTIE
TIE_OPTS = $(LOCAL_TIEFLAGS)
TIE_COMMAND = $(TIE_OPTS) #-F "$(TIE_INCLUDES)"
#


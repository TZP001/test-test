# ----------------------
# Specifications for Build step mkBSGlobalResource
# ----------------------
DGM_VERSION = 1.0
# ----------------------
include mkBSCompilersPathDecl.mk
#
RC_OPTS = $(LOCAL_RCFLAGS) $(LOCAL_POST_RCFLAGS)
#
RC_COMPILER = $(_MK_RC_UTILPATH)
GR_COMMAND = "$(RC_COMPILER)" $(RC_OPTS) $(GR_INCLUDE) /FO "%OBJECT%" "$(GR_SOURCELIST)"
#

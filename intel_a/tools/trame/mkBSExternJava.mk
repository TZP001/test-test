#
# Specifications for Build step mkBSCompilJava
#
METACLASS_NAME   = ExternJava
#
DGM_GRAPH_PATH   = MODDGM_GRAPHPATH_JAVA
#
# Loop on MkmkOS_RootBuildtime to build SRCPATH_OSBT_PATH macro
SRCPATH_OSBT_MASK = $(MODPATH)/lib/
#
_MKMK_SRCPATH = "$(MODPATH)/lib/JAVA"
_USER_SRCPATH = $(LOCAL_SRCPATH:+SRCPATH_OSBT_MASK)$(LOCAL_SRCPATH)
#
SRCPATH = $(_USER_SRCPATH:-_MKMK_SRCPATH)
#
include mkBSJavaSet.mk
#

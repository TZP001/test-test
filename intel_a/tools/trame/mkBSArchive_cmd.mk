#
# Specifications for Build step mkBSArchive
#
LD_OBJLIST = MODmkobjlist
#
AR = lib
#
AR_OPTS = $(LOCAL_ARFLAGS) /nologo $(LOCAL_POST_ARFLAGS)
AR_COMMAND = $(AR) $(AR_OPTS) @"$(LD_OBJLIST)" /out:"%ARCHIVE%"
#
DGM_VERSION = 1.0
#

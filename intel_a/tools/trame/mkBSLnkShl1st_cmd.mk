# ----------------------
# Specifications for Build step mkBSLnkShl1st
# ----------------------
DGM_VERSION = 1.0
# ----------------------
include mkBSLnkCommonDecl.mk
#
LD_NAMEOPT = /NAME:"$(RTNAME)"
#
LD_OPTS = /LIB $(PROGRAM_EXTENSION:+LD_NAMEOPT) /NOLOGO /DEF $(USE_EXPORTS_LIST:%?DEFEXPLIST_OPT) $(MACHINE_FLAG) $(LOCAL_OPTS)
LD_LIBS = $(LOCAL_LIBS) $(_MK_COMMON_LIBS)
LD_LIBPATH = $(LOCAL_LIBPATH) $(_MK_COMMON_LIBPATH)
#
EXPORT_SYMBOLS_FILE = $(SYLPATHNAME)
DEFEXPLIST_OPT= /DEF:"$(EXPORT_SYMBOLS_FILE)"
# ~4
EXPORT_SYMBOLS_COMMAND = mkexportsymbolsM -out "$(EXPORT_SYMBOLS_FILE)" @"$(LD_OBJLIST)" 
# ~1
LD_COMMAND = "$(LD)" $(LD_OPTS) @"$(LD_OBJLIST)" /OUT:
#
# Build the export lists before the link
SCRIPT_COMMAND = ~4 ~1
#

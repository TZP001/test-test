# @(#) preprocess
# ----------------------
# Specifications for Build step mkBSLnkMain
#
include mkBSLnkCommonDecl.mk
#
# ----------------------
#if (defined MK_BITMODE) && (MK_BITMODE >= 64)
#rem: 64-bit
_MK_LDOPTS_BITMOD = /STACK:4194304
#else
#rem: 32-bit
 _MK_LARGEADD_OPTS = /LARGEADDRESSAWARE
#endif
#
# Warning: /STACK option must precede LOCAL_OPTS on command line 
LD_OPTS = $(_MK_LDOPTS_BITMOD) $(LOCAL_OPTS) $(_MK_LARGEADD_OPTS) $(_MK_COMMON_OPTS) /FIXED:NO $(MACHINE_FLAG) /MANIFEST $(_MK_MANIFESTUAC_OPTS)
LD_LIBS = $(LOCAL_LIBS) $(WS_LIBS) $(_MK_COMMON_LIBS)
LD_LIBPATH = $(LOCAL_LIBPATH) $(WS_LIBPATH) $(_MK_COMMON_LIBPATH)
# ~1
LD_COMMAND = "$(LD)" $(LD_OPTS) $(_MK_MANIFESTFILE_OPTS) $(LD_LIBPATH) $(LD_LIBS) @"$(LD_OBJLIST)" /OUT:
# ~3
MANIFEST_COMMAND = "$(MT_COMPILER)" -nologo -manifest "$(_MK_MANIFESTFILE)"%MANIFEST_OBJECTS% -outputresource:"$(RUNTIME_NAME);1"
EXTRA_COMMAND = $(MANIFEST_COMMAND)
#
DGM_VERSION = 1.0
#
#SCRIPT_COMMAND = LD_COMMAND [1] MANIFEST_COMMAND LD_SIGN_COMMAND
# ~2 = CAAV5Licensing
SCRIPT_COMMAND = ~1 ~2 ~3
#


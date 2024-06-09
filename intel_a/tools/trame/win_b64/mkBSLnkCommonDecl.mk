# @(#) preprocess
# ----------------------
# Common specifications for link-edit
# ----------------------
include mkBSCompilersPathDecl.mk
include mkBSSignToolDecl.mk
# ----------------------
#if (defined MK_MSCVER) && (MK_MSCVER >= 1500)
#rem: Microsoft Visual C++ 9.0 and higher
_MK_MANIFESTUAC_ASINVOKER = /MANIFESTUAC:level='asInvoker'
_MK_MANIFESTUAC_REQADMIN = $(MANIFESTUAC_ADMIN:+"/MANIFESTUAC:level='requireAdministrator'")
_MK_MANIFESTUAC_OPTS = $(_MK_MANIFESTUAC_REQADMIN:-_MK_MANIFESTUAC_ASINVOKER)
SUB_WIN  = /SUBSYSTEM:WINDOWS /ENTRY:wWinMainCRTStartup mfcs90u.lib mfc90u.lib
LD_OPTIMIZE = $(OPTIMIZATION_LD:@"/OPT:ICF /OPT:REF")
#else
SUB_WIN  = /SUBSYSTEM:WINDOWS /ENTRY:wWinMainCRTStartup mfcs80u.lib mfc80u.lib
LD_OPTIMIZE = $(OPTIMIZATION_LD:@"/OPT:ICF /OPT:REF /OPT:NOWIN98")
#endif
# ----------------------
LD = $(_MK_LINK_UTILPATH)
MT_COMPILER = $(_MK_MT_UTILPATH)
# ----------------------
SUB_CONS = /SUBSYSTEM:CONSOLE
MACHINE_FLAG = /MACHINE:X64
EDITANDCONTINUE = $(MKMK_DEBUGEDITANDCONTINUE:%-"/FORCE:MULTIPLE")
# ----------------------
_MK_COMMON_OPTS = /LARGEADDRESSAWARE $(EDITANDCONTINUE) $(CXX_MAPFILE:+"/MAP") /DEBUG /DEBUGTYPE:CV /NOLOGO /fixed:no $(MKMK_DEBUG:%-LD_OPTIMIZE)
_MK_COMMON_LIBS = kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
              advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib 
_MK_COMMON_LIBPATH =
# ----------------------
_MK_MANIFESTFILE = $(MOD_ObjectsPath)\$(MODNAME).manifest
_MK_MANIFESTFILE_OPTS = /MANIFESTFILE:"$(_MK_MANIFESTFILE)"
# ----------------------
LOCAL_OPTS = $(LOCAL_LDFLAGS)
LOCAL_LIBS = $(SYS_LIBS)
LOCAL_LIBPATH = $(SYS_LIBPATH)
# ----------------------
_SIGN_OBJNAME = $(RUNTIME_NAME)
#

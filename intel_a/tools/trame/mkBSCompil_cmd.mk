# @(#) preprocess
# ----------------------
# Specifications for Build step mkBSCompil
# ----------------------
DGM_VERSION = 1.0
# ----------------------
include mkBSCompilersPathDecl.mk
# ----------------------
#if (defined MK_MSCVER) && (MK_MSCVER >= 1500)
#rem: Microsoft Visual C++ 9.0 and higher
_MK_WIN_VER = /D"WINVER=0x0502" /D"_WIN32_WINNT=0x0502"
_MK_MFC_VER = /D"_MFC_VER=0x0900"
_MK_VC9OPTS = /D"_BIND_TO_CURRENT_VCLIBS_VERSION=1"
_MK_QVC_IFOPTS = /Qvc9
#rem: To include afxwin.h in CATIAV5Precompiled.h
_MK_PRECOMPIL_WITH_AFXWINDEF = /D"_MK_PRECOMPIL_WITH_AFXWIN"
#rem: _AFXDLL if STATIC_LIBS does not exist
_MK_AFXDLLDEF = /D"_AFXDLL"
_MK_AFXDLL = $(STATIC_LIBS:%@_MK_AFXDLLDEF)
# ----------------------
#else
#rem: Microsoft Visual C++ 8.0
#if (defined MK_BITMODE) && (MK_BITMODE >= 64)
#rem: 64-bit
_MK_WIN_VER = /D"WINVER=0x0502" /D"_WIN32_WINNT=0x0502"
#else
#rem: 32-bit
_MK_WIN_VER = /D"WINVER=0x0500" /D"_WIN32_WINNT=0x0500"
#endif
_MK_MFC_VER = /D"_MFC_VER=0x0800"
_MK_QVC_IFOPTS = /Qvc8
#rem: Empty for VS 8.0
_MK_PRECOMPIL_WITH_AFXWINDEF =
#rem: _AFXDLL
_MK_AFXDLL = /D"_AFXDLL"
#endif
# ----------------------
LICENCE_FW_TYPE = $(MkmkExternalDS:+"External")
# ----------------------
#if (defined MK_BITMODE) && (MK_BITMODE >= 64)
#rem: 64-bit
_MK_DEFINED_BITMOD = /D"WIN64" /D"PLATEFORME_DS64" /D"_DS_PLATEFORME_64" /D"_WIN64" /D"_AMD64_=1"
# Mode "Debug & continue" is not supported on 64-bit, do not switch /Zi to /ZI
_EDITANDCONTINUE = $(MKMK_DEBUGEDITANDCONTINUE:+"/Zi")
F_OPTIMIZE = $(OPTIMIZATION_FORTRAN:-"/optimize:3 /QxW")
#else
#rem: 32-bit
_MK_DEFINED_BITMOD = /D"WIN32" /D"_CRT__NONSTDC_NO_DEPRECATE" /D"_CRT_SECURE_NO_DEPRECATE"
# Mode "Debug & continue" supported, do switch /Zi to /ZI
_EDITANDCONTINUE = $(MKMK_DEBUGEDITANDCONTINUE:+"/ZI")
F_OPTIMIZE = $(OPTIMIZATION_FORTRAN:-"/optimize:2 /QxW")
#endif
# ----------------------
DEFINED = /D"_WINDOWS" /D"_WINDOWS_SOURCE" /D"_WINNT_SOURCE" /D"_ENDIAN_LITTLE"\
	$(_MK_WIN_VER) $(_MK_MFC_VER) $(_MK_VC9OPTS)\
	/D"_CAT_ANSI_STREAMS" /D"CAT_ENABLE_NATIVE_EXCEPTION"\
	/D"OS_$(MkmkOS_NAME)" $(_MK_DEFINED_BITMOD)\
	$(MKMK_DEVSTAGE:%-"/DCNEXT_CLIENT")\
	/D"_MK_CONTNAME_=$(CONTNAME)"\
	/D"_MK_MODNAME_=$(MODNAME)" /D"_MK_FWNAME_=$(LICENCE_FW_TYPE:-FWNAME)"
#
# ----------------------
#rem: C++
# ----------------------
#
CPP_DEBUG_VALUE = /Od
CPP_DEBUG = $(MKMK_DEBUG:+CPP_DEBUG_VALUE)
#
_MK_RTTI=/GR$(CLR:%-"-")
CPP_OPTIMIZE_VALUE = /Oxt /Gy /GF $(CXX_RTTI:@_MK_RTTI)
CPP_OPTIMIZE = $(OPTIMIZATION_CPP:-CPP_OPTIMIZE_VALUE)
# ----------------------
#if (defined MK_MSCVER) && (MK_MSCVER >= 1500)
#rem: Microsoft Visual C++ 9.0 and higher
#rem: /Wp64 has been deprecated
CPP_WARNING = $(MKMK_WARNING:+"/W3 /wd4251")
CPP_STANDARD = /W1 /wd4996 /wd4290
#else
#rem: Microsoft Visual C++ 8.0
#if (defined MK_BITMODE) && (MK_BITMODE >= 64)
#rem: 64-bit
CPP_WARNING = $(MKMK_WARNING:+"/W3 /Wp64 /wd4251")
CPP_STANDARD = /W1 /Wp64 /wd4996 /wd4290
#else
#rem: 32-bit
CPP_WARNING = $(MKMK_WARNING:+"/W3 /wd4251")
CPP_STANDARD = /W1 /wd4996 /wd4290
#endif
#endif
# ----------------------
CPP_BSCMAKE = $(MKMK_BSCMAKE:+"/FR")
#
#rem: add options if CXX_EXCEPTION exists even empty
CPP_EXCEPT = $(CXX_EXCEPTION:?"/EHsc")
#rem: if CXX_UNICODE does not exist
_MK_UNICODE = /D"UNICODE" /D"_UNICODE"
CPP_UNICODE= $(CXX_UNICODE:%@_MK_UNICODE)
#rem: if CXX_AFXDLL does not exist
CPP_AFXDLL = $(CXX_AFXDLL:%@_MK_AFXDLL)
#rem: use CXX_WARNINGPROMOTE if CXX_WARNINGPROMOTE exists even empty
_MK_WARNINGPROMOTE = $(CXX_WARNINGPROMOTE:@"CATWarningPromote.h")
CPP_WARNINGPROMOTEOPT = $(_MK_WARNINGPROMOTE:+"/FI")$(_MK_WARNINGPROMOTE)
#rem: use CXX_CATIAV5PRECOMPILED if CXX_CATIAV5PRECOMPILED exists
_MK_CATIAV5PRECOMPILED = $(CXX_CATIAV5PRECOMPILED:-"CATIAV5Precompiled.h")
CPP_CATIAV5PRECOMPILED = /FI"$(_MK_CATIAV5PRECOMPILED)"
# Do not use header pre-compilation if Imakefile.mk set MKMK_USEPRECOMPIL to an empty value
_USEPRECOMPIL = $(MKMK_USEPRECOMPIL)
#
CPP_FORCE_INCLUDE = $(_MK_WARNINGPROMOTE) $(_USEPRECOMPIL:+_MK_CATIAV5PRECOMPILED)
#
CPP_DYNOPTS = $(LOCAL_CCFLAGS) $(CPP_DEBUG:-CPP_OPTIMIZE) $(CLR:+"/CLR") $(CPP_WARNING:-CPP_STANDARD) $(CXX_GS:@"/GS-")
#
CPP_MKOPTS = $(STATIC_LIBS:%@"/MD") $(STATIC_LIBS:%?"/MT") $(CPP_BSCMAKE) $(CPP_EXCEPT) $(_EDITANDCONTINUE:-"/Zi")\
	$(CPP_UNICODE) $(CPP_AFXDLL) /D"_LANGUAGE_CPLUSPLUS" $(DEFINED) $(DEFINED_EXPORTEDBY)\
	$(CXX_FORSCOPE:@"/Zc:forScope-") $(CXX_WCHART:@"/Zc:wchar_t-")
#
# The name of the pch file
CPP_PCHBASENAME = mkmksourceforpch
CPP_PCHNAME = $(CPP_PCHBASENAME).pch
CPP_PCHSOURCE = $(MkmkROOTINSTALL_PATH)\.\tools\data\$(CPP_PCHBASENAME).cpp
# The options to force the include of the header precompiled
CPP_PCHINCLUDE_OPTS = $(MKMFC_DEPENDENCY:+_MK_PRECOMPIL_WITH_AFXWINDEF) /FI"$(_MK_CATIAV5PRECOMPILED)"
# The options to USE the precompiled header file
CPP_PCHUSED_OPTS = /Yu"$(_MK_CATIAV5PRECOMPILED)" /Fp"$(CPP_PCHNAME)"
# The options to CREATE the precompiled header file
CPP_PCHCREATE_OPTS = /Yc"$(_MK_CATIAV5PRECOMPILED)"
# The command line to CREATE the precompiled header file, empty if precompilation has been disabled
_MK_PCHCREATE_COMMAND = "$(CPP_COMPILER)" /nologo /c /TP $(CPP_PCHCREATE_OPTS) $(CPP_PCHUSED_OPTS) $(CPP_OPTS) $(CPP_INCLUDE) "$(CPP_PCHSOURCE)"
CPP_PCHCREATE_COMMAND = $(_USEPRECOMPIL:+_MK_PCHCREATE_COMMAND)
#
# Registered into dependancies graphs
CPP_OPTS = $(CPP_DYNOPTS) $(_USEPRECOMPIL:+CPP_PCHINCLUDE_OPTS) $(CPP_WARNINGPROMOTEOPT) $(CPP_MKOPTS) $(LOCAL_POST_CCFLAGS)
#
CPP_RESPONSEFILE = cpp.response.mk
# 
CPP_COMPILER = $(_MK_CL_UTILPATH)
# Macro CPP_PCHSOURCE_ENABLED is set by the build step if precompilation is active
CPP_COMMAND = "$(CPP_COMPILER)" /nologo /c /TP $(CPP_PCHSOURCE_ENABLED:+CPP_PCHUSED_OPTS) $(CPP_OPTS) $(CorbaCppBuildROOT_PATH:+CORBA_INCPATH) $(CPP_INCLUDE)
CPP_SINGLEPASSCOMMAND = "$(CPP_COMPILER)" /nologo /c /TP $(CPP_PCHSOURCE_ENABLED:+CPP_PCHUSED_OPTS) @"$(CPP_RESPONSEFILE)" $(CorbaCppBuildROOT_PATH:+CORBA_INCPATH) $(CPP_INCLUDE)
#
# ----------------------
#rem: C
# ----------------------
#if (defined MK_MSCVER) && (MK_MSCVER >= 1500)
#rem: Microsoft Visual C++ 9.0 and higher
#rem: /Wp64 has been deprecated
C_STANDARD = /W1 /wd4996
#else
#rem: Microsoft Visual C++ 8.0
#if (defined MK_BITMODE) && (MK_BITMODE >= 64)
#rem: 64-bit
C_STANDARD = /W1 /Wp64 /wd4996
#else
#rem: 32-bit
C_STANDARD = /W1 /wd4996
#endif
#endif
# ----------------------
C_DEBUG = $(CPP_DEBUG)
C_OPTIMIZE_VALUE = $(CPP_OPTIMIZE_VALUE)
C_OPTIMIZE = $(OPTIMIZATION_C:-C_OPTIMIZE_VALUE)
C_WARNING = $(CPP_WARNING)
C_BSCMAKE = $(CPP_BSCMAKE)
C_EXCEPT = $(CPP_EXCEPT)
C_UNICODE= $(CPP_UNICODE)
C_AFXDLL = $(CPP_AFXDLL)
#
C_OPTS = $(LOCAL_CFLAGS) $(C_DEBUG:-C_OPTIMIZE) $(CLR:+"/CLR") $(C_WARNING:-C_STANDARD) /GS-\
	$(STATIC_LIBS:%@"/MD") $(STATIC_LIBS:%?"/MT") $(C_BSCMAKE) $(C_EXCEPT) $(_EDITANDCONTINUE:-"/Zi")\
	$(C_UNICODE) $(C_AFXDLL) $(DEFINED) $(DEFINED_EXPORTEDBY) $(LOCAL_POST_CFLAGS)
#
C_RESPONSEFILE = c.response.mk
#
C_COMPILER = $(_MK_CL_UTILPATH)
C_COMMAND = "$(C_COMPILER)" /nologo /c $(C_OPTS) $(CPP_INCLUDE)
C_SINGLEPASSCOMMAND = "$(C_COMPILER)" /nologo /c @"$(C_RESPONSEFILE)" $(CPP_INCLUDE)
#
# ----------------------
#rem: FORTRAN
# ----------------------
#if (defined MK_IFVER) && (MK_IFVER >= 1001011)
#rem: --- Intel FORTRAN 10.1.011 and higher
_MK_VCVER_IFOPTS = $(_MK_QVC_IFOPTS)
#else
#rem: --- Intel FORTRAN 9.1
_MK_VCVER_IFOPTS = /Qvc8
_MK_IF091OPTS = /Zd /Zi
#endif
# ----------------------
F_DEBUG = $(MKMK_DEBUG:+"/Od /Zi /Zd")
F_IFACE_OPTS = /iface:nomixed_str_len_arg /iface:cref
F_PROTECT_OPTS = /assume:noprotect_constants
#
F_OPTS = $(_MK_VCVER_IFOPTS) $(LOCAL_FFLAGS) $(F_DEBUG:-F_OPTIMIZE) $(F_IFACE_OPTS)\
	/Qlowercase $(_MK_IF091OPTS) /w90 /cm /efi2\
	$(F_PROTECT_OPTS) /mCG_fast_sqrtps=F\
	/D_WINDOWS_SOURCE $(STATIC_LIBS:%@"/MD") $(STATIC_LIBS:%?"/MT")\
	/LD /Qsave $(LOCAL_POST_FFLAGS)
#
F_RESPONSEFILE = fort.response.mk
#
F_COMPILER = $(_MK_IFORT_UTILPATH)
F_COMMAND = "$(F_COMPILER)" /nologo /c $(F_OPTS) /fpp $(CPP_INCLUDE)
F_SINGLEPASSCOMMAND = "$(F_COMPILER)" /nologo /c @"$(F_RESPONSEFILE)" /fpp $(CPP_INCLUDE)
#
# ----------------------
#rem: ASSEMBLEUR
# ----------------------
#
S_OPTS = $(LOCAL_ASFLAGS) $(LOCAL_POST_ASFLAGS)
#
S_COMPILER = $(_MK_ML_UTILPATH)
S_COMMAND = "$(S_COMPILER)" /nologo /c /Cx $(S_OPTS)
#
# ----------------------
#rem: C++ Preprocesseur
# ----------------------
#
PPROC_OPTS = /EP /nologo
#
PPROC = $(_MK_CL_UTILPATH)
PPROC_COMMAND = "$(PPROC)" $(PPROC_OPTS) $(PPROC_INCLUDE)
#

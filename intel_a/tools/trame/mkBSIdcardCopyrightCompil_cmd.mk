# @(#) preprocess
# ----------------------
# Specifications for Build step mkBSIdcardCopyrightCompil
# ----------------------
DGM_VERSION = 1.0
# ----------------------
include mkBSCompilersPathDecl.mk
# ----------------------
#if (defined MK_BITMODE) && (MK_BITMODE >= 64)
#rem: 64-bit
_MK_DEFINED_BITMOD = /D"WIN64" /D"PLATEFORME_DS64" /D"_DS_PLATEFORME_64" /D"_WIN64" /D"_AMD64_=1"
#else
#rem: 32-bit
_MK_DEFINED_BITMOD = /D"WIN32" /D"_CRT__NONSTDC_NO_DEPRECATE" /D"_CRT_SECURE_NO_DEPRECATE"
#endif
# ----------------------
#
CPP_COMPILER = $(_MK_CL_UTILPATH)
CPP_OPTS = /c /nologo /MD /W1 /wd4996 /wd4290 /Zi /Od /GS-\
	/D"UNICODE" /D"_UNICODE" /D"_LANGUAGE_CPLUSPLUS"\
	/D"_WINDOWS" /D"_WINDOWS_SOURCE" /D"_WINNT_SOURCE"\
	/D"_ENDIAN_LITTLE" /D"WINVER=0x0502" /D"_WIN32_WINNT=0x0502"\
	/D"OS_$(MkmkOS_NAME)" $(_MK_DEFINED_BITMOD)
#
CPP_COMMAND = "$(CPP_COMPILER)" $(CPP_OPTS) $(CPP_INCLUDE)
#

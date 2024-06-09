# @(#) preprocess
# ----------------------
# Windows 32-bit mode
# Full pathnames for common utilities
# ----------------------
#if (defined MK_MSCVER) && (MK_MSCVER >= 1500)
#rem: Microsoft Visual C++ 9.0 and higher
_MK_MC_UTILPATH		= $(MkmkMSPSDKDIR)\bin\mc
_MK_MIDL_UTILPATH	= $(MkmkMSPSDKDIR)\bin\midl
_MK_RESGEN_UTILPATH	= $(MkmkMSPSDKDIR)\bin\resgen
_MK_TLBEXP_UTILPATH	= $(MkmkMSPSDKDIR)\bin\tlbexp
_MK_TLBIMP_UTILPATH	= $(MkmkMSPSDKDIR)\bin\tlbimp
_MK_ILDASM_UTILPATH	= $(MkmkMSPSDKDIR)\bin\ildasm
_MK_AL_UTILPATH		= $(MkmkMSPSDKDIR)\bin\al
# ----------------------
#else
#rem: Microsoft Visual C++ 8.0
_MK_MC_UTILPATH		= $(MkmkMSVSTOOLSBINDIR)\mc
_MK_MIDL_UTILPATH	= $(MkmkMSVSTOOLSBINDIR)\midl
_MK_RESGEN_UTILPATH	= $(MkmkMSNET20SDKDIR)\bin\resgen
_MK_TLBEXP_UTILPATH	= $(MkmkMSNET20SDKDIR)\bin\tlbexp
_MK_TLBIMP_UTILPATH	= $(MkmkMSNET20SDKDIR)\bin\tlbimp
_MK_ILDASM_UTILPATH	= $(MkmkMSNET20SDKDIR)\bin\ildasm
_MK_AL_UTILPATH		= $(MkmkMSVJSHARPDIR)\al
#endif
# ---------------------
_MK_BSCMAKE_UTILPATH= $(MkmkMSVCDIR)\bin\bscmake
_MK_CL_UTILPATH		= $(MkmkMSVCDIR)\bin\cl
_MK_DUMPBIN_UTILPATH= $(MkmkMSVCDIR)\bin\dumpbin
_MK_LIB_UTILPATH	= $(MkmkMSVCDIR)\bin\lib
_MK_LINK_UTILPATH	= $(MkmkMSVCDIR)\bin\link
_MK_ML_UTILPATH		= $(MkmkMSVCDIR)\bin\ml
# ---------------------
_MK_RC_UTILPATH = $(MkmkMSPSDKDIR)\bin\rc
_MK_MT_UTILPATH = $(MkmkMSPSDKDIR)\bin\mt
# ---------------------
_MK_CSC_UTILPATH	= $(MkmkMSVCSHARPDIR)\csc
_MK_VBC_UTILPATH	= $(MkmkMSVCSHARPDIR)\vbc
_MK_ILASM_UTILPATH	= $(MkmkMSVJSHARPDIR)\ilasm
_MK_VJC_UTILPATH	= $(MkmkMSVJSHARPDIR)\vjc
# ---------------------
#_MK_REGTLIB_UTILPATH = regtlib
# ---------------------
_MK_IFORT_UTILPATH = $(MkmkIFORTDIR)\bin\ifort
# ---------------------
_MK_DCC32_UTILPATH	= $(MkmkDELPHIDIR)\bin\dcc32
_MK_TLIBIMP_UTILPATH= $(MkmkDELPHIDIR)\bin\tlibimp
#

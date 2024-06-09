@if NOT DEFINED _DEBUG_ @echo off
rem ---------------------------------------------------------------------------
set NTunsetenvPath=%~dp0
rem ---------------------------------------------------------------------------
call MkodtUnSetenv.bat
rem ---------------------------------------------------------------------------
call MkcsUnSetenv.bat 2>NUL
rem ---------------------------------------------------------------------------
if NOT DEFINED TMP if DEFINED SystemDrive set TMP=%SystemDrive%\temp
if NOT DEFINED TEMP if DEFINED SystemDrive set TEMP=%SystemDrive%\temp
rem ---------------------------------------------------------------------------
:Profile
if NOT EXIST "%NTunsetenvPath%..\bin\NTunsetenvM.exe" (
@echo ERROR : %NTunsetenvPath%..\bin\NTunsetenvM.exe not found
goto :EOF
)
if DEFINED TMP if NOT EXIST "%TMP%" mkdir "%TMP%"
call "%NTunsetenvPath%..\bin\NTunsetenvM.exe" -getppid
if ERRORLEVEL 0 (
set NTunsetup=%TMP%\NTunsetup%ERRORLEVEL%.bat
) ELSE (
set NTunsetup=%TMP%\NTunsetup.bat
)
call "%NTunsetenvPath%..\bin\NTunsetenvM.exe" > "%NTunsetup%"
call "%NTunsetup%"
del /F "%NTunsetup%"
rem ---------------------------------------------------------------------------
set NTunsetup=
set NTunsetenvPath=
rem ---------------------------------------------------------------------------
set CorbaCppBuildROOT_PATH=
set CorbaCppROOT_PATH=
set CorbaJavaROOT_PATH=
rem ---------------------------------------------------------------------------
set DSarMakerROOT_PATH=
set JLMDeployROOT_PATH=
set MkmkRMSSDK_PATH=
rem ---------------------------------------------------------------------------
set JNIROOT_PATH=
set Java5ROOT_PATH=
set Java6ROOT_PATH=
set JavaROOT_PATH=
rem ---------------------------------------------------------------------------
set MK_DEVNULL=
set MK_SEPARATOR=
set MK_TEMPDIR=
set MkmkSHLIB_NAME=
rem ---------------------------------------------------------------------------
set DSXDEVVISUALCOMPILERVERSION=
rem ---------------------------------------------------------------------------
set MKMK_USEPRECOMPIL=
set MkmkADDON_LEVEL=
set NO_LOCAL_DEFINITION_FOR_IID=
rem ---------------------------------------------------------------------------
set Mkmk_Modifier=
set Mkmk_Modifier_BAD=
set MkmkBAD_MINITFLEVEL=
rem ---------------------------------------------------------------------------
set MkmkMSVCADDON_INCLUDE=
set MkmkMSVCADDON_LIB=
set MkmkMSVCADDON_PATH=
set MkmkMSPSDKDIR=
set MkmkMSVCDIR=
set MkmkMSVSTOOLSBINDIR=
rem ---------------------------------------------------------------------------
set MkmkMSVCSHARPDIR=
set MkmkMSVJSHARPDIR=
rem ---------------------------------------------------------------------------
set MkmkMSVSADDON_PATH=
set MkmkMSVSBINDIR=
set MkmkMSVSTADIR=
rem ---------------------------------------------------------------------------
set MkmkMSNET30DIR=
set MkmkMSNET35DIR=
rem ---------------------------------------------------------------------------
set MkmkIFORTDIR=
rem ---------------------------------------------------------------------------
set MkmkVS80Internal=
set MkmkVS90Internal=
set MkmkIF101Internal=
set MkmkIF91Internal=
set MkmkJDK16Internal=
set MkmkDELPHI50Internal=
set Mkmk_RELEASEInternal=
rem ---------------------------------------------------------------------------
set MkmkDictionary_PATH=
set MkmkIC_PATH=
set MkmkMsgCatalog_PATH=
set MkmkReffiles_PATH=
set MkmkTOOLSLIB_PATH=
set MkmkTOOLSINCLUDE_PATH=
set MkmkSHLIB_PATH=
rem ---------------------------------------------------------------------------
set MkmkOS_DOC=
rem ---------------------------------------------------------------------------
set MkmkPATH4TOOLS=
set MkmkROOTINSTALL_PATH=
set MkmkROOT_PATH=
set MkmkINSTALL_PATH=
set mkmkbuild=
set MkmkVERSION=
set MkodtOS_Runtime=
rem ---------------------------------------------------------------------------
goto :EOF

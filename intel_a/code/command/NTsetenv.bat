@if NOT DEFINED _DEBUG_ @echo off
rem ---------------------------------------------------------------------------
set NTsetenvPath=%~dp0
rem ---------------------------------------------------------------------------
rem --- VisualStudio and Visual C++
rem set MkmkVS80=yes
set MkmkVS80Internal=
set MkmkVS90Internal=
rem --- set current VisualStudio and Visual C++ version
if DEFINED MkmkVS80 set MkmkVS80Internal=yes
if not DEFINED MkmkVS80Internal (
set MkmkVS90Internal=yes
)
rem ---------------------------------------------------------------------------
rem --- FORTRAN
rem set MkmkIF91=91
set MkmkIF91Internal=
set MkmkIF101Internal=
rem --- set current FORTRAN version
if DEFINED MkmkIF91 set MkmkIF91Internal=%MkmkIF91%
if not DEFINED MkmkIF91Internal if DEFINED MkmkIF101 set MkmkIF101Internal=%MkmkIF101%
if not DEFINED MkmkIF91Internal if not DEFINED MkmkIF101 (
set MkmkIF101Internal=101.011
)
rem ---------------------------------------------------------------------------
rem --- JDK
set MkmkJDK16Internal=
rem --- set current JDK version update
if DEFINED MkmkJDK16 set MkmkJDK16Internal=%MkmkJDK16%
if not DEFINED MkmkJDK16Internal set MkmkJDK16Internal=0_14
rem ---------------------------------------------------------------------------
rem --- DELPHI
set MkmkDELPHI50Internal=
rem --- set current DELPHI version
set MkmkDELPHI50Internal=yes
rem ---------------------------------------------------------------------------
set Mkmk_RELEASEInternal=
if DEFINED Mkmk_RELEASE set Mkmk_RELEASEInternal=%Mkmk_RELEASE%
rem --- CATIA Version 5, phase I ----------------------------------------------
set MkmkADDON_LEVEL=MK_CATIAVER=5
rem ---------------------------------------------------------------------------
rem -- set MKMKPKTOKEN=DIIFAH3VPG06Q4JBPD7JTGW0PC0
set NO_LOCAL_DEFINITION_FOR_IID=yes
set MKMK_USEPRECOMPIL=yes
rem ---------------------------------------------------------------------------
set Mkmk_Modifier=1578
if DEFINED _Mkmk_Modifier set Mkmk_Modifier=%_Mkmk_Modifier%
set Mkmk_Modifier_BAD=16
if DEFINED _Mkmk_Modifier_BAD set Mkmk_Modifier_BAD=%_Mkmk_Modifier_BAD%
rem ---------------------------------------------------------------------------
set MkmkBAD_MINITFLEVEL=4
if DEFINED _MkmkBAD_MINITFLEVEL set MkmkBAD_MINITFLEVEL=%_MkmkBAD_MINITFLEVEL%
rem ---------------------------------------------------------------------------
set MkmkOS_RootBuildtime=
if DEFINED _MkmkOS_RootBuildtime set MkmkOS_RootBuildtime=%_MkmkOS_RootBuildtime%
rem ---------------------------------------------------------------------------
if NOT DEFINED TEMP if DEFINED SystemDrive set TEMP=%SystemDrive%\Temp
if NOT DEFINED TMP if DEFINED TEMP set TMP=%TEMP%
if DEFINED TEMP set MK_TEMPDIR=%TEMP%
rem ---------------------------------------------------------------------------
set MkmkOS_DOC=DOC
set MkmkSHLIB_NAME=PATH
set MK_DEVNULL=NUL
set MK_SEPARATOR=;
rem ---------------------------------------------------------------------------
:version
set mkmkbuild=0
set MkmkVERSION=Unknown version
set _mkmkversion=%NTsetenvPath%..\bin\mkmkversion.exe
if EXIST "%_mkmkversion%" FOR /F "tokens=1" %%i IN ('"%_mkmkversion%"') DO set mkmkbuild=%%i
if EXIST "%_mkmkversion%" FOR /F "tokens=*" %%i IN ('"%_mkmkversion%" -fullversion') DO set MkmkVERSION=%%i
set _mkmkversion=
@echo * mkmk version %MkmkVERSION% *
set _mkmkinstdate=%NTsetenvPath%MkmkInstallDate.date
if EXIST "%_mkmkinstdate%" FOR /F "tokens=*" %%i IN (%_mkmkinstdate%) DO @echo * Installation date %%i *
set _mkmkinstdate=
rem ---------------------------------------------------------------------------
:Profile
if NOT EXIST "%NTsetenvPath%..\bin\NTsetenvM.exe" (
@echo ERROR : %NTsetenvPath%..\bin\NTsetenvM.exe not found
goto :EOF
)
if DEFINED TEMP if NOT EXIST "%TEMP%" mkdir "%TEMP%"
call "%NTsetenvPath%..\bin\NTsetenvM.exe" -getppid
if ERRORLEVEL 0 (
set NTsetup=%TEMP%\NTsetup%ERRORLEVEL%.bat
) ELSE (
set NTsetup=%TEMP%\NTsetup.bat
)
call "%NTsetenvPath%..\bin\NTsetenvM.exe" > "%NTsetup%"
call "%NTsetup%"
del /F "%NTsetup%"
if DEFINED NTsetup set NTsetup=
rem ---------------------------------------------------------------------------
rem ----- Set DSxDevVisualCompiler version
if NOT EXIST "%NTsetenvPath%\ddvdversion.bat" goto End
for /f %%i in ('call "%NTsetenvPath%\ddvdversion.bat"') do set DSXDEVVISUALCOMPILERVERSION=%%i
if DEFINED DSXDEVVISUALCOMPILERVERSION @echo * Version DSx.Dev Visual Compiler: %DSXDEVVISUALCOMPILERVERSION% *
if NOT DEFINED DSXDEVVISUALCOMPILERVERSION @echo WARNING: Not a supported operating system for DSxDevVisualCompiler profile.
rem ---------------------------------------------------------------------------
:End
rem ---------------------------------------------------------------------------
if EXIST "%NTsetenvPath%\MkcsSetenv.bat" call "%NTsetenvPath%\MkcsSetenv.bat"
rem ---------------------------------------------------------------------------
call MkodtSetenv.bat
rem ---------------------------------------------------------------------------
if DEFINED NTsetenvPath set NTsetenvPath=
if NOT EXIST \dev md \dev
rem ---------------------------------------------------------------------------
goto :EOF

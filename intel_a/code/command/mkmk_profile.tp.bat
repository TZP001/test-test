@if not DEFINED _DEBUG_ @echo off
rem -----------------------------------------------------------------------------
rem - mkmk profile UNIX
rem -
rem - {TEMPLATE_LEVEL} must be replaced with level
rem - {TEMPLATE_HOST} must be replaced with NETAPP hostname
rem -	used in \\{TEMPLATE_HOST}\{TEMPLATE_LEVEL}rel\BFS
rem -
rem - TOOLSROOTPATHFULL
rem -	must be replaced with the installation path
rem -----------------------------------------------------------------------------
@echo * mkmk Windows profile Version 1.1.0 *
rem -----
if DEFINED _fnd_ set _fnd_=
for %%i in (NTunsetenv.bat) do set _fnd_=%%~$PATH:i
if DEFINED _fnd_ call %_fnd_%
if DEFINED _fnd_ set _fnd_=
rem -----
if DEFINED MkmkROOT_PATH set MkmkROOT_PATH=
if DEFINED MkmkINSTALL_PATH set MkmkINSTALL_PATH=
rem -----
if NOT DEFINED TCK_PROFILE_ID if DEFINED ADL_FR_CATIA set TCK_PROFILE_ID=%ADL_FR_CATIA%
rem -----
rem For diffusion switch process
set TOOLSROOTPATHFULL="Will be substitued"
set TOOLSROOTPATH="Will be substitued"
rem -----
set MkmkOFFICIAL_PATH=%TOOLSROOTPATHFULL%
if DEFINED TOOLSROOTPATHFULL set TOOLSROOTPATHFULL=
rem -----
set ADL_ODT_IMPACT=\\ds\dsy\{TEMPLATE_LEVEL}odt\{TEMPLATE_LEVEL}d\MemoryCheck\intel_a
set MkmkMACRO_V4=C:\TEMP
rem -----------------------------------------------------------------------------
rem - Search for macro LEVEL pathname
rem -----
if DEFINED MkmkMACRO_LEVEL set MkmkMACRO_LEVEL=
if DEFINED _MkmkMACRO_LEVEL set MkmkMACRO_LEVEL=%_MkmkMACRO_LEVEL%
if DEFINED MkmkMACRO_LEVEL (
 @echo Set MkmkMACRO_LEVEL to %MkmkMACRO_LEVEL% using _MkmkMACRO_LEVEL
 goto endmacrolevel
)
if DEFINED ReleaseDataProfile set ReleaseDataProfile=
if NOT DEFINED MkmkMACRO_LEVEL if DEFINED ADL_FR_CATIA if DEFINED TOOLSROOTPATH set ReleaseDataProfile=%TOOLSROOTPATH%\Release.data\%ADL_FR_CATIA%\Release.data.profile.bat
if DEFINED ReleaseDataProfile if EXIST "%ReleaseDataProfile%" call "%ReleaseDataProfile%"
if DEFINED ReleaseDataProfile set ReleaseDataProfile=
if DEFINED MkmkMACRO_LEVEL if DEFINED ReleaseDataProfile (
 @echo Set MkmkMACRO_LEVEL to %MkmkMACRO_LEVEL% using %ReleaseDataProfile%
 goto endmacrolevel
)
if NOT DEFINED MkmkMACRO_LEVEL @echo WARNING : Unable to MkmkMACRO_LEVEL
:endmacrolevel
if DEFINED TOOLSROOTPATH set TOOLSROOTPATH=
if DEFINED ReleaseDataProfile set ReleaseDataProfile=
rem -----------------------------------------------------------------------------
rem - Initialization using directly a run time view: MkmkROOT_PATH
rem -    _MkmkROOT_PATH_${TCK_PROFILE_ID}
rem -    _MkmkROOT_PATH_${TCK_ID}
rem -    _MkmkROOT_PATH_${ADL_FR_CATIA}
rem -    _MkmkROOT_PATH
rem -----
if DEFINED TCK_PROFILE_ID if DEFINED _MkmkROOT_PATH_%TCK_PROFILE_ID% for /f %%i in ('echo %%_MkmkROOT_PATH_%TCK_PROFILE_ID%%%') do set MkmkROOT_PATH=%%i
if DEFINED TCK_PROFILE_ID if DEFINED _MkmkROOT_PATH_%TCK_PROFILE_ID% @echo Set MkmkROOT_PATH to %MkmkROOT_PATH% using _MkmkROOT_PATH_%TCK_PROFILE_ID%
if DEFINED TCK_PROFILE_ID if DEFINED _MkmkROOT_PATH_%TCK_PROFILE_ID% goto pasadlfrcatia
rem -----
if DEFINED TCK_ID if DEFINED _MkmkROOT_PATH_%TCK_ID% for /f %%i in ('echo %%_MkmkROOT_PATH_%TCK_ID%%%') do set MkmkROOT_PATH=%%i
if DEFINED TCK_ID if DEFINED _MkmkROOT_PATH_%TCK_ID% @echo Set MkmkROOT_PATH to %MkmkROOT_PATH% using _MkmkROOT_PATH_%TCK_ID%
if DEFINED TCK_ID if DEFINED _MkmkROOT_PATH_%TCK_ID% goto pasadlfrcatia
rem -----
if DEFINED ADL_FR_CATIA if DEFINED _MkmkROOT_PATH_%ADL_FR_CATIA% for /f %%i in ('echo %%_MkmkROOT_PATH_%ADL_FR_CATIA%%%') do set MkmkROOT_PATH=%%i
if DEFINED ADL_FR_CATIA if DEFINED _MkmkROOT_PATH_%ADL_FR_CATIA% @echo Set MkmkROOT_PATH to %MkmkROOT_PATH% using _MkmkROOT_PATH_%ADL_FR_CATIA%
rem -----
:pasadlfrcatia
if NOT DEFINED MkmkROOT_PATH if DEFINED _MkmkROOT_PATH @echo Set MkmkROOT_PATH to %_MkmkROOT_PATH% using _MkmkROOT_PATH
if NOT DEFINED MkmkROOT_PATH if DEFINED _MkmkROOT_PATH set MkmkROOT_PATH=%_MkmkROOT_PATH%
rem -----
rem - call to code\command\NTsetenv.bat found in MkmkROOT_PATH
rem -----
set _ntsetenv_=
if DEFINED MkmkROOT_PATH for %%i in (code\command\NTsetenv.bat) do set _ntsetenv_=%%~$MkmkROOT_PATH:i
if DEFINED _ntsetenv_ call %_ntsetenv_%
if DEFINED _ntsetenv_ goto end
rem -----
if DEFINED MkmkROOT_PATH if NOT DEFINED _ntsetenv_ (
 @echo No file NTsetenv.bat found in 'code\command' of specified paths [%MkmkROOT_PATH%] >&2
 @echo mkmk profile failed >&2
 goto error )
rem -
rem -----------------------------------------------------------------------------
rem - No MkmkROOT_PATH found, search for MkmkINSTALL_PATH
rem - Initialization using an installation path: MkmkINSTALL_PATH.
rem -    _MkmkINSTALL_PATH_${TCK_PROFILE_ID}
rem -    _MkmkINSTALL_PATH
rem -    MkmkOFFICIAL_PATH
rem -----
if DEFINED TCK_PROFILE_ID if DEFINED _MkmkINSTALL_PATH_%TCK_PROFILE_ID% for /f %%i in ('echo %%_MkmkINSTALL_PATH_%TCK_PROFILE_ID%%%') do set MkmkINSTALL_PATH=%%i
if DEFINED TCK_PROFILE_ID if DEFINED _MkmkINSTALL_PATH_%TCK_PROFILE_ID% @echo Set MkmkINSTALL_PATH to %MkmkINSTALL_PATH% using _MkmkINSTALL_PATH_%TCK_PROFILE_ID%
rem -----
if NOT DEFINED MkmkINSTALL_PATH if DEFINED _MkmkINSTALL_PATH @echo Set MkmkINSTALL_PATH to %_MkmkINSTALL_PATH% using _MkmkINSTALL_PATH
if NOT DEFINED MkmkINSTALL_PATH if DEFINED _MkmkINSTALL_PATH set MkmkINSTALL_PATH=%_MkmkINSTALL_PATH%
rem -----
if NOT DEFINED MkmkINSTALL_PATH @echo Set MkmkINSTALL_PATH to %MkmkOFFICIAL_PATH%
if NOT DEFINED MkmkINSTALL_PATH set MkmkINSTALL_PATH=%MkmkOFFICIAL_PATH%
rem -----
rem - call to MkmkSetenv.bat found in MkmkINSTALL_PATH
rem -----
set _mkmksetenv_=
if DEFINED MkmkINSTALL_PATH for %%i in (MkmkSetenv.bat) do set _mkmksetenv_=%%~$MkmkINSTALL_PATH:i
if DEFINED _mkmksetenv_ call %_mkmksetenv_%
if DEFINED _mkmksetenv_ goto end
rem -----
if NOT DEFINED _mkmksetenv_ (
 @echo No file MkmkSetenv.bat found in specified path [%MkmkINSTALL_PATH%] >&2
 @echo mkmk profile failed >&2
 goto error )
rem -----
:error
if DEFINED ADL_ODT_IMPACT set ADL_ODT_IMPACT=
if DEFINED ADL_ODT_DROPCURRENT set ADL_ODT_DROPCURRENT=
if DEFINED ADL_ODT_DROPFILE set ADL_ODT_DROPFILE=
if DEFINED MkmkMACRO_LEVEL set MkmkMACRO_LEVEL=
if DEFINED MkmkMACRO_V4 set MkmkMACRO_V4=
if DEFINED MkmkROOT_PATH set MkmkROOT_PATH=
if DEFINED MkmkINSTALL_PATH set MkmkINSTALL_PATH=
rem -----
:end
if DEFINED MkmkOFFICIAL_PATH set MkmkOFFICIAL_PATH=
if DEFINED _ntsetenv_ set _ntsetenv_=
if DEFINED _mkmksetenv_ set _mkmksetenv_=
call set MkmkINSTALL_PATH >NUL

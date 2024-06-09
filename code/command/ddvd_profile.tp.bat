@if not DEFINED _DEBUG_ @echo off
rem -----------------------------------------------------------------------------
rem - ddvd profile 
rem -
rem - {TEMPLATE_LEVEL} must be replaced with : CXR18 or R203
rem -
rem - TOOLSROOTPATHFULL
rem -	must be replaced with the installation path
rem -----------------------------------------------------------------------------
@echo * ddvd Windows profile Version 1.1.0 *
rem -----
rem if DEFINED _fnd_ set _fnd_=
rem for %%i in (NTunsetenv.bat) do set _fnd_=%%~$PATH:i
rem if DEFINED _fnd_ call %_fnd_%
rem if DEFINED _fnd_ set _fnd_=
rem -----
if DEFINED ddvdROOT_PATH set ddvdROOT_PATH=
if DEFINED ddvdINSTALL_PATH set ddvdINSTALL_PATH=
rem -----
rem For diffusion switch process
set TOOLSROOTPATHFULL="Will be substitued"
set TOOLSROOTPATH="Will be substitued"
rem -----
set ddvdOFFICIAL_PATH=%TOOLSROOTPATHFULL%
if DEFINED TOOLSROOTPATHFULL set TOOLSROOTPATHFULL=
rem -----------------------------------------------------------------------------
rem - Initialization using directly a run time view: ddvdROOT_PATH
rem -    _ddvdROOT_PATH_${TCK_PROFILE_ID}
rem -    _ddvdROOT_PATH_${TCK_ID}
rem -    _ddvdROOT_PATH_${ADL_FR_CATIA}
rem -    _ddvdROOT_PATH
rem -----
if DEFINED TCK_PROFILE_ID if DEFINED _ddvdROOT_PATH_%TCK_PROFILE_ID% for /f %%i in ('echo %%_ddvdROOT_PATH_%TCK_PROFILE_ID%%%') do set ddvdROOT_PATH=%%i
if DEFINED TCK_PROFILE_ID if DEFINED _ddvdROOT_PATH_%TCK_PROFILE_ID% @echo Set ddvdROOT_PATH to %ddvdROOT_PATH% using _ddvdROOT_PATH_%TCK_PROFILE_ID%
if DEFINED TCK_PROFILE_ID if DEFINED _ddvdROOT_PATH_%TCK_PROFILE_ID% goto ddvdpasadlfrcatia
rem -----
if DEFINED TCK_ID if DEFINED _ddvdROOT_PATH_%TCK_ID% for /f %%i in ('echo %%_ddvdROOT_PATH_%TCK_ID%%%') do set ddvdROOT_PATH=%%i
if DEFINED TCK_ID if DEFINED _ddvdROOT_PATH_%TCK_ID% @echo Set ddvdROOT_PATH to %ddvdROOT_PATH% using _ddvdROOT_PATH_%TCK_ID%
if DEFINED TCK_ID if DEFINED _ddvdROOT_PATH_%TCK_ID% goto ddvdpasadlfrcatia
rem -----
if DEFINED ADL_FR_CATIA if DEFINED _ddvdROOT_PATH_%ADL_FR_CATIA% for /f %%i in ('echo %%_ddvdROOT_PATH_%ADL_FR_CATIA%%%') do set ddvdROOT_PATH=%%i
if DEFINED ADL_FR_CATIA if DEFINED _ddvdROOT_PATH_%ADL_FR_CATIA% @echo Set ddvdROOT_PATH to %ddvdROOT_PATH% using _ddvdROOT_PATH_%ADL_FR_CATIA%
rem -----
:ddvdpasadlfrcatia
if NOT DEFINED ddvdROOT_PATH if DEFINED _ddvdROOT_PATH @echo Set ddvdROOT_PATH to %_ddvdROOT_PATH% using _ddvdROOT_PATH
if NOT DEFINED ddvdROOT_PATH if DEFINED _ddvdROOT_PATH set ddvdROOT_PATH=%_ddvdROOT_PATH%
rem -----
rem - call to code\command\NTsetenv.bat found in ddvdROOT_PATH
rem -----
rem set _ntsetenv_=
rem if DEFINED ddvdROOT_PATH for %%i in (code\command\NTsetenv.bat) do set _ntsetenv_=%%~$ddvdROOT_PATH:i
rem if DEFINED _ntsetenv_ call %_ntsetenv_%
rem if DEFINED _ntsetenv_ goto end
rem -----
rem if DEFINED ddvdROOT_PATH if NOT DEFINED _ntsetenv_ (
rem  @echo No file NTsetenv.bat found in 'code\command' of specified paths [%ddvdROOT_PATH%] >&2
rem  @echo ddvd profile failed >&2
rem  goto error )
rem -
rem -----------------------------------------------------------------------------
rem - No ddvdROOT_PATH found, search for ddvdINSTALL_PATH
rem - Initialization using an installation path: ddvdINSTALL_PATH.
rem -    _ddvdINSTALL_PATH_${TCK_PROFILE_ID}
rem -    _ddvdINSTALL_PATH
rem -    ddvdOFFICIAL_PATH
rem -----
if DEFINED TCK_PROFILE_ID if DEFINED _ddvdINSTALL_PATH_%TCK_PROFILE_ID% for /f %%i in ('echo %%_ddvdINSTALL_PATH_%TCK_PROFILE_ID%%%') do set ddvdINSTALL_PATH=%%i
if DEFINED TCK_PROFILE_ID if DEFINED _ddvdINSTALL_PATH_%TCK_PROFILE_ID% @echo Set ddvdINSTALL_PATH to %ddvdINSTALL_PATH% using _ddvdINSTALL_PATH_%TCK_PROFILE_ID%
rem -----
if NOT DEFINED ddvdINSTALL_PATH if DEFINED _ddvdINSTALL_PATH @echo Set ddvdINSTALL_PATH to %_ddvdINSTALL_PATH% using _ddvdINSTALL_PATH
if NOT DEFINED ddvdINSTALL_PATH if DEFINED _ddvdINSTALL_PATH set ddvdINSTALL_PATH=%_ddvdINSTALL_PATH%
rem -----
if NOT DEFINED ddvdINSTALL_PATH @echo Set ddvdINSTALL_PATH to %ddvdOFFICIAL_PATH%
if NOT DEFINED ddvdINSTALL_PATH set ddvdINSTALL_PATH=%ddvdOFFICIAL_PATH%
rem -----
rem - call to ddvdSetenv.bat found in ddvdINSTALL_PATH
rem -----
set _ddvdsetenv_=
if DEFINED ddvdINSTALL_PATH for %%i in (ddvdSetenv.bat) do set _ddvdsetenv_=%%~$ddvdINSTALL_PATH:i
if DEFINED _ddvdsetenv_ call %_ddvdsetenv_%
if DEFINED _ddvdsetenv_ goto end
rem -----
if NOT DEFINED _ddvdsetenv_ (
 @echo No file ddvdSetenv.bat found in specified path [%ddvdINSTALL_PATH%] >&2
 @echo ddvd profile failed >&2
 goto error )
rem -----
:error
if DEFINED ddvdROOT_PATH set ddvdROOT_PATH=
if DEFINED ddvdINSTALL_PATH set ddvdINSTALL_PATH=
rem -----
:end
if DEFINED ddvdOFFICIAL_PATH set ddvdOFFICIAL_PATH=
rem if DEFINED _ntsetenv_ set _ntsetenv_=
if DEFINED _ddvdsetenv_ set _ddvdsetenv_=
call set ddvdINSTALL_PATH >NUL

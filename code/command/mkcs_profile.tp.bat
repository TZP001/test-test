@if not DEFINED _DEBUG_ @echo off
rem -----------------------------------------------------------------------------
rem - mkcs profile UNIX
rem -
rem - TOOLSROOTPATHFULL
rem -	must be replaced with the installation path
rem -----------------------------------------------------------------------------
@echo * mkCheckSource Windows profile Version 1.1.0 *
rem -----
if DEFINED _fnd_ set _fnd_=
for %%i in (MkcsUnSetenv.bat) do set _fnd_=%%~$PATH:i
if DEFINED _fnd_ call %_fnd_%
if DEFINED _fnd_ set _fnd_=
rem -----
if DEFINED mkcsROOT_PATH set mkcsROOT_PATH=
if DEFINED mkcsINSTALL_PATH set mkcsINSTALL_PATH=
if DEFINED MkcsROOT_PATH set MkcsROOT_PATH=
if DEFINED MkcsINSTALL_PATH set MkcsINSTALL_PATH=
rem -----
rem For diffusion switch process
set TOOLSROOTPATHFULL="Will be substitued"
rem -----
set mkcsOFFICIAL_PATH=%TOOLSROOTPATHFULL%
if DEFINED TOOLSROOTPATHFULL set TOOLSROOTPATHFULL=
rem -----------------------------------------------------------------------------
rem - Initialization using directly a run time view: mkcsROOT_PATH
rem -    _mkcsROOT_PATH_${TCK_PROFILE_ID}
rem -    _mkcsROOT_PATH_${TCK_ID}
rem -    _mkcsROOT_PATH_${ADL_FR_CATIA}
rem -    _mkcsROOT_PATH
rem -----
if DEFINED TCK_PROFILE_ID if DEFINED _mkcsROOT_PATH_%TCK_PROFILE_ID% for /f %%i in ('echo %%_mkcsROOT_PATH_%TCK_PROFILE_ID%%%') do set mkcsROOT_PATH=%%i
if DEFINED TCK_PROFILE_ID if DEFINED _mkcsROOT_PATH_%TCK_PROFILE_ID% @echo Set mkcsROOT_PATH to %mkcsROOT_PATH% using _mkcsROOT_PATH_%TCK_PROFILE_ID%
if DEFINED TCK_PROFILE_ID if DEFINED _mkcsROOT_PATH_%TCK_PROFILE_ID% goto pasadlfrcatia
rem -----
if DEFINED TCK_ID if DEFINED _mkcsROOT_PATH_%TCK_ID% for /f %%i in ('echo %%_mkcsROOT_PATH_%TCK_ID%%%') do set mkcsROOT_PATH=%%i
if DEFINED TCK_ID if DEFINED _mkcsROOT_PATH_%TCK_ID% @echo Set mkcsROOT_PATH to %mkcsROOT_PATH% using _mkcsROOT_PATH_%TCK_ID%
if DEFINED TCK_ID if DEFINED _mkcsROOT_PATH_%TCK_ID% goto pasadlfrcatia
rem -----
if DEFINED ADL_FR_CATIA if DEFINED _mkcsROOT_PATH_%ADL_FR_CATIA% for /f %%i in ('echo %%_mkcsROOT_PATH_%ADL_FR_CATIA%%%') do set mkcsROOT_PATH=%%i
if DEFINED ADL_FR_CATIA if DEFINED _mkcsROOT_PATH_%ADL_FR_CATIA% @echo Set mkcsROOT_PATH to %mkcsROOT_PATH% using _mkcsROOT_PATH_%ADL_FR_CATIA%
rem -----
:pasadlfrcatia
if NOT DEFINED mkcsROOT_PATH if DEFINED _mkcsROOT_PATH @echo Set mkcsROOT_PATH to %_mkcsROOT_PATH% using _mkcsROOT_PATH
if NOT DEFINED mkcsROOT_PATH if DEFINED _mkcsROOT_PATH set mkcsROOT_PATH=%_mkcsROOT_PATH%
rem -----
rem - call to code\command\MkcsSetenv.bat found in mkcsROOT_PATH
rem -----
set _mkcssetenv_=
if DEFINED mkcsROOT_PATH for %%i in (code\command\MkcsSetenv.bat) do set _mkcssetenv_=%%~$mkcsROOT_PATH:i
if DEFINED _mkcssetenv_ call %_mkcssetenv_%
if DEFINED _mkcssetenv_ goto end
rem -----
if DEFINED mkcsROOT_PATH if NOT DEFINED _mkcssetenv_ (
 @echo No file MkcsSetenv.bat found in 'code\command' of specified paths [%mkcsROOT_PATH%] >&2
 @echo mkcs profile failed >&2
 goto error )
rem -
rem -----------------------------------------------------------------------------
rem - No mkcsROOT_PATH found, search for mkcsINSTALL_PATH
rem - Initialization using an installation path: mkcsINSTALL_PATH.
rem -    _mkcsINSTALL_PATH_${TCK_PROFILE_ID}
rem -    _mkcsINSTALL_PATH
rem -    mkcsOFFICIAL_PATH
rem -----
if DEFINED TCK_PROFILE_ID if DEFINED _mkcsINSTALL_PATH_%TCK_PROFILE_ID% for /f %%i in ('echo %%_mkcsINSTALL_PATH_%TCK_PROFILE_ID%%%') do set mkcsINSTALL_PATH=%%i
if DEFINED TCK_PROFILE_ID if DEFINED _mkcsINSTALL_PATH_%TCK_PROFILE_ID% @echo Set mkcsINSTALL_PATH to %mkcsINSTALL_PATH% using _mkcsINSTALL_PATH_%TCK_PROFILE_ID%
rem -----
if NOT DEFINED mkcsINSTALL_PATH if DEFINED _mkcsINSTALL_PATH @echo Set mkcsINSTALL_PATH to %_mkcsINSTALL_PATH% using _mkcsINSTALL_PATH
if NOT DEFINED mkcsINSTALL_PATH if DEFINED _mkcsINSTALL_PATH set mkcsINSTALL_PATH=%_mkcsINSTALL_PATH%
rem -----
if NOT DEFINED mkcsINSTALL_PATH @echo Set mkcsINSTALL_PATH to %mkcsOFFICIAL_PATH%
if NOT DEFINED mkcsINSTALL_PATH set mkcsINSTALL_PATH=%mkcsOFFICIAL_PATH%
rem -----
rem - call to MkcsSetenv.bat found in mkcsINSTALL_PATH
rem -----
if DEFINED _mkcssetenv_ set _mkcssetenv_=
if DEFINED mkcsINSTALL_PATH for %%i in (MkcsSetenv.bat) do set _mkcssetenv_=%%~$mkcsINSTALL_PATH:i
if DEFINED _mkcssetenv_ call %_mkcssetenv_%
if DEFINED _mkcssetenv_ goto end
rem -----
if NOT DEFINED _mkcssetenv_ (
 @echo No file MkcsSetenv.bat found in specified path [%mkcsINSTALL_PATH%] >&2
 @echo mkcs profile failed >&2
 goto error )
rem -----
:error
if DEFINED mkcsROOT_PATH set mkcsROOT_PATH=
if DEFINED mkcsINSTALL_PATH set mkcsINSTALL_PATH=
rem -----
:end
if DEFINED mkcsOFFICIAL_PATH set mkcsOFFICIAL_PATH=
if DEFINED _mkcssetenv_ set _mkcssetenv_=
call set mkcsINSTALL_PATH >NUL

@if NOT DEFINED _DEBUG_ @echo off
rem ---------------------------------------------------------------------------
if DEFINED mkcsOS_Buildtime set mkcsOS_Buildtime=
if DEFINED mkcsOS_NAME set mkcsOS_NAME=
if DEFINED mkcsSHLIB_PATH set mkcsSHLIB_PATH=
rem ---------------------------------------------------------------------------
rem - Set the mkcsOS_Runtime depending on OS
rem -----
if DEFINED mkcsOS_Runtime set mkcsOS_Runtime=
if NOT DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITECTURE%" == "x86" set mkcsOS_Runtime=intel_a
rem - if NOT DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set mkcsOS_Runtime=win_b64
if NOT DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set mkcsOS_Runtime=intel_a
rem - if DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set mkcsOS_Runtime=win_b64
if DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set mkcsOS_Runtime=intel_a
rem -----
if NOT DEFINED mkcsOS_Runtime set mkcsOS_Runtime=intel_a
set mkcsSHLIB_NAME=PATH
rem ---------------------------------------------------------------------------
rem - Set the mkcsINTALL_PATH and mkcsROOT_PATH
rem -----
if NOT DEFINED mkcsINSTALL_PATH if NOT DEFINED mkcsROOT_PATH (
@echo ERROR: Neither mkcsINSTALL_PATH nor mkcsROOT_PATH was found, failed
goto error
)
rem -----
rem - If mkcsROOT_PATH then set mkcsINTALL_PATH with dirname of mkcsROOT_PATH
if NOT DEFINED mkcsINSTALL_PATH if DEFINED mkcsROOT_PATH for /f %%i in ('echo %%mkcsROOT_PATH%%\..') do set mkcsINSTALL_PATH=%%~fi
rem -----
rem - If mkcsINTALL_PATH then set the mkcsROOT_PATH = mkcsINTALL_PATH\mkcsOS_Runtime
if DEFINED mkcsINSTALL_PATH if DEFINED mkcsOS_Runtime set mkcsROOT_PATH=%mkcsINSTALL_PATH%\%mkcsOS_Runtime%
rem -----
rem - Set mkcsSHLIB_PATH = mkcsROOT_PATH\code\bin
if DEFINED mkcsROOT_PATH set mkcsSHLIB_PATH=%mkcsROOT_PATH%\code\bin
rem -----
rem - Add to PATH = mkcsROOT_PATH\code\command
if DEFINED mkcsROOT_PATH set PATH=%PATH%;%mkcsROOT_PATH%\code\command
rem ---------------------------------------------------------------------------
rem - Set mkcsOS_Buildtime with MkmkOS_Buildtime
rem -----
rem - Check if MkmkOS_Buildtime already exists
if DEFINED MkmkOS_Buildtime set mkcsOS_Buildtime=%MkmkOS_Buildtime%
if DEFINED MkmkOS_NAME set mkcsOS_NAME=%MkmkOS_NAME%
if DEFINED mkcsOS_Buildtime goto version
rem -----
rem - MkmkOS_Buildtime does not already exist, search for NTsetos.bat in PATH
if DEFINED _fnd_ set _fnd_=
for %%i in (NTsetos.bat) do set _fnd_=%%~$PATH:i
if NOT DEFINED _fnd_ (
@echo ERROR: profile NTsetos.bat was not found in PATH, failed to set mkcsOS_Buildtime
goto error
)
if DEFINED _fnd_ call %_fnd_%
if DEFINED _fnd_ set _fnd_=
if DEFINED MkmkOS_Buildtime set mkcsOS_Buildtime=%MkmkOS_Buildtime%
if DEFINED MkmkOS_NAME set mkcsOS_NAME=%MkmkOS_NAME%
for %%i in (NTunsetos.bat) do set _fnd_=%%~$PATH:i
if DEFINED _fnd_ call %_fnd_% >NUL
if DEFINED _fnd_ set _fnd_=
rem ---------------------------------------------------------------------------
:version
set mkcsbuild=0
set mkcsVERSION=Unknown version
set _mkcsversion=%mkcsSHLIB_PATH%\mkmkversion.exe
if EXIST "%_mkcsversion%" FOR /F "tokens=1" %%i IN ('"%_mkcsversion%"') DO set mkcsbuild=%%i
if EXIST "%_mkcsversion%" FOR /F "tokens=*" %%i IN ('"%_mkcsversion%" -fullversion') DO set mkcsVERSION=%%i
set _mkcsversion=
@echo * mkcs version %mkcsVERSION% *
set _mkcsinstdate=%mkcsROOT_PATH%\code\command\mkcsInstallDate.date
if EXIST "%_mkcsinstdate%" FOR /F "tokens=*" %%i IN (%_mkcsinstdate%) DO @echo * Installation date %%i *
set _mkcsinstdate=
goto end
rem ---------------------------------------------------------------------------
:error
if DEFINED mkcsROOT_PATH set mkcsROOT_PATH=
if DEFINED mkcsINSTALL_PATH set mkcsINSTALL_PATH=
if DEFINED mkcsOS_Buildtime set mkcsOS_Buildtime=
if DEFINED mkcsOS_Runtime set mkcsOS_Runtime=
if DEFINED mkcsOS_NAME set mkcsOS_NAME=
if DEFINED mkcsSHLIB_NAME set mkcsSHLIB_NAME=
if DEFINED mkcsSHLIB_PATH set mkcsSHLIB_PATH=
rem ---------------------------------------------------------------------------
:end
call set mkcsINSTALL_PATH >NUL

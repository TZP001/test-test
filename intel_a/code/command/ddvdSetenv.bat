@if NOT DEFINED _DEBUG_ @echo off
rem ----------
rem - If ddvdROOT_PATH then set ddvdINTALL_PATH with dirname of ddvdROOT_PATH
if NOT DEFINED ddvdINSTALL_PATH if DEFINED ddvdROOT_PATH for /f %%i in ('echo %%ddvdROOT_PATH%%\..') do set ddvdINSTALL_PATH=%%~fi
if NOT DEFINED ddvdINSTALL_PATH (
@echo ERROR: Variable ddvdINSTALL_PATH not found>&2
@echo mkmk profile failed>&2
goto :EOF
)

rem ----------
if NOT DEFINED ddvdROOT_PATH if DEFINED _ddvdROOT_PATH @echo Set ddvdROOT_PATH to %_ddvdROOT_PATH% using _ddvdROOT_PATH
if NOT DEFINED ddvdROOT_PATH if DEFINED _ddvdROOT_PATH set ddvdROOT_PATH=%_ddvdROOT_PATH%
rem --
if NOT DEFINED ddvdROOT_PATH @echo Set ddvdROOT_PATH to %ddvdINSTALL_PATH%\intel_a
if NOT DEFINED ddvdROOT_PATH set ddvdROOT_PATH=%ddvdINSTALL_PATH%\intel_a
rem ----- Fin du calcul de ddvdROOT_PATH

rem ----- Exports
set PATH=%PATH%;%ddvdROOT_PATH%\code\command
set ddvdSHLIB_NAME=PATH
set ddvdSHLIB_PATH=%ddvdROOT_PATH%\code\bin
set ddvdOS_Runtime=intel_a
set ddvdOS_NAME=Windows_NT

rem ----- Set compiler version
for /f %%i in ('call DSxDevVisualCompiler -version') do set DSXDEVVISUALCOMPILERVERSION=%%i
echo Version DSx.Dev Visual Compiler: %DSXDEVVISUALCOMPILERVERSION%


:end
rem ----- Cleaning

echo Visual Designers environment set.

rem ----------
goto :EOF

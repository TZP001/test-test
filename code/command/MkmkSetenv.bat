@if NOT DEFINED _DEBUG_ @echo off
rem ----------
rem - If MkmkROOT_PATH then set MkmkINTALL_PATH with dirname of MkmkROOT_PATH
if NOT DEFINED MkmkINSTALL_PATH if DEFINED MkmkROOT_PATH for /f %%i in ('echo %%MkmkROOT_PATH%%\..') do set MkmkINSTALL_PATH=%%~fi
if NOT DEFINED MkmkINSTALL_PATH (
@echo ERROR: Variable MkmkINSTALL_PATH not found>&2
@echo mkmk profile failed>&2
goto :EOF
)
rem ----------
set _ENV_=
if NOT DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITECTURE%" == "x86" set _ENV_=intel_a\code\command\NTsetenv.bat
rem - if NOT DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set _ENV_=win_b64\code\command\NTsetenv.bat
if NOT DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set _ENV_=intel_a\code\command\NTsetenv.bat
rem - if DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set _ENV_=win_b64\code\command\NTsetenv.bat 
if DEFINED PROCESSOR_ARCHITEW6432 if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set _ENV_=intel_a\code\command\NTsetenv.bat 
if NOT DEFINED _ENV_ set _ENV_=intel_a\code\command\NTsetenv.bat
rem ----------
set _FND_=
if DEFINED MkmkINSTALL_PATH for %%i in (%_ENV_%) do set _FND_=%%~$MkmkINSTALL_PATH:i
if DEFINED _FND_ (
call %_FND_%
set _FND_=
) else (
@echo ERROR: File '%_ENV_%' not found in specified paths [%MkmkINSTALL_PATH%]>&2
@echo mkmk profile failed>&2
)
rem ----------
goto :EOF

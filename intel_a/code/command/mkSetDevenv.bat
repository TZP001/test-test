@echo off
setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " mkManageDevenvRegM "
rem -------------------------------------------------------------------------------------
set CMD_NAME=mkManageDevenvRegM

set MkmkIC_SCRIPT=
set CATICPath=%MkmkIC_PATH%
set Path=%Path%;%MkmkSHLIB_PATH%
set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%

if NOT DEFINED NO_SINGLE_SETCATENV set SINGLE_SETCATENV=1
set arg=%*
goto :main

:option
set /A begin=0
for %%j in (%arg%) do call :case %1 %%j
goto :EOF

:case
set /A begin=%begin%+1
if %1 NEQ %2 goto :EOF
set /A end=%begin%+1
for /F "tokens=%begin%,%end%*" %%i in ('echo %arg%') do call :switch %1 %%j
goto :EOF

:help
echo ##############################################################################
echo This program attaches devenv to a process in Windows Registry.
echo Options :
echo    -h                   : Help
echo    -b process           : process name.
echo ##############################################################################"
goto :EOF

:value
set Value=%1
goto :EOF

:switch
for /F "tokens=2,3*" %%i in ('echo %*') do call :value %%i%%j%%k
if "%1" == "-h" set helpMode=Yes
if "%Value%" == "" goto :EOF
if "%1" == "-b" set ProcessName=%Value:"=%
goto :EOF

:parameter_not_set
echo #   ERROR :  parameter ProcessName not set, aborting.
goto :help

:main
set ProcessName=
set helpMode=
for %%i in (-h -b) do call :option %%i
if defined helpMode goto :help
if not defined ProcessName goto :parameter_not_set 

if DEFINED _DEBUG_ (call devenv) ELSE call %CMD_NAME% -set -process %ProcessName%

:end

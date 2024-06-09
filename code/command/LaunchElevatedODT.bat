@echo off
setlocal enabledelayedexpansion

SET envfiletosource=%1
sh -c "cat \"%envfiletosource%\" | grep -v ^TMP= | grep -v ^APPDATA= | grep -v ^TEMP= | grep -v ^USERNAME= | grep -v ^USERPROFILE= | grep -v ^TMPDIR=  > \"%envfiletosource%.new\""
sh -c "mv \"%envfiletosource%.new\" \"%envfiletosource%\""

rem --------------------------------
echo ## MKODT: Executing ODT with elevated privileges 
rem --------------------------------

rem --------------------------------
rem
rem SOURCE ENV FILE
rem
rem --------------------------------
for /f "usebackq delims=" %%a in (%1) do (
set %%a
)

rem --------------------------------
rem
rem PREPARE CATSTART COMMAND
rem
rem --------------------------------
SET /a counter=0
FOR %%A IN (%*) DO (
IF NOT "!counter!"=="0" IF "!counter!"=="1" set shelltolaunch=!shelltolaunch! %%A
IF NOT "!counter!"=="0" IF NOT "!counter!"=="1" set shelltolaunch=%%A

set /a counter+=1
)
SET cmdtolaunch=CATSTART -direnv %ADL_ODT_TMP%\CATEnv -s -noconsole -run "sh -c \"!shelltolaunch!\""

rem --------------------------------
rem
rem CHANGE DIRECTORY
rem
rem --------------------------------
cd %ADL_ODT_TMP%\MKODT_DATA


rem --------------------------------
rem
rem EXECUTE ODT
rem
rem --------------------------------
call !cmdtolaunch!
set RC=%ERRORLEVEL%

EndLocal
:end

rem --------------------------------
echo ## MKODT: End of elevated privileges execution
rem --------------------------------

exit %RC%

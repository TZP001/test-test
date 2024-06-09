@echo off

set WinRunnerhome=C:\Program Files\Mercury Interactive\WinRunner\arch
set StartWinRunner=C:\temp\StartWinRunner.bat
set rc=15
set PATH=%PATH%;%WinRunnerhome%

if not exist "%WinRunnerhome%\WRun.exe" (
echo Cannot find Wrun.exe, check Winrunner installation
goto end
) 

set rc=0
set appli=%*
set name=%1%

if "%name%" == "IExplore" (
for /F "tokens=*" %%i in ('registry -p -r -k "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\InstallInfo" -n "Install Dir"') do set appli="%%i\IEXPLORE.EXE" %2%
rem set appli="C:\Program Files\Plus!\Microsoft Internet\IEXPLORE.EXE" %2%
set Browser=YES
)

if "%name%" == "Netscape" (
set appli="C:\Program Files\Netscape\Communicator\Program\netscape.exe" %2%
set Browser=YES
)

rem -----------------------
rem   Redaction WinRunnerVPM
rem -----------------------

echo @echo off> %StartWinRunner%
echo title %StartWinRunner%>> %StartWinRunner%
echo setlocal>> %StartWinRunner%
echo echo %appli% launched. ^> %ADL_ODT_TMP%\StartWinRunner.launch >> %StartWinRunner%

if defined WRRECORDCAPTURE (
if "%Browser%" == "YES" (
echo echo "When WinRunner is opened press any key to launch %name%...">> %StartWinRunner%
echo timeout 120>> %StartWinRunner%
)
)
echo %ADL_ODT_WRCOV% %appli%>> %StartWinRunner%
echo echo CNEXT Return code : ^%%ERRORLEVEL^%% ^>^> %ADL_ODT_TMP%\StartWinRunner.traces >> %StartWinRunner%

echo exit>> %StartWinRunner%
echo endlocal>> %StartWinRunner%


rem -----------------
rem     Capture
rem -----------------


if defined WRRECORDCAPTURE (
 
start %StartWinRunner%

del "%WinRunnerhome%\..\tmp\temp.gui" 2>NUL
WRun.exe -t %ADL_ODT_REC% -auto_load on -auto_load_dir "%ADL_ODT_REC%"
move %ADL_ODT_REC%\temp.gui %ADL_ODT_REC%\%ODT_LOG_NAME%.gui 
goto end 
)

rem -----------------
rem     Replay
rem -----------------
set CNEXTOUTPUT=%ADL_ODT_TMP%\StartWinRunner.traces

if defined ADL_ODT_WRCOV (
set CNEXTOUTPUT=
set WRtimeout=600
)
rem del %ADL_ODT_OUT%\%ODT_LOG_NAME%.winrunner 2>NUL
cp -pr %ADL_ODT_REC% %ADL_ODT_TMP%/%ODT_LOG_NAME%.rec

if not defined WRtimeout set WRtimeout=50
WRun.exe -t %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec -batch on -run -create_text_report on -dont_show_welcome -run_minimized -verify result -cs_fail on -cs_run_delay 40 -timeout %WRtimeout% 

type %ADL_ODT_TMP%\StartWinRunner.launch
type %ADL_ODT_TMP%\StartWinRunner.traces
type %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec\result\report.txt 2> NUL

grep "stop run          pass" %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec\result\report.txt 2> NUL
set rc=%ERRORLEVEL%

rem more time for PureCoverage
if not defined Covtimeout set Covtimeout=45
if defined ADL_ODT_JAVACOV sleep %Covtimeout%

rem copy %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec\result\report.txt %ADL_ODT_OUT%\%ODT_LOG_NAME%.winrunner
goto end



:end
del %StartWinRunner%
echo exit %rc% | sh


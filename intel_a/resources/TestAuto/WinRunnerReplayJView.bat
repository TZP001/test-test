@echo off

set WinRunnerhome=C:\Program Files\Mercury Interactive\WinRunner\arch
set CLASSPATH=c:\Program Files\Mercury Interactive\WinRunner\classes;%CLASSPATH%
set CLASSPATH=C:\Program Files\Common Files\Mercury Interactive\SharedFiles\JavaAddin\classes;%CLASSPATH%
set StartWinRunnerVPM=C:\temp\StartWinRunnerVPM.bat
set rc=15
set PATH=%PATH%;%WinRunnerhome%

if not exist "%WinRunnerhome%\WRun.exe" (
echo Cannot find WRun.exe, check Winrunner installation
goto end
) 

set rc=0
set input=%*%
echo set args=%input% |sed -e "s/\//\\/g" |sed -e "s/-D/\/d:/g" | sed -e "s/-mx[0-9a-z]*//g"| sed -e "s/-ms[0-9a-z]*//g" > %ADL_ODT_TMP%\tempbatch.bat
echo set CLASSPATH=%CLASSPATH%|sed -e "s/\//\\/g" >>%ADL_ODT_TMP%\tempbatch.bat
echo set ADL_ODT_TMP_slash=%ADL_ODT_TMP%|sed -e "s/\\/\\\\/g" >>%ADL_ODT_TMP%\tempbatch.bat
call %ADL_ODT_TMP%\tempbatch.bat
rem mode couverture : lancement de createFakeSrc.pl (ReplayPath prereq)
rem if defined ADL_ODT_JAVACOV perl %ReplayPath%\createFakeSrc.pl %WSROOT%\.. %ADL_ODT_TMP%
rem -----------------------
rem   Redaction WinRunnerVPM
rem -----------------------

echo @echo off > %StartWinRunnerVPM%
echo title %StartWinRunnerVPM%>> %StartWinRunnerVPM%
echo setlocal >> %StartWinRunnerVPM%
echo set COMMANDS=%WSROOT%\JAVA\code\command>> %StartWinRunnerVPM%
echo set PATH=C:\Program Files\JProbe\Coverage;%PATH%;%WSROOT%\PortalNative\CNext.plugins\plugins\Windows_NT>> %StartWinRunnerVPM%
echo set CLASSPATH=%CLASSPATH%;%MkmkROOT_PATH%\docs\java\Portal_LF.jar>> %StartWinRunnerVPM%
echo del C:\.CATPreferredHosts>> %StartWinRunnerVPM%
echo del C:\WINNT\Java\.CATPreferredHosts>> %StartWinRunnerVPM%

rem echo if defined ADL_ODT_JAVACOV del C:\temp\%%ODT_LOG_NAME%%_1.jpc>> %StartWinRunnerVPM%
rem echo if defined ADL_ODT_JAVACOV del C:\temp\%%ODT_LOG_NAME%%_1.txt>> %StartWinRunnerVPM%

rem cas replay std
if not defined JAVARECORDCAPTURE echo %%ADL_ODT_JAVACOV%% jview %args% | sed "s/$/>%ADL_ODT_TMP_slash%\\StartWinRunner.traces 2>\&1/g">> %StartWinRunnerVPM%

rem cas replay JProbe
rem if not defined JAVARECORDCAPTURE if defined ADL_ODT_JAVACOV echo jplauncher.exe -jp_append=true -jp_working_dir=. -jp_snapshot_dir=C:\temp -jp_output_file=%%ODT_LOG_NAME%% -jp_filter=java.*:E,javax.*:E,sun.*:E,sunw.*:E,com.sun.*:E,com.ms.*:E,IE.Iona.*:E,com.klg.*:E -jp_vm=jdk118 -jp_function=coverage -jp_record_from_start=coverage -jp_final_snapshot=coverage %input% | sed "s/$/>%ADL_ODT_TMP_slash%\\StartWinRunner.traces 2>\&1/g"> %ADL_ODT_TMP%\StartWinRunnerVPMJprobe.bat
rem if not defined JAVARECORDCAPTURE if defined ADL_ODT_JAVACOV echo exit>> %ADL_ODT_TMP%\StartWinRunnerVPMJprobe.bat
rem if not defined JAVARECORDCAPTURE if defined ADL_ODT_JAVACOV echo start /min /wait %ADL_ODT_TMP%\StartWinRunnerVPMJprobe.bat>> %StartWinRunnerVPM%
rem if not defined JAVARECORDCAPTURE if defined ADL_ODT_JAVACOV echo jpcovreport.exe -snapshot=C:\temp\%%ODT_LOG_NAME%%_1.jpc -output=C:\temp\%%ODT_LOG_NAME%%_1.txt -format=text -type=verydetailed -sourcepath=%ADL_ODT_TMP%\fakeSrc>> %StartWinRunnerVPM%
rem if not defined JAVARECORDCAPTURE if defined ADL_ODT_JAVACOV echo if defined ReplayPath perl %%ReplayPath%%\FromJProbeToPureCoverage.pl C:\temp\%%ODT_LOG_NAME%%_1.txt C:\temp\%%ODT_LOG_NAME%%.txt>> %StartWinRunnerVPM%
rem if not defined JAVARECORDCAPTURE if defined ADL_ODT_JAVACOV echo if defined ReplayPath del C:\temp\%%ODT_LOG_NAME%%_1.txt>> %StartWinRunnerVPM%
rem if not defined JAVARECORDCAPTURE if defined ADL_ODT_JAVACOV echo del C:\temp\%%ODT_LOG_NAME%%_1.jpc>> %StartWinRunnerVPM%

rem cas capture
if defined JAVARECORDCAPTURE echo %%ADL_ODT_JAVACOV%% jview %args%>> %StartWinRunnerVPM%
echo exit>> %StartWinRunnerVPM%
echo endlocal>> %StartWinRunnerVPM%
rem -----------------
rem     Capture
rem -----------------

if not defined WRAddIn set WRAddIn=java

if defined JAVARECORDCAPTURE (
del %ADL_ODT_REC%\%ODT_LOG_NAME%.gui 2>NUL
wstart -t %StartWinRunnerVPM% %StartWinRunnerVPM%
del "%WinRunnerhome%\..\tmp\temp.gui"
rem "%WinRunnerhome%\WRun.exe" -addins java -t %ADL_ODT_REC% -auto_load on -auto_load_dir "%WinRunnerhome%\..\tmp"
WRun.exe -addins %WRAddIn% -t %ADL_ODT_REC% -auto_load on -auto_load_dir "%ADL_ODT_REC%" -dont_show_welcome
move %ADL_ODT_REC%\temp.gui %ADL_ODT_REC%\%ODT_LOG_NAME%.gui
rem detection des identifications faibles
grep "class_index" %ADL_ODT_REC%\%ODT_LOG_NAME%.gui 2> NUL
goto end 
)

rem -----------------
rem     Replay
rem -----------------

cp -pr %ADL_ODT_REC% %ADL_ODT_TMP%/%ODT_LOG_NAME%.rec

rem validite projet winrunner
if not exist %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec\exp\exp (
mkdir %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec\exp
touch %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec\exp\exp
)

del "%WinRunnerhome%\..\tmp\temp.gui"

rem WRtimeout par defaut=20 sec
if not defined WRtimeout set WRtimeout=20
rem if not defined WRAddIn set WRAddIn=java
rem WRun.exe -t %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec -batch on -run -addins java,WebTest -create_text_report on -dont_show_welcome -run_minimized -verify result -cs_fail on  -dont_show_welcome -cs_run_delay 40 -timeout %WRtimeout% 
WRun.exe -t %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec -batch on -run -addins %WRAddIn% -create_text_report on -dont_show_welcome -run_minimized -verify result -cs_fail on  -dont_show_welcome -cs_run_delay 40 -timeout %WRtimeout% 

type %ADL_ODT_TMP%\StartWinRunner.traces
type %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec\result\report.txt 2> NUL
grep "stop run          pass" %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec\result\report.txt > NUL
set rc=%ERRORLEVEL%

rem more time for PureCoverage
if not defined Covtimeout set Covtimeout=45
if defined ADL_ODT_JAVACOV sleep %Covtimeout%

goto end



:end
del %StartWinRunnerVPM% 2> NUL
echo exit %rc% | sh


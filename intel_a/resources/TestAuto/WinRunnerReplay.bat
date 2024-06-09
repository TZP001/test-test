@echo off

goto :main

:SelectJRESunLevel
echo
rem if "%JREROOT_PATH%" EQU "%JRE5ROOT_PATH%" set BOOTCLASSPATH=C:\PROGRA~1\COMMON~1\MERCUR~1\SHARED~1\JAVAAD~1\Patches\jdk\1.5.0;C:\PROGRA~1\COMMON~1\MERCUR~1\SHARED~1\JAVAAD~1\Patches\default;%BOOTCLASSPATH%
rem if "%JREROOT_PATH%" EQU "%JRE6ROOT_PATH%" set BOOTCLASSPATH=C:\PROGRA~1\COMMON~1\MERCUR~1\SHARED~1\JAVAAD~1\Patches\jdk\1.6.0;C:\PROGRA~1\COMMON~1\MERCUR~1\SHARED~1\JAVAAD~1\Patches\default;%BOOTCLASSPATH%
rem if "%JREROOT_PATH%" EQU "%JRE6ROOT_PATH%" set JAVA_TOOL_OPTIONS=-agentlib:micsupp
goto :main2

:main
set WinRunnerhome=C:\Program Files\Mercury Interactive\WinRunner\arch
set JavaAddInhome=C:\Program Files\Common Files\Mercury Interactive\SharedFiles\JavaAddin\bin

rem # AJOUT DANS CLASSPATH ET BOOTCLASSPATH DES JAR DE WINRUNNER rem 

############################################################
rem set CLASSPATH=C:\Rational\Coverage\Rational.jar;C:\Program Files\Common Files\Mercury Interactive\SharedFiles\JavaAddin\classes\mic.jar;%CLASSPATH%
set CLASSPATH=C:\Program Files\Common Files\Mercury Interactive\SharedFiles\JavaAddin\classes;C:\Program Files\Common Files\Mercury Interactive\SharedFiles\JavaAddin\classes\mic.jar;%CLASSPATH%
set BOOTCLASSPATH=C:\PROGRA~1\COMMON~1\MERCUR~1\SHARED~1\JAVAAD~1\classes;C:\PROGRA~1\COMMON~1\MERCUR~1\SHARED~1\JAVAAD~1\classes\mic.jar;%BOOTCLASSPATH%
rem Ajout specifique au niveau de jre utilise :

if "%ADL_ODT_JRE%" EQU "ibmjre_a" set BOOTCLASSPATH=C:\PROGRA~1\COMMON~1\MERCUR~1\SHARED~1\JAVAAD~1\Patches\jdk\hcn_1.3.0;C:\PROGRA~1\COMMON~1\MERCUR~1\SHARED~1\JAVAAD~1\Patches\default;%BOOTCLASSPATH%
if "%ADL_ODT_JRE%" EQU "sunjre_a" goto :SelectJRESunLevel

:main2
cp -p "%JavaAddInhome%"/mic_if2c.dll "%JAVA_HOME%/bin" > %ADL_ODT_NULL% 2>&1
cp -p "%JavaAddInhome%"/mic_if2c_aqt.dll "%JAVA_HOME%/bin" > %ADL_ODT_NULL% 2>&1

if DEFINED BOOTCLASSPATH_ToAdd set BOOTCLASSPATH=%BOOTCLASSPATH_ToAdd%;%BOOTCLASSPATH%
if DEFINED BOOTCLASSPATH_ToAdd set CLASSPATH=%BOOTCLASSPATH_ToAdd%;%CLASSPATH%
set IBM_JAVA_OPTIONS=
set _JAVA_OPTIONS=
rem #############################################################

rem # Check de la presence de WinRunner sur la machine :
rem ####################################################
set rc=15
set PATH=%PATH%;%WinRunnerhome%

if not exist "%WinRunnerhome%\WRun.exe" (
echo Cannot find WRun.exe, check Winrunner installation
goto end
) 
rem ####################################################

rem # Creation de tempbatch.bat pour reexporter le CLASSPATH et ADL_ODT_TMP_slash :
rem ###############################################################################
set rc=0
set args=%*%
rem set input=%*%
rem echo set args=%input% |sed -e "s/\//\\/g" |sed -e "s/-D/\/d:/g" | sed -e "s/-mx[0-9a-z]*//g"| sed -e "s/-ms[0-9a-z]*//g" > %ADL_ODT_TMP%\tempbatch.bat
echo set CLASSPATH=%CLASSPATH%|sed -e "s/\//\\/g" >>%ADL_ODT_TMP%\tempbatch.bat
echo set ADL_ODT_TMP_slash=%ADL_ODT_TMP%|sed -e "s/\\/\\\\/g" >>%ADL_ODT_TMP%\tempbatch.bat
call %ADL_ODT_TMP%\tempbatch.bat
rem ###############################################################################

rem # Creation du fichier C:\temp\StartWinRunnerVPM.bat et StartWRJavaCovVPM permettant de lancer java en mode coverage :
rem #####################################################################################################################
set StartWinRunnerVPM=C:\temp\StartWinRunnerVPM.bat
set StartJavacov=C:\Temp\StartWRJavaCovVPM.bat
echo @echo off > %StartWinRunnerVPM%
echo title %StartWinRunnerVPM%>> %StartWinRunnerVPM%
echo setlocal >> %StartWinRunnerVPM%
echo set COMMANDS=%WSROOT%\JAVA\code\command>> %StartWinRunnerVPM%
rem echo set PATH=C:\Program Files\JProbe\Coverage;%PATH%;%WSROOT%\PortalNative\CNext.plugins\plugins\Windows_NT>> %StartWinRunnerVPM%
echo set CLASSPATH=%CLASSPATH%;%MkmkROOT_PATH%\docs\java\Portal_LF.jar>> %StartWinRunnerVPM%
echo set BOOTCLASSPATH=%BOOTCLASSPATH% >> %StartWinRunnerVPM%
echo del C:\.CATPreferredHosts>> %StartWinRunnerVPM%
echo del "%USERPROFILE%\.CATPreferredHosts" >> %StartWinRunnerVPM%
rem cas replay std

rem ################################################################
rem echo echo CLASSPATH=%%CLASSPATH%% >> %StartWinRunnerVPM%
rem echo echo BOOTCLASSPATH=%%BOOTCLASSPATH%% >> %StartWinRunnerVPM%
rem echo echo PATH=%%PATH%% >> %StartWinRunnerVPM%
rem echo echo IBM_JAVA_OPTIONS=%%IBM_JAVA_OPTIONS%% >> %StartWinRunnerVPM%
rem ################################################################

if "%debuggerMode%" NEQ "MemoryCheck" (

if not defined ADL_ODT_JAVACOV echo "%%JAVA_HOME%%\bin\java" -Dawt.toolkit=mercury.awt.awtSW -Xbootclasspath/p:"%%BOOTCLASSPATH%%" %args% ^> %ADL_ODT_TMP_slash%\StartWinRunner.traces 2^>^&1 >> %StartWinRunnerVPM%
)
if "%debuggerMode%" EQU "MemoryCheck" echo "%%PATH_TEST%%\java" -Dawt.toolkit=mercury.awt.awtSW -Xbootclasspath/p:"%%BOOTCLASSPATH%%" %args% ^> %ADL_ODT_TMP_slash%\StartWinRunner.traces 2^>^&1 >> %StartWinRunnerVPM%

rem if not defined ADL_ODT_JAVACOV echo "%%JAVA_HOME%%\bin\java" -Dawt.toolkit=mercury.awt.awtSW -Xbootclasspath/p:"%%BOOTCLASSPATH%%" %args% ^> %ADL_ODT_TMP_slash%\StartWinRunner.traces 2^>^&1 >> %StartWinRunnerVPM%
rem Si ADL_ODT_COV value : Creation d'un 2nd batch pour lancer la commande java :
if defined ADL_ODT_JAVACOV echo @echo off > %StartJavacov%
if defined ADL_ODT_JAVACOV echo "%%JAVA_HOME%%\bin\java" -Dawt.toolkit=mercury.awt.awtSW -Xbootclasspath/p:"%%BOOTCLASSPATH%%" %args% ^> %ADL_ODT_TMP_slash%\StartWinRunner.traces 2^>^&1 >> %StartJavacov%
if defined ADL_ODT_JAVACOV echo %%ADL_ODT_JAVACOV%% %StartJavacov% >> %StartWinRunnerVPM%

rem cas capture
rem if defined JAVARECORDCAPTURE echo %%ADL_ODT_JAVACOV%% jview %args%>> %StartWinRunnerVPM%
rem if defined JAVARECORDCAPTURE echo %%ADL_ODT_JAVACOV%% 

rem "%%JAVA_HOME%%\bin\java" -Xbootclasspath/p:"%%BOOTCLASSPATH%%" %args% >> %StartWinRunnerVPM%

echo endlocal>> %StartWinRunnerVPM%
echo exit>> %StartWinRunnerVPM%
rem ###############################################################################

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

if not defined WRDebug WRun.exe -t %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec -run -batch on -addins %WRAddIn% -create_text_report on -dont_show_welcome -run_minimized -verify result -cs_fail on  -dont_show_welcome -cs_run_delay 40 -timeout %WRtimeout% 
if "%WRDebug%" EQU "1" WRun.exe -t %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec -run -batch on -addins %WRAddIn% -create_text_report on -dont_show_welcome -animate -verify result -cs_fail on  -dont_show_welcome -cs_run_delay 40 -timeout %WRtimeout% 
if "%WRDebug%" EQU "2" WRun.exe -t %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec -addins %WRAddIn%
rem OK : WRun.exe -t %ADL_ODT_TMP%\%ODT_LOG_NAME%.rec -run -addins %WRAddIn% -create_text_report on -dont_show_welcome -animate -verify result -cs_fail on  -dont_show_welcome -cs_run_delay 40 -timeout %WRtimeout% 

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
del %StartJavacov% 2> NUL
echo exit %rc% | sh


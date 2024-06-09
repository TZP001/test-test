@echo off
setlocal
if NOT DEFINED MkmkWSAD_PATH set Path=%Path%;%MkmkSHLIB_PATH%
if DEFINED MkmkWSAD_PATH set Path=%MkmkWSAD_PATH%;%MkmkSHLIB_PATH%
set CATTraDecDir=NUL
set CATICPath=%MkmkIC_PATH%
set CATDictionaryPath=%MkmkDictionary_PATH%
set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%
set CATDefaultEnvironment=MkmkEnvironment
set PATH=%JavaROOT_PATH%\jre\bin\classic;%JavaROOT_PATH%\jre\bin;%PATH%

set RTVJAVA=
set BOOTCLASSPATH=
call :BUILDRTVDIR "%CATInstallPath%"
call :BUILDRTVDIR "%MkmkINSTALL_PATH%"

goto :ENDRTV

:BUILDRTVDIR
  for /F "tokens=1,* delims=;" %%i in (%1%) do (
	if cmdextversion 2 (call :ADDRTVDIR "%%i") else (call :ADDRTVDIR %%i)
	call :BUILDRTVDIR "%%j"
  )
goto :EOF

:ADDRTVDIR
if cmdextversion 2 set CLASSPATH=%CLASSPATH%;%~1\docs\javacommon;%~1\docs\java;%~1\code\command
if cmdextversion 2 set RTVJAVA=%RTVJAVA%;%~1\docs\javacommon;%~1\docs\java;%~1\code\command
if cmdextversion 2 set RUNTIME=%~1\docs\java
if not cmdextversion 2 set CLASSPATH=%CLASSPATH%;%1\docs\javacommon;%1\docs\java;%1\code\command
if not cmdextversion 2 set RTVJAVA=%RTVJAVA%;%1\docs\javacommon;%1\docs\java;%1\code\command
if not cmdextversion 2 set RUNTIME=%1\docs\java
goto :EOF

:FINDANDADDJAR
  set res=%~$RTVJAVA:1
  if not defined res echo !!! FINDANDADDJAR: %1 not found
  if defined res set CLASSPATH=%CLASSPATH%;%res%
goto :EOF

:ENDRTV

call :FINDANDADDJAR ITJavaCatalogue.jar
call :FINDANDADDJAR CATITJavaServerServices.jar
call :FINDANDADDJAR msqlcon.jar

"%JavaROOT_PATH%\bin\java" -cp "%CLASSPATH%" -DMkmkOS_Buildtime=%MkmkOS_Buildtime% -DITEnoviaWebSiteServer=%ITEnoviaWebSiteServer%  %CLASS_NAME% %*
endlocal


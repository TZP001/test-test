@echo off
set returnCode=0
setlocal

set MkmkIC_SCRIPT=

rem Licensing
set CATReferenceSettingPath=
set CATDictionaryPath=%mkmkROOT_PATH%\code\dictionary

set PATH=%PATH%;%mkmkSHLIB_PATH%

DSxDevVisualCompilerM -version
set returnCode=%ERRORLEVEL%
endlocal


exit /b %returnCode%

@echo off

quantify /SaveData=%ADL_ODT_OUT%\%ODT_LOG_NAME%.pv.qfy /ShowInstrumentationProgress=no /ShowLoadLibraryProgress=no %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh

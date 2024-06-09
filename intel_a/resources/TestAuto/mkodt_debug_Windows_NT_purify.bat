@echo off

purify /SaveData=%ADL_ODT_OUT%\%ODT_LOG_NAME%.pv.pfy /ShowInstrumentationProgress=no /ShowLoadLibraryProgress=no %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh

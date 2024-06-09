@echo off

coverage /SaveData=%ADL_ODT_OUT%\%ODT_LOG_NAME%.pv.cfy /ShowInstrumentationProgress=no /ShowLoadLibraryProgress=no %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh

@echo off

msdev -d %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh

@echo off

quantify %debuggerLoadPath% %*

set rc=%ERRORLEVEL%
echo exit %rc%| sh

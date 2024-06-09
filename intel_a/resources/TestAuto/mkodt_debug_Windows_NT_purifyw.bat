@echo off

purify %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh

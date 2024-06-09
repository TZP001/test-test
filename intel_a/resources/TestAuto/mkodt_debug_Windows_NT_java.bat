@echo off

if not defined PortJavaOpt set PortJavaOpt=8001

set _JAVA_OPTIONS=-Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,address=localhost:%PortJavaOpt%,suspend=y

"%JAVA_HOME%"\bin\java %*
set rc=%ERRORLEVEL%
echo exit %rc%| sh

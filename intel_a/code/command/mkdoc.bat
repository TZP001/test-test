@echo off

setlocal

set CNEXT_LEVEL=%MkmkMACRO_LEVEL%\CNEXTLVL
set LEVEL=%MkmkMACRO_LEVEL%\LEVEL
set OS_LEVEL=%MkmkMACRO_LEVEL%\Windows_NT
set CMD_NAME=mkdocM
set CATReferenceSettingPath=
rem ------------------------------------
rem set DITA Open Toolkit environment
rem ------------------------------------
set ANT_HOME=%MkmkDITAOpenToolkit%\apache-ant-1.6.5
set PATH=%PATH%;%ANT_HOME%\bin
set ANT_OPTS="-Xmx256m"
set DITA_OT_DIR=%MkmkDITAOpenToolkit%\DITA_OT
set JAVA_HOME=%MkmkDITAOpenToolkit%\j2re1.4.2_08
set CLASSPATH=%DITA_OT_DIR%\lib\dostdelta3ds.jar;%DITA_OT_DIR%\lib\resolver.jar;

call StdMKMKCommand %*


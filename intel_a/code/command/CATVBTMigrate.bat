@echo off
goto debut

rem -----------------------------------------------------------
:CATVBTMigrateSingle
if exist %%i\CNext\code\dictionary(
echo csi
	cd %%i\CNext\code\dictionary
echo csicsi
	call :CATVBTMigrate
echo csicsicsi
	cd ..\..\..\.. )
goto :EOF

rem -----------------------------------------------------------
:debut
if NOT EXIST ToolsData\Log	mkdir ToolsData\Log
echo ## Migrate ENOVIA Framework
for /F %%i in ( 'dir /S *.metadata /b ') do (
	copy %%i %%i.off > ToolsData\Log\TraceMigr
)
echo ### Migrate Workspace Succeded


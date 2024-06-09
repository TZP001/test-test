@echo off
rem 
rem %1 = directory output de mkchecksource
rem
set returnCode=0
set fileResult=%1\Main.html
if EXIST %fileResult% rm %fileResult%

echo mkCheckSource -html %*
call mkCheckSource -html %*
set returnCode=%ERRORLEVEL%
echo mkCheckSource return code = %returnCode%

if %returnCode% == 0 (
	if EXIST %fileResult% (
		echo Display results: %1\Main.html
		cd %1 
		start Main.html
	)
)

exit %returnCode%


@echo off

rem taScanOdt.bat
rem just a redirection to the perl script in the same directory
rem the problem is to get the directory name where the .bat sits...

setlocal

rem can you believe the next lines ??? that is windows NT !!!
for /F %%i in ('which %0') do set scriptName=%%i
for /F %%i in ('dirname %scriptName%') do set dirName=%%i

perl %dirName%\taScanOdt.pl %*

endlocal

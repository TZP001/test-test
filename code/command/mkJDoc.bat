@echo off
setlocal


set CMD_NAME=mkstep 
call StdMKMKCommand -s javadoc %*
if ERRORLEVEL 1 goto end

set  optionW=0
set param=%*
set param=%param% ---endparam---
REM echo "param=%param%"
FOR /F "tokens=1*" %%i IN ("%param%") DO IF "%%i"=="---endparam---" goto :endboucle
set trouvew=0
set /a counter=0
:boucle
SET /a counter=%counter%+1
FOR /F "tokens=1*" %%i IN ("%param%") DO IF "%%i"=="-W" SET trouvew=1
REM echo trouvew %trouvew% 
FOR /F "tokens=1*" %%i IN ("%param%") DO SET param1=%%j
REM echo param1-%param1%--
FOR /F "tokens=1*" %%i IN ("%param1%") DO IF "%%i"=="---endparam---" goto :endboucle
IF "%trouvew%"=="0" SET param=%param1% 
IF "%trouvew%"=="1" goto :trouvew 
REM SET param=%param1% 
REM echo param %param%
if %counter%==50 goto :end
goto :boucle

:trouvew
REM echo on est ds :trouvew
REM echo param %param%
FOR /F "tokens=1-2" %%i IN ("%param%") DO SET pathToWs=%%j\\Doc\\docs\api
REM echo pathToWs %pathToWs%

:endboucle
REM echo on est ds endboucle

if ERRORLEVEL 1 goto end	
	call jCDGData %pathToWs%
:end

@echo off
rem =======================================
rem TCK Management profile 1.1 
rem Generated by TCK installation procedure 
rem Copyright Dassault-Systemes 2000 
rem =======================================
set ERRORLEVEL=-
set ERRORLEVEL=
if NOT DEFINED TCK_ROOT_PATH goto initfailed
set _exerootpath=%TCK_ROOT_PATH%
if DEFINED MkmkROOTINSTALL_PATH set _exerootpath=%MkmkROOTINSTALL_PATH%
rem =======================================
if NOT DEFINED TMP if DEFINED SystemDrive set TMP=%SystemDrive%\temp
if DEFINED TMP if NOT EXIST "%TMP%" mkdir "%TMP%"
rem =======================================
rem Call getRADECATSettingPath to retreive and export RADECATSettingPath variable
call "%_exerootpath%\code\bin\return_random.exe"
set getRADE=%TMP%\getRADE%ERRORLEVEL%.bat
call "%_exerootpath%\code\bin\catstart.exe" -s -run "getRADECATSettingPath" -env "CAA_RADE.V5R21_RADE21.B21" -direnv "C:\ProgramData\DassaultSystemes\CATEnv" >%getRADE%
if ERRORLEVEL 1 goto initRADEfailed
set _exerootpath=
call "%getRADE%"
del /F "%getRADE%"
goto :EOF
rem =======================================
:initRADEfailed
echo.
if EXIST "%getRADE%" type "%getRADE%"
echo Failed to set up environment.
echo.
goto :EOF
rem =======================================
:initfailed
echo.
echo Variable TCK_ROOT_PATH is not set.
echo Failed to set up environment.
echo.

@echo off
rem
rem MJPEG Codec Setup
rem
rem %1 ---> Optional installed Dll path (where MJPEGReader.dll, MJPEGDecoder.dll, MJPEGEncoder.dll and MJPEGWriter are)
rem

set InstallPath=.

if "%1" NEQ "" set InstallPath=%1

copy %InstallPath%\MJPEGReader.dll %SystemRoot%
copy %InstallPath%\MJPEGDecoder.dll %SystemRoot%
copy %InstallPath%\MJPEGEncoder.dll %SystemRoot%
copy %InstallPath%\MJPEGWriter.dll %SystemRoot%

rem 
rem Test if Windows XP then gdiplus.dll already installed
rem
if "%SESSIONNAME%" NEQ "Console" copy %InstallPath%\gdiplus.dll %SystemRoot%

set Reader=%SystemRoot%\MJPEGReader.dll
set Decoder=%SystemRoot%\MJPEGDecoder.dll
set Enoder=%SystemRoot%\MJPEGEncoder.dll
set Writer=%SystemRoot%\MJPEGWriter.dll

regsvr32 /s %Reader%
regsvr32 /s %Decoder%
regsvr32 /s %Encoder%
regsvr32 /s %Writer%

echo "MJPEGReader.dll, MJPEGDecoder.dll, MJPEGEncoder.dll and MJPEGWriter.dll are registered"

set FILE=%TEMP%\mjpegcodec.reg
if exist %FILE% del %FILE%

echo REGEDIT4>>%FILE%
echo [HKEY_CLASSES_ROOT\Media Type\{E436EB83-524F-11CE-9F53-0020AF0BA770}\{15C769AF-579E-4547-A458-70B190608D09}]>>%FILE%
echo "0"="0,4,,52494646,112,4,4D4A5047">>%FILE%
echo "1"="0,4,,52494646,112,4,4A504547">>%FILE%
echo "Source Filter"="{00F163F7-07D1-4794-A495-2F5B253399E8}">>%FILE%

regedit -s %FILE%

echo %FILE% added to the registry



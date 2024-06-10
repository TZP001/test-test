@echo off
rem =================================================================
rem !! - This shell installs functionnalities to open 
rem !!   files in a running Portal session
rem !! - also declares several file types as "openable" by the Portal
rem !! - adds a popup item "Send to > Dassault Systemes Portal" (on files)
rem !! - defines the protocol "remotefile" (works with IE)
rem =================================================================
rem =================================================================

set PORTALNAME=ENOVIA Portal
set PORTALSHORTNAME=ENOVPortal
set REGENTRY=%PORTALSHORTNAME%.File

rem installation directory: should be OK by default
set INSTALLDIR=%USERPROFILE%\%PORTALSHORTNAME%

rem Portal directory: point to a Portal WorkSpace (yours or BSF)
set PORTALDIR=E:\users\psc\adele\Portal5psc

rem Portal starter shell: Application or Browser (!!!: in application mode, redirect the standard output to a file)
rem set PORTALCMD="C:\Program Files\Plus!\Microsoft Internet\IEXPLORE.EXE" http://charango/indexDevDsar.html
rem set PORTALCMD="C:\Program Files\Netscape\Communicator\Program\netscape.exe" http://charango/indexDevDsar.html
set PORTALCMD="e:\users\psc\bin\runPortal.bat > %TEMP%\Portal.log"

rem openurl.exe: should be OK by default
set SENDURLEXE=%PORTALDIR%\JAVA\docs\download\openurl.exef

rem Portal Icon: should be OK by default
set PORTALICON=%PORTALDIR%\JAVA\docs\download\Portal.ico

rem file extensions "openable" by the Portal: should be OK by default
set LISTEXT=.hcg .wrl .html .htm .dxf .cgm .hpgl .hgl .gl .dwg .cdd .doc .ppt .xls .pdf .mpx .txt


rem =================================================================
rem =================================================================

rem openurl.exe & Portal.ico copy
rem =============================
cp %SENDURLEXE% %INSTALLDIR%\openurl.exe
set SENDURLEXE=%INSTALLDIR%\openurl.exe

cp %PORTALICON% %INSTALLDIR%\Portal.ico
set PORTALICON=%INSTALLDIR%\Portal.ico


rem initialisations
rem ===============
if not exist %INSTALLDIR% mkdir %INSTALLDIR%

set INSTALLREGDIR=%INSTALLDIR:\=\\%
set PORTALDIRREG=%PORTALDIR:\=\\%
set REGICON=%PORTALICON:\=\\%


rem openurl.cmd
rem ===========
set FILE=%INSTALLDIR%\%PORTALSHORTNAME%URL.cmd
if exist %FILE% del %FILE%

echo @echo off>>%FILE%
echo title OPEN URL...>>%FILE%
echo set PORTALCMD=%PORTALCMD%>>%FILE%
rem echo %JVM% com.dassault_systemes.catweb.base.net.url.SendURL %%* -portalcmd %%PORTALCMD%%>>%FILE%
echo %SENDURLEXE% %%* -portalcmd %%PORTALCMD%%>>%FILE%
echo exit>>%FILE%

rem open.cmd
rem ===========
set FILE=%INSTALLDIR%\%PORTALSHORTNAME%.cmd
if exist %FILE% del %FILE%

echo @echo off>>%FILE%
echo set URLLIST=>>%FILE%
echo for %%%%a in ( %%* ) do call :TREATARG %%%%a>>%FILE%
echo start /min %INSTALLDIR%\%PORTALSHORTNAME%URL.cmd %%URLLIST%%>>%FILE%
echo exit>>%FILE%
echo.>>%FILE%
echo :TREATARG>>%FILE%
echo   if exist %%1 (>>%FILE%
echo     set URLLIST=%%URLLIST%% file:///%%1>>%FILE%
echo     goto :EOF>>%FILE%
echo   )>>%FILE%
echo   set URLLIST=%%URLLIST%% %%1>>%FILE%
echo goto :EOF>>%FILE%


rem shortcut "Send To>Dassault Systemes Portal"
rem -------------------------------------------
echo.
@echo on
shortcut -f %FILE% -w %INSTALLDIR% -i %PORTALICON% %USERPROFILE%\SendTo\"%PORTALNAME%.lnk"
@echo off


rem remotefile.reg
rem ==============
set FILE=%INSTALLDIR%\remotefile.reg
if exist %FILE% del %FILE%

echo REGEDIT4>>%FILE%
echo [HKEY_CLASSES_ROOT\remotefile]>>%FILE%
echo @="URL:Remote File Protocol">>%FILE%
echo "EditFlags"=dword:00000002>>%FILE%
echo "URL Protocol"="">>%FILE%
echo "AMovie.bak.Source Filter"="no default string">>%FILE%
echo "Source Filter"="{E436EBB6-524F-11CE-9F53-0020AF0BA770}">>%FILE%
echo. >>%FILE%
echo [HKEY_CLASSES_ROOT\remotefile\DefaultIcon]>>%FILE%
echo @="%REGICON%">>%FILE%
echo. >>%FILE%
echo [HKEY_CLASSES_ROOT\remotefile\shell]>>%FILE%
echo. >>%FILE%
echo [HKEY_CLASSES_ROOT\remotefile\shell\open]>>%FILE%
echo. >>%FILE%
echo [HKEY_CLASSES_ROOT\remotefile\shell\open\command]>>%FILE%
echo @="%INSTALLREGDIR%\\%PORTALSHORTNAME%.cmd \"%%1\"">>%FILE%

%FILE%
echo.
echo %FILE% added to the registry

rem fileext.reg
rem ===========
set FILE=%INSTALLDIR%\fileext.reg
if exist %FILE% del %FILE%

echo REGEDIT4>>%FILE%
echo.>>%FILE%
echo [HKEY_CLASSES_ROOT\%REGENTRY%]>>%FILE%
echo @="%PORTALNAME% File">>%FILE%
echo [HKEY_CLASSES_ROOT\%REGENTRY%\DefaultIcon]>>%FILE%
echo @="%REGICON%">>%FILE%
echo [HKEY_CLASSES_ROOT\%REGENTRY%\shell\open]>>%FILE%
echo [HKEY_CLASSES_ROOT\%REGENTRY%\shell\open\command]>>%FILE%
echo @="%INSTALLREGDIR%\\%PORTALSHORTNAME%.cmd \"%%1\"">>%FILE%

for %%e in ( %LISTEXT% ) do call :SUB1 %%e %FILE%

%FILE%
echo.
echo If you want to associate file types with the Portal, execute manually %FILE% (verify first)

pause

goto END
rem ----------------------------------------------------------
rem arg1: extension arg2: dest. reg file
:SUB1
  set TMPF=%TEMP%\tmp.bat
  if exist %TMPF% del %TMPF%
  set REGD=%1
  registry -p -k "HKEY_CLASSES_ROOT\%1" -n "" | %WINDIR%\System32\find /v "HKEY_CLASSES_ROOT\%1\" | %WINDIR%\System32\find /v "Key not found">%TMPF%
  for /F %%i in ( 'type %TMPF%' ) do (
    echo extension %1 associated with: %%i
    set REGD=
  )
  if not X%REGD%==X (
    echo extension %1 not associated.
    echo.>>%2
    echo [HKEY_CLASSES_ROOT\%REGD%]>>%2
    echo @="%REGENTRY%">>%2
  )
goto :EOF
rem ----------------------------------------------------------

:MKREGDIR
for /F "tokens=1* delims=\" %%i in ( 'echo %1' ) do (
  set REGDIR=%%i
  call :SUBREC %%j
)
goto :EOF

:SUBREC
if X%1==X goto :EOF
for /F "tokens=1* delims=\" %%i in ( 'echo %1' ) do (
  set REGDIR=%REGDIR%\\%%i
  call :SUBREC %%j
  goto :EOF
)

:END


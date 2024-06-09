@echo off

set PATH=%PATH%;%~dp0;%JavaROOT_PATH%/bin

cd /d %1

FOR %%i IN (*.jar) DO CALL :jar %%i
FOR %%j IN (*.dsar) do call :dsar %%j

exit %errorlevel%

:jar
echo --------------------------------------------------------
echo unjarring %1
echo --------------------------------------------------------
jar xvf %1
IF not %errorlevel% == 0 call :ErrorJar %1 %errorlevel%
rm -f %1
goto :EOF

:dsar
echo --------------------------------------------------------
echo undsarring %1
echo --------------------------------------------------------
dsar xvf %1
if %errorlevel% == 0 call :ErrorDsar %1 %errorlevel%
rm -f %1
goto :EOF

:ErrorJar
echo --------------------------------------------------------
echo ERROR: unable to unjar : %1
echo --------------------------------------------------------
exit %2

:ErrorDsar
echo --------------------------------------------------------
echo EROR: unable to undsar : %1
echo --------------------------------------------------------
exit %2

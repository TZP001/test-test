@echo off
setlocal

REM written by PSC (19/09/2000)
REM ===========================
REM
REM This shell script uses SDK to :
REM - compile COM based native JAVA code,
REM - certificate code from PortalNative,
REM - certificate URLmgt code,
REM - make an EXE from class sendURL.
REM

REM ====== modify those variables if need be =======
set SDKBIN32=e:\dev\sdk3.2\bin
set TEMPO=e:\tmp\tempo
set ADLWS=e:\users\psc\ADELE\Portal5psc

REM ====== initializations (don't modify) ======
set CLASSPATH=
set OLDPATH=%PATH%
set PATH=%SDKBIN32%;%PATH%

set CLASSES_CAB=%TEMPO%\CLASSES_CAB
set CLASSES_JAR=%TEMPO%\CLASSES_JAR

REM %~dp0 is this file location
set HERE=%~dp0
REM set ADLWS=%HERE%..\..\..

set FRM_NATIVE=%ADLWS%\PortalNative
set FRM_LAUNCHER=%ADLWS%\PortalLauncher

set CERT_DIR=%FRM_LAUNCHER%\Data.d\certificates

set PRE_EXE=%TEMPO%\PortalStartup.exe
set PRE_CAB=%TEMPO%\CATWebStartup.cab

set CAB_STARTUP=%FRM_LAUNCHER%\CNext.gen\docs\java\CATWebStartup.cab
set JAR_STARTUP=%FRM_NATIVE%\PortalMSC.mjext\lib\JAVA\PortalMSC.jar

REM ====== Argument reading =======
if X%1==X (
  call :usage
  goto ENDPROG
)
if %1==cab (
  call :compilation
  call :createcab
  goto ENDPROG
)
if %1==exe (
rem call :compilation
  echo createexe is no more supported
  goto ENDPROG
)
if %1==jar (
  call :compilation
  call :createjar
  goto ENDPROG
)
if %1==jarcomp (
  call :compilation
  call :createjar
  cd %FRM_NATIVE%\PortalMSC.mjext
  mkmk
  cd ..\PLNallnativeMS.mj
  mkmk
  goto ENDPROG
)
if %1==all (
  call :compilation
  call :createcab
  call :createjar
  goto ENDPROG
)
if %1==urlmgt (
  call :makeurlmgt
  goto ENDPROG
)
echo Unknown option: %1
goto ENDPROG

REM ===========================================================================
:usage
  echo Usage: [option]
  echo         : this help
  echo  cab    : creates the cab startup file
  echo  jar    : creates the jar startup file
  echo  jarcomp: creates the jar startup file + mkmk stuff
  echo  all    : creates all the startup files
  echo  urlmgt : compiles and creates certif. for URLmgt
  goto :EOF

REM ===========================================================================
:makeurlmgt
  set MYMOD=PortalBase\PLBurlmgt.mj
  set MYCLASSES=%TEMPO%\URLmgt
  set MYCAB=%HERE%\URLmgt.cab
  set MYJAR=%HERE%\URLmgt.jar
  set MYEXE=%HERE%\openurl.exef
  
  echo.
  echo +========
  echo  Compile.
  echo +========
  
  del /s /q %MYCLASSES%
  mkdir %MYCLASSES%
  
  call :compmod %MYMOD% %MYCLASSES% %MYCLASSES%

  echo.
  echo +===========
  echo  Making JAR.
  echo +===========

  del %MYJAR%
  cd %MYCLASSES%

  echo jar cf %MYJAR% com
  jar cf %MYJAR% com
  
  echo.
  echo +========================
  echo  Creating the sendurl EXE.
  echo +========================
  
  cd %MYCLASSES%
 
  echo jexegen /v /w /r /main:com.dassault_systemes.catweb.base.net.url.SendURL /out:%MYEXE% *
  jexegen /v /r /main:com.dassault_systemes.catweb.base.net.url.SendURL /out:%MYEXE% *

  echo.
  echo +===============================
  echo  Creating the CAB start-up file.
  echo +===============================

  del %MYCAB%
  cd %MYCLASSES%
  echo cabarc -p -r N %MYCAB% *
  cabarc -p -r N %MYCAB% *
  
  echo.
  echo +==============================
  echo  Signing the CAB start-up file.
  echo +==============================

  cd %CERT_DIR%
  echo signcode -spc cert.spc -v cert.pvk -j javasign.dll -jp low.ini %MYCAB%
  signcode -spc cert.spc -v cert.pvk -j javasign.dll -jp low.ini %MYCAB%

  goto :EOF

REM ===========================================================================
:compilation
  echo.
  echo +========================
  echo  Building the class files.
  echo +========================

  del /s /q %CLASSES_CAB%
  mkdir %CLASSES_CAB%
  
  call :compmod PortalNative\PLNnativeGL.mj %CLASSES_CAB% %CLASSES_CAB%
  call :compmod PortalNative\PLNlocal.mj %CLASSES_CAB% %CLASSES_CAB%
  call :compmod PortalNative\PLNautomation.mj %CLASSES_CAB% %CLASSES_CAB%
  call :compmod PortalNative\PLNautomationMS.mj %CLASSES_CAB% %CLASSES_CAB%
  call :compmod PortalNative\PLNbrowser.mj %CLASSES_CAB% %CLASSES_CAB%
  call :compmod PortalNative\PLNbrowserMS.mj %CLASSES_CAB% %CLASSES_CAB%
  call :compmod PortalNative\PLNnativeMS.mj %CLASSES_CAB% %CLASSES_CAB%
  call :compmod PortalLauncher\PLLDSarStartup.mj %CLASSES_CAB% %CLASSES_CAB%
  call :compmod PortalLauncher\PLLDSarStartupMS.mj %CLASSES_CAB% %CLASSES_CAB%

  goto :EOF

REM ===========================================================================
:compmod
  cd %ADLWS%\%1\src
  set DESTDIR=%2
  set INCLDIR=%3
  set SOURCES=
  for /D /R %%i IN (*) DO call :appendifjava %%i

  echo.
  echo ======= compiling %1

  echo jvc /nomessage /x- /cp:p %INCLDIR% /d %DESTDIR% %SOURCES%
  jvc /nomessage /x- /cp:p %INCLDIR% /d %DESTDIR% %SOURCES%

  goto :EOF

REM ===========================================================================
:appendifjava
  for %%j in (%1\*.java) DO goto ADD
  goto :EOF

:ADD
REM  echo adding %1\*.java
  set SOURCES=%SOURCES% %1\*.java
goto :EOF

REM ===========================================================================
:exec
  %*
goto :EOF

REM ===========================================================================
:createcab
  echo.
  echo +==============================
  echo  Creating the CAB start-up file.
  echo +==============================

  del %CAB_STARTUP%
  cd %CLASSES_CAB%
  echo cabarc -p -r N %PRE_CAB% *
  cabarc -p -r N %PRE_CAB% *
  
  echo.
  echo +=============================
  echo  Signing the CAB start-up file.
  echo +=============================

  cd %CERT_DIR%
  echo signcode -spc cert.spc -v cert.pvk -j javasign.dll -jp low.ini %PRE_CAB%
  signcode -spc cert.spc -v cert.pvk -j javasign.dll -jp low.ini %PRE_CAB%

  echo cp %PRE_CAB% %CAB_STARTUP%
  cp %PRE_CAB% %CAB_STARTUP%

  goto :EOF

REM ===========================================================================
:createexe
  echo.
  echo +==============================
  echo  Creating the EXE start-up file.
  echo +==============================
 
  cd %CLASSES_CAB%
 
  echo jexegen /v /w /r /main:com.dassault_systemes.catweb.dsarstartup.msappli.Main /out:%PRE_EXE% *
  jexegen /v /w /r /main:com.dassault_systemes.catweb.dsarstartup.msappli.Main /out:%PRE_EXE% *

  echo cp %PRE_EXE% %CERT_DIR%
  cp %PRE_EXE% %CERT_DIR%

  goto :EOF

REM ===========================================================================
:createjar
  echo.
  echo +=================================================
  echo  Creating the Portal Microsoft native class files.
  echo +=================================================

  del /s /q %CLASSES_JAR%
  mkdir %CLASSES_JAR%
  
  call :compmod PortalNative\PLNnativeGL.mj %CLASSES_JAR% %CLASSES_CAB%
  call :compmod PortalNative\PLNbrowserMS.mj %CLASSES_JAR% %CLASSES_CAB%
  call :compmod PortalNative\PLNnativeMS.mj %CLASSES_JAR% %CLASSES_CAB%
  
  echo.
  echo ======= Making jar

  set PATH=%OLDPATH%
  del %JAR_STARTUP%
  cd %CLASSES_JAR%

  @echo jar cf %JAR_STARTUP% com
  jar cf %JAR_STARTUP% com

goto :EOF

:ENDPROG
pause
endlocal

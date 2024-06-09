@if NOT DEFINED _DEBUG_ @echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem usage:
rem set mkmkJarList=myMod1;myMod2;myMod3
rem set mkmkJMainClass=a.b.c.MyClass
rem by default jar are located in docs\java
rem set _javaserver to use jar in docs\javaserver directory
rem call StdMKMKCommand4J %*
rem to modify the xmx param of the jvm (max stack size) set mkmkJXMX=-XmxZZZm, default is -Xmx512m

set mycp=
set found=0
set first=0
set jarpath=docs\java

if DEFINED _javaserver (
	 set jarpath=docs\javaserver
	)

rem for each jar to locate
@for %%j in (%mkmkJarList%) do (
rem for each concatenation path of tools
  @for %%f in (%MkmkROOT_PATH:;= %) do (
       if !found! EQU 0 (
        if exist  "%%f\%jarpath%\%%j.jar" (
         if !first! EQU 0 (
           set mycp=%%f\%jarpath%\%%j.jar
	   set first=1
         ) else (
           set mycp=!mycp!;%%f\%jarpath%\%%j.jar
         )
         set found=1	
	)
       )
  ) 
  set found=0
)

if not defined mkmkJXMX set mkmkJXMX=-Xmx512m

call "%JavaROOT_PATH%\bin\java" %mkmkJXMX% -classpath "%mycp%" -DMainClass %mkmkJMainClass% %*


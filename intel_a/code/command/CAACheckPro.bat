echo off
REM -------------
REM trace file
set OUT=trace_CAACheckPro.out


REM ------------------------------
REM force mkmk standard build mode
set MKMK_EXPNOINDIRECT=
set MKMK_IDCARDEXTEND=

REM --------------------------
echo Remove all derived objects
call mkRemoveDo -a > %OUT% 2>&1
echo .

REM ------------------------------------------------
echo Remove Dummmy framework created by previous runs
del /f /q /s DummyFW >> %OUT% 2>&1
echo .

REM -------------------------------------------
echo Rebuild all and create dependencies databases
call mkmk -ua -xrefdb >> %OUT% 2>&1
echo .

REM -------------------------------------------
echo Run analyzer
call mkCAACheckPro.bat -a >> %OUT% 2>&1
echo .

REM ---------------------------------------------------
REM Rebuild with right prereqs and/or on dummy Protected 
REM using a special mkmk mode

echo Rebuild using a special mkmk mode
set MKMK_EXPNOINDIRECT=yes
set MKMK_IDCARDEXTEND=.mk

call mkmk -ua >> %OUT% 2>&1


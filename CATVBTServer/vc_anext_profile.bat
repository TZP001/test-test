@echo off
rem 
rem %1 = nom du workspace Adele
rem %2 = nom de la TCK 
rem %3 etc... = options du adl_ch_ws
rem
set VBTws=%1
shift
set VBTtck=%1
shift 
set VBToptions=%1 %2 %3 %4 %5 %6 %7 %8 %9

if "%TEMP%" NEQ "" set VBTtmp=%TEMP%
if "%TMP%" NEQ "" set VBTtmp=%TMP%
if DEFINED PROCESSOR_ARCHITEW6432 set PROCESSOR_ARCHITECTURE=AMD64

echo Opening SCM Workspace %VBTws%
echo Running TCK profile for %VBTtck% ...
call tck_profile %VBTtck%
if %VBTws% == - goto end
echo Running adl_ch_ws %VBTws% %VBToptions% ...
call adl_ch_ws %VBTws% %VBToptions% > "%VBTtmp%\vc.env2"
type "%VBTtmp%\vc.env2"
:end
if errorlevel 1 exit
cd > "%VBTtmp%\vc.dir"
call adl_ds_ws %VBTws% -program -out "%VBTtmp%\%VBTws%.txt"
set VBTws=
set VBTtck=
set VBToptions=
set > "%VBTtmp%\vc.env"

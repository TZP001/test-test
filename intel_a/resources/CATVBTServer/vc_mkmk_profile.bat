@echo off
rem
rem %1 = niveau CATIA
rem

if "%TEMP%" NEQ "" set VBTtmp=%TEMP%
if "%TMP%" NEQ "" set VBTtmp=%TMP%
if DEFINED PROCESSOR_ARCHITEW6432 set PROCESSOR_ARCHITECTURE=AMD64

echo Running mkmk profile...
call tck_profile %1
if not DEFINED MkmkOS_VAR exit
set > "%VBTtmp%\vc.env"

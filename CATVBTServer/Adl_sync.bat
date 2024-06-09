@echo off

set MERGE_INFO_FILE=%TEMP%\merge_info.%RANDOM%.txt

CALL adl_sync -no_manual_merge -merge_info %MERGE_INFO_FILE% %*
set RC=%ERRORLEVEL%
if not "%RC%" == "0" goto label_end

findstr "RUN_SOLVE_MERGE=TRUE" %MERGE_INFO_FILE% >nul
if not "%ERRORLEVEL%" == "0" goto label_end

start "adl_solve_merge" /w cmd /c adl_solve_merge
set RC=%ERRORLEVEL%

:label_end

del /s /q %MERGE_INFO_FILE% >nul 2>nul
set MERGE_INFO_FILE=
exit /B %RC%

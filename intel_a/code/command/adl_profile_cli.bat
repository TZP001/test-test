@if defined ADL_Debug @echo on
@if not defined ADL_Debug @echo off

if not defined TCK_ROOT_PATH goto tckenvfailed
goto start

:tckenvfailed
echo Variable TCK_ROOT_PATH is not set. Run tck_init first.
set TCK_ROOT_PATH= >nul
goto label_end

:start
rem Clean PATH
"%TCK_ROOT_PATH%\code\bin\search_path" adl_unset.bat >nul 2>&1
if not errorlevel 1 @call adl_unset.bat

call "d:\Program Files (x86)\Dassault Systemes\B21\intel_a\code\command\admin\site_profile.bat"
call "d:\Program Files (x86)\Dassault Systemes\B21\intel_a\code\command\admin\int_site_profile.bat"
goto Continue_exe
set ADL_LEVEL=5
set OSDS=intel_a

if not exist "%ADL_DIFF_PATH%\CodeRef\%ADL_SITE_NAME%\%OSDS%\code\bin\ADLCopyLocal.exe" goto Set_ADL_path

if not "%ADL_DIFF_LOCAL%"=="Y" goto Set_ADL_path
call "%ADL_DIFF_PATH%\CodeRef\%ADL_SITE_NAME%\%OSDS%\code\bin\ADLCopyLocal.exe" "%ADL_DIFF_PATH%\CodeRef\%ADL_SITE_NAME%" "%ADL_DIFF_LOCAL_PATH%\CodeRef\%ADL_SITE_NAME%" Date_Diff_Adele %OSDS%
if NOT ERRORLEVEL 1 goto Set_ADL_local_path
echo Unable to copy files on your machine.
echo Programs will be available through network: %ADL_DIFF_PATH%\CodeRef\%ADL_SITE_NAME%\%OSDS%

:Set_ADL_path
set ADL_PATH=%ADL_DIFF_PATH%\CodeRef\%ADL_SITE_NAME%\%OSDS%
goto Continue_exe

:Set_ADL_local_path
set ADL_PATH=%ADL_DIFF_LOCAL_PATH%\CodeRef\%ADL_SITE_NAME%\%OSDS%
rem ----------------------------------------------
rem Generate env suitable for local SCM runtimeview
call "%ADL_PATH%\code\bin\setcatenv" -e SCMEnv.txt -d "%ADL_PATH%\code\command\admin" -p "%ADL_PATH%" -desktop no
if NOT ERRORLEVEL 1 goto Continue_exe
set rtcode=5
echo Failed to generate SCM environment in local runtimeview %ADL_PATH%
echo Please call your SCM administrator
goto label_end

:Continue_exe
echo ------------------------------------------------------------------------
echo SCM Variables:
echo ----------------------------
echo ADL_LEVEL=%ADL_LEVEL%
echo ADL_DIFF_LOCAL=%AD_DIFF_LOCALL%
echo ADL_DIFF_LOCAL_PATH=%ADL_DIFF_LOCAL_PATH%
echo ADL_PATH=%ADL_PATH%
echo ------------------------------------------------------------------------

rem ----------------------------------------------
rem * PATH 
rem ----------------------------------------------
set ADL_USER_PATH=%ADL_PATH%\code\command

set PATH=%PATH%;%ADL_USER_PATH%

:label_cleanlog
rem Clean current user's log
echo User log cleaner started
call "%ADL_USER_PATH%\admin\adl_clean_log" 7
set rtcode=%ERRORLEVEL%
echo User log cleaner ended

rem ----------------------------------------------
rem * End 
rem ----------------------------------------------
:label_end
call "%TCK_ROOT_PATH%\code\bin\return_code" %rtcode%

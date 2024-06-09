@if not DEFINED ADL_DEBUG @echo off
REM
REM Adele front to the Araxis Merger.
REM

REM
REM This program is called with the following arguments: 
REM
REM -adl <ancestor> <version1> <version2> <result> <return_code_file> <comPrec1>...<comPrecN> [-batch -begcom debug -endcom fin] [-info <file>] [-norecom] 
REM

REM ============================================================================================
REM Please set the following variable according to your own installation of the Araxis Merger
for /F "tokens=2 delims= " %%i in ('%ADL_PATH%\code\bin\reg query "HKLM\SOFTWARE\Classes\Merge2000.Application\CLSID\\"') do @set ARA_CLSID=%%i
for /F "tokens=2 delims= " %%i in ('%ADL_PATH%\code\bin\reg query "HKLM\SOFTWARE\Classes\CLSID\%ARA_CLSID%\LocalServer32\\"') do @set _Merger_Path=%%~di%%~pi
set ARA_CLSID=
REM ============================================================================================


goto label_after_usage

:label_usage

rem ============================================================================================
rem                           usage
rem ============================================================================================
echo
echo Usage : -adl ancestor version1 version2 result return_code_file [Previous...] [-batch -begcom debug -endcom fin] [-info file] [-norecom] 
echo SVP   : respectez l'ordre des arguments... 
echo   -adl        : files to merge 
echo   -batch      : if this option is present, we launch the SCM merger in batch mode
echo   -info       : information file on the versions to merge
echo   -norecom    : there is no recommendations (because of no ancestor)

goto label_end

:label_after_usage

rem ============================================================================================
rem                           initialisation
rem ============================================================================================
set ancestor=
set version1=
set version2=
set result=
set return=

:label_loop_arguments

rem ============================================================================================
rem                           arguments analyse 
rem ============================================================================================

rem ============================================================================================
rem                           *** -adl
rem ============================================================================================
rem After option "-adl", we search all the filenames


if not "%1" == "-adl" goto label_batch

shift
if "%1" == "" goto label_usage
if "%1" == "-batch" goto label_usage
if "%1" == "-info" goto label_usage
if "%1" == "-norecom" goto label_usage
set ancestor=%1
shift
if "%1" == "" goto label_usage
if "%1" == "-batch" goto label_usage
if "%1" == "-info" goto label_usage
if "%1" == "-norecom" goto label_usage
set version1=%1
shift
if "%1" == "" goto label_usage
if "%1" == "-batch" goto label_usage
if "%1" == "-info" goto label_usage
if "%1" == "-norecom" goto label_usage
set version2=%1
shift

rem Remove write rights in order to force the user to merge into the result file
attrib +r "%version1%" 2>nul
attrib +r "%version2%" 2>nul

if "%1" == "" goto label_usage
if "%1" == "-batch" goto label_usage
if "%1" == "-info" goto label_usage
if "%1" == "-norecom" goto label_usage
set result=%1
shift

if "%1" == "" goto label_usage
if "%1" == "-batch" goto label_usage
if "%1" == "-info" goto label_usage
if "%1" == "-norecom" goto label_usage
set return=%1
shift


:label_test_next_arg

if "%1" == "-batch" goto label_batch
if "%1" == "-info" goto label_info
if "%1" == "-norecom" goto label_norecom
if "%1" == "" goto label_no_more_argument

set Prec=%1
shift

goto label_test_next_arg


:label_batch

rem ============================================================================================
rem                            *** -batch
rem ============================================================================================
if not "%1" == "-batch" goto label_info
REM In case of a batch merge, we call the SCM merger since the Araxis merger does not support this mode
goto batch_merge

:label_info

rem ============================================================================================
rem                            *** -info
rem ============================================================================================
if not "%1" == "-info" goto label_norecom
shift
if "%1" == "" goto label_usage
if "%1" == "-batch" goto label_usage
if "%1" == "-info" goto label_usage
if "%1" == "-norecom" goto label_usage
shift
goto label_loop_arguments

:label_norecom

rem ============================================================================================
rem                           *** -norecom
rem ============================================================================================
rem Warning, we consider that this option must be the last on the line (if present)
if not "%1" == "-norecom" goto label_EOL
goto no_ancestor

:label_EOL
rem ============================================================================================
rem                           *** EOL
rem ============================================================================================
if not "%1" == "" goto label_usage
goto label_no_more_argument


rem ============================================================================================
rem							  *** Missing Files 
rem ============================================================================================

:files_missing
echo Some required files are missing in the command line.
goto label_usage


rem ============================================================================================
rem							  *** Merger Launch
rem ============================================================================================

:label_no_more_argument

:with_ancestor
rem test la présence du fichier ancestor, version1, version2, result
if "%ancestor%" == "" goto files_missing
if "%version1%" == "" goto files_missing
if "%version2%" == "" goto files_missing
if "%result%" == "" goto files_missing
CALL "%_Merger_Path%\compare.exe" /wait /a1 /3 "%ancestor%" "%version1%" "%version2%" "%result%" /title1:"Common ancestor (merge here)" /title2:"Current version" /title3:"Outer version"
set rtcode=%ERRORLEVEL%
goto end

:no_ancestor
rem test la présence du fichier version1, version2, result
if "%version1%" == "" goto files_missing
if "%version2%" == "" goto files_missing
if "%result%" == "" goto files_missing
CALL "%_Merger_Path%\compare.exe" /wait /a1 /3 "%result%" "%version1%" "%version2%" "%result%" /title1:"NO ancestor (merge here)" /title2:"Current version" /title3:"Outer version" 
set rtcode=%ERRORLEVEL%
goto end

:batch_merge
CALL "%ADL_PATH%\code\bin\ADLMergerExec.exe" %*
set rtcode=%ERRORLEVEL%
goto end

:label_end
:end

rem ============================================================================================
rem							  *** End
rem ============================================================================================
rem Restore write rights to be able to remove the temporary files
attrib -r "%version1%" 2>nul
attrib -r "%version2%" 2>nul

REM SCM will retrieve a return code in the <return_code_file> file
"%TCK_ROOT_PATH%\code\bin\test_echo.exe" %rtcode% >"%return%"
REM Ensure the .bat program returns the right error code
call "%TCK_ROOT_PATH%\code\bin\return_code.exe" %rtcode%

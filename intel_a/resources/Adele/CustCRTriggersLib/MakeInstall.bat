@echo off

if "%1" == "" goto label_usage
set TEMPO=%1
if exist "%TEMPO%" goto label_with_dir

:label_usage
echo Usage: MakeInstall temporary_directory
echo This tool creates a runtime view with the compiled library and the message catalogs.
echo                                      _
echo Prerequisites:
echo - the temporary directory path <temp_dir>\ADLCMCustCRTriggers doesn't exist, or it can be deleted
echo - the CL and LINK tools must be found in PATH
echo - the command must be run in the directory containing the source files (.cpp and .h) and the message catalog subdirectory
echo      current_directory
echo       +- *.cpp
echo       +- *.h
echo       +- msgcatalog
echo           +- *.CATNls
echo           +- French
echo           !   +- *.CATNls
echo       ...
echo                                      _
echo Steps:
echo - the directory ADLCMCustCRTriggers is created into the temporary directory path
echo - the message catalog subdirectory is copied
echo - the source files (*.cpp) are compiled
echo - the library ADLCMCustCRTriggers.dll is generated
echo - you copy the temporary directory and all its contents in order to be installed
goto label_end

:label_with_dir

if exist "ADLCMAPICRTriggers.h" goto label_with_APIArchi

echo #ERR# The command must be run in the directory which contains the headers and the source files.>&2
goto label_end

:label_with_APIArchi

echo ##############################################
echo                 Initialization
echo ##############################################

rmdir /s /q %TEMPO%\ADLCMCustCRTriggers >nul 2>&1
mkdir %TEMPO%\ADLCMCustCRTriggers\code\bin %TEMPO%\ADLCMCustCRTriggers\resources\msgcatalog
if "%ERRORLEVEL%" == "0" goto label_mkdir_ok

echo #ERR# mkdir %TEMPO%\ADLCMCustCRTriggers\code\bin %TEMPO%\ADLCMCustCRTriggers\resources failed>&2
goto label_end

:label_mkdir_ok

xcopy /s msgcatalog %TEMPO%\ADLCMCustCRTriggers\resources\msgcatalog
if "%ERRORLEVEL%" == "0" goto label_copy1_ok
echo #ERR# xcopy /s msgcatalog %TEMPO%\ADLCMCustCRTriggers\resources failed>&2
goto label_end

:label_copy1_ok
xcopy /s *.cpp %TEMPO%\ADLCMCustCRTriggers
if "%ERRORLEVEL%" == "0" goto label_copy2_ok
echo #ERR# xcopy /s *.cpp %TEMPO%\ADLCMCustCRTriggers failed>&2
goto label_end

:label_copy2_ok
xcopy /s *.h %TEMPO%\ADLCMCustCRTriggers
if "%ERRORLEVEL%" == "0" goto label_copy3_ok
echo #ERR# xcopy /s *.h %TEMPO%\ADLCMCustCRTriggers failed>&2
goto label_end

rem -------------------------------------
:label_compile
set target=%1
set target=%target:.cpp=.obj%
cl /nologo /Od /W3 /MD /GX /Zi /D"UNICODE" /D"_UNICODE" /D"_AFXDLL" /D"_LANGUAGE_CPLUSPLUS" /D"_WINDOWS" /D"_WINDOWS_SOURCE" /D"_WINNT_SOURCE" /D"_ENDIAN_LITTLE" /D"OS_Windows_NT" /D"WIN32" /D__ADLCMCustCRTriggers /Fo%TEMPO%\ADLCMCustCRTriggers\%target% /c %1
if not "%ERRORLEVEL%" == "0" set RC=1
goto :EOF
rem -------------------------------------

:label_copy3_ok
cd %TEMPO%\ADLCMCustCRTriggers

echo ##############################################
echo                 Compilation
echo ##############################################

set RC=0

for %%f in (*.cpp) do CALL :label_compile %%f

if "%RC%" == "0" goto label_cl_ok

echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>&2
echo #ERR# The compilation has failed.>&2
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>&2
goto label_end

:label_cl_ok

echo ##############################################
echo                  Link-edit
echo ##############################################

link /DLL /NODEFAULTLIB:mfc42.lib /NODEFAULTLIB:mfcs42.lib /FORCE:MULTIPLE /DEBUG /DEBUGTYPE:CV /NOLOGO /MACHINE:IX86 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /out:%TEMPO%\ADLCMCustCRTriggers\code\bin\ADLCMCustCRTriggers.dll %TEMPO%\ADLCMCustCRTriggers\*.obj

if "%ERRORLEVEL%" == "0" goto label_link_ok

echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>&2
echo #ERR# The link edit has failed.>&2
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>&2
goto label_end

:label_link_ok

echo ##############################################
echo                    End
echo ##############################################

del %TEMPO%\ADLCMCustCRTriggers\*.obj

tree /f %TEMPO%\ADLCMCustCRTriggers
echo The directory %TEMPO%\ADLCMCustCRTriggers has been successfully created.

:label_end

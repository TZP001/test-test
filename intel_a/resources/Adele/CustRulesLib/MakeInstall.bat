@echo off

if "%1" == "" goto label_usage
set TEMPO=%1
if exist "%TEMPO%" goto label_with_dir

:label_usage
echo Usage: MakeInstall temporary_directory
echo This tool creates a runtime view with the compiled library and the message catalogs.
echo                                      _
echo Prerequisites:
echo - the temporary directory path <temp_dir>\ADLCMCustRules doesn't exist, or it can be deleted
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
echo - the directory ADLCMCustRules is created into the temporary directory path
echo - the message catalog subdirectory is copied
echo - the source files (*.cpp) are compiled
echo - the library ADLCMCustRules.dll is generated
echo - you copy the temporary directory and all its contents in order to be installed
goto label_end

:label_with_dir

if exist "ADLCMAPIArchi.h" goto label_with_APIArchi

echo #ERR# The command must be run in the directory which contains the headers and the source files.>&2
goto label_end

:label_with_APIArchi

echo ##############################################
echo                 Initialization
echo ##############################################

rmdir /s /q %TEMPO%\ADLCMCustRules >nul 2>&1
mkdir %TEMPO%\ADLCMCustRules\code\bin %TEMPO%\ADLCMCustRules\resources\msgcatalog
if "%ERRORLEVEL%" == "0" goto label_mkdir_ok

echo #ERR# mkdir %TEMPO%\ADLCMCustRules\code\bin %TEMPO%\ADLCMCustRules\resources failed>&2
goto label_end

:label_mkdir_ok

xcopy /s msgcatalog %TEMPO%\ADLCMCustRules\resources\msgcatalog
if "%ERRORLEVEL%" == "0" goto label_copy1_ok
echo #ERR# xcopy /s msgcatalog %TEMPO%\ADLCMCustRules\resources failed>&2
goto label_end

:label_copy1_ok
xcopy /s *.cpp %TEMPO%\ADLCMCustRules
if "%ERRORLEVEL%" == "0" goto label_copy2_ok
echo #ERR# xcopy /s *.cpp %TEMPO%\ADLCMCustRules failed>&2
goto label_end

:label_copy2_ok
xcopy /s *.h %TEMPO%\ADLCMCustRules
if "%ERRORLEVEL%" == "0" goto label_copy3_ok
echo #ERR# xcopy /s *.h %TEMPO%\ADLCMCustRules failed>&2
goto label_end

rem -------------------------------------
:label_compile
set target=%1
set target=%target:.cpp=.obj%
cl /nologo /Od /W3 /MD /GX /Zi /D"UNICODE" /D"_UNICODE" /D"_AFXDLL" /D"_LANGUAGE_CPLUSPLUS" /D"_WINDOWS" /D"_WINDOWS_SOURCE" /D"_WINNT_SOURCE" /D"_ENDIAN_LITTLE" /D"OS_Windows_NT" /D"WIN32" /D__ADLCMCustRules /Fo%TEMPO%\ADLCMCustRules\%target% /c %1
if not "%ERRORLEVEL%" == "0" set RC=1
goto :EOF
rem -------------------------------------

:label_copy3_ok
cd %TEMPO%\ADLCMCustRules

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

link /DLL /NODEFAULTLIB:mfc42.lib /NODEFAULTLIB:mfcs42.lib /FORCE:MULTIPLE /DEBUG /DEBUGTYPE:CV /NOLOGO /MACHINE:IX86 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib /out:%TEMPO%\ADLCMCustRules\code\bin\ADLCMCustRules.dll %TEMPO%\ADLCMCustRules\*.obj

if "%ERRORLEVEL%" == "0" goto label_link_ok

echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>&2
echo #ERR# The link edit has failed.>&2
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>&2
goto label_end

:label_link_ok

echo ##############################################
echo                    End
echo ##############################################

del %TEMPO%\ADLCMCustRules\*.obj

tree /f %TEMPO%\ADLCMCustRules
echo The directory %TEMPO%\ADLCMCustRules has been successfully created.

:label_end

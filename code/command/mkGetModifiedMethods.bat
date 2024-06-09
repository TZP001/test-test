@echo off
set arg=%*
set batch_name=%0
goto :main

:option
set /A begin=0
for %%j in (%arg%) do call :case %1 %%j
goto :EOF

:case
set /A begin=%begin%+1
if %1 NEQ %2 goto :EOF
set /A end=%begin%+1
for /F "tokens=%begin%,%end%*" %%i in ('echo %arg%') do call :switch %1 %%j
goto :EOF

:help
echo ##############################################################################
echo This program gives methods modified since last promotion
echo Options :
echo    -h                   : Help
echo    -W WSROOT            : Workspace directory.
echo    -R WSReference       : Workspace directory.
echo    -L filename          : To give the source list to compare
echo    -o outputfile        : To give the result file that contain impacted ODTs.
echo    -k                   : To keep the ODT_IMP_TMP that contain the temporary files
echo ##############################################################################"
goto :EOF

:value
set Value=%1
goto :EOF

:switch
for /F "tokens=2,3*" %%i in ('echo %*') do call :value %%i%%j%%k
if "%1" == "-W" set WSROOT=%Value:"=%
if "%1" == "-R" set WSREF=%Value:"=%
if "%1" == "-L" set FileSrc=%Value:"=%
if "%1" == "-o" set OutputFile=%Value:"=%
if "%1" == "-h" set helpMode=Yes
if "%1" == "-k" set KeepMode=Yes
goto :EOF

:promo
echo #   Launching the adl_promote -simul....
set PromoFile=%ODT_IMP_TMP%\adl_promo.txt
echo #   INFO : Launching adl_promote -simul -no_check_caa_rules -program -out %PromoFile% 
call adl_promote -simul -no_check_caa_rules -program -out %PromoFile% > %ODT_IMP_TMP%\adl_promote.txt 2>&1
set RC=%ERRORLEVEL%
set ProcessName=adl_promote
if "%RC%" NEQ "0" goto :ProcessFailed
goto :EOF

:NoSrcFile 
if not defined PromoFile call :promo
goto :EOF

:ProcessFailed
echo #   ERROR : Process %ProcessName% failed ...
echo #   ERROR : see the commands output in %ODT_IMP_TMP%.
set EXIT=1
goto :EOF

:RemoveFile
echo # INFO : Removing projected files
call %ODT_IMP_TMP%\cleanprojlst >%ODT_IMP_TMP%\cleanprojlst.txt 2>&1
echo #   INFO : Removing temporary directory %ODT_IMP_TMP%...
rm %ODT_IMP_TMP%\*.txt
rm %ODT_IMP_TMP%\*.bat
rm -r %ODT_IMP_TMP%
goto :EOF



:main
set WSROOT=
set WSREF=
set PromoFile=
set FileSrc=
set OutputFile=
set KeepMode=
set helpMode=
set EXIT=0

if not defined ODT_IMP_TMP set ODT_IMP_TMP=C:\Temp\ODT_IMP_TMP_%RANDOM%
rm -rf %ODT_IMP_TMP%
mkdir "%ODT_IMP_TMP%" > NUL 2>&1
for %%i in (-h -W -R -o -k -promote -L -Order) do call :option %%i
if defined helpMode goto :help
if not defined WSROOT (
	echo #   ERROR :  option -W not set, aborting.
	goto :help
	)
	
if not defined OutputFile (
	echo #   ERROR :  option -o not set, aborting.
	goto :help
	)
if not defined FileSrc call :NoSrcFile 
if "%EXIT%" NEQ "0" exit /b %EXIT%
echo #
echo ################################################################################
echo #   INFO : Workspace = %WSROOT%
if defined PromoFile echo #   INFO : Promotion output file = %PromoFile%
if defined FileSrc echo #   INFO : Source file = %FileSrc%
if defined WSREF echo #   INFO : Reference workspace = %WSREF%

echo #   INFO : Output impact file = %OutputFile%

echo ################################################################################
echo #
echo #   INFO : Getting Src To Compare...
set ProcessName=mkGetSrcToCompare

if defined PromoFile call mkGetSrcToCompare -W %WSROOT% -promote %PromoFile%  -debug 1  > %ODT_IMP_TMP%\mkGetSrcToCompare.txt 2>&1
if defined FileSrc call mkGetSrcToCompare -W %WSROOT% -WS_REF %WSREF% -FileSrc %FileSrc% -debug 1  > %ODT_IMP_TMP%\mkGetSrcToCompare.txt 2>&1
set RC=%ERRORLEVEL%
if "%RC%" NEQ "0" goto :ProcessFailed 
if "%EXIT%" NEQ "0" exit /b %EXIT%

echo #   INFO : projection ...
call %ODT_IMP_TMP%\adlprojlst >%ODT_IMP_TMP%\adl_project.txt 2>&1


echo #   INFO : Compare the different source versions...
set ProcessName=mkCompareSrc 
call mkCompareSrc -i %ODT_IMP_TMP%\filesrctocmp.txt -o %ODT_IMP_TMP%\Impacttmp.txt > %ODT_IMP_TMP%\mkCompareSrc.txt 2>&1
set RC=%ERRORLEVEL%
if "%RC%" NEQ "0" goto :ProcessFailed 
if "%EXIT%" NEQ "0" exit /b %EXIT%


echo #   INFO : Getting Method Prototypes...
set ProcessName=mkGetMethodsProto
call mkGetMethodsProto -W %WSROOT% -Input %ODT_IMP_TMP%\Impacttmp.txt -Output %ODT_IMP_TMP%\ImpactFile.txt > %ODT_IMP_TMP%\mkGetMethodsProto.txt 2>&1
set RC=%ERRORLEVEL%

if "%RC%" NEQ "0" goto :ProcessFailed 
if "%EXIT%" NEQ "0" exit /b %EXIT%

copy %ODT_IMP_TMP%\ImpactFile.txt %OutputFile%
echo Methods modified saved in %OutputFile%

if not defined KeepMode call :RemoveFile
echo ################################################################################
goto :EOF

:end

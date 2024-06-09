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
echo This program gives Odts Impacted by promote simulation.
echo Options :
echo    -h                   : Help
echo    -W WSROOT            : Workspace directory.
echo    -R WSReference       : Workspace directory.
echo    -promote filename    : To give the file resulting from the command:
echo                             adl_promote -simul -out filename -program
echo    -L filename          : To give the source list to compare
echo    -Order n             : Gives the order of the impacted ODTs list (n = 0, 1 or 2)
echo                                n = 0 (by default) : No order : one unordered ODTlist generated in one resulting file
echo                                n = 1 : ordered : one ordered ODT impacted list in one resulting file:
echo                                                    - First, ODTs impacted by sources
echo                                                    - Second, the other ODTs impacted by headers
echo                                n = 2 : ordered : 2 resulting files :
echo                                                    - one with the ODTs impacted by sources
echo                                                    - The other with the ODTs impacted by headers
echo                                n = 3 : ordered : 3 resulting files :
echo                                                    - First one with the ODTs impacted by sources
echo                                                    - Second one with the ODTs impacted by headers
echo                                                    - Third one with all ODTs impacted by methods and functions

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
if "%1" == "-promote" set PromoFile=%Value:"=%
if "%1" == "-L" set FileSrc=%Value:"=%
if "%1" == "-Order" set Order=%Value:"=%
if "%1" == "-o" set OutputFile=%Value:"=%
if "%1" == "-h" set helpMode=Yes
if "%1" == "-k" set KeepMode=Yes
goto :EOF

:promo
echo #   WARNING : parameter -promote not set, launching the adl_promote -simul....
set PromoFile=%ODT_IMP_TMP%\adl_promo.txt
echo #   INFO : Launching adl_promote -simul -no_check_caa_rules -program -out %PromoFile% 
call adl_promote -simul -no_check_caa_rules -program -out %PromoFile% > %ODT_IMP_TMP%\adl_promote.txt 2>&1
set RC=%ERRORLEVEL%
set ProcessName=adl_promote
if "%RC%" NEQ "0" goto :ProcessFailed
rem echo ## FIN adl_promote ##
goto :EOF

:NoSrcFile 
if not defined PromoFile call :promo
goto :EOF

:ProcessFailed
echo #   ERROR : Process %ProcessName% failed ...
echo #   ERROR : see the commands output in %ODT_IMP_TMP%.
set EXIT=1
goto :EOF

:parameter_not_set
echo #   ERROR :  parameter WSROOT not set, aborting.
goto :help

:RemoveFile
echo # INFO : Removing projected files
call %ODT_IMP_TMP%\cleanprojlst >%ODT_IMP_TMP%\cleanprojlst.txt 2>&1
echo #   INFO : Removing temporary directory %ODT_IMP_TMP%...
rm %ODT_IMP_TMP%\*.txt
rm %ODT_IMP_TMP%\*.bat
rm -r %ODT_IMP_TMP%
goto :EOF

:FindImpactKO
echo #   RESULT : Problem during TAFindImpact... see output in %ODT_IMP_TMP%\TAFindImpact.txt.
goto :EOF

:FindImpactHdr
set ProcessName=TAFindImpact

if not exist %ODT_IMP_TMP%\ImpactHdrFile.txt goto :EOF
echo #   INFO : Launching TAFindImpact on header...
call TAFindImpact -Impact %ODT_IMP_TMP%\ImpactHdrFile.txt -OutFile %OutputHdrFile% > %ODT_IMP_TMP%\TAFindImpactHdr.txt 2>&1
set RC=%ERRORLEVEL%
echo #
grep "ERROR :" %ODT_IMP_TMP%\TAFindImpactHdr.txt >NUL 2<&1
set RC=%ERRORLEVEL%
if "%RC%" EQU "0" goto :FindImpactKO
grep "is generated containing results of impact." %ODT_IMP_TMP%\TAFindImpactHdr.txt 
grep "ODTs are in the database." %ODT_IMP_TMP%\TAFindImpactHdr.txt 
grep "ODTs are impacted." %ODT_IMP_TMP%\TAFindImpactHdr.txt 
echo #

sh +C GetDiffHdrSrc.sh %OutputHdrFile% %OutputFile% > C:\Temp\resultdiff 2>&1
grep "not found." C:\Temp\resultdiff >NUL 2>&1
set RC=%ERRORLEVEL%
if "%RC%" EQU "0" rm C:\Temp\resultdiff
if "%RC%" EQU "0" goto :EOF
if "%Order%" EQU "1" cat  C:\Temp\resultdiff >> %OutputFile%
if "%Order%" EQU "2" mv C:\Temp\resultdiff %OutputHdrFile%
if "%Order%" EQU "3" mv C:\Temp\resultdiff %OutputHdrFile%

rem rm C:\Temp\resultdiff
goto :EOF

:FindImpactMethods
set ProcessName=TAFindImpact

if not exist %ODT_IMP_TMP%\ImpactMethFile.txt goto :EOF
echo #   INFO : Launching TAFindImpact on methods...
call TAFindImpact -Impact %ODT_IMP_TMP%\ImpactMethFile.txt -OutFile %OutputMethFile% > %ODT_IMP_TMP%\TAFindImpactMeth.txt 2>&1
set RC=%ERRORLEVEL%
echo #
grep "ERROR :" %ODT_IMP_TMP%\TAFindImpactMeth.txt >NUL 2<&1
set RC=%ERRORLEVEL%
if "%RC%" EQU "0" goto :FindImpactKO
grep "is generated containing results of impact." %ODT_IMP_TMP%\TAFindImpactMeth.txt 
grep "ODTs are in the database." %ODT_IMP_TMP%\TAFindImpactMeth.txt 
grep "ODTs are impacted." %ODT_IMP_TMP%\TAFindImpactMeth.txt 
echo #
goto :EOF

:main
set WSROOT=
set WSREF=
set PromoFile=
set FileSrc=
set OutputFile=
set KeepMode=
set helpMode=
set Order=0
set EXIT=0
rem set Path=%Path%;E:\users\dmh\mkcmpsrc\mkmk\intel_a\code\bin

if not defined ODT_IMP_TMP set ODT_IMP_TMP=C:\Temp\ODT_IMP_TMP_%RANDOM%
rm -rf %ODT_IMP_TMP%
mkdir "%ODT_IMP_TMP%" > NUL 2>&1
for %%i in (-h -W -R -o -k -promote -L -Order) do call :option %%i
if defined helpMode goto :help
if not defined WSROOT goto :parameter_not_set 
if not defined OutputFile set OutputFile=C:\Temp\ImpactedODTList
if not defined OutputHdrFile set OutputHdrFile=C:\Temp\ImpactedHdrODTList
if not defined OutputMethFile set OutputMethFile=C:\Temp\ImpactedMethODTList
rm %OutputFile% > NUL 2>&1
rm %OutputHdrFile% > NUL 2>&1
rm %OutputMethFile% > NUL 2>&1
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

if defined PromoFile call mkGetSrcToCompare -W %WSROOT% -promote %PromoFile%  -debug 1 -Order %Order% > %ODT_IMP_TMP%\mkGetSrcToCompare.txt 2>&1
if defined FileSrc call mkGetSrcToCompare -W %WSROOT% -WS_REF %WSREF% -FileSrc %FileSrc% -debug 1 -Order %Order% > %ODT_IMP_TMP%\mkGetSrcToCompare.txt 2>&1
set RC=%ERRORLEVEL%
if "%RC%" NEQ "0" goto :ProcessFailed 
if "%EXIT%" NEQ "0" exit /b %EXIT%
rem echo ## FIN mkGetSrcToCompare ##

echo #   INFO : projection ...
call %ODT_IMP_TMP%\adlprojlst >%ODT_IMP_TMP%\adl_project.txt 2>&1
rem echo ## FIN adl_project ##

echo #   INFO : Compare the different source versions...
set ProcessName=mkCompareSrc 
call mkCompareSrc -i %ODT_IMP_TMP%\filesrctocmp.txt -o %ODT_IMP_TMP%\Impacttmp.txt > %ODT_IMP_TMP%\mkCompareSrc.txt 2>&1
set RC=%ERRORLEVEL%
if "%RC%" NEQ "0" goto :ProcessFailed 
if "%EXIT%" NEQ "0" exit /b %EXIT%

rem echo ## FIN mkCompareSrc ##

echo #   INFO : Getting Method Prototypes...
set ProcessName=mkGetMethodsProto
call mkGetMethodsProto -W %WSROOT% -Input %ODT_IMP_TMP%\Impacttmp.txt -Output %ODT_IMP_TMP%\ImpactFile.txt > %ODT_IMP_TMP%\mkGetMethodsProto.txt 2>&1
set RC=%ERRORLEVEL%

if "%RC%" NEQ "0" goto :ProcessFailed 
if "%EXIT%" NEQ "0" exit /b %EXIT%
rem echo ## FIN mkGetMethodsProto ##

if "%Order%" EQU "3" grep -v ".c" %ODT_IMP_TMP%\ImpactFile.txt > %ODT_IMP_TMP%\ImpactMethFile.txt

echo #   INFO : Launching TAFindImpact...
set ProcessName=TAFindImpact
call TAFindImpact -Impact %ODT_IMP_TMP%\ImpactFile.txt -OutFile %OutputFile% -batch > %ODT_IMP_TMP%\TAFindImpact.txt 2>&1
set RC=%ERRORLEVEL%
echo #
grep "ERROR :" %ODT_IMP_TMP%\TAFindImpact.txt >NUL 2<&1
set RC=%ERRORLEVEL%
rem if "%RC%" EQU "0" goto :FindImpactKO
grep "RESULT : No impacted ODTs found." %ODT_IMP_TMP%\TAFindImpact.txt 

rem >NUL 2<&1
rem set RC=%ERRORLEVEL%
rem if "%RC%" NEQ "0" echo # RESULT : ODTs are impacted. See the file %OutputFile%.
rem if "%RC%" NEQ "0" grep "are impacted."%ODT_IMP_TMP%\TAFindImpact.txt. See the file %OutputFile%.
rem if "%RC%" EQU "0" echo # RESULT : RESULT : No impacted ODTs found.

grep "is generated containing results of impact." %ODT_IMP_TMP%\TAFindImpact.txt 
grep "ODTs are in the database." %ODT_IMP_TMP%\TAFindImpact.txt 
grep "ODTs are impacted." %ODT_IMP_TMP%\TAFindImpact.txt 
rem echo ## FIN TAFindImpact ##
echo #

if "%Order%" NEQ "0" call :FindImpactHdr
if "%Order%" EQU "3" call :FindImpactMethods

if not defined KeepMode call :RemoveFile
echo ################################################################################
goto :EOF

:end

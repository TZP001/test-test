@echo off
rem  Remplacement de la commande adl_ch_ws
rem  pour pouvoir l'appeler depuis un programme 
rem  et recuperer les variables d'environnement
rem 

rem  Les appels possibles sont (on suppose cet ordre respecte)
rem    ws tmpfile
rem    ws -no_ds tmpfile
rem    ws -no_image -no_ds tmpfile
rem    ws -no_image tmpfile
rem    ws -image image -no_ds tmpfile
rem    ws -image image tmpfile

rem tck_init est cense avoir ete execute
rem Calcul du nom d'un fichier temporaire
:settmpfile
if "%ADL_PATH%" == "" (
	call return_random
) else (
	call "%ADL_PATH%\code\bin\return_random"
)
set TCK_TMP_FILE=%ADL_TMP%\ADLTransferChWsTmp_%ERRORLEVEL%.txt
if exist "%TCK_TMP_FILE%" goto settmpfile

if "%2"=="-no_ds" goto nodisplay
if "%2"=="-image" goto withimage
if "%2"=="-no_image" goto withoutimage

:noargument
call adl_ch_ws.bat %1 -no_tck >"%TCK_TMP_FILE%" 2>&1
set rtcode=%ERRORLEVEL%
cd > %2
set >> %2
goto end

:nodisplay
call adl_ch_ws.bat %1 -no_tck %2 >"%TCK_TMP_FILE%" 2>&1
set rtcode=%ERRORLEVEL%
cd > %3
set >> %3
goto end

:withoutimage
if "%3"=="-no_ds" goto withoutimagenodisplay
call adl_ch_ws.bat %1 -no_tck %2 >"%TCK_TMP_FILE%" 2>&1
set rtcode=%ERRORLEVEL%
cd > %3
set >> %3
goto end

:withoutimagenodisplay
call adl_ch_ws.bat %1 -no_tck %2 %3 >"%TCK_TMP_FILE%" 2>&1
set rtcode=%ERRORLEVEL%
cd > %4
set >> %4
goto end

:withimage
if "%4"=="-no_ds" goto withimagenodisplay
call adl_ch_ws.bat %1 -no_tck %2 %3 >"%TCK_TMP_FILE%" 2>&1
set rtcode=%ERRORLEVEL%
cd > %4
set >> %4
goto end

:withimagenodisplay
call adl_ch_ws.bat %1 -no_tck %2 %3 %4 >"%TCK_TMP_FILE%" 2>&1
set rtcode=%ERRORLEVEL%
cd > %5
set >> %5
goto end

:end
cat "%TCK_TMP_FILE%" 2>nul
del /q "%TCK_TMP_FILE%" 
if "%ADL_PATH%" == "" (
	call return_code %rtcode%
) else (
	call "%ADL_PATH%\code\bin\return_code" %rtcode%
)

@rem Copyright 2000, Dassault Systemes. All rights reserved
@if "%ADL_DEBUG%" == "" @echo off

set ADL_CH_WS_RC=0
rem @echo on

rem ----------------------------------------------------------------------------
rem *** Controles et creation du fichier .bat pour renseigner l'environnement :
rem ----------------------------------------------------------------------------

:label_tmp_file_exists
if "%ADL_PATH%" == "" (
	call return_random
) else (
	call "%ADL_PATH%\code\bin\return_random"
)
set ADL_CH_WS_TMP_BAT_FILE=%ADL_TMP%\ADL_CH_WS_%USERNAME%_%errorlevel%.bat
if exist %ADL_CH_WS_TMP_BAT_FILE% goto label_tmp_file_exists
echo rem >%ADL_CH_WS_TMP_BAT_FILE%
if exist %ADL_CH_WS_TMP_BAT_FILE% goto label_bat_file_exists

echo Cannot create file %ADL_CH_WS_TMP_BAT_FILE%
echo Aborting...
set ADL_CH_WS_RC=5
goto label_end

rem -------------------------------------------------------------------------------------------
rem *** Execution de la commande avec renseignement de l'environnement dans le fichier .bat :
rem -------------------------------------------------------------------------------------------

rem ---------------------------
rem Lancement de la commande :
rem ---------------------------

:label_bat_file_exists
if exist "%ADL_USER_PATH%/adl_ch_ws_i.exe" goto label_exist
echo Unable to find ADL_USER_PATH/adl_ch_ws_i
echo Please contact your Adele Administrator
set ADL_CH_WS_RC=5
goto label_end_ch_w

:label_exist
call "%ADL_USER_PATH%\adl_ch_ws_i" %* -env_file %ADL_CH_WS_TMP_BAT_FILE%
set ADL_CH_WS_RC=%errorlevel%

if not exist %ADL_CH_WS_TMP_BAT_FILE% goto label_end

if not "%ADL_CH_WS_RC%" == "0" goto label_end_ch_w

call %ADL_CH_WS_TMP_BAT_FILE%
set ADL_CH_WS_RC=%errorlevel%
rem : pour tester le cd

rem s il n y a pas de changement d image donc de cd 
if "%ADL_IMAGE_DOS_DIR%" == "" set ADL_CH_WS_RC=0

goto label_end_ch_w

rem ---------------------------------
rem *** On supprime le fichier temporaire
rem ---------------------------------

:label_end_ch_w
del /q %ADL_CH_WS_TMP_BAT_FILE% >nul 2>&1
if "%ADL_CH_WS_RC%" == "0" title %ADL_WS%

rem -----------------------------
rem *** Sortie de la commande :
rem -----------------------------

:label_end
set ADL_CH_WS_TMP_BAT_FILE=

if "%ADL_PATH%" == "" (
	call return_code %ADL_CH_WS_RC%
) else (
	call "%ADL_PATH%\code\bin\return_code" %ADL_CH_WS_RC%
)

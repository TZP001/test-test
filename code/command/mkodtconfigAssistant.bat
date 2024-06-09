@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " mkodtconfigAssistantM "
rem -------------------------------------------------------------------------------------

rem --- definition de la variable d'environnement MKODTCONFIG_URL_DOC
set MKODTCONFIG_URL_DOC=http://tools2e/Home/QMA/mkodtconfig/mkodtconfig.html

set CMD_NAME=mkodtconfigAssistantM.exe

rem P2 look
if exist %BSFCODEPATH% (
set CATGraphicPath=%BSFCODEPATH%\%MkmkOS_Runtime%\resources\graphic\icons;%MkmkROOT_PATH%\resources\graphic\icons\normal
set CATICPath=%BSFCODEPATH%\%MkmkOS_Runtime%\code\productIC
)

rem P1 look
if not exist %BSFCODEPATH% set CATGraphicPath=%MkmkROOT_PATH%\resources\graphic\icons\normal

set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%
set Path=%Path%;%MkmkSHLIB_PATH%
if NOT DEFINED _DEBUG_ %CMD_NAME% %*

endlocal


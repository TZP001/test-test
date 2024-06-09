@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " BXMLServer.exe "
rem -------------------------------------------------------------------------------------

set CMD_NAME=BXMLServer.exe

set Path=%Path%;%MkmkSHLIB_PATH%
if NOT DEFINED _DEBUG_ call %CMD_NAME% %*


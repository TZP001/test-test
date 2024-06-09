@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " BXML2Table.exe "
rem -------------------------------------------------------------------------------------

set CMD_NAME=BXML2Table.exe

set Path=%Path%;%MkmkSHLIB_PATH%
if NOT DEFINED _DEBUG_ call %CMD_NAME% %*


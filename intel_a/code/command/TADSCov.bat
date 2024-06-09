@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " TADSCovM "
rem -------------------------------------------------------------------------------------

set CMD_NAME=TADSCovM

set Path=%Path%;%MkmkSHLIB_PATH%

if NOT DEFINED DSCOV_OUTPUT set DSCOV_OUTPUT=C:\temp\DSCOV_OUTPUT.txt

if NOT DEFINED _DEBUG_ %CMD_NAME% %*

endlocal


@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " XMLMkodtResultsM "
rem -------------------------------------------------------------------------------------
set CMD_NAME=TAXMLComputeM


set Path=%Path%;%MkmkSHLIB_PATH%


if DEFINED _DEBUG_ (call devenv) ELSE call %CMD_NAME% %*


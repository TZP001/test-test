@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " TANotifyBI"
rem -------------------------------------------------------------------------------------

set CMD_NAME=TANotifyBIM.exe

if NOT DEFINED _DEBUG_ call %CMD_NAME% %*


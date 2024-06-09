@echo off
rem --------------------------------------------------
rem Procedure de soumission de la commande mkGetPreq !
rem --------------------------------------------------
setlocal
rem --------------------------------------------------
set env_Mkmk_Modifier=
if DEFINED Mkmk_Modifier (
set env_Mkmk_Modifier=%Mkmk_Modifier%
set Mkmk_Modifier=
)
rem --------------------------------------------------
set env_Mkmk_Modifier_BAD=
if DEFINED Mkmk_Modifier_BAD (
set env_Mkmk_Modifier_BAD=%Mkmk_Modifier_BAD%
set Mkmk_Modifier_BAD=
)
rem --------------------------------------------------
set CMD_NAME=mkmkmodifierM
call StdMKMKCommand %*


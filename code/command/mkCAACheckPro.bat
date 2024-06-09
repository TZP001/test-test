@echo off
setlocal
rem ------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE --> " CAACheckProM "
rem ------------------------------------------------------------------
set MKMK_EXPNOINDIRECT=yes
set CMD_NAME=mkCAACheckProM
set PATH=E:\tooltest\intel_a\code\bin;%PATH%
call StdMKMKCommand %*

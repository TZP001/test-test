@echo off

: ----------------------------------------------
: Procedure de soumission de la commande mkrun !
: ----------------------------------------------

setlocal

if "%ITEnoviaSitePort%" == "" set ITEnoviaSitePort=5000
if "%ITEnoviaSiteServer%" == "" set ITEnoviaSiteServer=localhost

set CMD_NAME=mkrunM

if "%MKRUNATDS%" == "yes" set CMD_NAME=mkrunMInternalDS

set mkrun_CATTraDecDir=%CATTraDecDir%
set CATUserSettingPath=NUL

call StdMKMKCommand -ITPort %ITEnoviaSitePort% -ITServer %ITEnoviaSiteServer% %*


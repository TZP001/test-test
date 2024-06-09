@echo off

: ----------------------------------------------
: Procedure de soumission de la commande mkrun !
: ----------------------------------------------

setlocal

if "%ITEnoviaSitePort%" == "" set ITEnoviaSitePort=5000
if "%ITEnoviaSiteServer%" == "" set ITEnoviaSiteServer=localhost

set CMD_NAME=mkrunM

if exist ToolsData rm -rf ToolsData

if "%MKRUNATDS%" == "yes" set CMD_NAME=mkrunMInternalDS

call StdMKMKCommand -hostname localhost:1570 -trame  ITVaultNT -ITPort %ITEnoviaSitePort% -ITServer %ITEnoviaSiteServer%  %*


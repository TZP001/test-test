@echo off

: ----------------------------------------------
: Procedure de soumission de la commande mkrun !
: ----------------------------------------------

setlocal

if "%ITEnoviaSitePort%" == "" set ITEnoviaSitePort=5000
if "%ITEnoviaSiteServer%" == "" set ITEnoviaSiteServer=localhost

set CMD_NAME=mkrunM

if exist ToolsData\ITEnovia\%MkmkOS_Buildtime% rm -rf ToolsData\ITEnovia\%MkmkOS_Buildtime%

if "%MKRUNATDS%" == "yes" set CMD_NAME=mkrunMInternalDS

call StdMKMKCommand -hostname localhost:1570 -trame  ODTServerNT -ITPort %ITEnoviaSitePort% -ITServer %ITEnoviaSiteServer%  %*


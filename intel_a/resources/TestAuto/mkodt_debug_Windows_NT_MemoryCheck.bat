@echo off

rem **** Gestion du cache ****
if NOT DEFINED CE_CACHE set CE_CACHE=E:\MemoryCheck\Cache
md %CE_CACHE% > %ADL_ODT_NULL% 2>&1

rem **** Gestion des traces ****
if NOT DEFINED CE_TRACES set CE_TRACES=0

rem **** Gestion de l'output ****
set SwitchCeOutput=0
if NOT DEFINED CE_OUTPUT (
set SwitchCeOutput=1
set CE_OUTPUT=%ADL_ODT_TMP%\_%ODT_LOG_NAME%.txt
)

rem **** Gestion du resultat ****
set CE_RESULT=%ADL_ODT_TMP%\%ODT_LOG_NAME%_ce.txt

CEBatch %debuggerLoadPath% %*
set rc=%ERRORLEVEL%
type %CE_RESULT% >>%ADL_ODT_OUT%\%ODT_LOG_NAME%_ce.txt
if %SwitchCeOutput% == 1 (
type %ADL_ODT_TMP%\cei_%ODT_LOG_NAME%.txt >>%ADL_ODT_OUT%\cei_%ODT_LOG_NAME%.txt 
type %ADL_ODT_TMP%\cep_%ODT_LOG_NAME%.txt >>%ADL_ODT_OUT%\cep_%ODT_LOG_NAME%.txt 
type %ADL_ODT_TMP%\cec_%ODT_LOG_NAME%.txt >>%ADL_ODT_OUT%\cec_%ODT_LOG_NAME%.txt 
)

echo exit %rc% | sh

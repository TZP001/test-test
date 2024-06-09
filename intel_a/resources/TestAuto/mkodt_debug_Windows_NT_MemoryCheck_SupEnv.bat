@echo off

rem *** Nettoyage des resultats eventuels de replays precedents

rm %ADL_ODT_OUT%\%ODT_LOG_NAME%_ce.txt

if NOT DEFINED CE_OUTPUT (
rm %ADL_ODT_OUT%\cei_%ODT_LOG_NAME%.txt 
rm %ADL_ODT_OUT%\cep_%ODT_LOG_NAME%.txt 
rm %ADL_ODT_OUT%\cec_%ODT_LOG_NAME%.txt 
)
echo exit 0| sh

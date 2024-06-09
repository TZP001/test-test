@echo off
rem 
rem Shell utilise pour mkOdt
rem %1 = directory output de mkchecksource si ADL_ODT_OUT non value
rem %2 = directory output a concatener
rem %3 = page html a lancer
rem
if "%ADL_ODT_OUT%" NEQ "" set MKODTOUT=%ADL_ODT_OUT%
if "%ADL_ODT_OUT%"=="" set MKODTOUT=%1
cd %MKODTOUT%\%2
start %3

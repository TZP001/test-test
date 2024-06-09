@echo off

: ---------------------------------------------
: Procedure de soumission de la commande mkbs !
: ---------------------------------------------

setlocal

rem La macro LEVEL specifique CNEXT si elle existe
set CNEXT_LEVEL=%MkmkMACRO_LEVEL%\CNEXTLVL
set LEVEL=%MkmkMACRO_LEVEL%\LEVEL
set OS_LEVEL=%MkmkMACRO_LEVEL%\Windows_NT
set CMD_NAME=mkbsM

call StdMKMKCommand %*


@echo off

: ---------------------------------------------
: Procedure de soumission de la commande mkstep !
: ---------------------------------------------

setlocal

rem La macro LEVEL specifique CNEXT si elle existe

set CNEXT_LEVEL=%MkmkMACRO_LEVEL%\CNEXTLVL
set LEVEL=%MkmkMACRO_LEVEL%\LEVEL
set OS_LEVEL=%MkmkMACRO_LEVEL%\Windows_NT
set CATReferenceSettingPath=

set CMD_NAME=mkstepM

if DEFINED MKMKATDS set CMD_NAME=mkstepMInternalDS

call StdMKMKCommand %*


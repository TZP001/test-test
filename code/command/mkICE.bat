@echo off

: ------------------------------------------------
: Identity Card Editor
: ------------------------------------------------

setlocal
set CMD_NAME=mkICEM
set CLR_PATH=%~dp0..\..\code\clr
PATH=%PATH%;%CLR_PATH%
start /b mkICEM %*

@echo off
setlocal

if DEFINED MKMKATDS set CMD_NAME=mkds
if NOT DEFINED MKMKATDS set CMD_NAME=mkmk
call %CMD_NAME% -a -noci -nobuild -ignore_mkerror && call mkCreateRuntimeView %*


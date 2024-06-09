@echo off
setlocal
call mkmk -mkdataonly %*
call mkstep -s headerlist:headermap %*

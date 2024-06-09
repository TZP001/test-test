@echo off
setlocal
set _MK_VJC32PATH=C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727
set PATH=%_MK_VJC32PATH%;%PATH%
call vjc %*

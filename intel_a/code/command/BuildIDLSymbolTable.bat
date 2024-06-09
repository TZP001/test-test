@echo off

setlocal

set PATH=%PATH%;%mkcsSHLIB_PATH%


BuildIDLSymbolTableM %*

endlocal

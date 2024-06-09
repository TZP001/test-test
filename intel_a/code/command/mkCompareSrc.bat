@echo off

setlocal

set PATH=%PATH%;%mkcsSHLIB_PATH%

mkCompareSrcM %*

endlocal

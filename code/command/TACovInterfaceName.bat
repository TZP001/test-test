@echo off

setlocal

set PATH=%PATH%;%mkcsSHLIB_PATH%

set MkmkROOT_PATH=%mkcsROOT_PATH%;%MkmkROOT_PATH%

TACovInterfaceNameM %*

endlocal

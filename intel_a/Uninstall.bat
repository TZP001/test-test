@echo off
SET DS_UNINSTALL_BATCH=YES
if exist "d:\Program Files (x86)\Dassault Systemes\B21\EndBatch" del "d:\Program Files (x86)\Dassault Systemes\B21\EndBatch"
if exist "d:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch" del "d:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch"
"d:\Program Files (x86)\Dassault Systemes\B21\intel_a\code\bin\Uninstall.exe" "d:\Program Files (x86)\Dassault Systemes\B21" "CODE" "GUI" "B21" "1"
:wait
if  exist "d:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch" goto error
if not exist "d:\Program Files (x86)\Dassault Systemes\B21\EndBatch" goto wait
goto end
:error
@echo Uninstall failed : see  C:\Users\Administrator\AppData\Local\Temp\cxinst.log
if exist "d:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch" del "d:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch"
goto exit
:end
del /Q  "d:\Program Files (x86)\Dassault Systemes\B21\intel_a\code\bin\Uninstall.exe" 2>nul
rmdir /Q /S "d:\Program Files (x86)\Dassault Systemes\B21" 2>nul
@echo End of uninstall
:exit

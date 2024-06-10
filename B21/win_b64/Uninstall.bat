@echo off
SET DS_UNINSTALL_BATCH=YES
if exist "D:\Program Files (x86)\Dassault Systemes\B21\EndBatch" del "D:\Program Files (x86)\Dassault Systemes\B21\EndBatch"
if exist "D:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch" del "D:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch"
"D:\Program Files (x86)\Dassault Systemes\B21\win_b64\code\bin\Uninstall.exe" "D:\Program Files (x86)\Dassault Systemes\B21" "CODE" "GUI" "B21" "0"
:wait
if  exist "D:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch" goto error
if not exist "D:\Program Files (x86)\Dassault Systemes\B21\EndBatch" goto wait
goto end
:error
@echo Uninstall failed : see  C:\Users\Administrator\AppData\Local\Temp\cxinst.log
if exist "D:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch" del "D:\Program Files (x86)\Dassault Systemes\B21\ErrorBatch"
goto exit
:end
del /Q  "D:\Program Files (x86)\Dassault Systemes\B21\win_b64\code\bin\Uninstall.exe" 2>nul
rmdir /Q /S "D:\Program Files (x86)\Dassault Systemes\B21" 2>nul
@echo End of uninstall
:exit

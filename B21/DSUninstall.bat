@echo Uninstall is running ..
@echo off
if exist "C:\Users\Administrator\AppData\Local\Temp\Uninstall.bat" del "C:\Users\Administrator\AppData\Local\Temp\Uninstall.bat"
Move "D:\Program Files (x86)\Dassault Systemes\B21\win_b64\Uninstall.bat"  "C:\Users\Administrator\AppData\Local\Temp\Uninstall.bat" 1>nul 2>nul
"C:\Users\Administrator\AppData\Local\Temp\Uninstall.bat" 2>nul

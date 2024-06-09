@if NOT DEFINED _DEBUG_ @echo off
set MkodtOS_Runtime=%MkmkOS_Buildtime%
rem # if _MkodtCheckOSRunTime valued Specific win32on64 and Windows Server 2003 (winsrv_a and winsrv_a64) :
rem # flagged To support winsvr as pool submit machine

if not defined _MkodtCheckOSRunTime goto :EOF

rem Specific win7_* :
FOR /F "tokens=3,*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') DO SET OSversion=%%i %%j
if /i "%OSversion%" == "Windows 7 Enterprise" set MkodtOS_Runtime=win7_a64
if /i "%OSversion%" == "Windows 7 Enterprise" if "%MkmkOS_BitMode%" == "32" if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set MkodtOS_Runtime=win7_32on64
if /i "%OSversion%" == "Windows 7 Enterprise" if "%MkmkOS_BitMode%" == "32" if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set MkodtOS_Runtime=win7_32on64
if /i "%OSversion%" == "Windows 7 Enterprise" goto :EOF

rem Specific Win32on64 :
if "%MkmkOS_BitMode%" == "32" if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set MkodtOS_Runtime=win32on64
if "%MkmkOS_BitMode%" == "32" if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set MkodtOS_Runtime=win32on64
if "%MkodtOS_Runtime%" == "win32on64" goto :EOF

rem Specific winsrv_* :
FOR /F "tokens=4,*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') DO SET OSversion=%%i %%j
if /i "%OSversion%" == "Windows Server 2003" set MkodtOS_Runtime=winsrv_a
if /i "%OSversion%" == "Windows Server 2003" if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set MkodtOS_Runtime=winsrv_a64
if /i "%OSversion%" == "Windows Server 2003" if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set MkodtOS_Runtime=winsrv_a64
if /i "%OSversion%" == "Windows Server 2003" goto :EOF

rem Specific winsrv_b* :
FOR /F "tokens=3,*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') DO SET OSversion=%%i %%j
if /i "%OSversion%" == "Windows Server (R) 2008 Enterprise" set MkodtOS_Runtime=winsrv_b
if /i "%OSversion%" == "Windows Server (R) 2008 Enterprise" if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set MkodtOS_Runtime=winsrv_b64
if /i "%OSversion%" == "Windows Server (R) 2008 Enterprise" if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set MkodtOS_Runtime=winsrv_b64
if /i "%OSversion%" == "Windows Server (R) 2008 Enterprise" goto :EOF

rem Specific winsrv_b* :
FOR /F "tokens=3,*" %%i IN ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName') DO SET OSversion=%%i %%j
if /i "%OSversion%" == "Windows Server (R2) 2008 Enterprise" set MkodtOS_Runtime=winsrv_b
if /i "%OSversion%" == "Windows Server (R2) 2008 Enterprise" if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set MkodtOS_Runtime=winsrv_b64
if /i "%OSversion%" == "Windows Server (R2) 2008 Enterprise" if "%PROCESSOR_ARCHITEW6432%" == "AMD64" set MkodtOS_Runtime=winsrv_b64
if /i "%OSversion%" == "Windows Server (R2) 2008 Enterprise" goto :EOF


rem ----------
goto :EOF

rem
rem Progra~1 = Program files
rem Micros~2 = Microsoft Visual Studio
rem I-Run2~1.0 = I-Run 2.0
rem
set ISOGEN_DIR=C:\Progra~1\Alias
set DEV_STUDIO_DIR=C:\Progra~1\Micros~2
set ISOGEN_RUN_DIR="%ISOGEN_DIR%\Isogen"
set ISOGEN_DEV_DIR=%ISOGEN_DIR%\I-Run2~1.0\Development
set INCLUDE=%INCLUDE%;%ISOGEN_DEV_DIR%
set LIB=%LIB%;%ISOGEN_DEV_DIR%;%DEV_STUDIO_DIR%\vc98\lib
set PATH=%PATH%;%ISOGEN_RUN_DIR%;%DEV_STUDIO_DIR%\Common\msdev98\bin
"%DEV_STUDIO_DIR%\VC98\bin/cl.exe" CATIAPcf2Dxf.obj /link %ISOGEN_DEV_DIR%\encrypt.lib %ISOGEN_DEV_DIR%\pisogen.lib


set mkcsROOT_PATH=d:\Program Files (x86)\Dassault Systemes\B21\intel_a
set PATH=%PATH%;%mkcsROOT_PATH%\code\command
set mkcsSHLIB_NAME=PATH
set mkcsSHLIB_PATH=%mkcsROOT_PATH%\code\bin
set mkcsOS_Runtime=intel_a
if DEFINED _mkcsOS_Buildtime set mkcsOS_Buildtime=%_mkcsOS_Buildtime%
if DEFINED mkcsOS_Buildtime goto end 
if DEFINED MkmkOS_Buildtime set mkcsOS_Buildtime=%MkmkOS_Buildtime% 
if DEFINED MkmkOS_NAME set mkcsOS_NAME=%MkmkOS_NAME% 
if DEFINED mkcsOS_Buildtime goto date 
rem ----- 
rem - MkmkOS_Buildtime does not already exist, search for NTsetos.bat in PATH 
if DEFINED _fnd_ set _fnd_= 
for %%i in (NTsetos.bat) do set _fnd_=%%~$PATH:i 
if NOT DEFINED _fnd_ ( 
@echo ERROR: profile NTsetos.bat was not found in PATH, failed to set mkcsOS_Buildtime 
goto error 
 ) 
if DEFINED _fnd_ call %_fnd_% 
if DEFINED _fnd_ set _fnd_= 
if DEFINED MkmkOS_Buildtime set mkcsOS_Buildtime=%MkmkOS_Buildtime% 
if DEFINED MkmkOS_NAME set mkcsOS_NAME=%MkmkOS_NAME% 
for %%i in (NTunsetos.bat) do set _fnd_=%%~$PATH:i 
if DEFINED _fnd_ call %_fnd_% >NUL 
if DEFINED _fnd_ set _fnd_= 
rem ----------------------------------------------------------------------------- 
:date 
set mkcsvers=mkCheckSource 1.19.1 
set mkcsbuild=11901 
if DEFINED mkcsdate set mkcsvers=%mkcsvers% %mkcsdate% 
:version 
@echo * %mkcsvers% * 
goto end 
rem ----------------------------------------------------------------------------- 
:error 
if DEFINED mkcsROOT_PATH set mkcsROOT_PATH= 
if DEFINED mkcsINSTALL_PATH set mkcsINSTALL_PATH= 
if DEFINED mkcsOS_Buildtime set mkcsOS_Buildtime= 
if DEFINED mkcsOS_Runtime set mkcsOS_Runtime= 
if DEFINED mkcsOS_NAME set mkcsOS_NAME= 
if DEFINED mkcsSHLIB_NAME set mkcsSHLIB_NAME= 
if DEFINED mkcsSHLIB_PATH set mkcsSHLIB_PATH= 
:end 
set mkcsOS_NAME=Windows_NT
set mkcsClientMode=1
set CSCSkipTestOfMapFileValidity=1
echo mkCheckSource environment set.


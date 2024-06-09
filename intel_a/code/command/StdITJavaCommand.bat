@echo off
setlocal
if NOT DEFINED MkmkWSAD_PATH set Path=%Path%;%MkmkSHLIB_PATH%
if DEFINED MkmkWSAD_PATH set Path=%MkmkWSAD_PATH%;%MkmkSHLIB_PATH%
set CATTraDecDir=NUL
set CATICPath=%MkmkIC_PATH%
set CATDictionaryPath=%MkmkDictionary_PATH%
set CATMsgCatalogPath=%MkmkMsgCatalog_PATH%
set CATDefaultEnvironment=MkmkEnvironment
set PATH=%JavaROOT_PATH%\jre\bin\classic;%JavaROOT_PATH%\jre\bin;%PATH%

for /F "delims=;" %%i in ("%MkmkROOT_PATH%") do set CLASSPATH=%%i\docs\java\msqlcon.jar;%%i\docs\java\ITJavaCatalogue.jar;%%i\docs\java\CATITJavaServerServices.jar;%CLASSPATH%

call "%JavaROOT_PATH%\bin\java" -DMkmkOS_Buildtime=%MkmkOS_Buildtime% -DITEnoviaWebSiteServer=%ITEnoviaWebSiteServer% %CLASS_NAME% %*


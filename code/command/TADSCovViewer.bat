@echo off

setlocal

rem -------------------------------------------------------------------------------------
rem   SHELL DE LANCEMENT DE LA COMMANDE UTILISATEUR  -->   " TADSCovViewerM "
rem -------------------------------------------------------------------------------------


set DSCovViewerTmpDir=c:\temp\TADSCovViewer_%RANDOM%
mkdir %DSCovViewerTmpDir%

call %MkmkROOT_PATH%\code\clr\TADSCovViewerM.exe %*%
if exist %DSCovViewerTmpDir% rmdir /S /Q %DSCovViewerTmpDir%

endlocal


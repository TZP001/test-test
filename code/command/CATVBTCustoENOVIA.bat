rem . StdMKMKLimitEnv.sh
rem --------------------------------------------------------

set CATICPath=%MkmkIC_PATH%

set CNEXT_LEVEL=%MkmkMACRO_LEVEL%\CNEXTLVL

set LEVEL=%MkmkMACRO_LEVEL%\LEVEL

set OS_LEVEL=%MkmkMACRO_LEVEL%\%MkmkOS_NAME%

set PATH=%VBTRADELibs%\code\bin;%PATH%

set CMD_NAME=CATVBTCustoENOVIAM.exe
call StdMKMKCommand.bat


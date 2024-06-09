@echo off

if not DEFINED mkcsSHLIB_NAME (
echo "mkcsSHLIB_NAME not defined, you must be in a mkCheckSource environment !!!"
exit 1
)

if not DEFINED mkcsOS_Runtime (
echo "mkcsOS_Runtime not defined, you must be in a mkCheckSource environment !!!"
exit 1
)


if DEFINED ADLV5_Mkcs_INSTALL (

set mkcsROOT_PATH=%ADLV5_Mkcs_INSTALL%\%mkcsOS_Runtime%
)

if not DEFINED ADLV5_Mkcs_INSTALL (

if not DEFINED mkcsROOT_PATH set mkcsROOT_PATH=\\atlas\mkcscxr13_d1\%mkcsOS_Runtime%

)


set PATH=%PATH%;%mkcsROOT_PATH%\code\bin

rem set MkmkROOT_PATH=%mkcsROOT_PATH%;%MkmkROOT_PATH%

rem to desactivate mkCheckSource, comment next line

set mkCheckSourceAvailable=1

if not DEFINED mkCheckSourceAvailable (

echo " No mkCheckSource available..."
echo
echo
exit 0
)


mkCheckSourceM -ADLMode -settings %mkcsROOT_PATH%\resources\mkCheckSource\Settings_ADLV5.xml -traceDefFile %mkcsROOT_PATH%\resources\mkCheckSource\ADLV5_TraceDefinition.xml -filterFile %mkcsROOT_PATH%\resources\mkCheckSource\Filter.xml %* 
exit %ERRORLEVEL%


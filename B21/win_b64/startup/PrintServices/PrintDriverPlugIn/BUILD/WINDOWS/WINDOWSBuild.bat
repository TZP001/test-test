@echo off
rem Dassault Systemes 2002
echo "  V5 Print Plugin API "

rem V5 Print Plugin API 

rem Build Command based adapted for Windows VC environment (be sure to have access to commande line NMAKE, CL and LINK)
rem ' Refers to Microsoft Visual Studio documentation for detail description of this configuration.
rem ' 
rem ' - Create an empty directory (C:\V5PRINTDRIVER) 
rem ' - Copy in this directory 
rem        - your .cpp Print Plugin implementation (can use CATPDPluginTemplate.cpp as help skeleton)
rem '       - WINDOWSBuild.bat
rem '       - CATPDPluginAPI.h
rem '       - CATPDPlugin.mak

rem '  - Adjust the source name and dll name in the CATPDPlugin.mak

rem -  - Execute WINDOWSBuild.bat command

NMAKE /f CATPDPlugin.mak 

echo " DLL generated "

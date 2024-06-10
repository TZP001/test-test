@echo off
rem ********************************************
rem ***                                      ***
rem ***     Process Engineer TO V5 BATCH     ***
rem ***                                      ***
rem ********************************************
rem 
rem This Batch file is used to launch V5 application from DELMIA Process Engineer
rem This batch will launch DNBIPDDirectLaunch.exe using user V5 Environment
rem Settings. Admin user must update this file when he is installing application.
rem 
rem
rem
rem  1.	V5InstallationPath : Directory where the V5 is installed
rem  2.	V5UserEnvFilePath  : Directory where the V5 environment file is stored
rem                          (by default: %USERPROFILE%\Application Data\DassaultSystemes\CATEnv)
rem  3. V5UserEnvName      : V5 Environment name (User should use use environment)
rem

rem ==============================================================================
rem ===                To be set by the administrator:                         ===
rem ==============================================================================

set CATNoStartDocument=0 
set V5InstallationPath=C:\Program Files\Dassault Systemes\B09
set V5UserEnvFilePath="%USERPROFILE%\Application Data\DassaultSystemes\CATEnv"
set V5UserEnvName=V5Rx

rem === Command line - Do not change ===

start %V5InstallationPath%\intel_a\code\bin\DNBIPDDirectLaunch.exe -env %V5UserEnvName% -direnv %V5UserEnvFilePath%

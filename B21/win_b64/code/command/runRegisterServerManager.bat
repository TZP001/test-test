rem echo off
rem ################################################################################
rem #                                                                              #
rem # COPYRIGHT DASSAULT SYSTEMES 1999                                             #
rem #                                                                              #
rem #     Shell Script command to register CATIAServerManager                      #
rem #       Name            : runRegisterServerManager                             #
rem #       Input           : host name                                            #
rem #       Output          : stdout                                               #
rem #                                                                              #
rem ################################################################################
set IT_CONFIG_PATH=%CATInstallPath%\startup\orbix
set SERVER_HOST=%1

"%CATInstallPath%\code\bin\putit" -h %SERVER_HOST% -shared CATIAServerManager "%CATInstallPath%\code\bin\GW0SRVMG" 
"%CATInstallPath%\code\bin\chmodit" CATIAServerManager i+all
"%CATInstallPath%\code\bin\chmodit" CATIAServerManager l+all

echo off
rem ################################################################################
rem #                                                                              #
rem # COPYRIGHT DASSAULT SYSTEMES 2000                                             #
rem #                                                                              #
rem #     Shell Script command to Remove the Implementation Repository entry       #
rem #       Name            : runDeleteServerManager                               #
rem #       Input           : none                                                 #
rem #       Output          : stdout                                               #
rem #                                                                              #
rem ################################################################################
set IT_CONFIG_PATH=%CATInstallPath%\startup\orbix

"%CATInstallPath%\code\bin\rmit" CATIAServerManager  

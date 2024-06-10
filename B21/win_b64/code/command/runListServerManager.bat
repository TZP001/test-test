echo off
rem ################################################################################
rem #                                                                              #
rem # COPYRIGHT DASSAULT SYSTEMES 2000                                             #
rem #                                                                              #
rem #     Shell Script command to list the Implementation Repository               #
rem 
rem #       Name            : runListServerManager                                 #
rem #       Input           : none                                                 #
rem #       Output          : stdout                                               #
rem #                                                                              #
rem ################################################################################
set IT_CONFIG_PATH=%CATInstallPath%\startup\orbix
rem SERVER_HOST=`uname -n`
rem export SERVER_HOST
rem 
"%CATInstallPath%\code\bin\lsit" 

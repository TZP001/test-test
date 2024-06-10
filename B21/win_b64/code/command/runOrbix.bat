echo off
rem ###########################################################################
rem   COPYRIGHT DASSAULT SYSTEMES 2000                                        #
rem                                                                           #
rem   Component Class : Shell Script command to start orbix daemon            #
rem                                                                           #
rem    Name            : runOrbix                                             #
rem    Input           : none                                                 #
rem    Output          : stdout                                               #
rem                                                                           #
rem ###########################################################################
set IT_CONFIG_PATH=%CATInstallPath%\startup\orbix

rem -----------------------------------------------------------------------
rem Start Orbix Daemon
rem ------------------------------------------------------------------------
"%CATInstallPath%\code\bin\orbixd" -u -s 


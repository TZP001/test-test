rem @echo on
rem @echo running : V5setup.bat
rem @echo ---------------------
rem @echo 
@echo off
rem ###########################################################################
rem
rem       Environment Setup to run CATIA V5 Direct Server
rem 
rem  Description:
rem	This file needs to be sourced before lauching the server.
rem       It defines environment variables that define:
rem	- CATIA V5 version to load appropriate server libraries 
rem	- client-server communication details
rem	- product directory structure 
rem	- message debugging
rem	- CATIA V5 run script location
rem	- license file
rem  NOTE:
rem	User may have to reset some of the variables if the server fails to
rem	to run.
rem
rem
rem  Modification History:
rem
rem       cre     rmd     05-17-00        original code
rem       mod     api     05-23-00	  initialization of V5_INSTALL_DIR
rem					  and V5_CATIA_VERSION added
rem	  mod	  vg	  06-03-00	  Server Debug option to be switched to
rem					  OFF 
rem       bug     api     09-26-00        Fix for bug# igrip.4649. Redefined
rem                                       LM_LICENSE_FILE.
rem
rem ###########################################################################

rem ######################### Please Note! ################################
rem Initialization of the following two variables is necessary to
rem run the Server. 
rem 
rem 1.V5_CATIA_VERSION
rem 2.V5_INSTALL_DIR
rem 3.LM_LICENSE_FILE
rem
rem These variables should be initialised in this file or in the environment
rem before calling the server. Otherwise the server shall exit with an
rem appropriate error message.
rem ########################################################################

rem ################ Initialize the variables here#####################

rem ################ 1. Initialize V5_CATIA_VERSION ##################
rem
rem Specify CATIA version. eg.
rem set V5_CATIA_VERSION=V5R3
rem
rem ###################################################################
rem if "%V5_CATIA_VERSION%" == "" set V5_CATIA_VERSION=

if "%V5_CATIA_VERSION%" == "" set V5_CATIA_VERSION=

rem ################ 2. Initialize V5_INSTALL_DIR #####################
rem
rem Specify V5 installation directory. eg.
rem set V5_INSTALL_DIR=C:\dassaultSystemes\V5R4021\
rem
rem ###################################################################
rem if "%V5_INSTALL_DIR%" == "" set V5_INSTALL_DIR=

rem if not exist P:\nul subst P: "F:\Dassault Systemes\B05"
rem set V5_INSTALL_DIR=P:\

set V5_INSTALL_DIR=

rem ##################################################################
rem set DENEB_PATH
rem ##################################################################
if "%DENEB_PATH%" == "" set DENEB_PATH=

rem ################ 3. Initialize LM_LICENSE_FILE ####################
rem
rem Specify V5server License file egs:,
rem set LM_LICENSE_FILE=C:\deneb\license\license.dat
rem
rem ###################################################################
if "%LM_LICENSE_FILE%" == "" set LM_LICENSE_FILE=%DENEB_PATH%\license\license.dat

rem ##################################################################
rem set DENEB_PROD_DIR
rem ##################################################################
if "%DENEB_PROD_DIR%" == "" set DENEB_PROD_DIR=%DENEB_PATH%\vmap

rem ##################################################################
rem set DENEB_BIN_DIR
rem ##################################################################
if "%DENEB_BIN_DIR%" == "" set DENEB_BIN_DIR=%DENEB_PROD_DIR%\bin

rem ##################################################################
rem flag to turn messaging from the server on or off
rem ##################################################################
if "%V5DENEB_SRV_DEBUG%" == "" set V5DENEB_SRV_DEBUG=OFF

rem ##################################################################
rem host machine on which the server will be running
rem ##################################################################
if "%CATV5SRV_HOSTNAME%" == "" set CATV5SRV_HOSTNAME=%COMPUTERNAME%

rem ##################################################################
rem the port number on which the server will open communication socket
rem ##################################################################
if "%CATV5SRV_PORT_NUM%" == "" set CATV5SRV_PORT_NUM=7050

rem ##################################################################
rem the amount of time in seconds the client will wait for first 
rem response from the server
rem ##################################################################
if "%CATV5SRV_CLIENT_TIMEOUT%" == "" set CATV5SRV_CLIENT_TIMEOUT=72

rem ##################################################################
rem command line to launch the server
rem ##################################################################
set CATV5SRV_LAUNCH_CMD=runV5DServer.bat

rem ##################################################################
rem set PATH
rem ##################################################################
set PATH=%DENEB_PROD_DIR%\V5;%PATH%;

rem ##################################################################
rem set TMP_DIR
rem ##################################################################
if "%TMPDIR%" == "" set TMPDIR=C:\tmp




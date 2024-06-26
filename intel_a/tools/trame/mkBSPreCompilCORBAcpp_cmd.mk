#
# Specifications for Build step PreCompilCORBAcpp
#
CORBA_CLIENT_DEFINE = CLIENT
CORBA_SERVER_DEFINE = SERVER
#CORBA_CS_DEFAULT = $(CORBA_CLIENT_DEFINE) $(CORBA_SERVER_DEFINE)
CORBA_CS_DEFAULT = 
CORBA_CS = $(CORBA_CPP_CS:-CORBA_CS_DEFAULT)
CORBA_OPTS = $(CORBA_COMPILER) $(CORBA_CPP_OPTS:-"")
CORBA_SERVER_SUFFIX = _S.cpp
CORBA_CLIENT_SUFFIX = _C.cpp
CORBA_INCLUDE_SUFFIX = .h
CORBA_HOME = $(CorbaCppROOT_PATH:-"")
CORBA_PATH = $(CORBA_HOME)\bin
CORBA_CONFIG = $(CORBA_HOME)\config
CORBA_COMPILER = $(CORBA_PATH)\idl
CORBA_MANDATORY_OPTS = %CORBA_INCLUDE% -c $(CORBA_CLIENT_SUFFIX) -s $(CORBA_SERVER_SUFFIX) -h $(CORBA_INCLUDE_SUFFIX)
# CORBA_OPTS depends of CORBA_COMPILER
CORBA_COMMAND = $(CORBA_OPTS) $(CORBA_MANDATORY_OPTS) -out "%TEMP_OBJECT_PATH%"
_TEMPORARYEXTENSION=.tmpcpp
#
DGM_VERSION = 1.0
#


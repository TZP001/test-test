#
# Descriptions des modules de types "CORBA"
#
OS = COMMON
#
BUILD_PRIORITY_MOD = LINK_WITH
#
TYPELATE = mkCorba
#
IMAKEKEY_VALID =
#
TARGETS_VALID = corbagrammar cscimplement corbacompilation corbaglobalresource corbalink1st corbalink2nd corbaarchive runtimedata buildtimedata
#
# Default is CPP part for modules CORBA, see ModJava.mk for specific JAVA Part
#
CLIENT = CORBA_SHL_C_
SERVER = CORBA_SHL_S_
CLIENT_A = CORBA_AR_C_
SERVER_A = CORBA_AR_S_
#

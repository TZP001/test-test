#
# Descriptions des modules de types "JAVA"
#
OS = COMMON
#
BUILD_PRIORITY_MOD = LINK_WITH
#
TYPELATE = mkJavaClient
#
IMAKEKEY_VALID =
#
TARGETS_VALID = javagrammar javabuild javajni javadoc clean runtimedata buildtimedata cscimplementjava
#
# Specific JAVA part of modules CORBA, see ModCorba.mk for default CPP Part
#
CLIENT = CORBA_JAVA_C_
SERVER = CORBA_JAVA_S_
#

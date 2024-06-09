#
# Descriptions des modules de types "JAVA"
#
OS = COMMON
#
BUILD_PRIORITY_MOD = LINK_WITH
#
TYPELATE = mkJavaCommon
#
IMAKEKEY_VALID =
# If not in CLR mode
TARGETS_VALID		= javagrammar javabuild javajni javadoc clean runtimedata buildtimedata cscimplementjava
# If CLR=CSHARP: j2csharpbuild
TARGETS_VALID_CSHARP= javagrammar javabuild javajni javadoc clean runtimedata buildtimedata j2csharpbuild cscimplementjava
# If CLR=JSHARP: jsharpbuild
TARGETS_VALID_JSHARP= javagrammar javabuild javajni javadoc clean runtimedata buildtimedata jsharpbuild cscimplementjava
#
# Specific JAVA part of modules CORBA, see ModCorba.mk for default CPP Part
#
CLIENT = CORBA_JAVA_C_
SERVER = CORBA_JAVA_S_
#

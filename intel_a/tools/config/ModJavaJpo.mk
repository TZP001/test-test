#
# Descriptions des modules de types "JAVA JPO"
#
OS = COMMON
#
BUILD_PRIORITY_MOD = LINK_WITH
#
TYPELATE = mkJavaJpo
#
IMAKEKEY_VALID =
# If not in CLR mode
TARGETS_VALID		= javagrammar javabuild javajni javadoc clean runtimedata buildtimedata cscimplementjava
# If CLR=CSHARP: j2csharpbuild
TARGETS_VALID_CSHARP= javagrammar javabuild javajni javadoc clean runtimedata buildtimedata j2csharpbuild cscimplementjava
# If CLR=JSHARP: jsharpbuild
TARGETS_VALID_JSHARP= javagrammar javabuild javajni javadoc clean runtimedata buildtimedata jsharpbuild cscimplementjava
#
# Default package name is "."
PACKAGE_MODULE = .
#
# Mandatory, used to list the sources to be copied into the runtime view during mkBSRuntimeData
RTV_BSMETACLASS_SRC = CompilSharp CompilJava
# Default root directory in runtime view to copy files (WS/$OS)
RTV_ROOT_FILE_COPY = code/commands
#

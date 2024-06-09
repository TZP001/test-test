#
# Descriptions des modules de types "JSHARP"
#
OS = COMMON
#
BUILD_PRIORITY_MOD = LINK_WITH
#
TYPELATE = mkSharpDllJ
# If CLR=CSHARP: j2csharpbuild
TARGETS_VALID_CSHARP= javagrammar clean runtimedata buildtimedata j2csharpbuild
# If CLR=JSHARP: jsharpbuild
TARGETS_VALID_JSHARP= javagrammar clean runtimedata buildtimedata jsharpbuild
#

#
# Descriptions des modules de types "SHARED LIBRARY"
#
OS = COMMON
#
# Uncomment to order link-edit regarding the LINK_WITH
#BUILD_PRIORITY_MOD = LINK_WITH
#
TYPELATE = mkSharedLibrary
#
IMAKEKEY_VALID = COMDYN_MODULE INCLUDED_MODULES
#
TARGETS_VALID = cppgrammar cscimplement sourcecheck caacheck typelibgrammar compilation sourceruler globalresource cpponly link1st link2nd clean runtimedata buildtimedata
#
TARGETS_MANDATORIES = link1st link2nd
#


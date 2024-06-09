#
# Specifications for Build step mkBSDsar
#
METACLASS_NAME   = Dsar
#
DGM_GRAPH_PATH   = MODDGM_GRAPHPATH_JAVA
#
SOURCE_EXTENSION = *.class
#
include mkBSJavaSet.mk
include mkBSJavaVersion.mk
#
DGM_DEPEND = JAVA_VERSION
#

#
# Specifications for Build step mkBSBigJar
#
METACLASS_NAME   = BigJar
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

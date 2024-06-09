#
# Specifications for Build step mkBSDocJava
#
METACLASS_NAME   = DocJava
METACLASS_SOURCE = DocJava

#
DGM_GRAPH_PATH   = MODDGM_GRAPHPATH_JAVA
#
SOURCE_EXTENSION = *.java
#
WSROOT_PATH=$(WSPATH)
#
include mkBSJavaSet.mk
include mkBSJavaVersion.mk
#
DGM_DEPEND = JAVA_VERSION
#

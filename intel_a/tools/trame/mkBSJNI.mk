#
# Specifications for Build step mkBSJNI
#
METACLASS_NAME = Grammar
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_JAVA
#
SOURCE_EXTENSION = *.java
#
DEPENDENT_ON   = $(MOD_LinkWith)
#
include mkBSJavaSet.mk
include mkBSJavaVersion.mk
#
DGM_DEPEND = JAVA_VERSION
#

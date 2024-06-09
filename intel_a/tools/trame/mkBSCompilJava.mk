#
# Specifications for Build step mkBSCompilJava
#
METACLASS_NAME = CompilJava
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_JAVA
#
SOURCE_EXTENSION = *.java
#
DEPENDENT_ON = $(MOD_LinkWith)
#
OBJLIST = .mkObjListGeneric
#
include mkBSJavaSet.mk
include mkBSJavaVersion.mk
#
DGM_DEPEND = JAVA_VERSION
#

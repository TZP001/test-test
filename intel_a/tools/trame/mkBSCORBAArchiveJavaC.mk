#
# Specifications for Build step mkBSCORBAArchiveJavaC
#
METACLASS_NAME = ArchiveJava_C
#
METACLASS_SOURCE = CompilJava_C
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_JAVA
#
SOURCE_EXTENSION_FOR_TEST = *.class
#
CORBA_JAVA_PACKAGE_CS = $(CORBA_JAVA_PACKAGE:-"com.dassault_systemes")
CORBA_PACKAGE = $(CORBA_JAVA_PACKAGE_C:-CORBA_JAVA_PACKAGE_CS)
#
CORBA_DIRECTORY = tmp.client
#
include mkBSJavaVersion.mk
#
DGM_DEPEND = JAVA_VERSION
#

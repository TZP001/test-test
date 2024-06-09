#
# Specifications for Build step Java doc
#
# ---------------------
#
JDOC_COMPILEUR = $(JAVA_PATH)\bin\javadoc
JDOC_LIB = $(JAVA_PATH)\lib\tools.jar
JDOC_LIBS      = $(LOCAL_CLASSPATH);$(WS_LIBS);$(JDOC_LIB);$(SYS_LIBS)
JDOC_OPTIMIZE  = $(OPTIMIZATION_JDOC:" ")
JDOC_PATH      = $(WS_PATH);$(LOCAL_CLASSPATH)
JDOC_OPTS      = $(LOCAL_JDOC_FLAGS) $(JDOC_OPTIMIZE) 
#JDOC_OBJLIST = $(MOD_ObjectsPath)\.mkObjListGeneric
JDOC_CONTROLLIST =$(MOD_ObjectsPath)\.mkJdocControl.txt

JDOC_DOCLET	= com.dassault_systemes.MkBSImplement.MkDoclet.JDoclet
JDOC_DOCLETPATH=$(DOCLET)

DOCLET_JAR_NAME = MkDoclet.jar
DOCLET_JAR_SUBDIR = docs\java
DSGIF_SUBDIR = tools\trame
DSGIF_NAME = DSLogo.gif
#

JDOC_COMMAND = "$(JDOC_COMPILEUR)" $(JAVA_SOURCE_OPTION:@"-source 1.3") $(JDOC_OPTS) -J-Djava.compiler=NONE -J-Xms128m -J-Xmx256m -classpath "$(JDOC_LIBS)"  

#$(WS_LINK) -J-Xmx180m
#
DGM_VERSION = 1.5
#


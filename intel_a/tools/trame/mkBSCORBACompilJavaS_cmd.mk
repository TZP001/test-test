#
# Specifications for Build step mkBSCORBACompilJavaS
#
# ---------------------
#
JAVA_COMPILER = $(JAVA_PATH)\bin\javac
JAVA_OPTIMIZE  = $(MKMK_DEBUG:+"-g")
CORBA_LIBS     = $(CorbaJavaROOT_PATH)\lib\OrbixWeb.jar
JAVA_LIBS      = $(CorbaJavaROOT_PATH:+CORBA_LIBS)$(WS_LIBS)
#
JAVA_OBJLIST = $(JAVA_OBJPATH)\$(OBJLIST)
#
JAVA_COMMAND = "$(JAVA_COMPILER)" $(LOCAL_JAVAFLAGS) $(JAVA_OPTIMIZE) $(JAVA_OPTS)\
					-classpath "$(JAVA_LIBS)$(SYS_JAVALIBS:+";")$(SYS_JAVALIBS)"\
					-d "$(LOCAL_JAVALIBS)" @"$(JAVA_OBJLIST)"
#
MKMK_DGM_BEHAVIOUR=update
#
#
DGM_VERSION = 1.0
#


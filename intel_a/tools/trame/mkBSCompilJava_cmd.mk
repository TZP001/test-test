#
# Specifications for Build step Java compil >= 1.2
# ----------------------
DGM_VERSION = 1.0
# ----------------------
#
JAVA_COMPILEUR = $(JAVA_PATH)\bin\javac
JAVA_OPTIMIZE  = $(MKMK_DEBUG:+"-g")
JAVA_LIBS      = $(WS_LIBS)
#
JAVA_OBJLIST = $(OBJPATH)\$(OBJLIST)
#
JAVA_COMMAND = "$(JAVA_COMPILEUR)" $(LOCAL_JAVAFLAGS) $(LOCAL_JAVA_FLAGS) $(JAVA_OPTIMIZE) $(JAVA_OPTS)\
				 	-classpath "$(JAVA_LIBS)$(LOCAL_WS_LIBS:+";")$(LOCAL_WS_LIBS)"\
					-d "$(LOCAL_LIBS)" @"$(JAVA_OBJLIST)"
#
JAR      = $(JAVA_PATH)\bin\jar
JAR_OUT  = f "$(SET_JAROBJNAME)"
#
JAR_OBJS = .
JAR_OPTS = cM
#
JAR_COMMAND = "$(JAR)" $(JAR_OPTS)$(JAR_OUT) $(JAR_OBJS)
#

MKMK_DGM_BEHAVIOUR=update

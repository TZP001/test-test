#
# Specifications for Build step mkBSCORBAArchiveJavaC
#
JAR      = $(JAVA_PATH)\bin\jar
JAR_OUT  = f "$(SET_JAROBJNAME)"
JAR_OBJS = .
JAR_OPTS = $(LOCAL_JARFLAGS) c
#
JAR_COMMAND = "$(JAR)" $(JAR_OPTS)$(JAR_OUT) $(JAR_OBJS)
#
#
DGM_VERSION = 1.0
#


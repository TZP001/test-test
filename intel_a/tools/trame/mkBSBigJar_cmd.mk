#
# Specifications for Build step Java BigJar
#
# ---------------------
#
BIGJAR_JAVA = $(JAVA_PATH)\bin\jar 
BIGJAR_OPTS = $(LOCAL_BIGJARFLAGS) cf
#
JAR_EXTENSION = .jar
#
#
DEJAR      = $(JAVA_PATH)\bin\jar
DEJAR_OPTS =  $(LOCAL_JARFLAGS) xf
#
DEJAR_COMMAND = "$(DEJAR)" $(DEJAR_OPTS) 
#
BIGJAR_COMMAND = "$(BIGJAR_JAVA)" $(BIGJAR_OPTS)
#
DGM_VERSION = 1.0
#


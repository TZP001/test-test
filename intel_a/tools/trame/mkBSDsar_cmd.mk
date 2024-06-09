#
# Specifications for Build step Java Dsar
#
# ---------------------
#
DSAR_JAVA = $(JAVA_PATH)\bin\java 
DSAR_OUT  = f $(SET_JAROBJNAME)
DSAR_OPTS = $(LOCAL_DSARFLAGS) c
#
DSAR_EXTENSION = .dsar
#
JAR_DSAR_NAME = CATWebDSarMaker.jar
JAR_DSAR_SUBDIR = docs\java
#
DEJAR      = $(JAVA_PATH)\bin\jar
DEJAR_OPTS =  $(LOCAL_JARFLAGS) xf
#
DEJAR_COMMAND = "$(DEJAR)" $(DEJAR_OPTS) 
#
DSAR_COMMAND = "$(DSAR_JAVA)" -classpath "$(DSARMAKER)" com.dassault_systemes.internal.dsar.mkDSAR cf 
#
DGM_VERSION = 1.0
#


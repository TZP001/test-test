#
# Specifications for Build step Java Native Interface
#
# ---------------------
#
JNI_GENERATOR = $(JAVA_PATH)\bin\javah
#
JAVA_COMMAND = "$(JNI_GENERATOR)" -classpath ".$(WS_LIBS)" -jni -force
#
DGM_VERSION = 1.0
#


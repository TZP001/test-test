###########################################################
# Specifications for Build step mkBSGrammarJava
###########################################################
JAVACC_COMPILER = mkjavacc.bat
JAVACC_OPTS = -JDK_VERSION=1.3 $(LOCAL_JAVACCFLAGS) 
JAVACC_COMMAND = $(JAVACC_COMPILER) $(JAVACC_OPTS)
#
###########################################################
MXJAVAJPO_COMPILER = mxjpocompiler.bat
MXJAVAJPO_VERSION = 1.0
MXJAVAJPO_OPTS = $(LOCAL_MXJPOFLAGS) -o "%OBJECT%" -i
MXJAVAJPO_COMMAND = $(MXJAVAJPO_COMPILER) $(MXJAVAJPO_OPTS)
#
###########################################################
MXJAVAJDL_COMPILER = mxjdlcompiler.bat
MXJAVAJDL_VERSION = 1.1
MXJAVAJDL_OPTS = -mkid $(MXJAVAJDL_VERSION) $(LOCAL_MXJDLFLAGS)
MXJAVAJDL_COMMAND = $(MXJAVAJDL_COMPILER) $(MXJAVAJDL_OPTS)
#
###########################################################
MXJAVAWSDL_COMPILER = mxwsdlcompiler.bat
MXJAVAWSDL_VERSION = 1.0
MXJAVAWSDL_OPTS = $(LOCAL_MXJAVAWSDLFLAGS)
MXJAVAWSDL_COMMAND = $(MXJAVAWSDL_COMPILER) $(MXJAVAWSDL_OPTS)
#
###########################################################
DERIVED_EXTENSION = *.java
#
###########################################################
DGM_DEPEND =
DGM_VERSION = 1.1
#

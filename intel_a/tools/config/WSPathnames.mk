#############################################################
# Les macros suivantes ont l'air stupides mais sont utilisees
# fort subtilement par mkFRONTrun.cpp. Donc, pas touche.
#
#############################################################
# Modification de SHE pour suppression de CNEXT.dev
# delete: CNEXT = CNext
# delete: DEV = .dev
# delete: RTV_CNEXTDEV = $(MkmkOS_VAR)
# delete: RTV_DOC               = docs
# delete: RTV_JAVA              = $(RTV_DOC)/java
# delete: RTV_JAVA_CNEXT        = $(MkmkOS_Buildtime)
# delete: RTV_JAVA_CNEXTJAVA    = $(RTV_JAVA_CNEXT)/$(RTV_JAVA)
# delete: RTV_JAVA_DOC          = $(RTV_DOC)/api
#
#############################################################
#  change: RTV_CNEXT         de $(MkmkOS_VAR)/$(CNEXT)  vers $(MkmkOS_VAR)
#  change: RTV_CNEXTDEV      de $(RTV_CNEXT)$(DEV)      vers $(MkmkOS_VAR)
#############################################################
# SHE: La RTV de doc est Doc alors que MkmkOS_DOC vaut DOC
#RTV_DOC               = $(MkmkOS_DOC)
RTV_DOC               = Doc
RTV_CNEXT             = $(MkmkOS_Buildtime)
#
RTV_CODESTEPLIB       = code/steplib
RTV_CODEBIN           = code/bin
RTV_CODELIB           = code/lib
RTV_CODEINST          = code/bin_inst
RTV_CODETLB1          = code/tlb1
RTV_CODEIC            = code/productIC
RTV_CPSPATH			  = $(RTV_CODEIC)/ComponentsDefinition
RTV_CODECOMMAND       = code/command
RTV_RESOURCES         = resources
RTV_FEATCTLG          = resources/featurecatalog
RTV_CNEXTCODELIB      = $(RTV_CNEXT)/$(RTV_CODELIB)
RTV_CNEXTCODEBIN      = $(RTV_CNEXT)/$(RTV_CODEBIN)
RTV_CNEXTCODELB1      = $(RTV_CNEXT)/$(RTV_CODETLB1)
RTV_CNEXTCODEIC       = $(RTV_CNEXT)/$(RTV_CODEIC)
RTV_CNEXTFEATCTLG     = $(RTV_CNEXT)/$(RTV_FEATCTLG)
#
RTV_SRCJAVA			= code/commands
RTV_APIJAVA			= docs/api
RTV_DOCJAVA			= docs/java
RTV_SERVERDOCJAVA	= docs/javaserver
RTV_COMMONDOCJAVA	= docs/javaserver
RTV_JAVA_CNEXT		= $(MkmkOS_Buildtime)
RTV_JAVA_CNEXTJAVA	= $(RTV_JAVA_CNEXT)/$(RTV_DOCJAVA)
#
WSROOT = $(WSPATH)
RTV_PATH = $(WSPATH)/./$(RTV_CNEXT)
MACLEV = $(WSPATH)/CATIAV5Level.lvl
#
RUNTIME_PATH = $(RTV_PATH)/$(RTV_CODEBIN)
BUILDTIME_PATH = $(RTV_PATH)/$(RTV_CODELIB)
STEPLIB_PATH_TLB1 = $(RTV_PATH)/$(RTV_CODETLB1)
STEPLIB_PATH_IC = $(RTV_PATH)/$(RTV_CODEIC)
STEPLIB_COMMAND = $(RTV_PATH)/$(RTV_CODECOMMAND)
#
RUNTIME_PATH_JAVA = $(WSPATH)/./$(RTV_JAVA_CNEXT)/$(RTV_DOCJAVA)
RUNTIME_PATH_DOCJAVA = $(WSPATH)/./$(RTV_JAVA_CNEXT)/$(RTV_APIJAVA)
RUNTIME_PATH_DOC = $(WSPATH)/./$(RTV_JAVA_CNEXT)/docs

#
STEPLIB_PATH = $(RUNTIME_PATH)
#

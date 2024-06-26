#
# Specifications for Build step Grammar2nd
#
############################################
DSXDEVVISUAL = DSxDevVisualCompilerM
DSXDEVVISUAL_CREATEDFILE = DSxDevVisualCompiler.createdfiles
DSXDEVVISUAL_USEDFILE = DSxDevVisualCompiler.usedfiles
DSXDEVVISUAL_COMMAND_TIMEOUT = 900
#
DSXDEVVISUAL_DEBUG = $(MKMK_DEBUG:+"-g")
DSXDEVVISUAL_WARNING = $(MKMK_WARNING:+"-w")
DSXDEVVISUAL_MKID = -mkid "$(DSXDEVVISUALCOMPILERVERSION)"
#
DSXDEVVISUAL_OPTS = $(DSXDEVVISUALCOMPILERVERSION:+DSXDEVVISUAL_MKID) $(DSXDEVVISUAL_DEBUG) $(DSXDEVVISUAL_WARNING) $(LOCAL_DSXDEVVISUALFLAGS)
DSXDEVVISUAL_COMMAND = $(DSXDEVVISUAL) -I "$(RTV_DSXDEVVISUAL)" $(DSXDEVVISUAL_OPTS)
############################################
#
DGM_VERSION = 1.0
#

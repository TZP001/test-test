#
# Descriptions des modules de types "DOC_MAP"
#
OS = COMMON
#
TYPELATE = mkDocMap
#
IMAKEKEY_VALID      = SUBSTITUTION_FILE
#
TARGETS_VALID       = IntermediateView PublishHtm Indexation CheckRTVDoc clean
#
TARGETS_MANDATORIES = IntermediateView PublishHtm Indexation CheckRTVDoc  
#
# ---------------- speciale du chef ----------------
#
OBJPATH            = $(MODPATH)/Objects/$(MkmkOS_DOC)
#

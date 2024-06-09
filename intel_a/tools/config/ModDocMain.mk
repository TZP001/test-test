#
# Descriptions des modules de types "DOC_MAIN"
#
OS = COMMON
#
TYPELATE = mkDocMain
#
IMAKEKEY_VALID      = SUBSTITUTION_FILE
#
TARGETS_VALID       = docmain docupdate doccheck clean DoxMain Indexation
#
# TARGETS_MANDATORIES = docmain docupdate doccheck
#
# ---------------- speciale du chef ----------------
#
OBJPATH            = $(MODPATH)/Objects/$(MkmkOS_DOC)
#

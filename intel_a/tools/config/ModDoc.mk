#
# Descriptions des modules de types "DOC"
#
OS = COMMON
#
### BUILD_PRIORITY_MOD = LINK_WITH
#
TYPELATE = mkDoc
#
IMAKEKEY_VALID      = SUBSTITUTION_FILE
#
TARGETS_VALID       = doc docupdate doccheck docindex clean Dox Indexation
#
# TARGETS_MANDATORIES = doc docupdate doccheck docindex
#
# ---------------- speciale du chef ----------------
#
OBJPATH            = $(MODPATH)/Objects/$(MkmkOS_DOC)
#

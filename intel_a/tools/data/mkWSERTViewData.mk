#
# Loop on MkmkOS_RootBuildtime to build HIERARCHICAL_OSBT_DATA_PATH macro
HIERARCHICAL_OSBT_DATA_MASK = $(FWPATH)/CNext.specifics_
HIERARCHICAL_CNEXT_DATA_PATH = $(HIERARCHICAL_OSBT_DATA_PATH) \
                               "$(FWPATH)/CNext.specifics_$(MkmkOS_NAME)$(MkmkOS_BitMode)" \
                               "$(FWPATH)/CNext.specifics_$(MkmkOS_NAME)" \
                               "$(FWPATH)/CNext.specifics_$(MkmkOS_Type)$(MkmkOS_BitMode)" \
                               "$(FWPATH)/CNext.specifics_$(MkmkOS_Type)" \
                               "$(FWPATH)/CNext.specifics_$(MkmkOS_BitMode)" \
                               "$(FWPATH)/CNext"
#
CNEXT_DATA_PATTERN = CNext.*
CNEXT_AVOID_PATTERN = CNext.specifics* CNext.internal*
#
# Loop on MkmkOS_RootBuildtime to build HIERARCHICAL_OSBT_INTERNAL_PATH macro
HIERARCHICAL_OSBT_INTERNAL_MASK = $(FWPATH)/CNext.internal_
HIERARCHICAL_CNEXT_INTERNAL_PATH = $(HIERARCHICAL_OSBT_INTERNAL_PATH) \
                                   "$(FWPATH)/CNext.internal_$(MkmkOS_NAME)$(MkmkOS_BitMode)" \
                                   "$(FWPATH)/CNext.internal_$(MkmkOS_NAME)" \
                                   "$(FWPATH)/CNext.internal_$(MkmkOS_Type)$(MkmkOS_BitMode)" \
                                   "$(FWPATH)/CNext.internal_$(MkmkOS_Type)" \
                                   "$(FWPATH)/CNext.internal_$(MkmkOS_BitMode)" \
                                   "$(FWPATH)/CNext.internal"
#

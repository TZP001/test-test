#
MKMKOSDOC = $(MkmkOS_DOC)
MKMKOSVAR = $(MkmkOS_Buildtime)
#
SRCPATH = $(MODPATH)/src
OBJPATH = $(MODPATH)/Objects/$(MKMKOSVAR)
RESOURCEPATH = $(MODPATH)/lib
#
ILocal = $(MODPATH)/LocalInterfaces
GLocal = $(MODPATH)/LocalGenerated/$(MKMKOSVAR)
#
MODmkdata = $(OBJPATH)/.mkdata.mkb
#
MODRTViewData = $(VARIOUS_PATH)/$(MODNAME)/module.data
#
DOC_MODvariouspath = $(DOC_VARIOUS_PATH)/$(MODNAME)
DOC_MODRTViewData = $(DOC_MODvariouspath)/module.data
#
RESOURCELOCALPATH = $(GLocal)/lib
#
JDOC_MODRTViewData = $(DOC_MODvariouspath)/module.data
#

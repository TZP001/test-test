##############################################################
#
# Pathname which start from the Module's pathname
#
#############################################################
#
MKMKOSBT = $(MkmkOS_Buildtime)
#
MKMKOSJAVA = $(MKMKOSBT)
MKMKOSDOC = $(MkmkOS_DOC)
#
SRCPATH = src
RESOURCEDIR = Resources
RESOURCEPATH = lib
#
ILocal = LocalInterfaces
GLocal = LocalGenerated/$(MKMKOSBT)
V4_SRCCATGEO = $(GLocal)/catgeo
#
MOD_ROOT_PATH = /
#
OBJPATH = Objects/$(MKMKOSBT)
OBJPATH_JAVA = Objects/$(MKMKOSJAVA)
OBJPATH_DOC = Objects/$(MKMKOSDOC)
#
MOD_MKDATA_PATH = $(OBJPATH)/.mkdata.mkb
MOD_RTVIEWDATA = module.data
MOD_MACDIRS_PATH = $(OBJPATH)/.macdirs.mk
MOD_INCDIRS_PATH = $(OBJPATH)/.incdirs.mk
#
MODCSC_DBPATH = $(OBJPATH)/mkcsc
#
MODmkobjlist = $(OBJPATH)/.mkobjlist.o
MODmkobjlist_C = $(OBJPATH)/.mkobjlist_C.o
MODmkobjlist_S = $(OBJPATH)/.mkobjlist_S.o
#
MODDGM_GRAPHPATH = $(OBJPATH)
MODDGM_GRAPHPATH_JAVA = $(OBJPATH_JAVA)
MODDGM_GRAPHPATH_DOC = $(OBJPATH_DOC)
#
CUSTOM_COMMANDS_CONFIG_PATH = $(MODPATH)
#
RESOURCELOCALPATH = $(GLocal)/lib
#

# -------------------------------------------------
# WINDOWS specifics steps definition
# -------------------------------------------------
Step_typelib = typelibmext typelib
Step_typelibgrammar = typelibgrammar
# -------------------------------------------------
Step_NETbuild = NETmext NETbuild
# NETmext is: csharpbuild j2csharpbuild jsharpbuild vbbuild
# -------------------------------------------------
Step_RMS = rmsmanifest 
# -------------------------------------------------
Fw_bscmake = bscmake
#
# -------------------------------------------------
# specification doc XMetaL
Mod_docXM = headerlist headermap DoxGrammarFw DoxGrammar1st DoxGrammar2nd DoxGrammar3rd\
			Dox DoxMain DoxBase IntermediateView PublishHtm Indexation CheckRTVDoc
#

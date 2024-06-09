# -------------------------------------------------
# include of OS specific steps declaration
# -------------------------------------------------
#
include StepsSpecificsGraphs.mk
#
# -------------------------------------------------
# steps list to apply to all Frameworks
# -------------------------------------------------
Fw_idcard = CIbuild
Fw_idcardcps = CICpsBuild
#
# -------------------------------------------------
# steps list to apply to build XRefDB for Frameworks
# -------------------------------------------------
Fw_xrefdb = XrefDB
#
# -------------------------------------------------
# steps list to apply to build CODE modules
#  $(Step_typelib) is not set only for Linux in file StepsSpecificsGraphs.mk
#  $(Step_typelibgrammar) is set only for Windows in file StepsSpecificsGraphs.mk
#  $(Step_NETmext) is set only for Windows in file StepsSpecificsGraphs.mk
#  $(Step_NETbuild)  is set only for Windows in file StepsSpecificsGraphs.mk
#  $(Step_RMS) is set only for Windows in file StepsSpecificsGraphs.mk
#  $(Step_v4link) is set only for UNIX in file StepsSpecificsGraphs.mk
#  $(Step_v4grammar) is set only for UNIX in file StepsSpecificsGraphs.mk
#  $(Step_v4pif) is set only for UNIX in file StepsSpecificsGraphs.mk
# -------------------------------------------------
Mod_code = CIcompilation headerlist headermap buildtimedata corbagrammar fwgrammar cppgrammar \
	grammar1st grammar2nd grammar3rd $(Step_v4grammar) $(Step_typelib) \
	javamext $(Step_NETmext) corbacompilation javagrammar javabuild $(Step_NETbuild) javajni javapack \
	$(Step_typelibgrammar) headerruler ocamlcompil \
	compilation sourceruler \
	corbalink1st corbalink2nd \
	linkmext \
	corbaarchive ocamlarchive \
	archive \
	link1st link2nd \
	link \
	$(Step_RMS) $(Step_v4link) runtimedata ocamllink \
	dummynls cabjar tclkit $(Step_v4pif) pythonbuild
# -------------------------------------------------
# steps list to apply to build DOC modules
# -------------------------------------------------
Mod_doc  = doc docmain docbase docupdate doccheck docindex
#
# -------------------------------------------------
# steps list to apply to build JAVA DOC modules
# -------------------------------------------------
Mod_javadoc = javadoc
#
# -------------------------------------------------
# steps list for Code Source Checker
Mod_csc = headerlist headermap cscinterface cscimplementjava cscimplement
#Mod_csc = cscimplement

#

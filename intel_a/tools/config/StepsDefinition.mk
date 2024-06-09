# -------------------------------------------------
# include of OS specific steps declaration
# -------------------------------------------------
#
include StepsSpecificsDefinition.mk
#
# ---------------------------------------
#  steps to applying to Frameworks
# ---------------------------------------
#
CIpackaging = FrameworkMandatory 10 parallel FWPATH nohmap nohlist mkBSIdcardBuildAndCrypt
CIbuild = FrameworkMandatory 10 parallel FWPATH nohmap nohlist mkBSIdcardBuild
CIcompilation = Framework  0 parallel IDCARD_PATH_OS nohmap nohlist mkBSIdcardCopyrightCompil
CICpsBuild = Framework 0 parallel IDCARD_PATH_OS nohmap nohlist mkBSIdcardCpsBuild
# ---------------------------------------
headerlist = Framework 0 parallel IDCARD_PATH_OS nohmap nohlist mkBSHeaderList
headermap = Framework 0 parallel IDCARD_PATH_OS nohmap nohlist mkBSHeaderMap
# ---------------------------------------
sourceruler = Module 510 parallel OBJPATH hmap nohlist mkBSSourceRuler
headerruler = Framework 0 parallel IDCARD_PATH_OS hmap nohlist mkBSHeaderRuler
# ---------------------------------------
dummynls = Framework 0 parallel IDCARD_PATH_OS nohmap nohlist mkBSDummyNLS
XrefDB = FrameworkMandatory 5000 parallel FWPATH nohmap nohlist mkBSXrefDB
#
# ---------------------------------------
#  steps to applying to Modules
# ---------------------------------------
# --- NONE
#SHE: nonebuild = Module 500 parallel OBJPATH nohmap nohlist $(compilBS) 
# --- ARCHIVE
#SHE: staticlib = Module 780 parallel OBJPATH nohmap nohlist $(compilBS) mkBSArchive
# --- SHARED LIBRARY
#SHE: exportlib = Module 900 parallelandordered OBJPATH nohmap nohlist $(compilBS) mkBSLnkShl1st
#SHE: dynamiclib = Module 920 parallelandordered OBJPATH nohmap nohlist mkBSLnkShl2nd
# --- LOAD MODULE
#SHE: executable = Module 950 parallel OBJPATH nohmap nohlist $(compilBS) mkBSLnkMain mkBSRMS
#
corbagrammar = Module 10 sequence OBJPATH hmap hlistornot mkBSPreCompilCORBAcpp mkBSPreCompilCORBAjavaC mkBSPreCompilCORBAjavaS mkBSPostCompilCORBAjavaC mkBSPostCompilCORBAjavaS
# ---------------------------------------
typelibmext = Module 90 sequence OBJPATH nohmap nohlist mkBSTypelibExternal
typelib = Module 100 sequence OBJPATH nohmap nohlist mkBSTypelib mkBSMidl
# ---------------------------------------
javagrammar = Module 210 parallelandordered OBJPATH nohmap nohlist mkBSIdlJava mkBSGrammarJava
javabuild = Module 220 parallelandordered OBJPATH nohmap nohlist mkBSCompilJava mkBSXmlManifest mkBSArchiveJava
javajni = Module 230 parallelandordered OBJPATH nohmap nohlist mkBSJNI
javapack = Module 250 parallel OBJPATH nohmap nohlist mkBSDsar mkBSBigJar
# ---------------------------------------
ocamlcompil = Module 400 parallelandordered OBJPATH hmap nohlist mkBSOCamlCompil
# ---------------------------------------
corbalink1st = Module 600 parallel OBJPATH nohmap nohlist mkBSCORBALnkShl1stC mkBSCORBALnkShl1stS
corbalink2nd = Module 620 parallel OBJPATH nohmap nohlist mkBSCORBALnkShl2ndC mkBSCORBALnkShl2ndS
corbaarchive = Module 750 parallel OBJPATH nohmap nohlist mkBSCORBAArchiveC mkBSCORBAArchiveS
# ---------------------------------------
linkmext  = Module 700 parallel OBJPATH nohmap nohlist mkBSExternal
ocamlarchive = Module 760 parallelandordered OBJPATH nohmap nohlist mkBSOCamlArchive
archive = Module 780 parallel OBJPATH nohmap nohlist mkBSArchive
link1st = Module 900 parallelandordered OBJPATH nohmap nohlist mkBSLnkShl1st
link2nd = Module 920 parallelandordered OBJPATH nohmap nohlist mkBSLnkShl2nd
ocamllink = Module 960 parallelandordered OBJPATH nohmap nohlist mkBSOCamlLnkMain
link = Module 950 parallel OBJPATH nohmap nohlist mkBSLnkMain
# ---------------------------------------
buildtimedata = Module 45 parallel OBJPATH nohmap nohlist mkBSBuildtimeData
runtimedata = Module 960 parallel OBJPATH nohmap nohlist mkBSRuntimeData
# ---------------------------------------
cabjar = Module 1000 sequence OBJPATH nohmap nohlist mkBSCabJar
tclkit = Module 1100 sequence OBJPATH nohmap nohlist mkBSTclKit
# ---------------------------------------
doc = Module 2000 parallelandordered OBJPATH nohmap nohlist mkBSDocGenXml mkBSDocParser
docmain = Module 2100 parallelandordered OBJPATH nohmap nohlist mkBSDocParser
docbase = Module 2200 parallelandordered OBJPATH nohmap nohlist mkBSDocParser
docupdate = Module 2300 parallel OBJPATH nohmap nohlist mkBSDocFromXml mkBSDocRefUpdate
doccheck = Module 2400 parallel OBJPATH nohmap nohlist mkBSDocExtAnc
docindex = Module 2500 parallel OBJPATH nohmap nohlist mkBSDocNewIndex
# ---------------------------------------
javadoc = Module 3000 parallel OBJPATH nohmap nohlist mkBSDocJava
#
# ---------------------------------------
#  Specifics step
# ---------------------------------------
cpponly = Module 0 parallel OBJPATH hmap nohlist mkBScppOnly
#
# ---------------------------------------
#  CSC steps
# ---------------------------------------
headercheck = Framework 0 parallel IDCARD_PATH_OS nohmap nohlist mkBSCSCHeader
sourcecheck = Module 500 parallel OBJPATH nohmap nohlist mkBSCSCSource
caacheck = Module 500 parallel OBJPATH nohmap nohlist mkBSCSCCAADeprecated
#
# ---------------------------------------
#  NEW Sources code checkers steps
# ---------------------------------------
cscinterface = Framework 0 parallel IDCARD_PATH_OS hmap nohlist mkBSCSCItfCpp
cscimplement = Module 0 parallel OBJPATH hmap nohlist mkBSCSCImplCpp
cscimplementjava = Module 0 parallel OBJPATH nohmap nohlist mkBSCSCImplJava
# ---------------------------------------
#
cppgrammar = Module 50 parallel OBJPATH hmap hlistornot mkBSGrammar mkBSIdl mkBSIdlJNI mkBSPreproV4
grammar1st = ModuleMandatory 50 parallel OBJPATH hmap hlistornot mkBSGrammar2nd mkBSTIE mkBSWIDL mkBSCodeGen1st
grammar2nd = Module 60 parallel OBJPATH hmap hlistornot mkBSCodeGen2nd
grammar3rd = Module 70 parallel OBJPATH hmap hlistornot mkBSCodeGen3rd
#
pythonbuild = Module 1200 parallel OBJPATH nohmap nohlist mkBSPython
#
# ----------------------
# MOBILE RELATED
# ----------------------
grammarmob = Module 50 parallel OBJPATH nohmap nohlist mkBSGrammarMob
linkresource = Module 1000 parallel OBJPATH nohmap nohlist mkBSLinkResource
#

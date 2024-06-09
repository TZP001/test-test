# -------------------------------------------------
# Error type: data update
# -------------------------------------------------
# --- Imakefile.mk and IdentityCard.h analysis
DataUpdate=data update;Conv
# --- Import/Export of interfaces between frameworks
headerlist=data update;Compil
headermap=data update;Compil
# --- mkmk dependencies graphs for impact analysis
XrefDB=data update;Compil
# -------------------------------------------------
# Error type: code generation
# -------------------------------------------------
# --- grammar
fwgrammar=code generation;Compil
cppgrammar= code generation;Compil
grammar1st=code generation;Compil
grammar2nd=code generation;Compil
grammar3rd=code generation;Compil
delphigrammar=code generation;Compil
corbagrammar=code generation;Compil
v4grammar=code generation;Compil
# --- java grammar
typelibgrammar=code generation;Compil
javagrammar=code generation;Compil
# --- c++ preprocessor
cpponly=code generation;Compil
# -------------------------------------------------
# Error type: compilation
# -------------------------------------------------
# --- Static C++ checker (mkCheckSource)
headercheck=compilation;Conv
sourcecheck=compilation;Conv
# --- Architecture checker (BAD)
headerruler=compilation;Conv
sourceruler=compilation;Conv
# --- Compilation
delphicompilation=compilation;Compil
compilation=compilation;Compil
corbacompilation=compilation;Compil
ocamlcompil=compilation;Compil
# --- Python
pythonbuild=compilation;Compil
# -------------------------------------------------
# Error type: link-edit
# -------------------------------------------------
# --- IdentityCard.h compilation
CIbuild=compilation;Compil
CIcompilation=compilation;Compil
CIpackaging=compilation;Compil
CICpsBuild=compilation;Compil
# --- Static libraries
archive=link-edit;Link
corbaarchive=link-edit;Link
ocamlarchive=link-edit;Link
# --- Type libraries
typelib=link-edit;Link
typelibmext=link-edit;Link
# --- Dynamic libraries
link1st=link-edit;Link
link2nd=link-edit;Link
corbalink1st=link-edit;Link
corbalink2nd=link-edit;Link
ocamllink=link-edit;Link
linkmext=link-edit;Link
v4link=link-edit;Link
# --- Load modules
link=link-edit;Link
# --- Post-link operations
rmsmanifest=link-edit;Link
bscmake=link-edit;Link
caacheck=link-edit;Link
# --- Versionning of executables
corbaglobalresource=link-edit;Link
globalresource=link-edit;Link
versioninfo=link-edit;Link
# --- Resources
buildtimedata=link-edit;Link
runtimedata=link-edit;Link
dummynls=link-edit;Link
tclkit=link-edit;Link
# --- Java
javabuild=link-edit;Link
javamext=link-edit;Link
javajni=link-edit;Link
javapack=link-edit;Link
cabjar=link-edit;Link
# --- .NET assemblies
NETbuild=link-edit;Link
csharpbuild=link-edit;Link
j2csharpbuild=link-edit;Link
jsharpbuild=link-edit;Link
NETmext=link-edit;Link
sharpmext=link-edit;Link
vbbuild=link-edit;Link
# --- V4 PIF
v4pif=link-edit;Link
# -------------------------------------------------
# Error type: online documentation
# -------------------------------------------------
doc=online documentation;Conv
docbase=online documentation;Conv
doccheck=online documentation;Conv
docindex=online documentation;Conv
docmain=online documentation;Conv
docupdate=online documentation;Conv
javadoc=online documentation;Conv
PublishHtm=online documentation;Conv
DoxBase=online documentation;Conv
DoxMain=online documentation;Conv
Dox=online documentation;Conv
Indexation=online documentation;Conv
CheckRTVDoc=online documentation;Conv
IntermediateView=online documentation;Conv
DoxGrammarFw=online documentation;Conv
DoxGrammar1st=online documentation;Conv
DoxGrammar2nd=online documentation;Conv
DoxGrammar3rd=online documentation;Conv
# -------------------------------------------------
# Error type: CSC
# -------------------------------------------------
cscimplement=source check;Conv
cscinterface=source check;Conv
cscimplementjava=source check;Conv
# -------------------------------------------------
# MOBILE
# -------------------------------------------------
grammarmob=link-edit;Link
linkresource=link-edit;Link
#


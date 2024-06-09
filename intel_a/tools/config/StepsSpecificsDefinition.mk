#
#SHE: compilBS = mkBSCompil mkBSVersionInfo mkBSXmlVersionInfo mkBSSourceRuler
#
compilation= Module 500 parallel OBJPATH map nohlist mkBSCompil mkBSVersionInfo mkBSXmlVersionInfo
corbacompilation = Module 210 sequence OBJPATH hmap nohlist mkBSCORBACompil mkBSCORBACompilJavaC mkBSCORBAArchiveJavaC mkBSCORBACompilJavaS mkBSCORBAArchiveJavaS mkBSVersionInfoC mkBSVersionInfoS
#
versioninfo = Module 150 parallel OBJPATH nohmap nohlist mkBSVersionInfo
#
fwgrammar= Framework 40 parallel IDCARD_PATH_OS hmap hlistornot mkBSDynamicCreator mkBSCodeGenFw
#
corbaglobalresource = Module 600 parallel OBJPATH nohmap nohlist mkBSGlobalResourceC mkBSGlobalResourceS
globalresource = Module 900 parallel OBJPATH nohmap nohlist mkBSGlobalResource
#
typelibgrammar = Module 280 parallel OBJPATH hmap hlistornot mkBSImportCompil
#
bscmake = Framework 6000 parallel IDCARD_PATH_OS nohmap nohlist mkBSBscMake
#
rmsmanifest = Module 955 sequence OBJPATH nohmap nohlist mkBSRMS
#
NETmext = Module 1050 parallel OBJPATH nohmap nohlist mkBSExternal
#          
NETbuild	= Module Assembly parallelandordered csharpbuild j2csharpbuild jsharpbuild vbbuild
#
csharpbuild	= Module 1100 parallelandordered OBJPATH nohmap nohlist mkBSDynamicCreatorSharp mkBSXmlAssemblyAndVersionInfoAndPolicy mkBSCSharp mkBSCppManaged
j2csharpbuild = Module 1100 parallelandordered OBJPATH nohmap nohlist mkBSJavaToCSharp mkBSDynamicCreatorSharp mkBSXmlAssemblyAndVersionInfoAndPolicy mkBSCSharp
jsharpbuild	= Module 1100 parallelandordered OBJPATH nohmap nohlist mkBSXmlAssemblyAndVersionInfoAndPolicy mkBSJSharp
vbbuild		= Module 1100 parallelandordered OBJPATH nohmap nohlist mkBSXmlAssemblyAndVersionInfoAndPolicy mkBSVB
#
javamext= Module 200 parallel OBJPATH nohmap nohlist mkBSExternJava mkBSExternalSharp
#
Dox = Module 1800 parallelandordered OBJPATH nohmap nohlist mkBSDocXMParser mkBSDocXMPreproId2url
DoxMain = Module 1810 parallelandordered OBJPATH nohmap nohlist mkBSDocXMParser
DoxBase = Module 1820 parallelandordered OBJPATH nohmap nohlist mkBSDocXMParser
IntermediateView = Module 1900 parallelandordered OBJPATH nohmap nohlist mkBSDocXMIntermediateBuildtime
PublishHtm       = Module 1910 parallelandordered OBJPATH nohmap nohlist mkBSDocXMPublishHtm mkBSDocXMUpdateHtm mkBSDocXMRootMapStructure mkBSDocXMGenerateStructure mkBSDocXMPreproId2url
Indexation = Module 1920 parallelandordered OBJPATH nohmap nohlist mkBSDocXMIndexation
CheckRTVDoc = Module 1930 parallelandordered OBJPATH nohmap nohlist mkBSDocXMCheckRTVDoc
# doc grammar for smaCodeGen
DoxGrammarFw =  Framework 40 parallel IDCARD_PATH_OS hmap hlistornot mkBSCodeGenFw
DoxGrammar1st = ModuleMandatory 50 parallel OBJPATH hmap hlistornot mkBSCodeGen1st
DoxGrammar2nd = Module 60 parallel OBJPATH hmap hlistornot mkBSCodeGen2nd
DoxGrammar3rd = Module 70 parallel OBJPATH hmap hlistornot mkBSCodeGen3rd
#


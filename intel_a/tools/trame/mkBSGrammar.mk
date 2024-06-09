#
# Specifications for Build step mkBSGrammar
#
METACLASS_NAME = Grammar
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
SOURCE_EXTENSION = *.exsrc *.exx *.y *.yc *.byc *.by *.l *.fl *.lh *.lc *.flc *.mll *.mly\
		 *.CPP *.odl *.msgsrc *.mc *.feat *.CATfct *.exsrcv4 *.DSGen *.sypintro *.jdlsrc *.mocsrc
#SHE: apu: *.osm
#
# To Dispatch preprocessed object on prefix
.feat = RTV_FEATCTLG
.CATfct = RTV_FEATCTLG
.dic = RTV_CODEDICTIONARY
.iid = RTV_CODEDICTIONARY
.clsid = RTV_CODEDICTIONARY
.fact = RTV_CODEDICTIONARY
#
.buildlevel = RTV_RESOURCES
#
#SHE: verbotten:  .CATNls = RTV_MSGCTLG
.CATRsc = RTV_MSGCTLG
#

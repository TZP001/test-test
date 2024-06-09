#
# Basic objects for build step mkBSGrammar
#
.c = mkBODerivedGeneric
.cpp = mkBODerivedGeneric
.h = mkBOGeneratedHeader_h
#
# Microsoft typelib
.odl = mkBOSource_odl
.tlb = mkBOGeneratedFromODL_tlb
# Feature Catalogs
#.osm = mkBOSource_osm
.feat = mkBOToCopy
.CATfct = mkBOToCopy
# DSxDevVisualCompiler
.DSGen = mkBOSource_DSGenExp
.DlgCmp = mkBODerivedGeneric
.DlgEnum = mkBODerivedGeneric
.DlgDel = mkBODerivedGeneric
# DSxDevIntrospectionCompiler
.sypintro = mkBOSource_sypintro
.dsmtl = mkBOUsedGeneric
# Express and ExpressX
.cplx = mkBOUsed_express
.express = mkBOUsed_express
.exsrc = mkBOSource_exsrc
.exsrcv4 = mkBOSourceV4_exsrc
.exx = mkBOSource_exx
# Yacc & Bison C
.yc = mkBOSource_yc
.byc = mkBOSource_byc
# Yacc & Bison C++
.y = mkBOSource_y
.by = mkBOSource_by
# Lex & Flex C
.lc = mkBOSource_lc
.flc = mkBOSource_flc
# Lex & Flex C++
.l = mkBOSource_l
.fl = mkBOSource_fl
.lh = mkBOSource_lh
# Lex et Yacc OCaml
.mll = mkBOCamlSource_mll
.mly = mkBOCamlSource_mly
# Error messages from SPATIAL
.msgsrc = mkBOSource_msgsrc
.err = mkBOGeneratedHeader_h
# Microsoft Error Messages
.mc = mkBOSource_msmc
.rc = mkBODerivedGeneric
.bin = mkBODerivedGeneric
.dbg = mkBODerivedGeneric
# JDL compile from MatrixOne
.jdlsrc = mkBOSource_jdlsrc
.jdl = mkBOUsedGeneric
.idl = mkBOUsedGeneric
# MOC
.mocsrc = mkBOSource_mocsrc
#
.CPP = mkBOToPreprocess
<Default> = mkBOPreprocessed
#

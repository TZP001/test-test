#
# Specifications for Build step DocIndex
#
# ---------------------
#
DIX_COMPILER = mkidxM
#
#
DIX_OPTS = -appletpath "$(WSPATH)/Doc/online$(LANG)"\
           -wsroot "$(WSPATH)" -modname $(MODNAME)\
           -srcfile "$(DOC_MODRTViewData)"
#
DIX_COMMAND = $(DIX_COMPILER) $(DIX_OPTS)
#

### DIC_CHINESE_OPT = $(SOURCE_LANG:+"-dic_chinese")

###           -prdidx $(PRODUCT_FOR_INDEX)\
### 	      -solidx $(SOLUTION_FOR_INDEX)\
###           $(SOURCE_LANG:+"-lang") $(SOURCE_LANG)\     desormais base sur le regional setting 
###           $(PRODUCT_FOR_INDEX:+"-prdidx") $(PRODUCT_FOR_INDEX)\
###           $(MODELER_FOR_INDEX:+"-modidx") $(MODELER_FOR_INDEX)\
###           $(SOLUTION_FOR_INDEX:+"-solidx") $(SOLUTION_FOR_INDEX)\
###           -srclist "$(SOURCE_FOR_INDEX)"\
###           -part_title "$(TITLE_FOR_INDEX)"\
###           $(DIC_CHINESE_OPT) $(DIC_CHINESE_OPT:+DIC_CHINESE)

#
DGM_VERSION = 1.0
#


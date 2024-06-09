#
# Specifications for Build step DocIndex
#
# ---------------------
#
IDX_COMPILER = $(JavaROOT_PATH)/bin/java 
#
#
# en attendant de savoir ou sera le jar !
IDX_JAR = $(DITA_OT_DIR)/lib/mkidx.jar
#
IDX_MAP_OPTS = 	-jar "$(IDX_JAR)" \
		--normal \
		--modulename=$(MODNAME) \
		--lang=%LANGIDX% \
		--runpath=. \
		--output=%OUT_MAP_PATH%\%IDX_MAP_FILE% \
		--outputmultimedia=%OUT_MAP_PATH%\%IDX_MULTIMEDIA_FILE% \
		--fileslist=%OUT_MAP_PATH%\%IDX_MAPLIST_FILE% \
		--trace=none \
		--forceutf8=%FORCEUTF8%

IDX_GLOSS_OPTS = -jar "$(IDX_JAR)" \
		--glossary \
		--lang=%LANGIDX% \
		--runpath=$(MODNAME) \
		--output=%OUT_GLOSS_PATH%\%IDX_GLOSS_FILE% \
		--fileslist=%OUT_GLOSS_LIST_PATH%\%IDX_GLOSSLIST_FILE% \
		--trace=none

IDX_TOC_OPTS = 	-jar "$(IDX_JAR)" \
		--techprod \
		--runpath=. \
		--output=%OUT_TOC_PATH%\%IDX_TOC_FILE% \
		--fileslist=%OUT_TOC_PATH%\%IDX_TOCLIST_FILE% \
		--trace=none
#  --lang=%LANGIDX% \




#
IDX_MAP_COMMAND = $(IDX_COMPILER) $(IDX_MAP_OPTS)
IDX_GLOSS_COMMAND = $(IDX_COMPILER) $(IDX_GLOSS_OPTS)
IDX_TOC_COMMAND = $(IDX_COMPILER) $(IDX_TOC_OPTS)
#

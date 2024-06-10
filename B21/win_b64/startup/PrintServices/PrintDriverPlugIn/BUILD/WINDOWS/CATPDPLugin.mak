# Microsoft Developer Studio Generated NMAKE File, Based on CATPDPPLUGIN.dsp

#   MODIFIY THE MODULE DRIVER NAME and SOURCE DRIVER IMPLEMENTATION
MODULE=CATPDPPLUGIN
DRIVERSOURCE=CATPDPluginTraces

!IF "$(CFG)" == ""
CFG=$(MODULE) - Win32 Debug
!MESSAGE No configuration specified. Defaulting to $(MODULE) - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "$(MODULE) - Win32 Release" && "$(CFG)" != "$(MODULE) - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "$(MODULE).mak" CFG="$(MODULE) - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "$(MODULE) - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "$(MODULE) - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

CPP=cl.exe
MTL=midl.exe
RSC=rc.exe
SCR=CATPDPPluginTraces

!IF  "$(CFG)" == "$(MODULE) - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\CATPDPPLUGIN.dll"


CLEAN :
	-@erase "$(INTDIR)\$(DRIVERSOURCE).obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\$(MODULE).dll"
	-@erase "$(OUTDIR)\$(MODULE).exp"
	-@erase "$(OUTDIR)\$(MODULE).lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_WINDOWS_SOURCE" /D "_MBCS" /D "_USRDLL" /D "__CATPDPPLUGIN" /Fp"$(INTDIR)\CATPDPPLUGIN.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\$(MODULE).bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:no /pdb:"$(OUTDIR)\CATPDPPLUGIN.pdb" /machine:I386 /out:"$(OUTDIR)\CATPDPPLUGIN.dll" /implib:"$(OUTDIR)\CATPDPPLUGIN.lib" 
LINK32_OBJS= \
	"$(INTDIR)\*.obj"

"$(OUTDIR)\$(MODULE).dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "CATPDPPLUGIN - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\$(MODULE).dll"


CLEAN :
	-@erase "$(INTDIR)\*.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(OUTDIR)\$(MODULE).dll"
	-@erase "$(OUTDIR)\$(MODULE).exp"
	-@erase "$(OUTDIR)\$(MODULE).ilk"
	-@erase "$(OUTDIR)\$(MODULE).lib"
	-@erase "$(OUTDIR)\$(MODULE).pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_WINDOWS_SOURCE" /D "_MBCS" /D "_USRDLL" /D "__CATPDPPLUGIN"  /D "CATPDPPLUGIN_EXPORTS" /D "__CATPDPPLUGIN" /Fp"$(INTDIR)\CATPDPPLUGIN.pch" /YX /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\$(MODULE).bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\CATPDPPLUGIN.pdb" /debug /machine:I386 /out:"$(OUTDIR)\CATPDPPLUGIN.dll" /implib:"$(OUTDIR)\CATPDPPLUGIN.lib" /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\*.obj"

"$(OUTDIR)\$(MODULE).dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("$(MODULE).dep")
!INCLUDE "$(MODULE).dep"
!ELSE 
!MESSAGE Warning: cannot find "$(MODULE).dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "$(MODULE) - Win32 Release" || "$(CFG)" == "CATPDPPLUGIN - Win32 Debug"
SOURCE=$(DRIVERSOURCE).cpp

#"$(INTDIR)\$(DRIVERSOURCE).obj" : $(SOURCE) "$(INTDIR)"
"$(INTDIR)\*.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 


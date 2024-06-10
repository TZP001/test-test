# Sample makefile for windows 64 for the sample user defined inverse kinematics
# NOTE ABOUT 64 BITS USAGE
#
# need to use a cmd shell and run vcvars to set up 64 bits environment before doing nmake all
#
# Target library name and locations
# Replace the name of the library at your convenience
DEST		= .\lib
LIBRARY		= libdnbusr

#
# set up the MS Visual C++ compiler
#
# Specify the location where the compiler can be found
MS_LOC		= "C:\Program Files (x86)\Microsoft Visual Studio 8\VC"
#
#PATH		= $(MS_LOC)\bin;$(PATH)
#

#
# location of the library file to link with to resolve symbols
#
LIBDENEB_LOC	= ..\..\code\bin
INCS            = -I .\include -I $(MS_LOC)\include -I $(MS_LOC)\mfc\include

#
# define the commands
#
CC		= cl
LD		= link
DELETE		= del
MOVE		= move
SET		= set
MKDIR           = mkdir

#
# define some important file names 
#
LIBRARY_DLL	= $(DEST)\$(LIBRARY).dll
LIBRARY_LIB	= $(DEST)\$(LIBRARY).lib
LIBRARY_EXP	= $(DEST)\$(LIBRARY).exp
LIBRARY_SYM	= $(LIBDENEB_LOC)\DNBVMAPUsrKin.lib

#
# compile and link options and flags
#
CFLAGS		= $(INCS) -DWINDOWS_SOURCE -D_DNBUSERLIB -DNDEBUG -DWIN32 -DWINNT -DWINDOWS_NT -DDOS -nologo -W0 -MD -DUSE_DOUBLE
LDFLAGS		= -NOLOGO \
		-INCREMENTAL:no \
		-SUBSYSTEM:windows \
		-NODEFAULTLIB:libc.lib \
		-DLL msvcrt.lib \
		user32.lib gdi32.lib winspool.lib kernel32.lib \
		comdlg32.lib advapi32.lib shell32.lib \
		ole32.lib \
		oleaut32.lib uuid.lib oldnames.lib \
		opengl32.lib glu32.lib glaux.lib

#
# files to compile
#
OBJS	      	= \
		kin_exmpl.obj

#
# this target will rebuilt the library
#
lib: 	warn $(OBJS) $(LIBRARY_SYM)
	@echo Making $(LIBRARY_LIB) ...
#	@$(SET) LIB=$(MS_LOC)\lib\amd64;$(MS_LOC)\PlatformSDK\lib\amd64;$(MS_LOC)\atlmfc\lib\amd64;$(LIB)
	-@$(DELETE) $(LIBRARY_DLL)
	-@mkdir $(DEST)
	@$(LD) -OUT:$(LIBRARY_DLL) $(LDFLAGS) $(OBJS) $(LIBRARY_SYM)
	@echo $(LIBRARY_DLL) is up-to-date
	-@$(DELETE) $(LIBRARY_LIB) $(LIBRARY_EXP)
	-@$(DELETE) *.obj

#
# echo the assumption about the location of visual C++
# remove this target if you want to suppress this warning
#
warn:
	@echo

#
# this target will remove all of the object files
#
clean:  warn
	@echo removing all object files ...
	-@$(DELETE) *.obj
	@echo Done.

#
# this target will force a recompile of all files and rebuilt the library
#
all:	clean lib 

# default rule for making a .obj from a .c (compiling the C programs)
# is built in
.c.obj:
	$(CC) $(CFLAGS) /c $<

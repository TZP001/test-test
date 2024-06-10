############################################################################################################
EXTERNS.zip is a Microsoft Visual Studio project (.NET, vc7).
This is an implementation sample for extern functions Starting from R17SP4.
Options to generate a dll are set, review them and adapt paths to your working environment.
It goes with the example EXTERNS.catproduct given in Delmia Automation User Documentation:
Logic Design -> Modules and Blocks -> User Tasks -> Using Extern Functions and Constants.

############################################################################################################
You generate the stubs first, and here is a memo to build a Visual Studio project from scratch:

1. NEW PROJECT
File -> New -> Project -> Visual C++ -> Win 32 Project, Ok.
Application Settings:  DLL and Empty Project, Finish.

2. ADDING GENERATED FILES
Source Files directory, click RMB, Add -> Add Existing Item [select generated source files], Open.
Do the same for include files.

3. SETTINGS
Project (in the solution explorer), click RMB, Properties:
	C/C++ -> General -> Additional Include Directories: include of the project
	C/C++ -> Preprocessor -> Preprocessor Definitions: add _WINDOWS_SOURCE and __MyLogicalWorkspaceName
	Linker -> General -> Additional Library Directories: add the project lib
	Linker -> Input -> Additional Dependencies: add AUTLciVMExterns.lib

############################################################################################################



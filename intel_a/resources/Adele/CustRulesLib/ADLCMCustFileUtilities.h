#ifndef ADLCMCustFileUtilities_h
#define ADLCMCustFileUtilities_h

#include <stdio.h>
#include "ADLCMAPIArchi.h"

class ADLCMAPIInterface;

class ADLCMCustFileUtilities
{
public:
	// Opens a file with fopen()
	static HRESULT FileOpen(
		const char *FilePath,
		const char *Mode,
		ADLCMAPIInterface &APIInterface,
		FILE *&pFile);

	// Close a file with fclose()
	static HRESULT FileClose(
		FILE *pFile,
		const char *FilePath, // File path to display if error
		ADLCMAPIInterface &APIInterface);

	// Read a line in a text file with fgets()
	static HRESULT FileGetString(
		char *Buffer,
		int Size,
		Boolean &NothingRead, // = TRUE if nothing to read and end of file reached
		FILE *pFile,
		const char *FilePath, // File path to display if error
		ADLCMAPIInterface &APIInterface);

	// Write a line in a text file with fputs()
	static HRESULT FilePutString(
		const char *Buffer,
		FILE *pFile,
		const char *FilePath, // File path to display if error
		ADLCMAPIInterface &APIInterface);
};

#endif /* ADLCMCustFileUtilities_h */

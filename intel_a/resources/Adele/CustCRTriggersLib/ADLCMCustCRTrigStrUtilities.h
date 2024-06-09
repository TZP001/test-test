#ifndef ADLCMCustCRTrigStrUtilities_h
#define ADLCMCustCRTrigStrUtilities_h

#include "ADLCMAPICRTriggers.h"

#define ADL_ASSERT(condition,message) \
{ \
	if (! (condition)) \
	{ \
		cout << "#ERR# Fatal internal error: " << message << "on file: " << __FILE__ << " at line: " << __LINE__ << endl << "Contact your administrator" << endl; \
		exit(-1); \
	} \
}

class ADLCMCustCRTrigStrUtilities
{
public:
	// Extracts the root name and the extension from a filename.
	static void ExtractExtensionFromFileName(
		const char *FileName,
		char *&RootName,         // To be destroyed by delete []
		char *&Extension,        // Extension without the "."; to be destroyed by delete []
		Boolean &WithExtension); // TRUE if an extension has been found ("fic." -> RootName = "fic", Extension = "" but WithExtension = TRUE)

	// Finds Name in the array considering case. The function returns the element that has been found, or NULL otherwise.
	static const char *LookupOne(const char *Name, const char *NameArray[], int Size);
	// Sample:
	//    const char *NameArray[] = {"First", "Second", "Third"};
	//    int NbNames = sizeof(NameArray) / sizeof(const char *);
	//    const char *Result = NULL;
	//    Result = LookupOne("Toto",   NameArray, NbNames); // -> NULL
	//    Result = LookupOne("first",  NameArray, NbNames); // -> NULL
	//    Result = LookupOne("Second", NameArray, NbNames); // -> "Second"

	// Finds Name in the array ignoring case.
	static const char *LookupOneNoCase(const char *Name, const char *NameArray[], int Size);
	// Sample:
	//    const char *NameArray[] = {"First", "Second", "Third"};
	//    int NbNames = sizeof(NameArray) / sizeof(const char *);
	//    const char *Result = NULL;
	//    Result = LookupOne("Toto",   NameArray, NbNames); // -> NULL
	//    Result = LookupOne("first",  NameArray, NbNames); // -> "First"
	//    Result = LookupOne("Second", NameArray, NbNames); // -> "Second"

	// Concats the string array elements in order to build a message parameter.
	// The result must be destroyed by delete [].
	static char *ConcatStrings(
		const char *NameArray[],
		int Size,
		const char *ElementSeparator = ", ",
		const char *PrefixDelimiter = "\"",
		const char *SuffixDelimiter = "\"");

	// Compares two strings ignoring case.
	static int CompareNoCase(const char *String1, const char *String2);

	// Extracts one field in a string.
	// Assert if the field is not found
	static void ExtractOneField(
		const char *String,      // The input string
		const char *Separator,   // Separator between the fields
		int NumField,            // Field number to extract, the first field is 1
		char *&Field);           // The content of the field. To be destroyed by delete []
};

#endif /* ADLCMCustCRTrigStrUtilities_h */

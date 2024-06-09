#include "ADLCMCustStringUtilities.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef _WINDOWS_SOURCE
#include <direct.h>
#else
#include <strings.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#endif

// Extracts the root name and the extension from a filename.
void ADLCMCustStringUtilities::ExtractExtensionFromFileName(
	const char *FileName,
	char *&RootName,
	char *&Extension,
	Boolean &WithExtension)
{
	const char *pName = FileName;
	int FileNameLength = strlen(FileName);

	const char *pDest = NULL;
	pDest = strrchr(FileName, '.');

	WithExtension = pDest != NULL;

	if (pDest == NULL)
	{
		RootName = new char [FileNameLength + 1];
		strcpy(RootName, FileName);
		Extension = new char [1];
		strcpy(Extension, "");
	}
	else
	{
		int PosExt = pDest - pName;
		if (PosExt > 0)
		{
			RootName = new char [PosExt+1];
			strncpy(RootName, FileName, PosExt); // End of the string
			RootName[PosExt] = '\0';
		}
		else
		{
			RootName = new char [1];
			strcpy(RootName, "");
		}

		Extension = new char [FileNameLength + 1 - PosExt];
		strcpy(Extension, pDest + 1);
	}
}

// Finds Name in the array considering case. The function returns the element that has been found, or NULL otherwise.
const char *ADLCMCustStringUtilities::LookupOne(const char *Name, const char *NameArray[], int Size)
{
	for (int Cnt1 = 0; Cnt1 < Size; Cnt1++)
	{
		if (strcmp(Name, NameArray[Cnt1]) == 0)
			return Name;
	}
	return NULL;
}

// Finds Name in the array ignoring case.
const char *ADLCMCustStringUtilities::LookupOneNoCase(const char *Name, const char *NameArray[], int Size)
{
	for (int Cnt1 = 0; Cnt1 < Size; Cnt1++)
	{
		if (CompareNoCase(Name, NameArray[Cnt1]) == 0)
			return Name;
	}
	return NULL;
}

// Concats the string array elements in order to build a message parameter.
char *ADLCMCustStringUtilities::ConcatStrings(
	const char *NameArray[],
	int Size,
	const char *ElementSeparator,
	const char *PrefixDelimiter,
	const char *SuffixDelimiter)
{
	int SeparatorLength = strlen(ElementSeparator);
	int PrefixLength = 0;
	int SuffixLength = 0;

	Boolean WithPrefixDelimiter = PrefixDelimiter != NULL && PrefixDelimiter[0] != '\0';
	Boolean WithSuffixDelimiter = SuffixDelimiter != NULL && SuffixDelimiter[0] != '\0';

	int AllSepLength = SeparatorLength;
	if (WithPrefixDelimiter)
	{
		PrefixLength = strlen(PrefixDelimiter);
		AllSepLength += PrefixLength;
	}
	if (WithSuffixDelimiter)
	{
		SuffixLength = strlen(SuffixDelimiter);
		AllSepLength += SuffixLength;
	}

	int Length = 0;
	int Cnt1;
	for (Cnt1 = 0; Cnt1 < Size; Cnt1++)
		Length += strlen(NameArray[Cnt1]) + AllSepLength;

	char *ConcatString = new char[Length + 1];
	Boolean AddSeparator = FALSE;

	char *pC1 = ConcatString;

	for (Cnt1 = 0; Cnt1 < Size; Cnt1++)
	{
		if (AddSeparator)
		{
			strncpy(pC1, ElementSeparator, SeparatorLength);
			pC1 += SeparatorLength;
		}
		else
			AddSeparator = TRUE;

		if (WithPrefixDelimiter)
		{
			strncpy(pC1, PrefixDelimiter, PrefixLength);
			pC1 += PrefixLength;
		}

		int ObjLength = strlen(NameArray[Cnt1]);
		strncpy(pC1, NameArray[Cnt1], ObjLength);
		pC1 += ObjLength;

		if (WithSuffixDelimiter)
		{
			strncpy(pC1, SuffixDelimiter, SuffixLength);
			pC1 += SuffixLength;
		}
	}
	*pC1 = '\0'; // End of string

	return ConcatString;
}

// Compares two strings ignoring case.
int ADLCMCustStringUtilities::CompareNoCase(const char *String1, const char *String2)
{
#ifdef _WINDOWS_SOURCE
	return _stricmp(String1, String2);
#else
	return strcasecmp(String1, String2);
#endif /* _WINDOWS_SOURCE */
}

// Extracts one field in a string.
void ADLCMCustStringUtilities::ExtractOneField(
	const char *String,
	const char *Separator,
	int NumField,
	char *&Field)
{
	const char *pC1 = String;
	const char *pC2 = pC1;
	int Cnt1;
	for (Cnt1 = 0; pC2 != NULL && Cnt1 < (NumField - 1); Cnt1++)
	{
		pC2 = strchr(pC1, Separator[0]);
		pC2++;
		pC1 = pC2;
	}
	if (pC2 == NULL || Cnt1 != (NumField -1))
	{
		// ASSERT
		printf("String format is invalid, the %d th field cannot be reached in %s\n", NumField, String);
		exit(-1);
	}
	const char *pC3 = strchr(pC1, Separator[0]);
	if (pC3 == NULL)
		pC3 = strchr(pC1, '\0');
	int Length = pC3 - pC2;
	Field = new char [Length + 1];
	strncpy(Field, pC1, Length);
	Field[Length] = '\0';
}

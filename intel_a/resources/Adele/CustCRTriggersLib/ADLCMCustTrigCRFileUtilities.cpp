#include "ADLCMCustTrigCRFileUtilities.h"

#include <errno.h>
#include <string.h>
#include <iostream.h>
#include "ADLCMAPICRTriggersInterface.h"
#include "ADLCMAPIMsgBldrCtlg.h"

// Opens a file with fopen()
HRESULT ADLCMCustTrigCRFileUtilities::FileOpen(
	const char *FilePath,
	const char *Mode,
	ADLCMAPICRTriggersInterface &APIInterface,
	FILE *&pFile)
{
	HRESULT hr = S_OK;

	pFile = fopen(FilePath, Mode);
	if (pFile == NULL)
	{
		ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = APIInterface.MakeMsgBldrCtlg("ADLBC", "0201"); // "Error while opening \"/p1\": /p2"
		pDiagnosticBldr->AddNewParameter(FilePath);
		pDiagnosticBldr->AddNewParameter(strerror(errno));

		hr = APIInterface.SetLastError(__FILE__, __LINE__, NULL, pDiagnosticBldr, NULL);
		delete pDiagnosticBldr;
	}
	return hr;
}

// Close a file with fclose()
HRESULT ADLCMCustTrigCRFileUtilities::FileClose(
	FILE *pFile,
	const char *FilePath,
	ADLCMAPICRTriggersInterface &APIInterface)
{
	HRESULT hr = S_OK;

	int RC = fclose(pFile);
	if (RC != 0)
	{
		ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = APIInterface.MakeMsgBldrCtlg("ADLBC", "0202"); // "Error while closing \"/p1\": /p2"
		pDiagnosticBldr->AddNewParameter(FilePath);
		pDiagnosticBldr->AddNewParameter(strerror(errno));

		hr = APIInterface.SetLastError(__FILE__, __LINE__, NULL, pDiagnosticBldr, NULL);
		delete pDiagnosticBldr;
	}
	return hr;
}

// Read a line in a text file with fgets()
HRESULT ADLCMCustTrigCRFileUtilities::FileGetString(
	char *Buffer,
	int Size,
	Boolean &NothingRead,
	FILE *pFile,
	const char *FilePath,
	ADLCMAPICRTriggersInterface &APIInterface)
{
	HRESULT hr = S_OK;

	char *pC1 = fgets(Buffer, Size, pFile);
	NothingRead = pC1 == NULL;
	if (NothingRead)
	{
		Buffer[0] = '\0'; // Empty string
		if (ferror(pFile))
		{
			ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = APIInterface.MakeMsgBldrCtlg("ADLBC", "0205"); // // "Error while reading a string from \"/p1\": /p2"
			pDiagnosticBldr->AddNewParameter(FilePath);
			pDiagnosticBldr->AddNewParameter(strerror(errno));

			hr = APIInterface.SetLastError(__FILE__, __LINE__, NULL, pDiagnosticBldr, NULL);
			delete pDiagnosticBldr;
		}
	}
	return hr;
}

// Write a line in a text file with fputs()
HRESULT ADLCMCustTrigCRFileUtilities::FilePutString(
	const char *Buffer,
	FILE *pFile,
	const char *FilePath,
	ADLCMAPICRTriggersInterface &APIInterface)
{
	HRESULT hr = S_OK;

	int RC = fputs(Buffer, pFile);
	if (RC < 0)
	{
		ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = APIInterface.MakeMsgBldrCtlg("ADLBC", "0203"); // "Error while writing a string to \"/p1\": /p2"
		pDiagnosticBldr->AddNewParameter(FilePath);
		pDiagnosticBldr->AddNewParameter(strerror(errno));

		hr = APIInterface.SetLastError(__FILE__, __LINE__, NULL, pDiagnosticBldr, NULL);
		delete pDiagnosticBldr;
	}
	return hr;
}

#include "ADLCMCustFileUtilities.h"

#include <errno.h>
#include <string.h>
#include "ADLCMAPIInterface.h"
#include "ADLCMAPIMsgBldrCtlg.h"

// Opens a file with fopen()
HRESULT ADLCMCustFileUtilities::FileOpen(
	const char *FilePath,
	const char *Mode,
	ADLCMAPIInterface &APIInterface,
	FILE *&pFile)
{
	HRESULT hr = S_OK;

	pFile = fopen(FilePath, Mode);
	if (pFile == NULL)
	{
		ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = APIInterface.MakeMsgBldrCtlg("ADLBC", "0201"); // "Error while opening \"/p1\": /p2"
		if (pDiagnosticBldr != NULL)
		{
			pDiagnosticBldr->AddNewParameter(FilePath);
			pDiagnosticBldr->AddNewParameter(strerror(errno));

			hr = APIInterface.SetLastError(__FILE__, __LINE__, NULL, pDiagnosticBldr, NULL);
			delete pDiagnosticBldr;
		}
		else
			hr = E_FAIL;
	}
	return hr;
}

// Close a file with fclose()
HRESULT ADLCMCustFileUtilities::FileClose(
	FILE *pFile,
	const char *FilePath,
	ADLCMAPIInterface &APIInterface)
{
	HRESULT hr = S_OK;

	int RC = fclose(pFile);
	if (RC != 0)
	{
		ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = APIInterface.MakeMsgBldrCtlg("ADLBC", "0202"); // "Error while closing \"/p1\": /p2"
		if (pDiagnosticBldr != NULL)
		{
			pDiagnosticBldr->AddNewParameter(FilePath);
			pDiagnosticBldr->AddNewParameter(strerror(errno));

			hr = APIInterface.SetLastError(__FILE__, __LINE__, NULL, pDiagnosticBldr, NULL);
			delete pDiagnosticBldr;
		}
		else
			hr = E_FAIL;
	}
	return hr;
}

// Read a line in a text file with fgets()
HRESULT ADLCMCustFileUtilities::FileGetString(
	char *Buffer,
	int Size,
	Boolean &NothingRead,
	FILE *pFile,
	const char *FilePath,
	ADLCMAPIInterface &APIInterface)
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
			if (pDiagnosticBldr != NULL)
			{
				pDiagnosticBldr->AddNewParameter(FilePath);
				pDiagnosticBldr->AddNewParameter(strerror(errno));

				hr = APIInterface.SetLastError(__FILE__, __LINE__, NULL, pDiagnosticBldr, NULL);
				delete pDiagnosticBldr;
			}
			else
				hr = E_FAIL;
		}
	}
	return hr;
}

// Write a line in a text file with fputs()
HRESULT ADLCMCustFileUtilities::FilePutString(
	const char *Buffer,
	FILE *pFile,
	const char *FilePath,
	ADLCMAPIInterface &APIInterface)
{
	HRESULT hr = S_OK;

	int RC = fputs(Buffer, pFile);
	if (RC < 0)
	{
		ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = APIInterface.MakeMsgBldrCtlg("ADLBC", "0203"); // "Error while writing a string to \"/p1\": /p2"
		if (pDiagnosticBldr != NULL)
		{
			pDiagnosticBldr->AddNewParameter(FilePath);
			pDiagnosticBldr->AddNewParameter(strerror(errno));

			hr = APIInterface.SetLastError(__FILE__, __LINE__, NULL, pDiagnosticBldr, NULL);
			delete pDiagnosticBldr;
		}
		else
			hr = E_FAIL;
	}
	return hr;
}

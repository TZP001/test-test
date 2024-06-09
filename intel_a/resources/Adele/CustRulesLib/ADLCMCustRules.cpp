#include "ADLCMCustRules.h"
#include "ADLCMAPIInterface.h"

// API classes delivered by the SCM command.
#include "ADLCMAPIMsgBldrCtlg.h"
#include "ADLCMAPIParsedProjPath.h"
#include "ADLCMAPIProjElem.h"

#include "ADLCMCustStringUtilities.h"
#include "ADLCMCustFileUtilities.h"
#include <string.h>

// *** Version check

const char *ADLCMGetAPIVersion()
{
	return ADL_API_VERSION;
}

// *** API initialization

static ADLCMAPIInterface *pAPIInterface = NULL;

HRESULT ADLCMInitAPI(ADLCMAPIInterface &APIInterface)
{
	// * Referencing the interface instance with a global pointer
	pAPIInterface = &APIInterface;

	// * Override the check functions with the local ones
	pAPIInterface->SetCheckArchiRulesPtr(&ADLCMCheckArchiRules);
	pAPIInterface->SetCheckIfUnixPathIsSharedPtr(&ADLCMCheckIfUnixPathIsShared);
	pAPIInterface->SetCheckSoftObjPtr(&ADLCMCheckSoftObj);
	pAPIInterface->SetCheckPromotionRequestPtr(&ADLCMCheckPromotionRequest);

	return S_OK;
}

// *** API interface

ADLCMAPIInterface &GetAPIInterface()
{
	return *pAPIInterface;
}

// *** Architecture rules check

HRESULT ADLCMCheckArchiRules(
	const ADLCMAPIParsedProjPath &APIParsedProjPath,
	int ProjElemIdx,
	const char *User,
	Boolean &UnicityWithExtension,
	Boolean &UnicityInFolder)
{
	HRESULT hr = S_OK;

	const ADLCMAPIProjElem &ProjElem = APIParsedProjPath.GetProjElem(ProjElemIdx);
	ADLCMAPIProjElem::ADLCMAPIProjElemType Type = ProjElem.GetProjElemType();

	if (ProjElem.ProjElemToCreate() || ProjElemIdx == APIParsedProjPath.GetNbProjElem() - 1)
	{
		// The SCM object is not yet declared, or it's the last path piece.

		if (Type == ADLCMAPIProjElem::ArchiFramework)
			// Framework -> default check
			hr = GetAPIInterface().DfltCheckArchiRules(
					APIParsedProjPath,
					ProjElemIdx,
					User,
					UnicityWithExtension,
					UnicityInFolder);

		else if (Type == ADLCMAPIProjElem::ArchiModule)
		{
			// Module -> the extension must be authorized.
			char *RootName = NULL;
			char *Extension = NULL;
			Boolean WithExtension;

			const char *ModName = ProjElem.GetProjName();
			ADLCMCustStringUtilities::ExtractExtensionFromFileName(ModName, RootName, Extension, WithExtension);
			int ModNameLength = strlen(ModName);
			int RootNameLength = strlen(RootName);

			#define ADL_MOD_ROOTNAME_LENGTH_MINI    1
			#define ADL_MOD_NAME_LENGTH_MAXI      128

			// Authorized extensions
			static const char *ModuleExtensionSet[] = {"toto", "titi", "tutu"};
			static int NbModuleExtensions = sizeof(ModuleExtensionSet) / sizeof(const char *);

			if (ADLCMCustStringUtilities::LookupOne(Extension, ModuleExtensionSet, NbModuleExtensions) == NULL)
			{
				ADLCMAPIMsgBldrCtlg *pRequestBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0001"); // "Verifying the name '/p1'";
				pRequestBldr->AddNewParameter(ModName);

				ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0002"); // "The name '/p1' has an unknown extension '/p2'";
				pDiagnosticBldr->AddNewParameter(ModName);
				pDiagnosticBldr->AddNewParameter(Extension);

				ADLCMAPIMsgBldrCtlg *pAdviceBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0003"); // "Module's name rules:..."
				pAdviceBldr->AddNewParameter(ADL_MOD_ROOTNAME_LENGTH_MINI);
				pAdviceBldr->AddNewParameter(ADL_MOD_NAME_LENGTH_MAXI);
				char *ModuleExtensionList = ADLCMCustStringUtilities::ConcatStrings(ModuleExtensionSet, NbModuleExtensions);
				pAdviceBldr->AddNewParameter(ModuleExtensionList);

				hr = GetAPIInterface().SetLastError(__FILE__, __LINE__, pRequestBldr, pDiagnosticBldr, pAdviceBldr);

				delete ModuleExtensionList;
				delete pRequestBldr;
				delete pDiagnosticBldr;
				delete pAdviceBldr;
			}

			delete [] RootName;
			delete [] Extension;
		}
	}

	// * Unicity check
	if (hr == S_OK)
	{
		if (Type == ADLCMAPIProjElem::ArchiFileElement)
		{
			// File element
			UnicityWithExtension = TRUE; // The unicity takes the extension into account
			UnicityInFolder =  FALSE;    // ... but not the containing folder
			// Example
			// -------
			// In the workspace Ws1, an user has created the file "Toto.txt".
			//
			//  !
			//  +- Fw1
			//  !   +- dir1
			//  !       +- Toto.txt    <- already declared as a SCM object
			//  +- Fw2
			//
			// In the workspace Ws2, the user wants to create another file named "TOTO.txt".
			//
			//  !
			//  +- Fw2
			//      +- TOTO.txt        <- not yet declared
			//
			// The creation fails because of the file "Fw1/Dir1/Toto.txt" found in Ws1.
		}
		else if (Type != ADLCMAPIProjElem::ArchiFramework)
		{
			UnicityWithExtension = TRUE; // The unicity takes the extension into account
			UnicityInFolder = TRUE;      // ... and the containing folder.
		}
		// Framework -> default rules (already done)
	}

	return hr;
}


// *** Check if the Unix path is shared or not (automount...)

HRESULT ADLCMCheckIfUnixPathIsShared(const char *Path, const char *LocalPathOptionName)
{
	HRESULT hr = S_OK;

	Boolean UnixSharedPathFound = FALSE;

	const char *Prefix = "/automounted/products/";
	int Length = strlen(Prefix);
	UnixSharedPathFound = strlen(Path) > Length && strncmp(Path, Prefix, Length) == 0;
	if (! UnixSharedPathFound)
	{
		Prefix = "/automounted/users/";
		Length = strlen(Prefix);
		UnixSharedPathFound = strlen(Path) > Length && strncmp(Path, Prefix, Length) == 0;
	}

	// The authorized path beginnings are "/automounted/products/" and "/automounted/users/".
	// If a user needs to declare another image directory, he has to use the option whose name is LocalPathOptionName.

	if (! UnixSharedPathFound)
	{
		ADLCMAPIMsgBldrCtlg *pRequestBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0010"); // "Check the Unix network path \"/p1\""
		pRequestBldr->AddNewParameter(Path);

		ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0011"); // "The Unix network path \"/p1\" is invalid."
		pDiagnosticBldr->AddNewParameter(Path);

		ADLCMAPIMsgBldrCtlg *pAdviceBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0012"); // "Use /p1 option or choose between the following paths: /p2"
		pAdviceBldr->AddNewParameter(LocalPathOptionName);
		pAdviceBldr->AddNewParameter("/automounted/products/, /automounted/users/");

		hr = GetAPIInterface().SetLastError(__FILE__, __LINE__, pRequestBldr, pDiagnosticBldr, pAdviceBldr);

		delete pRequestBldr;
		delete pDiagnosticBldr;
		delete pAdviceBldr;
	}

	return hr;
}


// *** Check the software object

HRESULT ADLCMCheckSoftObj(
	const ADLCMAPIParsedProjPath &APIParsedProjPath,
	const ADLCMAPIParsedProjPath *pTargetAPIParsedProjPath,
	const char *CommandName,
	const char *User,
	const char *CurrentWsTree,
	const char *CurrentWs,
	const char *CurrentImage)
{
	HRESULT hr = S_OK;
	
	// The modification of IdentityCard.h file of a framework other than *.tst for software level other than V5R11 is forbidden

	const ADLCMAPIProjElem &ProjElem = APIParsedProjPath.GetProjElem(APIParsedProjPath.GetNbProjElem() - 1);
	ADLCMAPIProjElem::ADLCMAPIProjElemType Type = ProjElem.GetProjElemType();

	if (strcmp(CommandName, "adl_co") == 0 || strcmp(CommandName, "adl_mv") == 0)
	{
		if (Type == ADLCMAPIProjElem::ArchiFileElement && strcmp(ProjElem.GetProjName(), "IdentityCard.h") == 0)
		{
			// Is it in a framework other than *.tst?
			const ADLCMAPIProjElem &FwProjElem = APIParsedProjPath.GetProjElem(0);
			const char *FwName = FwProjElem.GetProjName();
			size_t FwNameLength = strlen(FwName);
			if (FwNameLength < 4 || strcmp(FwName + FwNameLength - 4, ".tst") != 0)
			{
				// The software level (9th field of WS_TREE) is V5R11?
				char *SoftwareLevel = NULL;
				ADLCMCustStringUtilities::ExtractOneField(CurrentWsTree, "|", 9, SoftwareLevel);
				if (strcmp(SoftwareLevel, "V5R11") != 0)
				{
					wchar_t *Path = NULL;
					APIParsedProjPath.MakeRelativePath(Path); // -> "Fw1/IdentityCard/IdentityCard.h"

					ADLCMAPIMsgBldrCtlg *pRequestBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0020"); // "Verifying the element \"/p1\"."
					pRequestBldr->AddNewParameter(Path);

					ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0021"); // "The element \"/p1\" cannot be modified in /p2 level."
					pDiagnosticBldr->AddNewParameter(Path);
					pDiagnosticBldr->AddNewParameter(SoftwareLevel);

					ADLCMAPIMsgBldrCtlg *pAdviceBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0022"); // "See the CAA rules or call your CAA administrator"

					hr = GetAPIInterface().SetLastError(__FILE__, __LINE__, pRequestBldr, pDiagnosticBldr, pAdviceBldr);

					delete pRequestBldr;
					delete pDiagnosticBldr;
					delete pAdviceBldr;
					delete [] Path;
				}
				delete SoftwareLevel;
			}
		}
	}
	return hr;
}

// *** Check the promotion request

HRESULT ADLCMCheckPromotionRequest(
	const char *SoftObjChangesFilePath,
	const char *User,
	const char *CurrentWsTree,
	const char *CurrentWs,
	const char *PromotedWsRev,
	const char *TargetWs,
	const char *CurrentImage,
	Boolean Simulation,
	Boolean OutCAA)
{
	HRESULT hr = S_OK;
	
	// The check is done only if the CHECK_CAA_RULES attribute is set on the current workspace tree
	// and the software level (9th field of WS_TREE) is other than V5R11
	// The promotion of a modification in PublicInterfaces is forbidden
	char *CheckCAARules = NULL;
	char *SoftwareLevel = NULL;
	ADLCMCustStringUtilities::ExtractOneField(CurrentWsTree, "|", 7, CheckCAARules);
	ADLCMCustStringUtilities::ExtractOneField(CurrentWsTree, "|", 9, SoftwareLevel);
	if (strcmp(CheckCAARules, "CHECK_CAA_RULES") == 0 && strcmp(SoftwareLevel, "V5R11") != 0)
	{
		// Opening the input file
		Boolean InputFileIsOpen = FALSE;
		FILE *pInputFile = NULL;
		if (hr == S_OK)
		{
			hr = ADLCMCustFileUtilities::FileOpen(SoftObjChangesFilePath, "r", GetAPIInterface(), pInputFile);
			InputFileIsOpen = hr == S_OK;
		}

		// Search if at least one modification on PublicInterfaces directory is promoted
		// (modification of a file in PublicInterfaces, move of the PublicInterfaces directory, ...)
		if (hr == S_OK)
		{
			const int Size = 2048;
			char Line[Size];
			Boolean NothingRead = FALSE;
			char *SoftObjPath = NULL;
			Boolean PublicInterfacesIsModified = FALSE;
			while (hr == S_OK && ! PublicInterfacesIsModified)
			{
				hr = ADLCMCustFileUtilities::FileGetString(Line, Size, NothingRead, pInputFile, SoftObjChangesFilePath, GetAPIInterface());
				if (hr != S_OK || NothingRead)
					break; // <<<<<<<<<<<
				char *LineType = NULL;
				ADLCMCustStringUtilities::ExtractOneField(Line, "|", 1, LineType);
				if (strcmp(LineType, "_SOFT_OBJ") == 0)
				{
					// The path is the third field
					delete SoftObjPath;
					SoftObjPath = NULL;
					ADLCMCustStringUtilities::ExtractOneField(Line, "|", 2, SoftObjPath);
					const char *pC1 = SoftObjPath;
					const char *pC2 = strchr(pC1, '/');
					if (pC2 != NULL)
					{
						char *SecondElemPath = NULL;
						ADLCMCustStringUtilities::ExtractOneField(SoftObjPath, "/", 2, SecondElemPath);
						if (strcmp(SecondElemPath, "PublicInterfaces") == 0)
							PublicInterfacesIsModified = TRUE;
						delete SecondElemPath;
					}
				}
				delete LineType;
			}
			if (PublicInterfacesIsModified)
			{
				ADLCMAPIMsgBldrCtlg *pRequestBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0025"); // "Checking that the files to promote are in compliance with CAA rules"

				ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0026"); // "The \"/p1\" object cannot be modified in /p2 level."
				pDiagnosticBldr->AddNewParameter(SoftObjPath);
				pDiagnosticBldr->AddNewParameter(SoftwareLevel);

				ADLCMAPIMsgBldrCtlg *pAdviceBldr = GetAPIInterface().MakeMsgBldrCtlg("ADLCMCUSTRULES", "0022"); // "See the CAA rules or call your CAA administrator"

				hr = GetAPIInterface().SetLastError(__FILE__, __LINE__, pRequestBldr, pDiagnosticBldr, pAdviceBldr);

				delete pRequestBldr;
				delete pDiagnosticBldr;
				delete pAdviceBldr;
			}
			delete SoftObjPath;
		}

		if (InputFileIsOpen)
		{
			if (hr == S_OK)
				hr = ADLCMCustFileUtilities::FileClose(pInputFile, SoftObjChangesFilePath, GetAPIInterface());
			else
				fclose(pInputFile);
		}
	}
	delete CheckCAARules;
	delete SoftwareLevel;
	
	return hr;
}

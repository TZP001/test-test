#ifndef _ADLCMAPIInterface_H
#define _ADLCMAPIInterface_H

// ******************** ADLCMAPIInterface
/* Interface between the SCM command and the library.
 * An instance is passed to the library initialization function ADLCMInitAPI().
 */

#include "ADLCMAPIArchi.h"

enum ADLCMAPIErrorType
{
	ADLCMAPIErrorTypeCritical = 1,
	ADLCMAPIErrorTypeFatal = 2,
	ADLCMAPIErrorTypeWarning = 3,
	ADLCMAPIErrorTypeInformation = 4
};

class ADLCMAPIMsgBldr;
class ADLCMAPIMsgBldrCtlg;

class ADLCMAPIInterface
{
public:
	// *** Checks

	// * Default architecture rules check
	virtual HRESULT __stdcall DfltCheckArchiRules(ADLCMCheckArchiRulesArgs) const = 0;

	// * Default shared Unix path check (automount...)
	virtual HRESULT __stdcall DfltCheckIfUnixPathIsShared(ADLCMCheckIfUnixPathIsSharedArgs) const = 0;

	// * Override the check function the command will use instead of the default one(s).
	virtual void __stdcall SetCheckArchiRulesPtr(HRESULT (*pCheckArchiRules)(ADLCMCheckArchiRulesArgs)) = 0;
	virtual void __stdcall SetCheckIfUnixPathIsSharedPtr(HRESULT (*pCheckIfUnixPathIsShared)(ADLCMCheckIfUnixPathIsSharedArgs)) = 0;
	virtual void __stdcall SetCheckSoftObjPtr(HRESULT (*pCheckSoftObj)(ADLCMCheckSoftObjArgs)) = 0;
	virtual void __stdcall SetCheckPromotionRequestPtr(HRESULT (*pCheckPromotionRequest)(ADLCMCheckPromotionRequestArgs)) = 0;
	virtual void __stdcall SetCheckFlowPtr(HRESULT (*pCheckFlow)(ADLCMCheckFlowArgs)) = 0;

	// Sample:
	//    static ADLCMAPIInterface *pAPIInterface = NULL;
	//
	//    HRESULT MyCheckArchiRules(ADLCMCheckArchiRulesArgs)
	//    {
	//       HRESULT hr = S_OK;
	//       ...
	//       if (...)
	//          ...
	//       else
	//          hr = pAPIInterface->DfltCheckArchiRules(...); // Call the default check function
	//       return hr;
	//    }
	//
	//    HRESULT ADLCMInitAPI(ADLCMAPIInterface &APIInterface)
	//    {
	//       HRESULT hr = S_OK;
	//       pAPIInterface = &APIInterface; // Initialize the global static pointer
	//       pAPIInterface->SetCheckArchiRulesPtr(&MyCheckArchiRules); // -> It's now MyCheckArchiRules() which wille be called by the SCM command.
	//       ...
	//       return hr;
	//    }

	// *** Utilities

	// * Creates a NLS message builder using a catalog, a message code and optional parameters.
	virtual ADLCMAPIMsgBldrCtlg * __stdcall MakeMsgBldrCtlg(const char *Catalog, const char *Code) const = 0;
	// The message builder must be destroyed.
	// Sample:
	//    ADLCMAPIMsgBldrCtlg *pMsgBldr = pAPIInterface->MakeMsgBldrCtlg("ADLCMARCHI", "0001"); // "Verifying the objet's name."
	//    ...
	//    pMsgBldr->Release();
	//
	// The library path is supposed to respect the CNext rules:
	//     xxx/code/bin/<MyLibrary>
	// and the message catalog(s) is (are) loaded into
	//     xxx/resources/msgcatalog
	// or into a subdirectory if English is not the current language.
	//
	//     xxx
	//      +- code
	//      !   +- bin
	//      !       +- <MyLibrary>
	//      !
	//      +- resources
	//           !
	//           +- msgcatalog
	//               +- <MyCatalog>.CATNls       <- English
	//               !
	//               +- French
	//               !   +- <MyCatalog>.CATNls
	//               !
	//               +- Italian
	//               !   +- <MyCatalog>.CATNls
	//               !
	//               +- Japanese
	//                   +- <MyCatalog>.CATNls
	//
	// If the subdirectory doesn't exist or if the message catalog doesn't exist in it, the english catalog is loaded.
	//
	// The default catalog extension is ".CATNls".
	// Catalog message format:
	//    <code> = "<Text with parameters /p1, /p2...>";
	// The text is coded with the UTF8 code page, which includes the ISO 8859-1 code page.
	//
	// Sample:
	//    FIRST_MSG = "This is the message text, with the first parameter \"/p1\" and the second one /p2.";
	//    SECOND_MSG = "This is another message text.";

	// * Setting an error with NLS messages and HRESULT return code
	virtual HRESULT __stdcall SetLastError(
		const char *SourcePath, int SourceLine, // Name of the source and line the error occured
		ADLCMAPIMsgBldr *pRequestBldr,    // What's running
		ADLCMAPIMsgBldr *pDiagnosticBldr, // What's the problem
		ADLCMAPIMsgBldr *pAdviceBldr,     // What to do in order to correct the problem
		ADLCMAPIErrorType ErrorType = ADLCMAPIErrorTypeCritical, // Error level
		HRESULT hr = E_FAIL) = 0; // Return code
	// Sample:
	//   ADLCMAPIMsgBldrCtlg *pRequestBldr = pAPIInterface->MakeMsgBldrCtlg(...);
	//   pRequestBldr->AddNewParameter(...);
	//
	//   ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = pAPIInterface->MakeMsgBldrCtlg(...);
	//
	//   ADLCMAPIMsgBldrCtlg *pAdviceBldr = pAPIInterface->MakeMsgBldrCtlg(...);
	//
	//   hr = (*ADLAPISetLastError)(__FILE__, __LINE__, pRequestBldr, pDiagnosticBldr, pAdviceBldr);
	//
	//   pRequestBldr->Release();
	//   pDiagnosticBldr->Release();
	//   pAdviceBldr->Release();
};

#endif // _ADLCMAPIInterface_H

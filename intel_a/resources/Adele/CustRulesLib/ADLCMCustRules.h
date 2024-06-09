#ifndef ADLCMCustRules_H
#define ADLCMCustRules_H

#include "ADLCMAPIArchi.h"

#ifndef ExportedByADLCMCustRules
#ifdef _WINDOWS_SOURCE
#ifdef __ADLCMCustRules
#define ExportedByADLCMCustRules	__declspec(dllexport)
#else
#define ExportedByADLCMCustRules	__declspec(dllimport)
#endif
#else
#define ExportedByADLCMCustRules
#endif /* _WINDOWS_SOURCE */
#endif /* ExportedByADLCMCustRules */

class ADLCMAPIInterface;

extern "C" ExportedByADLCMCustRules const char *ADLCMGetAPIVersion();

extern "C" ExportedByADLCMCustRules HRESULT ADLCMInitAPI(ADLCMAPIInterface &APIInterface);

// *** Proposed functions

HRESULT ADLCMCheckArchiRules(ADLCMCheckArchiRulesArgs);

HRESULT ADLCMCheckIfUnixPathIsShared(ADLCMCheckIfUnixPathIsSharedArgs);

HRESULT ADLCMCheckSoftObj(ADLCMCheckSoftObjArgs);

HRESULT ADLCMCheckPromotionRequest(ADLCMCheckPromotionRequestArgs);

#endif // ADLCMCustRules_H

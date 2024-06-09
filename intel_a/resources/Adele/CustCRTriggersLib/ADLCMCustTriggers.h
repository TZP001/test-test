#ifndef ADLCMCustCRTriggers_H
#define ADLCMCustCRTriggers_H

#include "ADLCMAPICRTriggers.h"

#ifndef ExportedByADLCMCustCRTriggers
#ifdef _WINDOWS_SOURCE
#ifdef __ADLCMCustCRTriggers
#define ExportedByADLCMCustCRTriggers	__declspec(dllexport)
#else
#define ExportedByADLCMCustCRTriggers	__declspec(dllimport)
#endif
#else
#define ExportedByADLCMCustCRTriggers
#endif /* _WINDOWS_SOURCE */
#endif /* ExportedByADLCMCustCRTriggers */

class ADLCMAPICRTriggersInterface;

extern "C" ExportedByADLCMCustCRTriggers const char *ADLCMGetAPITrigVersion();

extern "C" ExportedByADLCMCustCRTriggers HRESULT ADLCMInitTrigAPI(ADLCMAPICRTriggersInterface &APITrigInterface);


#endif // ADLCMCustCRTriggers_H

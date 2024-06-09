#ifndef ADLCMAPIMsgBldrCtlg_h
#define ADLCMAPIMsgBldrCtlg_h

// ******************** ADLCMAPIMsgBldrCtlg
/* NLS message builder using a catalog, a message code and optional parameters.
 * The ADLCMAPIInterface offers a factory of such builders.
 */

#include "ADLCMAPIMsgBldr.h"

#define SUPER_ADLCMAPIMsgBldrCtlg  ADLCMAPIMsgBldr
class ADLCMAPIMsgBldrCtlg : public ADLCMAPIMsgBldr
{
public:
	virtual const char * __stdcall GetMsgCatalog() const = 0;
	virtual const char * __stdcall GetMsgId() const = 0;
	virtual void __stdcall AddNewParameter(const char *Arg) = 0;
	virtual void __stdcall AddNewParameter(int Arg) = 0;
	virtual void __stdcall AddNewParameter(const wchar_t *Arg) = 0;
	virtual void __stdcall MakeMsg(wchar_t *&String) = 0; // The returned string must be destroyed by delete []
};

#endif

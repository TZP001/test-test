#ifndef _ADLCMAPIMsgBldr_H
#define _ADLCMAPIMsgBldr_H

// ******************** ADLCMAPIMsgBldr
/* Basic NLS message builder.
 */

#include <stdlib.h>
#include "ADLCMAPIArchi.h"

class ADLCMAPIMsgBldr
{
public:
	inline virtual ~ADLCMAPIMsgBldr()
	{
	}
	virtual const char * __stdcall GetMsgCatalog() const = 0;
	virtual const char * __stdcall GetMsgId() const = 0;
	virtual void __stdcall MakeMsg(wchar_t *&String) = 0; // The returned string must be destroyed by delete []
};

#endif // _ADLCMAPIMsgBldr_H

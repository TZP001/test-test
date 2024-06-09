#ifndef _ADLCMAPIArchi_H
#define _ADLCMAPIArchi_H

/* - The library must export a function which returns the version it has been built with.
 *   If the returned version doesn't match the expected value, an error message is displayed so that
 *   the library must be recompiled.
 *
 * const char *ADLCMGetAPIVersion()
 * {
 *    return ADL_API_VERSION;
 * }
 *
 * - The library must also export a function in order to be initialized once.
 *   The ADLCMAPIInterface instance may be referenced with a static pointer in order to be used later.
 *
 * static ADLCMAPIInterface *pAPIInterface = NULL;
 *
 * HRESULT ADLCMInitAPI(ADLCMAPIInterface &APIInterface)
 * {
 *    HRESULT hr = S_OK;
 *    pAPIInterface = &APIInterface; // For further use
 *    ...
 *    return hr;
 * }
 *
 * - The library may provides check functions in order to override the default ones:
 *
 * HRESULT CheckArchiRules(ADLCMCheckArchiRulesArgs)
 *
 *   and/or
 *
 * HRESULT CheckIfUnixPathIsShared(ADLCMCheckIfUnixPathIsSharedArgs)
 *
 *   The arguments are explained below.
 *   Each may call the default function through the ADLCMAPIInterface instance.
 */

#if ! defined(IUnknown_H) && ! defined(_HRESULT_DEFINED)
#ifdef PLATEFORME_DS64
  typedef int HRESULT;
#else
  typedef long HRESULT;
#endif
#define _HRESULT_DEFINED
#endif // ! defined(IUnknown_H) && ! defined(_HRESULT_DEFINED)

#ifndef _WINDOWS_SOURCE
#define __stdcall
#endif

#ifndef _WINERROR_	
#define _WINERROR_
#define E_FAIL		((HRESULT)0x80004005L)
#define S_OK		((HRESULT)0x00000000L)
#define S_FALSE     ((HRESULT)0x00000001L)
#endif

#ifndef FALSE
#define	FALSE	0
#endif
#ifndef TRUE
#define	TRUE	1
#endif

#ifndef Boolean
typedef unsigned Boolean;
#endif

// * Version check
#define ADL_API_VERSION "2007_11_05"
class ADLCMAPIMsgBldrCtlg;
class ADLCMAPIParsedProjPath;

#define ADLCMCheckArchiRulesArgs \
	const ADLCMAPIParsedProjPath &APIParsedProjPath, /* Path cut into pieces (ADLCMAPIProjElem) */ \
	int ProjElemIdx,                /* Index of the path piece to consider */ \
	const char *User,               /* Name of the user who runs the command */ \
	Boolean &UnicityWithExtension,  /* Outputs TRUE -> check the unicity with the extension ("File1.cpp" -> check with "File1.cpp"), FALSE -> without the extension ("File1.cpp" -> check with "File1") */ \
	Boolean &UnicityInFolder        /* Outputs TRUE -> check the unicity in the containing folder, FALSE -> in any containing folder. */

#define ADLCMCheckIfUnixPathIsSharedArgs  \
	const char *Path,               /* Path of the image to create or to move. */ \
	const char *LocalPathOptionName /* Name of the option to skip the check (to be used in the error advice). */

#define ADLCMCheckSoftObjArgs \
	const ADLCMAPIParsedProjPath &APIParsedProjPath, /* Path cut into pieces (ADLCMAPIProjElem) */ \
	const ADLCMAPIParsedProjPath *pTargetAPIParsedProjPath, /* Target path cut into pieces (ADLCMAPIProjElem) */ \
	const char *CommandName,        /* Name of the running command */ \
	const char *User,               /* Name of the user who runs the command */ \
	const char *CurrentWsTree,      /* Current workspace tree */ \
	const char *CurrentWs,          /* Current workspace */ \
	const char *CurrentImage        /* Current image or <NULL> */

#define ADLCMCheckPromotionRequestArgs \
	const char *SoftObjChangesFilePath, /* File path containing software object changes to promote */ \
	const char *User,               /* Name of the user who runs the command */ \
	const char *CurrentWsTree,      /* Current workspace tree */ \
	const char *CurrentWs,          /* Current workspace */ \
	const char *PromotedWsRev,      /* Promoted workspace revision */ \
	const char *TargetWs,           /* Target workspace */ \
	const char *CurrentImage,       /* Current image or <NULL> */ \
	Boolean Simulation,             /* TRUE -> simulation mode, FALSE -> not simulation mode */ \
	Boolean OutCAA                  /* TRUE -> -adm_out_caa option on command line, FALSE -> no -adm_out_caa */

#define ADLCMCheckFlowArgs \
	const char *FlowDataFilePath,   /* File path containing flow data */ \
	const char *CommandName,        /* Name of the running command */ \
	const char *User,               /* Name of the user who runs the command */ \
	const char *CurrentWsTree,      /* Current workspace tree */ \
	const char *CurrentWs,          /* Current workspace */ \
	int NbOriginWsRev,              /* Number of origin workspace revisions */ \
	const char *OriginWsRev[],      /* Origin workspace revisions */ \
	const char *CurrentImage,       /* Current image or <NULL> */ \
	Boolean Simulation              /* TRUE -> simulation mode, FALSE -> not simulation mode */

#endif // _ADLCMAPIArchi_H

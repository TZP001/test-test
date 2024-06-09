#ifndef _ADLCMAPICRTrigger_H
#define _ADLCMAPICRTrigger_H

/***
 *
 *
 * The library should declare exported function in his header file as follow : 
 *
 * extern "C" ExportedByADLCMCustCRTriggers const char *ADLCMGetAPITrigVersion();
 *
 * extern "C" ExportedByADLCMCustCRTriggers HRESULT ADLCMInitTrigAPI(ADLCMAPICRTriggersInterface &APITrigInterface);
 *
 * - The library must export a function which returns the version it has been built with.
 *   If the returned version doesn't match the expected value, an error message is displayed so that
 *   the library must be recompiled.
 * 
 * 
 *
 * const char *ADLCMGetAPITrigVersion()
 * {
 *    return ADL_API_TRIG_VERS;
 * }
 *
 * - The library must also export a function in order to be initialized once.
 *   The ADLCMAPICRTriggersInterface instance may be referenced with a static pointer in order to be used later.
 *
 * 
 * static ADLCMAPICRTriggersInterface *pAPITrigInterface = NULL;
 *
 * HRESULT ADLCMInitTrigAPI(ADLCMAPICRTriggersInterface &APITrigInterface)
 * {
 * 	 HRESULT hr = S_OK;
 *	// * Referencing the interface instance with a global pointer
 *	pAPITrigInterface = &APITrigInterface;
 *
 *	// * set the Triggers functions with local ones
 *  ...
 *    return hr;
 * }
 *
 * - The Custom trigger library should provides functions in order to react to events recieved:
 *
 * HRESULT ADLCMPromotionReqCheckEvent(ADLCMPromotionReqCheckEventArgs);
 * HRESULT ADLCMPromotionReqCommitEvent(ADLCMPromotionReqCommitEventArgs);
 * HRESULT ADLCMPromotionReqAbortEvent(ADLCMPromotionReqAbortEventArgs);
 * HRESULT ADLCMCollectCRRequestCheckEvent(ADLCMCollectCRRequestCheckEventArgs);
 * HRESULT ADLCMCollectCRRequestCommitEvent(ADLCMCollectCRRequestCommitEventArgs);
 * HRESULT ADLCMCollectCRRequestAbortEvent(ADLCMCollectCRRequestAbortEventArgs);
 * HRESULT ADLCMRemovePromoEvent(ADLCMRemovePromoEventArgs);
 * HRESULT ADLCMRemovePromoReqEvent(ADLCMRemovePromoReqEventArgs);
 *
 *   The arguments are explained below.
 *   
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
#define ADL_API_TRIG_VERS "2008_03_19"


/***
 * Following defines are used by methods declared in ADLCMAPICRTriggersInterface.h
 * To have more details on thoses methods please refers to ADLCMAPICRTriggersInterface.h
 */

//Args given for a monotree CR collection request. As promotion for a multitree WS collection is performed sequentially
#define  ADLCMPromotionReqCheckEventArgs \
	const char *SoftObjChangesFilePath, /* File path containing software object changes to promote */ \
	const char *User,               /* Name of the user who runs the command */ \
	const char *TargetWs,           /* Target workspace case name */ \
	const char *TargetWsId,         /* Target workspace UUID*/ \
	const char *CRParams,			/* Command line paramaters of -cr option*/\
	const char *SoftLevel,			/* Software Level*/\
	Boolean IsSimulation              /* TRUE -> simulation mode, FALSE -> not simulation mode */ 



//As all useful informations where given by the check event, the commit event don't need any arguments
#define  ADLCMPromotionReqCommitEventArgs 

//As all useful informations where given by the check event, the Abort event don't need any arguments
#define  ADLCMPromotionReqAbortEventArgs


//Args given for a monotree CR collection request. As promotion for a multitree WS collection is performed sequentially
#define  ADLCMCollectCRRequestCheckEventArgs \
	const char *SoftObjChangesFilePath, /* File path containing software object changes to collect */ \
	const char *User,               /* Name of the user who runs the command */ \
	const char *CollectingWs,		/* Collecting WS case name*/\
	const char *CollectingWsId,		/* Collecting WS Id*/\
	const char *SoftLevel,			/* Software Level*/\
	Boolean IsCertifCollectingWS,	/* TRUE -> Collecting WS is a certification WS, FALSE -> Collecting Ws is not a certification WS*/\
	Boolean IsSimulation,           /* TRUE -> simulation mode, FALSE -> not simulation mode */ \
	Boolean IsLateCR 			    /* TRUE -> -cr_later option on command line, FALSE no -cr_later option on command line*/

//As all useful informations where given by the check event, the commit event don't need any arguments
#define  ADLCMCollectCRRequestCommitEventArgs 

//As for promotion request collect should fire an event if the command failed on a specific tree
//As all useful informations where given by the check event, the abort event don't need any arguments
#define  ADLCMCollectCRRequestAbortEventArgs


//args given on remove promotion command event
#define ADLCMRemovePromoEventArgs \
	const char *User,               /* Name of the user who runs the command */ \
	const char *CurrentWs,           /* Current workspace case name */ \
	const char *CurrentWsId,         /* Current workspace UUID */ \
	const char *CurrentWsTree,       /* Current workspace Tree case name*/ \
	const char *CurrentWsTreeId,     /* Current workspace Tree UUID*/ \
	const char *CurrentWsRev,        /* Current workspace tree case name*/ \
	const char *CurrentWsRevId,      /* Current workspace tree UUID*/ \
	const char *TargetWs,            /* Target workspace case name*/ \
	const char *TargetWsId           /* Target workspace UUID*/ 

	
	
//args given on remove request command event
#define ADLCMRemovePromoReqEventArgs \
	const char *User,               /* Name of the user who runs the command */ \
	const char *CurrentWs,          /* Current workspace case name*/ \
	const char *CurrentWsId,        /* Current workspace UUID*/ \
	const char *SourceWs,           /* Source workspace case name*/ \
	const char *SourceWsId,         /* Source workspace UUID*/ \
	const char *SourceWsTree,       /* Source workspace tree case name */ \
	const char *SourceWsTreeId,     /* Source workspace tree UUID*/ \
	const char *SourceWsRev,        /* Current workspace tree case name */ \
	const char *SourceWsRevId       /* Current workspace tree */ 
	

#endif // _ADLCMAPITriggersArchi_H

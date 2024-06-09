#ifndef _ADLCMTriggersInterface_H
#define _ADLCMTriggersInterface_H

// ******************** ADLCMAPICRTriggersInterface
/**
 * Interface between the SCM command and the custom CR Triggers library.
 * An instance is passed to the library initialization function ADLCMInitAPI().
 */

#include "ADLCMAPICRTriggers.h"

/**
* Define different Error level allowed to be thrown by event reciever via SetLastError call.
*
* @param ADLCMAPIErrorTypeCritical
*     Critical error: Serious problem, but event reciever may continue. Associated with E_FAIL or S_FALSE
* @param ADLCMAPIErrorTypeFatal
*     Fatal error: Serious probleme one step upper than critical error, the event reciever will not continue. Associated with E_FAIL
* @param ADLCMAPIErrorTypeWarning
*     Warning : Minor problem , operation will not be stopped on event reciever side. Associated with S_FALSE
* @param ADLCMAPIErrorTypeInformation
*     Information : no particular problem. Associated with S_FALSE or S_OK
*
*/
enum ADLCMAPIErrorType
{
	ADLCMAPIErrorTypeCritical = 1,
	ADLCMAPIErrorTypeFatal = 2,
	ADLCMAPIErrorTypeWarning = 3,
	ADLCMAPIErrorTypeInformation = 4
};



class ADLCMAPIMsgBldr;
class ADLCMAPIMsgBldrCtlg;



/** 
* This pluggin event is a check request for promotion command and allow to cancel a promotion request at tree level.
* In SCM context a promotion is a sequential operation. i.e: In a multitree WS a promotion is done tree after tree.
* The nominal event sequence for a multitree WS is: check/commit for tree.1, check/commit for tree.2 and so on
* Event is fired on execution of adl_promote command of SCM Kernel, treated by client custom CR triggers library.
*
* @param ADLCMPromotionReqCheckEventArgs [in]
*   Arguments are detailed in ADLCMAPIArchiCRTriggers.h
*   The  informations given are the output of adl_promote command in program mode, plus somme usefull missing info:
*		user: who called the command
*		TargetWS, TargetWSId: Where change are promoted
*		CRParams: What should be binded to thoses modifications. Can not be NULL, because this event is only fired with -cr option
*		IsSimulation: Usefull to know if the command will be really executed
*
* @return
*   <code>S_OK</code> Promotion check OK for the given WS.Tree, the command will continue
*   <code>S_FALSE</code> Promotion check KO for the given WS.Tree, but the command will be stopped.
* After this return SCM Kernel will fire an Abort event.
*   <code>E_FAIL</code> Promotion checker failed to assess promotion status, it is an unexpected error.
* When returning this value the trigger MUST also call SetLastError method. 
*
*/
typedef HRESULT (*ADLAPITriggerPromoteCheckEvt)(ADLCMPromotionReqCheckEventArgs);



/** 
* This message signifies that a promotion is effectively done on SCM side for a WS.Tree, SCM DataBase is uptodate.
* This event can only be recieved after a successful check event.
* This event is fired by SCM kernel after an ADLCMPromotionReqCheckEvent returning S_OK , treated by client custom triggers library. 
*
* @param ADLCMPromotionReqCommitEventArgs [in]
*   As all information where given by the corresponding check event, the commit don't have any args.
*
* @return
*   <code>S_OK</code> Promotion Commit OK for the given WS.Tree, the command will continue.
*	<code>E_FAIL</code> Promotion Commit KO for the given WS.Tree, When returning this value the trigger must also call SetLastError method.
*
*/
typedef HRESULT (*ADLAPITriggerPromoteCommitEvt)(ADLCMPromotionReqCommitEventArgs);





/** 
* The message signifies that a checker or a trigger abort the promotion command.
* This event can only be recieved after a failed check event.
* This event is fired by SCM Kernel when recieving S_FALSE as return code for a check event.
* 
* @param ADLCMPromotionReqAbortEventArgs [in]
*   As all information where given by the corresponding check event, the abort don't have any args.
*
* @return
*   Not specified.
*/
typedef HRESULT (*ADLAPITriggerPromoteAbortEvt)(ADLCMPromotionReqAbortEventArgs);



/** 
* This message signifies that a collect command with CR collect occurs on a WS for a Tree
* As for promotion command the collect is done Tree by Tree
* The event sequence for a multitree WS is: check/commit, check/commit and so on
* Event is fired on execution of collect command, by SCM Kernel, Treated by client custom triggers library.
*
* @param ADLCMCollectCRRequestCheckEventArgs [in]
*   The  informations given are the output of adl_promote command in program mode, plus somme usefull missing info:
*   IsCertifCollectingWS: To identify certification WS	
*	IsSimulation:  Usefull to know if the command will be really executed          
*	IsLateCR: if this flag is on CR will be collected later. adl_collect, adl_collect_cr -> flag off; adl_collect -cr_later -> falg on
*
* @return
*   <code>S_OK</code> Collect check OK for the given WS.Tree, the command will continue
*   <code>S_FALSE</code> Collect check KO for the given WS.Tree, but the command will be stopped. After this return SCM Kernel will fire an Abort event.
*   <code>E_FAIL</code> Collect check KO for the given WS.Tree, unexpected.When returning this value the trigger must also call SetLastError method. 
*
*
*/
typedef HRESULT (*ADLAPITriggerCollectCRCheckEvt)(ADLCMCollectCRRequestCheckEventArgs);





/** 
* This message signifies that a collect is effectively done on SCM side for a WS.Tree, DataBase is uptodate.
* This event can only be recieved after a check event.
* This event is fired by SCM kernel after an ADLCMCollectReqCheckEvent returning S_OK , Treated by client custom triggers library. 
*
* @param ADLCMCollectCRRequestCommitEventArgs [in]
*   As all information where given by the corresponding check event, the commit don't have any args.
*
* @return
*   <code>S_OK</code> Collect Commit OK for the given WS.Tree, the command will continue.
*	<code>E_FAIL</code> Collect Commit KO for the given WS.Tree, When returning this value the trigger must also call SetLastError method.
*
*/
typedef HRESULT (*ADLAPITriggerCollectCRCommitEvt)(ADLCMCollectCRRequestCommitEventArgs);



/** 
* The message signifies that a checker or a trigger abort the promotion command.This event can only be recieved after a check event.
* This event is fired by SCM Kernel when recieving S_FALSE as return code for a check event.
* 
* @param ADLCMCollectCRRequestAbortEventArgs [in]
*   As all information where given by the corresponding check event, the abort don't have any args.
*
* @return
*   Not specified
*/
typedef HRESULT (*ADLAPITriggerCollectAbortEvt) (ADLCMCollectCRRequestAbortEventArgs);

/** 
* This message signifies that a remove promote request command as occurs, for a WS
* As for previous multitree command, this one is done tree by tree
* This event is fired by SCM Kernel  and treated by client custom CR Triggers Lib. 
* @param ADLCMRemovePromoEventArgs [in]
*   Give all necessary informations about this command: Who is the caller, from which WS, which Tree and Which Ws was targeted
*
* @return
*   <code>S_OK</code> remove promote request OK, for the tree
*	<code>E_FAIL</code> remove promote request KO for the given WS.Tree, When returning this value the trigger must also call SetLastError method.
*
*/
typedef HRESULT (*ADLAPITriggerRemovePromoteEvt)(ADLCMRemovePromoEventArgs);

/** 
* This message signifies that a remove  request command as occurs, for a WS
* As for previous multitree command, this one is done tree by tree
* This event is fired by SCM Kernel  and treated by client custom CR Triggers Lib. 
* @param ADLCMRemovePromoEventArgs [in]
*   Give all necessary informations about this command: Who is the caller, from which WS, which Tree and Which Ws was the source of promotion
*
* @return
*   <code>S_OK</code> remove  request OK, for the tree
*	<code>E_FAIL</code> remove  request KO for the given WS.Tree, When returning this value the trigger must also call SetLastError method.
*
*/
typedef HRESULT (*ADLAPITriggerRemoveRequestEvt)(ADLCMRemovePromoReqEventArgs);


/**
* Communication interface between SCM and CR Trigger Library
* This classe is implemented and instaciated by SCM kernel.
* Library implementer should have in mind that his DLL (here CR Trigger Lib) has a really short life, As describe by the following life cycle: 
* For Each command proficient to trigger CR events the DLL is Load . At the end of the command the DLL is unload.
* This Class handle command abort by triggers or checkers but not manual command abort (Ctrl+c). In the second case no event will be fired !!
* The implementer should handle this case by himself.
*
* <br><b>Role</b>: This Class provides the following services
* <p>
*  Setters allowing Libarray to link his code to event fired by kernel.
* <p>
*  A Message catalog builder, to send information advises and hints to SCM user
* <p>
*  A utilitie to set last error and associate it with catalog messages.
*/

class ADLCMAPICRTriggersInterface
{
public:
	// *** Events

	
	/** 
	* Method Called by CR Trigger Library in ADLCMInitAPI to associate his implementation to the event fired by SCM command
	* <br><b>Role</b>: Set pointer to method implemented in the client library for Check promote event
	*
	* @param ADLAPITriggerPromoteCheckEvt [in]
	*   pointer to the function see Typedef for detailed comments
	*
	*/
	virtual void __stdcall SetCheckPromotionRequestPtr(ADLAPITriggerPromoteCheckEvt) = 0;
	/** 
	* Method Called by CR Trigger Library in ADLCMInitAPI to associate his implementation to the event fired by SCM command
	* <br><b>Role</b>: Set pointer to method implemented in the client library for Check promote event
	*
	* @param ADLAPITriggerPromoteCommitEvt [in]
	*   pointer to the function see Typedef for detailed comments
	*
	*/
	virtual void __stdcall SetCommitPromotionRequestPtr(ADLAPITriggerPromoteCommitEvt) = 0;
	/** 
	* Method Called by CR Trigger Library in ADLCMInitAPI to associate his implementation to the event fired by SCM command
	* <br><b>Role</b>: Set pointer to method implemented in the client library for Check promote event
	*
	* @param ADLAPITriggerPromoteAbortEvt [in]
	*   pointer to the function see Typedef for detailed comments
	*
	*/
	virtual void __stdcall SetPromotionRequestAbortPtr (ADLAPITriggerPromoteAbortEvt) =0;
	/** 
	* Method Called by CR Trigger Library in ADLCMInitAPI to associate his implementation to the event fired by SCM command
	* <br><b>Role</b>: Set pointer to method implemented in the client library for Check promote event
	*
	* @param ADLAPITriggerCollectCRCheckEvt [in]
	*   pointer to the function see Typedef for detailed comments
	*
	*/
	virtual void __stdcall SetCheckCollectCRRequestPtr(ADLAPITriggerCollectCRCheckEvt) = 0;
	/** 
	* Method Called by CR Trigger Library in ADLCMInitAPI to associate his implementation to the event fired by SCM command
	* <br><b>Role</b>: Set pointer to method implemented in the client library for Check promote event
	*
	* @param ADLAPITriggerCollectCRCommitEvt [in]
	*   pointer to the function see Typedef for detailed comments
	*
	*/
	virtual void __stdcall SetCommitCollectCRRequestPtr(ADLAPITriggerCollectCRCommitEvt) = 0;
	/** 
	* Method Called by CR Trigger Library in ADLCMInitAPI to associate his implementation to the event fired by SCM command
	* <br><b>Role</b>: Set pointer to method implemented in the client library for Check promote event
	*
	* @param ADLAPITriggerCollectAbortEvt [in]
	*   pointer to the function see Typedef for detailed comments
	*
	*/
	virtual void __stdcall SetCollectRequestAbortPtr(ADLAPITriggerCollectAbortEvt)=0;
	
	/** 
	* Method Called by CR Trigger Library in ADLCMInitAPI to associate his implementation to the event fired by SCM command
	* <br><b>Role</b>: Set pointer to method implemented in the client library for Check promote event
	*
	* @param ADLAPITriggerRemovePromoteEvt [in]
	*   pointer to the function see Typedef for detailed comments
	*
	*/
	virtual void __stdcall SetRemovePromotionPtr(ADLAPITriggerRemovePromoteEvt) = 0;
	/** 
	* Method Called by CR Trigger Library in ADLCMInitAPI to associate his implementation to the event fired by SCM command
	* <br><b>Role</b>: Set pointer to method implemented in the client library for Check promote event
	*
	* @param ADLAPITriggerRemoveRequestEvt [in]
	*   pointer to the function see Typedef for detailed comments
	*
	*/
	virtual void __stdcall SetRemoveRequestPtr(ADLAPITriggerRemoveRequestEvt) = 0;
	

	// Sample:
	//    static ADLCMAPICRTriggersInterface *pAPIInterface = NULL;
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
	//    HRESULT ADLCMInitAPI(ADLCMAPICRTriggersInterface &APIInterface)
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

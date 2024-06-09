#include "ADLCMCustTriggers.h"
#include "ADLCMAPICRTriggersInterface.h"

// API classes delivered by the SCM command.
#include "ADLCMAPIMsgBldrCtlg.h"

#include <string.h>
#include <iostream.h> 

#define ADL_ASSERT(condition,message) \
{ \
	if (! (condition)) \
	{ \
		cout << "#ERR# Fatal internal error: " << message << "on file: " << __FILE__ << " at line: " << __LINE__ << endl << "Contact your administrator" << endl; \
		exit(-1); \
	} \
}

// *** Version check

const char *ADLCMGetAPITrigVersion()
{
	return ADL_API_TRIG_VERS;
}

// *** API initialization
static ADLCMAPICRTriggersInterface *pAPITrigInterface = NULL;


ADLCMAPICRTriggersInterface &GetAPITrigInterface()
{
	
	ADL_ASSERT(pAPITrigInterface,"pAPITrigInterface is NULL");
	return *pAPITrigInterface;
}



//*** Build standart Messages without parameters, using MSg builder API
HRESULT MsgBldrCtlgNoParameters(const char* Request, const char* Diagnostic, const char* Advise, ADLCMAPIErrorType ErrorType,HRESULT hrParam)
{
	HRESULT hr = S_OK;
	ADLCMAPIMsgBldrCtlg *pRequestBldr = (Request)? GetAPITrigInterface().MakeMsgBldrCtlg("ADLCMCUSTTRIGGERS", Request) : NULL; 
	ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = (Diagnostic) ? GetAPITrigInterface().MakeMsgBldrCtlg("ADLCMCUSTTRIGGERS", Diagnostic):NULL; 
	ADLCMAPIMsgBldrCtlg *pAdviceBldr =(Advise)? GetAPITrigInterface().MakeMsgBldrCtlg("ADLCMCUSTTRIGGERS", Advise): NULL; 

	hr = GetAPITrigInterface().SetLastError(__FILE__, __LINE__, pRequestBldr, pDiagnosticBldr, pAdviceBldr, ErrorType, hrParam);

	delete pRequestBldr;
	delete pDiagnosticBldr;
	delete pAdviceBldr;
	return hr;
}

// *** Check the promotion request

HRESULT ADLCMPromotionReqCheckEvent(
	const char *SoftObjChangesFilePath, /* File path containing software object changes to promote */ \
	const char *User,                   /* Name of the user who runs the command */ \
	const char *TargetWs,               /* Target workspace case name */ \
	const char *TargetWsId,             /* Target workspace UUID*/ \
	const char *CRParams,			    /* Command line paramaters of -cr option*/ \
	const char *SoftLevel,			/* Software Level*/\
	Boolean IsSimulation                /* TRUE -> simulation mode, FALSE -> not simulation mode */ \
	)
{
	HRESULT hr = S_OK;
	
	//Test Arguments
	if(!SoftObjChangesFilePath || !User || !TargetWs || !TargetWsId || !CRParams || !SoftLevel)
	{
		// "Checking that Event arguments are valued"
		// "At least one of the arguments recieved is NULL"
		// "Call your Administrator this Error is unexpected"
		hr = MsgBldrCtlgNoParameters("0004","0005","0006",ADLCMAPIErrorTypeCritical,E_FAIL);
		
	}
	
	if(hr==S_OK && IsSimulation)
	{
		// "Event recieved :  Simulation mode"
		hr = MsgBldrCtlgNoParameters("0010",NULL,NULL,ADLCMAPIErrorTypeInformation,S_OK);
		
	}
	//test
	if(hr==S_OK)
	{
		Boolean CRIdIsUnknown = FALSE;
		char* GoodIR[]={"000111I","000111J"};
		//retrieve IR from CRParam
		char* pch;
		
		char* ParamTmp= (char*)malloc((strlen(CRParams)+1)*sizeof(char));
		strcpy(ParamTmp,CRParams);
		pch = strtok (ParamTmp," ");
		Boolean allOK = FALSE;
		//check validity of IR Id
		while (hr == S_OK  && pch != NULL)
		{
			int i;
			for(i=0; i < sizeof(GoodIR)/sizeof(char*); i++)
					if(	strcmp(pch,GoodIR[i])==0) 
					{
						
						allOK=TRUE;
						break;
					}
					
			if (i == sizeof(GoodIR)/sizeof(char*))
                                    allOK=FALSE;
			pch = strtok (NULL, " ");
			
		}
		if(!allOK)
			{
				ADLCMAPIMsgBldrCtlg *pRequestBldr = GetAPITrigInterface().MakeMsgBldrCtlg("ADLCMCUSTTRIGGERS", "0001"); // "Checking that the CR Id recieved are known by CM system"

				ADLCMAPIMsgBldrCtlg *pDiagnosticBldr = GetAPITrigInterface().MakeMsgBldrCtlg("ADLCMCUSTTRIGGERS", "0002"); // "One CR Id provided  is unknown by CM system"
				
				ADLCMAPIMsgBldrCtlg *pAdviceBldr = GetAPITrigInterface().MakeMsgBldrCtlg("ADLCMCUSTTRIGGERS", "0003"); // "Check that the CR parameters you provided actually exists, or replace it by a good one"

				hr = GetAPITrigInterface().SetLastError(__FILE__, __LINE__, pRequestBldr, pDiagnosticBldr, pAdviceBldr, ADLCMAPIErrorTypeCritical, S_FALSE);

				delete pRequestBldr;
				delete pDiagnosticBldr;
				delete pAdviceBldr;
			}
		//free memory
		free (ParamTmp);
	}
	//return
	cout << SoftLevel << endl;
	return hr;
}




// *** Treat Commit event on Promotion request
HRESULT ADLCMPromotionReqCommitEvent()
{
	HRESULT hr = S_OK;
	hr=MsgBldrCtlgNoParameters("0007",NULL,NULL,ADLCMAPIErrorTypeInformation,S_OK);// "Event recieved :  commit for promotion"
	cout << "EVTCOMMITPROMO" << endl;
          return hr;
          
          
}

// *** Treat Abort event on Promotion request
HRESULT ADLCMPromotionReqAbortEvent()
{
	HRESULT hr = S_OK;
	
	hr=MsgBldrCtlgNoParameters("0008",NULL,NULL,ADLCMAPIErrorTypeInformation,S_OK);// "Event recieved :  abort for promotion"
	cout << "EVTABORTPROMO" << endl;
	return hr;
}

//Treat Collect CR Request
HRESULT ADLCMCollectCRRequestCheckEvent(
	const char *SoftObjChangesFilePath, /* File path containing software object changes to collect */ 
	const char *User,               /* Name of the user who runs the command */ 
	const char *CollectingWs,		/* Collecting WS case name*/
	const char *CollectingWsId,		/* Collecting WS Id*/
	const char *SoftLevel,			/* Software Level*/
	Boolean IsCertifCollectingWS,	/* TRUE -> Collecting WS is a certification WS, FALSE -> Collecting Ws is not a certification WS*/
	Boolean IsSimulation,           /* TRUE -> simulation mode, FALSE -> not simulation mode */ 
	Boolean IsLateCR 			    /* TRUE -> -cr_later option on command line, FALSE no -cr_later option on command line*/
	)
{
	HRESULT hr = S_OK;
	
	//Test Arguments
	if(!SoftObjChangesFilePath || !User || !CollectingWs || !CollectingWsId || !SoftLevel)
	{
		
		 // "Checking that Event arguments are valued"
		// "At least one of the arguments recieved is NULL"
		// "Call your Administrator this Error is unexpected"
		hr=MsgBldrCtlgNoParameters("0004","0005","0006",ADLCMAPIErrorTypeCritical, E_FAIL);
		
	}

	if(hr==S_OK && IsCertifCollectingWS)
	{
		// "Event recieved :  Collect in a Certification WS"
		hr=MsgBldrCtlgNoParameters("0009",NULL,NULL,ADLCMAPIErrorTypeInformation, S_OK);
		
	}

	if(hr==S_OK && IsSimulation)
	{
		 // "Event recieved :  Simulation mode"
		hr=MsgBldrCtlgNoParameters("0010",NULL,NULL,ADLCMAPIErrorTypeInformation, S_OK);
		cout << "EVTSIMULMODE" << endl;
		
	}

	if(hr==S_OK && IsLateCR)
	{
		// "Event recieved :  Collect in cr_later mode"
		hr=MsgBldrCtlgNoParameters("0011",NULL,NULL,ADLCMAPIErrorTypeInformation, S_OK);
		cout << "EVTCRLATER" << endl;
		
	}
	
	//return 
	cout << SoftLevel << endl;
	return hr;
}




//Treating collect CR commit evt
HRESULT ADLCMCollectCRRequestCommitEvent()
{
	HRESULT hr = S_OK;
	// "Event recieved :  commit for collect"
	hr=MsgBldrCtlgNoParameters("0012",NULL,NULL,ADLCMAPIErrorTypeInformation, S_OK);
	cout << "EVTCOMMITCOLLECT" << endl;
	return hr;
}

//Treating collect CR abort evt
HRESULT ADLCMCollectCRRequestAbortEvent()
{
	HRESULT hr = S_OK;
	 // "Event recieved :  abort for Collect "
	hr=MsgBldrCtlgNoParameters("0013",NULL,NULL,ADLCMAPIErrorTypeInformation, S_OK);
	return hr;
}

//Treating Remove promote request event
HRESULT ADLCMRemovePromoEvent(
								const char *User,               /* Name of the user who runs the command */ 
								const char *CurrentWs,           /* Current workspace case name */ 
								const char *CurrentWsId,         /* Current workspace UUID */ 
								const char *CurrentWsTree,       /* Current workspace Tree case name*/ 
								const char *CurrentWsTreeId,     /* Current workspace Tree UUID*/ 
								const char *CurrentWsRev,        /* Current workspace tree case name*/ 
								const char *CurrentWsRevId,      /* Current workspace tree UUID*/ 
								const char *TargetWs,            /* Target workspace case name*/ 
								const char *TargetWsId           /* Target workspace UUID*/ 
								)
{
	HRESULT hr = S_OK;
	 // "Event recieved :  remove promotion request "
	hr=MsgBldrCtlgNoParameters("0014",NULL,NULL,ADLCMAPIErrorTypeInformation, S_OK);
	cout << "EVTREMPROMO" << endl;
	return hr;
}

//treating remove request event
HRESULT ADLCMRemovePromoReqEvent(
									const char *User,               /* Name of the user who runs the command */ 
									const char *CurrentWs,          /* Current workspace case name*/ 
									const char *CurrentWsId,        /* Current workspace UUID*/ 
									const char *SourceWs,           /* Source workspace case name*/ 
									const char *SourceWsId,         /* Source workspace UUID*/ 
									const char *SourceWsTree,       /* Source workspace tree case name */ 
									const char *SourceWsTreeId,     /* Source workspace tree UUID*/ 
									const char *SourceWsRev,        /* Current workspace tree case name */ 
									const char *SourceWsRevId       /* Current workspace tree */
								 )
{
	HRESULT hr = S_OK;
	 // "Event recieved :  remove request "
	hr=MsgBldrCtlgNoParameters("0015",NULL,NULL,ADLCMAPIErrorTypeInformation, S_OK);
	cout << "EVTREM" << endl;
	return hr;

}

HRESULT ADLCMInitTrigAPI(ADLCMAPICRTriggersInterface &APITrigInterface)
{
	
	HRESULT hr=S_OK;
	// * Referencing the interface instance with a global pointer
	pAPITrigInterface = &APITrigInterface;
	ADL_ASSERT(pAPITrigInterface,"pAPITrigInterface is NULL");
	
	// * set the Triggers functions with local ones
	// :NOTE: fkn290208 : ca ne passe pas l'outil mkcs...
	pAPITrigInterface->SetCheckPromotionRequestPtr(&ADLCMPromotionReqCheckEvent);
	pAPITrigInterface->SetCommitPromotionRequestPtr(&ADLCMPromotionReqCommitEvent) ;
	pAPITrigInterface->SetPromotionRequestAbortPtr (&ADLCMPromotionReqAbortEvent) ;
	pAPITrigInterface->SetCheckCollectCRRequestPtr(&ADLCMCollectCRRequestCheckEvent) ;
	pAPITrigInterface->SetCommitCollectCRRequestPtr(&ADLCMCollectCRRequestCommitEvent) ;
	pAPITrigInterface->SetCollectRequestAbortPtr(&ADLCMCollectCRRequestAbortEvent);
	pAPITrigInterface->SetRemovePromotionPtr(&ADLCMRemovePromoEvent);
	pAPITrigInterface->SetRemoveRequestPtr(&ADLCMRemovePromoReqEvent);
	
	

	return hr;
}

// *** API interface


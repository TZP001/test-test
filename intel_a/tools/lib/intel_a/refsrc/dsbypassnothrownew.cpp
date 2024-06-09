/**/
#include <windows.h>
#include <new>

typedef void* (*NewFuncPtr_t)(size_t) throw(std::bad_alloc);


//===============================================
// structure de maintien des pointeurs sur le new
//===============================================
struct DSRegisterNewAddr

{
  NewFuncPtr_t _newptr; // pointeur sur new
  NewFuncPtr_t _newptrcroch; // pointeur sur new []
} ;
static struct DSRegisterNewAddr S_RegNew;
static struct DSRegisterNewAddr *S_RegNewAddr=NULL;


//===============================================
// on recupere les pointeurs adhoc
//===============================================
static void DSRegisterNewAddr()
{
  if ( S_RegNewAddr  )  return;

  S_RegNewAddr=&S_RegNew;

  HINSTANCE mydll= NULL;

#ifdef _MSC_VER
#if   _MSC_VER == 1500	/* VC9 */
#	pragma message( "Version of the compiler 1500" )
  //check if msvcr90.dll is loaded instead of the debug version of msvcr90.dll
  mydll = GetModuleHandle(TEXT("msvcr90.dll"));
#elif _MSC_VER == 1400	/* VC8 */
#	pragma message( "Version of the compiler 1400" )
  //check if msvcr80.dll is loaded instead of the debug version of msvcr80.dll
  mydll = GetModuleHandle(TEXT("msvcr80.dll"));
#else
#	pragma message( "Unexpected version of the compiler" )
#	error
#endif
#endif

  //retreive the new and new[] address
  if (mydll != NULL)
  {
     S_RegNewAddr->_newptr= (NewFuncPtr_t)GetProcAddress(mydll, "??2@YAPAXI@Z");
     S_RegNewAddr->_newptrcroch= (NewFuncPtr_t)GetProcAddress(mydll, "??_U@YAPAXI@Z");
  }
}
//==================================================================
// presente pour  reduire l'inlining
static inline void DSDoNewAddrRegistration()
{
	static int Sl_Reg=0;
	if (Sl_Reg) return;
	Sl_Reg=-1;
	DSRegisterNewAddr() ;
}

//==================================================================
//new override
void * operator new( size_t cb )
{
	DSDoNewAddrRegistration();
	void* ptr = 0;
        try
	{
		if ( S_RegNewAddr && S_RegNewAddr->_newptr)	ptr = (S_RegNewAddr->_newptr)(cb);   //always valid ptrfn ( no abort)
		else ptr = malloc( cb);

	}
	catch(std::bad_alloc )
	{
		ptr = 0;
	}
	return (ptr);
}

//==================================================================
//new[] override
void * operator new[]( size_t cb )
{
	DSDoNewAddrRegistration();

	void* ptr = 0;

	try
	{
		if(S_RegNewAddr && S_RegNewAddr->_newptrcroch) ptr = (S_RegNewAddr->_newptrcroch)(cb);//always valid ptrfn ( no abort)
		else ptr=malloc(cb);
	
	}
	catch(std::bad_alloc)
	{
		ptr = 0;
	}
	return (ptr);
}

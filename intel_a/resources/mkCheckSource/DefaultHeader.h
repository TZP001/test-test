// Header pour donner a l''outil des informations qu''il n''arrive
// pas a determiner a partir des source (en particulier liees aux macros)
// Dec 2005 - JTF : ajout de _CAT_ANSI_STREAMS - a voir idem pour CNEXT_CLIENT


// Macros definies systematiquement dans les trames mkmk
#define _CAT_ANSI_STREAMS 1
#define CNEXT_CLIENT 1

// Macro OLE
#define STDMETHOD(x) x


/*class CATInterfaceObject : CATBaseUnknown {

					  public:
					    CATInterfaceObject(void);
					  };

// MBI : Cette classe est utilisee dans Visualisation,
// ni mkCheckSource ni moi ne trouvons sa declaration.

class SubscriptionChain;
*/
/*
typedef unsigned long ULONG;
typedef long HRESULT;
typedef struct  _GUID {} GUID;
typedef GUID IID;

class IUnknown
{
  CATDeclareInterface;
  
 public:
  
  virtual HRESULT QueryInterface(const IID &iid, void **ppv) = 0;
  virtual ULONG AddRef() = 0;
  virtual ULONG Release() = 0;
};

class IDispatch : public IUnknown
{
  CATDeclareInterface;
};

class CATBaseUnknown : public IDispatch
{
};

*/


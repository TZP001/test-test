#ifdef  _WINDOWS_SOURCE
#ifdef  __AUTLciVMExterns
#define ExportedByAUTLciVMExterns     __declspec(dllexport)
#else
#define ExportedByAUTLciVMExterns     __declspec(dllimport)
#endif
#else
#define ExportedByAUTLciVMExterns
#endif

#ifdef __cplusplus
#define ExportedByAUTLciVMExternsC   extern  "C" ExportedByAUTLciVMExterns
#else
#ifdef AUT_OUTSIDECATIA
#define ExportedByAUTLciVMExternsC  extern /*ExportedByAUTLciVMExterns*/
#else
#define ExportedByAUTLciVMExternsC  extern ExportedByAUTLciVMExterns
#endif
#endif

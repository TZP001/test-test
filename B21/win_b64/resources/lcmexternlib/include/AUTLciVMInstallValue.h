#ifndef AUTLCIVMINSTALLVALUE_H
#define AUTLCIVMINSTALLVALUE_H

#include <string.h>
#include <stdlib.h>
#include <stdio.h>



#include "AUTLciVMExterns.h"


#ifdef  _WINDOWS_SOURCE
#include <windows.h>
#include <tchar.h>
#endif

/* Value definition */
#ifdef _WIN64
	typedef __int64 intnat;
	typedef unsigned __int64 uintnat;
#else
	typedef long intnat;
	typedef unsigned long uintnat;
#endif	

typedef intnat value;
typedef uintnat mlsize_t;
typedef unsigned int tag_t;

/* Value access */
#define Field(x, i) (((value *)(x)) [i])
#define Abstract_tag 251
#define Bp_val(v) ((char *) (v))
#define String_val(x) ((char *) Bp_val(x))
#define Val_long(x) (((long)(x) << 1) + 1)
#define Val_int(x) Val_long(x)
#define Val_unit Val_int(0)

struct caml__roots_block {
  struct caml__roots_block *next;
  intnat ntables;
  intnat nitems;
  value *tables [5];
};

/* Value allocation */
ExportedByAUTLciVMExternsC value caml_alloc(mlsize_t size, tag_t tag);
ExportedByAUTLciVMExternsC value caml_copy_string(char const *);
ExportedByAUTLciVMExternsC struct caml__roots_block ** get_caml_local_roots();


#if defined (__GNUC__) && (__GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ > 7))
  #define CAMLunused __attribute__ ((unused))
#else
  #define CAMLunused
#endif

#define CAMLparam0() \
  struct caml__roots_block ** caml_local_roots_ptr = get_caml_local_roots (); \
  struct caml__roots_block *caml__frame = *caml_local_roots_ptr

#define CAMLparam1(x) \
  CAMLparam0 (); \
  CAMLxparam1 (x)

#define CAMLparam2(x, y) \
  CAMLparam0 (); \
  CAMLxparam2 (x, y)

#define CAMLxparam1(x) \
  struct caml__roots_block caml__roots_##x; \
  CAMLunused int caml__dummy_##x = (									\
	(caml__roots_##x.next = *caml_local_roots_ptr), \
    (*caml_local_roots_ptr = &caml__roots_##x), \
    (caml__roots_##x.nitems = 1), \
    (caml__roots_##x.ntables = 1), \
    (caml__roots_##x.tables [0] = &x), \
    0)

#define CAMLxparam2(x, y) \
  struct caml__roots_block caml__roots_##x; \
 CAMLunused int caml__dummy_##x = ( \
	(caml__roots_##x.next = *caml_local_roots_ptr), \
    (*caml_local_roots_ptr = &caml__roots_##x), \
    (caml__roots_##x.nitems = 1), \
    (caml__roots_##x.ntables = 2), \
    (caml__roots_##x.tables [0] = &x), \
    (caml__roots_##x.tables [1] = &y), \
    0)

#define CAMLlocal1(x) \
  value x = 0;		  \
  CAMLxparam1 (x)

#define CAMLlocal2(x, y) \
  value x = 0, y = 0;	 \
  CAMLxparam2 (x, y)

#define CAMLreturn0 do{ \
  *caml_local_roots_ptr = caml__frame; \
  return; \
}while (0)

#define CAMLreturn(result) do{ \
  *caml_local_roots_ptr = caml__frame; \
  return (result); \
}while(0)

struct custom_operations {
  char *identifier;
  void (*finalize)(value v);
  int (*compare)(value v1, value v2);
  intnat (*hash)(value v);
  void (*serialize)(value v, 
                    /*out*/ uintnat * wsize_32 /*size in bytes*/,
                    /*out*/ uintnat * wsize_64 /*size in bytes*/);
  uintnat (*deserialize)(void * dst);
};

/* Function registration */
ExportedByAUTLciVMExternsC void caml_raise_failure(const char *s) ;
ExportedByAUTLciVMExternsC int check_vm_version(char *version);
ExportedByAUTLciVMExternsC void install_adr(char *name, void *adr);
ExportedByAUTLciVMExternsC void uninstall_adr(char *name);
ExportedByAUTLciVMExternsC void install_const(char* name, value v);
ExportedByAUTLciVMExternsC void uninstall_const(char* name);

/* Text to Type conversion */
ExportedByAUTLciVMExternsC void install_info_type(char *name, void *adr);
ExportedByAUTLciVMExternsC void uninstall_info_type(char *name);

/* Value modification */
#define VAL(type, v) *((type *) v)

/* Type manipulation */

#define TYPE_ALLOC(lcm_type)					\
  CAMLparam0(); \
  CAMLlocal1(v);\
  AUTLcmxScalarPtr info = info_ ## lcm_type ##();\
  AUTLcmxObjectPtr obj_info = info->object;\
  if (obj_info) {\
    v = (value) (( *(obj_info->constructor)) ());\
  } else {\
     v = (value) calloc(1, info-> size);\
  }\
  CAMLreturn(v)

#define TYPE_DELETE(lcm_type)					\
  CAMLparam1(v); \
  AUTLcmxScalarPtr info = info_ ## lcm_type ##();\
  AUTLcmxObjectPtr obj_info = info->object;\
  lcm_type * data_v = ( lcm_type *) v;\
  if (data_v) {\
  if (obj_info) {\
	  ( *(obj_info-> destructor) )(data_v); \
  } else {\
      if (data_v) {free (data_v); data_v = NULL;}\
  }}\
  CAMLreturn(Val_unit)

#define TYPE_CREATE(lcm_type, x)	   \
  CAMLparam0();						   \
  CAMLlocal1(v);					   \
  AUTLcmxScalarPtr info = info_ ## lcm_type ##();\
  AUTLcmxObjectPtr obj_info = info->object;\
  lcm_type * data_v = NULL;\
  v = CAML___ ## lcm_type ## _alloc(); \
  data_v = ( lcm_type *) v;\
  if (obj_info) {\
	  ( *(obj_info-> recopy) )(data_v, &x); \
  } else {\
    memcpy((void *) data_v, (const void *) &x, (info_ ## lcm_type ##())-> size);\
  }\
  CAMLreturn(v)

#define TEXT_TO_TYPE(lcm_type, v, s)				   \
  CAMLparam2(v,s);									   \
  lcm_type * data_v = (lcm_type*) v;\
  ( *((info_ ## lcm_type ())-> fromText) )(data_v, String_val(s)); \
  CAMLreturn(Val_unit)

#define TYPE_TO_TEXT(lcm_type, v) \
  CAMLparam1(v);										\
  CAMLlocal1(res);										\
  char* str;											\
  lcm_type *data_v = (lcm_type*) v;\
  str = ( *((info_ ## lcm_type ())-> toText) )(data_v);			\
  res = caml_copy_string(str);							\
  free(str);											\
  CAMLreturn(res)

#ifndef AUT_OUTSIDECATIA
ExportedByAUTLciVMExternsC LPCTSTR lpctstr(const char *str);
#endif

#endif /*AUTLCIVMINSTALLVALUE_H*/

/* COPYRIGHT Dassault Systemes 2005
**===================================================================
**
** AUTLciVMPredefinedTypes.h
**
**===================================================================
**
**   LCM predefined constants, types and structures.
**
**===================================================================
**
**  LCM studio V5R17 for Wintel platform (MS Windows / Intel X86)
**
**===================================================================*/
#ifndef LCMPREDEFINEDTYPES_h
#define LCMPREDEFINEDTYPES_h

/* C++ Protection */
#ifdef __cplusplus
extern "C" { 
#endif

/* Scalar info for info_$type functions */
typedef char * (*AUTLcmxScalarToText) (void *x);
typedef void (*AUTLcmxScalarFromText) (void *x, char *);
typedef void* (*AUTLcmxConstructor) (void);
typedef void (*AUTLcmxDestructor) (void *);
typedef void (*AUTLcmxRecopy) (void *, const void *);

typedef struct {
  AUTLcmxConstructor constructor;
  AUTLcmxDestructor destructor;
  AUTLcmxRecopy recopy;
} AUTLcmxObject;
typedef AUTLcmxObject *AUTLcmxObjectPtr;

typedef struct {
	int size; /* used only for scalar object */
	AUTLcmxObjectPtr object; /* used only for object with constructor && descructors*/
  /* int scalar_kind; */
  AUTLcmxScalarToText toText;
  AUTLcmxScalarFromText fromText;
} AUTLcmxScalar;
typedef AUTLcmxScalar *AUTLcmxScalarPtr;

#define make_info_type(type) AUTLcmxScalarPtr info_ ## type () {\
  static AUTLcmxScalar info;\
  static int first = 1;\
  if (first) {\
	first = 0;\
	info.size = sizeof(type);\
	info.object = NULL;\
	info.toText = (AUTLcmxScalarToText) & type ## _to_text;\
	info.fromText = (AUTLcmxScalarFromText) & text_to_ ## type;\
  }\
  return &info;\
}

#define make_info_type_object(type) AUTLcmxScalarPtr info_ ## type () {\
 static AUTLcmxScalar info;\
  static AUTLcmxObject obj;\
  static int first = 1;\
  if (first) {\
	first = 0;\
	obj.constructor = (AUTLcmxConstructor) & type ## Constructor;\
    obj.destructor = (AUTLcmxDestructor) & type ## Destructor;\
    obj.recopy = (AUTLcmxRecopy) & type ## Recopy;\
	info. size = sizeof(type);\
	info.object = &obj;\
	info.toText = (AUTLcmxScalarToText) & type ## _to_text;\
	info.fromText = (AUTLcmxScalarFromText) & text_to_ ## type;\
  }\
  return &info;\
}

#ifndef NULL
#define NULL ((void *) 0)
#endif /* NULL not defined */


/* LCM types specification */

#ifndef LCM_PURE_T
#define LCM_PURE_T char
#endif /* LCM_PURE_T not defined */
typedef LCM_PURE_T pure;

#define PURE_VALUE  0

#ifndef LCM_BYTE_T
#define LCM_BYTE_T unsigned char
#endif /* LCM_BYTE_T not defined */
typedef LCM_BYTE_T LCMByte;

#ifndef LCM_BOOL_T
#define LCM_BOOL_T unsigned char
#endif /* LCM_BOOL_T not defined */
typedef LCM_BOOL_T LCMBool;

#ifndef LCM_WORD8_T
#define LCM_WORD8_T unsigned char
#endif /* LCM_WORD8_T not defined */
typedef LCM_WORD8_T LCMWord8;

#ifndef LCM_WORD16_T
#define LCM_WORD16_T unsigned short int
#endif /* LCM_WORD16_T not defined */
typedef LCM_WORD16_T LCMWord16;

#ifndef LCM_WORD32_T
#define LCM_WORD32_T unsigned long int
#endif /* LCM_WORD32_T not defined */
typedef LCM_WORD32_T LCMWord32;

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
#ifndef LCM_WORD64_T
#define LCM_WORD64_T unsigned long long int
#endif /* LCM_WORD64_T not defined */
typedef LCM_WORD64_T LCMWord64;
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

#ifndef LCM_UINT8_T
#define LCM_UINT8_T unsigned char
#endif /* LCM_UINT8_T not defined */
typedef LCM_UINT8_T LCMUint8;

#ifndef LCM_UINT16_T
#define LCM_UINT16_T unsigned short int
#endif /* LCM_UINT16_T not defined */
typedef LCM_UINT16_T LCMUint16;

#ifndef LCM_UINT32_T
#define LCM_UINT32_T unsigned long int
#endif /* LCM_UINT32_T not defined */
typedef LCM_UINT32_T LCMUint32;

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
#ifndef LCM_UINT64_T
#define LCM_UINT64_T unsigned long long int
#endif /* LCM_UINT64_T not defined */
typedef LCM_UINT64_T LCMUint64;
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

#ifndef LCM_INT8_T
#define LCM_INT8_T signed char
#endif /* LCM_INT8_T not defined */
typedef LCM_INT8_T LCMInt8;

#ifndef LCM_INT16_T
#define LCM_INT16_T signed short int
#endif /* LCM_INT16_T not defined */
typedef LCM_INT16_T LCMInt16;

#ifndef LCM_INT32_T
#define LCM_INT32_T signed long int
#endif /* LCM_INT32_T not defined */
typedef LCM_INT32_T LCMInt32;

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
#ifndef LCM_INT64_T
#define LCM_INT64_T signed long long int
#endif /* LCM_INT64_T not defined */
typedef LCM_INT64_T LCMInt64;
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

#ifndef LCM_FLOAT32_T
#define LCM_FLOAT32_T float
#endif /* LCM_FLOAT32_T not defined */
typedef LCM_FLOAT32_T LCMFloat32;

#ifndef LCM_FLOAT64_T
#define LCM_FLOAT64_T double
#endif /* LCM_FLOAT64_T not defined */
typedef LCM_FLOAT64_T LCMFloat64;

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
#ifndef LCM_FLOAT128_T
#define LCM_FLOAT128_T long double
#endif /* LCM_FLOAT128_T not defined */
typedef LCM_FLOAT128_T LCMFloat128;
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */


#ifndef LCM_CHAR8_T
#define LCM_CHAR8_T char
#endif /* LCM_CHAR8_T not defined */
typedef LCM_CHAR8_T LCMChar8;

/*
#ifndef LCM_MAX_STRING8_LENGTH
#define LCM_MAX_STRING8_LENGTH (80)
#endif 
*/

#ifndef MAX_LCMString8_LENGTH 
/* DO NOT REMOVE THE BRACKETS */
#define MAX_LCMString8_LENGTH (81)
#endif /*MAX_LCMString8_LENGTH not defined */

#ifndef LCM_STRING8_T
/*#define LCM_STRING8_T struct { char content[LCM_MAX_STRING8_LENGTH+1]; }*/
#define LCM_STRING8_T struct { char content [MAX_LCMString8_LENGTH]; }
#endif /* LCM_STRING8_T not defined */
typedef LCM_STRING8_T LCMString8;

/* C++ Protection */
#ifdef __cplusplus
} /* extern "C" */ 
#endif

#endif /* LCMPREDEFINEDTYPES_h */


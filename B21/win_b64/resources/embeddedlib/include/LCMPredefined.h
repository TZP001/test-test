/* COPYRIGHT Dassault Systemes 2004
**===================================================================
**
** LCMPredefined.h
**
**===================================================================
**
**   LCM predefined constants, types, structures and functions.
**
**===================================================================
**
**  LCM studio V5R17 for Wintel platform (MS Windows / Intel X86)
**
**===================================================================*/
#ifndef LCMPREDEFINED_h
#define LCMPREDEFINED_h

/* C++ Protection */
#ifdef __cplusplus
extern "C" { 
#endif
#include <AUTLciVMPredefinedTypes.h>

typedef enum
{
  LCM_OK = 0,
  LCM_FAIL = -1
} LCMStatus;

#define LCM_FRCNGS_PRE_REACT  (1)
#define LCM_FRCNGS_POST_REACT (2)

/* LCMBool */
#define LCM_TRUE    (1)
#define LCM_FALSE   (0)



/*
** Rotate functions for LCM Boolean vectors
*/
extern LCMWord8  lcmRorWord8 (const LCMWord8 data,  const LCMUint32 nbBools);
extern LCMWord16 lcmRorWord16(const LCMWord16 data, const LCMUint32 nbBools);
extern LCMWord32 lcmRorWord32(const LCMWord32 data, const LCMUint32 nbBools);
#ifdef ARCH_SUPPORTS_64_BIT_VALUE
extern LCMWord64 lcmRorWord64(const LCMWord64 data, const LCMUint32 nbBools);
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

extern LCMWord8  lcmRolWord8 (const LCMWord8 data,  const LCMUint32 nbBools);
extern LCMWord16 lcmRolWord16(const LCMWord16 data, const LCMUint32 nbBools);
extern LCMWord32 lcmRolWord32(const LCMWord32 data, const LCMUint32 nbBools);
#ifdef ARCH_SUPPORTS_64_BIT_VALUE
extern LCMWord64 lcmRolWord64(const LCMWord64 data, const LCMUint32 nbBools);
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
extern LCMInt64 pow_LCMInt64(LCMInt64 x, LCMInt64 y);
extern LCMUint64 pow_LCMUint64(LCMUint64 x, LCMUint64 y);
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */


extern LCMBool lcmEqString8(LCMString8 x, LCMString8 y);
extern LCMBool lcmNeqString8(LCMString8 x, LCMString8 y);
extern LCMBool lcmLessString8 (LCMString8 x, LCMString8 y);
extern LCMBool lcmGreaterString8 (LCMString8 x, LCMString8 y);
extern LCMBool lcmLessequalString8 (LCMString8 x, LCMString8 y);
extern LCMBool lcmGreaterequalString8 (LCMString8 x, LCMString8 y);
extern LCMString8 lcmConcatString8 (LCMString8 x, LCMString8 y);


/*
** Serialization/Deserialization functions for LCM predefined types
*/
/* LCM boolean and boolean arrays*/
extern LCMUint32 _serialize_LCMBool(LCMByte *pBuff, LCMBool *pData);
extern LCMUint32 _deserialize_LCMBool(LCMBool *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMWord8(LCMByte *pBuff, LCMWord8 *pData);
extern LCMUint32 _deserialize_LCMWord8(LCMWord8 *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMWord16(LCMByte *pBuff, LCMWord16 *pData);
extern LCMUint32 _deserialize_LCMWord16(LCMWord16 *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMWord32(LCMByte *pBuff, LCMWord32 *pData);
extern LCMUint32 _deserialize_LCMWord32(LCMWord32 *pData, LCMByte *pBuff);
#ifdef ARCH_SUPPORTS_64_BIT_VALUE
extern LCMUint32 _serialize_LCMWord64(LCMByte *pBuff, LCMWord64 *pData);
extern LCMUint32 _deserialize_LCMWord64(LCMWord64 *pData, LCMByte *pBuff);
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

/* LCM unsigned integers */
extern LCMUint32 _serialize_LCMUint8(LCMByte *pBuff, LCMUint8 *pData);
extern LCMUint32 _deserialize_LCMUint8(LCMUint8 *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMUint16(LCMByte *pBuff, LCMUint16 *pData);
extern LCMUint32 _deserialize_LCMUint16(LCMUint16 *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMUint32(LCMByte *pBuff, LCMUint32 *pData);
extern LCMUint32 _deserialize_LCMUint32(LCMUint32 *pData, LCMByte *pBuff);
#ifdef ARCH_SUPPORTS_64_BIT_VALUE
extern LCMUint32 _serialize_LCMUint64(LCMByte *pBuff, LCMUint64 *pData);
extern LCMUint32 _deserialize_LCMUint64(LCMUint64 *pData, LCMByte *pBuff);
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

/* LCM integer */
extern LCMUint32 _serialize_LCMInt8(LCMByte *pBuff, LCMInt8 *pData);
extern LCMUint32 _deserialize_LCMInt8(LCMInt8 *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMInt16(LCMByte *pBuff, LCMInt16 *pData);
extern LCMUint32 _deserialize_LCMInt16(LCMInt16 *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMInt32(LCMByte *pBuff, LCMInt32 *pData);
extern LCMUint32 _deserialize_LCMInt32(LCMInt32 *pData, LCMByte *pBuff);
#ifdef ARCH_SUPPORTS_64_BIT_VALUE
extern LCMUint32 _serialize_LCMInt64(LCMByte *pBuff, LCMInt64 *pData);
extern LCMUint32 _deserialize_LCMInt64(LCMInt64 *pData, LCMByte *pBuff);
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

/* LCM floating-point */
extern LCMUint32 _serialize_LCMFloat32(LCMByte *pBuff, LCMFloat32 *pData);
extern LCMUint32 _deserialize_LCMFloat32(LCMFloat32 *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMFloat64(LCMByte *pBuff, LCMFloat64 *pData);
extern LCMUint32 _deserialize_LCMFloat64(LCMFloat64 *pData, LCMByte *pBuff);

/* LCM char and string */
extern LCMUint32 _serialize_LCMChar8(LCMByte *pBuff, LCMChar8 *pData);
extern LCMUint32 _deserialize_LCMChar8(LCMChar8 *pData, LCMByte *pBuff);
extern LCMUint32 _serialize_LCMString8(LCMByte *pBuff, LCMString8 *pData);
extern LCMUint32 _deserialize_LCMString8(LCMString8 *pData, LCMByte *pBuff);

/* Execution context */
typedef enum
{
  LCM_APP_ENDED  = 0,
  LCM_APP_ACTIVE = 1
} LCM_APP_ACTIVITY;

typedef union
{
  LCMBool        boolVal;
  LCMWord8       word8Val;
  LCMWord16      word16Val;
  LCMWord32      word32Val;
#ifdef ARCH_SUPPORTS_64_BIT_VALUE
  LCMWord64      word64Val;
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */
  LCMUint8       uint8Val;
  LCMUint16      uint16Val;
  LCMUint32      uint32Val;
#ifdef ARCH_SUPPORTS_64_BIT_VALUE
  LCMUint64      uint64Val;
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */
  LCMInt8        int8Val;
  LCMInt16       int16Val;
  LCMInt32       int32Val;
#ifdef ARCH_SUPPORTS_64_BIT_VALUE
  LCMInt64       int64Val;
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */
  LCMFloat32     float32Val;
  LCMFloat64     float64Val;
  LCMChar8       char8Val;
  LCMString8    string8Val;
} LCM_ANY_TYPE;

typedef struct
{
	 LCMUint32      cycleTime;
	 LCMBool        reset;
	 LCMBool        ended;
} LCM_APP_INFO;


/* C++ Protection */
#ifdef __cplusplus
} /* extern "C" */ 
#endif

#endif /* LCMPREDEFINED_h */


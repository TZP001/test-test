/* COPYRIGHT Dassault Systemes 2004
**===================================================================
**
** LCMPredefined.c
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
#include <string.h>		/* strcpy(), strcmp(), strcat(), memset()  */
#include <stdlib.h>
#include "LCMPredefined.h"



LCMWord8  lcmRorWord8 (const LCMWord8 data, const LCMUint32 nbBools)
{
  LCMUint32   idxBit = 0U; /* 8-boolean vector */
  LCMWord8    result = data;
  
  for (idxBit = nbBools%8U; idxBit > 0U; idxBit--)
  {
    if ((result & 0x01U) != 0U)
    { result = (result >> 1) | 0x80U; }
    else
    { result = (result >> 1) & 0x7FU; }
  }
  return (result);
  
} /* End of function _lcmRorWord8() */

LCMWord16 lcmRorWord16(const LCMWord16 data, const LCMUint32 nbBools)
{
  LCMUint32   idxBit = 0U;
  LCMWord16   result = data;
  
  for (idxBit = nbBools%16U; idxBit > 0U ; idxBit--)
  {
    if ((result & 0x0001U) != 0U)
    { result = (result >> 1) | 0x8000U; }
    else
    { result = (result >> 1) & 0x7FFFU; }
  }
  return (result);
  
} /* End of function _lcmRorWord16() */

LCMWord32 lcmRorWord32(const LCMWord32 data, const LCMUint32 nbBools)
{
  LCMUint32   idxBit = 0U;
  LCMWord32   result = data;
  
  for (idxBit = nbBools%32U; idxBit > 0U ; idxBit--)
  {
    if ((result & 0x00000001UL) != 0U)
    { result = (result >> 1) | 0x80000000UL; }
    else
    { result = (result >> 1) & 0x7FFFFFFFUL; }
  }
  return (result);
  
} /* End of function _lcmRorWord32() */

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
LCMWord64 lcmRorWord64(const LCMWord64 data, const LCMUint32 nbBools)
{
  LCMUint32   idxBit = 0U;
  LCMWord64   result = data;
  
  for (idxBit = nbBools%64U; idxBit > 0U ; idxBit--)
  {
    if ((result & 0x0000000000000001UL) != 0U)
    { result = (result >> 1) | 0x8000000000000000UL; }
    else
    { result = (result >> 1) & 0x7FFFFFFFFFFFFFFFUL; }
  }
  return (result);
  
} /* End of function _lcmRorWord64() */
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

LCMWord8  lcmRolWord8 (const LCMWord8 data,  const LCMUint32 nbBools)
{
  LCMUint32   idxBit = 0U;
  LCMWord8    result = data;
  
  for (idxBit = nbBools%8U; idxBit > 0U ; idxBit--)
  {
    if ((result & 0x80U) != 0U)
    { result = (result << 1) | 0x01; }
    else
    { result = (result << 1); }
  }
  return (result);
  
} /* End of function _lcmRolWord8() */

LCMWord16 lcmRolWord16(const LCMWord16 data, const LCMUint32 nbBools)
{
  LCMUint32   idxBit = 0U;
  LCMWord16   result = data;
  
  for (idxBit = nbBools%16U; idxBit > 0U ; idxBit--)
  {
    if ((result & 0x8000U) != 0U)
    { result = (result << 1) | 0x0001U; }
    else
    { result = (result << 1); }
  }
  return (result);
  
} /* End of function _lcmRolWord16() */

LCMWord32 lcmRolWord32(const LCMWord32 data, const LCMUint32 nbBools)
{
  LCMUint32   idxBit = 0U;
  LCMWord32   result = data;
  
  for (idxBit = nbBools%32U; idxBit > 0U ; idxBit--)
  {
    if ((result & 0x80000000UL) != 0U)
    { result = (result << 1) | 0x00000001UL; }
    else
    { result = (result << 1); }
  }
  return (result);
  
} /* End of function _lcmRolWord32() */

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
LCMWord64 lcmRolWord64(const LCMWord64 data, const LCMUint32 nbBools)
{
  LCMUint32   idxBit = 0U;
  LCMWord64   result = data;
  
  for (idxBit = nbBools%64U; idxBit > 0U ; idxBit--)
  {
    if ((result & 0x8000000000000000UL) != 0U)
    { result = (result << 1) | 0x0000000000000001UL; }
    else
    { result = (result << 1); }
  }
  return (result);
  
} /* End of function _lcmRolWord64() */
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
LCMInt64 powLCMInt64(LCMInt64 x, LCMInt64 y) 
{ 
	LCMInt64 res = 0;
	LCMInt64 pre_res = res;
	int i;
#ifdef AUTLCI_INCATIA
	if (0 > y)
		caml_raise_failure("negative exponent in integer power function");
#endif
	if (0 <= y)
	{
		res = 1;
		pre_res = res;
		for ( i = 0; i < y && ((pre_res >0? pre_res : -pre_res) <= (res>0? res : -res)); i++){
			pre_res = res;
			res *= x;
		}
#ifdef AUTLCI_INCATIA
	if ((pre_res >0? pre_res : -pre_res) > (res>0? res : -res))
		caml_raise_failure("integer overflow");
#endif
	}
	return res;
}
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

#ifdef ARCH_SUPPORTS_64_BIT_VALUE
LCMUint64 powLCMUint64(LCMUint64 x, LCMUint64 y) 
{	
	LCMUint64 res = 1;
	LCMUint64 pre_res = res;
	int i = 0;

	for (i = 0; i < y && pre_res <= res; i++){
		pre_res = res;
		res *= x;
	}
#ifdef AUTLCI_INCATIA
	if (pre_res > res)
		caml_raise_failure("integer overflow");
#endif
	return res;
}
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */

LCMBool lcmEqString8(LCMString8 x, LCMString8 y)
{ return (LCMBool)(strncmp(x.content, y.content, MAX_LCMString8_LENGTH) == 0); }

LCMBool lcmNeqString8(LCMString8 x, LCMString8 y)
{ return (LCMBool)(strncmp(x.content, y.content, MAX_LCMString8_LENGTH) != 0); }

LCMBool lcmLessString8 (LCMString8 x, LCMString8 y)
{ return (LCMBool)(strncmp(x.content, y.content, MAX_LCMString8_LENGTH) < 0); }

LCMBool lcmGreaterString8 (LCMString8 x, LCMString8 y)
{ return (LCMBool)(strncmp(x.content, y.content, MAX_LCMString8_LENGTH) > 0); }

LCMBool lcmLessequalString8 (LCMString8 x, LCMString8 y)
{ return (LCMBool)(strncmp(x.content, y.content, MAX_LCMString8_LENGTH) <= 0); }

LCMBool lcmGreaterequalString8 (LCMString8 x, LCMString8 y)
{ return (LCMBool)(strncmp(x.content, y.content, MAX_LCMString8_LENGTH) >= 0); }

LCMString8 lcmConcatString8 (LCMString8 x, LCMString8 y)
{ 
	LCMString8 result;
	strncpy(result.content,x.content, MAX_LCMString8_LENGTH);
	strncat(result.content, y.content, MAX_LCMString8_LENGTH);
	result.content[MAX_LCMString8_LENGTH-1]='\0';
	/*fprintf(stderr,"concat (%s, %s) = %s",x.content, y.content, result.content);*/
	return (result); 
}

/* LCMBool */
LCMUint32 _serialize_LCMBool(LCMByte *pBuff, LCMBool *pData)
{
  if (pBuff != NULL)
  {
    *((LCMBool *)pBuff) = *pData;
  }
  return (1 * sizeof(LCMByte));

} /* End of function _serialize_LCMBool() */

LCMUint32 _deserialize_LCMBool(LCMBool *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = *((LCMBool *)pBuff);
  }
  return (1 * sizeof(LCMByte));

} /* End of function _deserialize_LCMBool() */

LCMUint32 _serialize_LCMWord8(LCMByte *pBuff, LCMWord8 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData);
  }
  return (1 * sizeof(LCMByte));

} /* End of function _serialize_LCMWord8() */

LCMUint32 _deserialize_LCMWord8(LCMWord8 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = pBuff[0];
  }
  return (1 * sizeof(LCMByte));

} /* End of function _deserialize_LCMWord8() */



/* LCMWord16 */
LCMUint32 _serialize_LCMWord16(LCMByte *pBuff, LCMWord16 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 8);
    pBuff[1] = (LCMByte) (*pData);
  }
  return (2 * sizeof(LCMByte));

} /* End of function _serialize_LCMWord16() */

LCMUint32 _deserialize_LCMWord16(LCMWord16 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 8) + pBuff[1];
  }
  return (2 * sizeof(LCMByte));

} /* End of function _deserialize_LCMWord16() */



/* LCMWord32 */
LCMUint32 _serialize_LCMWord32(LCMByte *pBuff, LCMWord32 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 24);
    pBuff[1] = (LCMByte) (*pData >> 16);
    pBuff[2] = (LCMByte) (*pData >> 8);
    pBuff[3] = (LCMByte) (*pData);
  }
  return (4 * sizeof(LCMByte));

} /* End of function _serialize_LCMWord32() */

LCMUint32 _deserialize_LCMWord32(LCMWord32 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 24) + (pBuff[1] << 16) + (pBuff[2] << 8) + pBuff[3];
  }
  return (4 * sizeof(LCMByte));

} /* End of function _deserialize_LCMWord32() */



#ifdef ARCH_SUPPORTS_64_BIT_VALUE
/* LCMWord64 */
LCMUint32 _serialize_LCMWord64(LCMByte *pBuff, LCMWord64 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 56);
    pBuff[1] = (LCMByte) (*pData >> 48);
    pBuff[2] = (LCMByte) (*pData >> 40);
    pBuff[3] = (LCMByte) (*pData >> 32);
    pBuff[4] = (LCMByte) (*pData >> 24);
    pBuff[5] = (LCMByte) (*pData >> 16);
    pBuff[6] = (LCMByte) (*pData >> 8);
    pBuff[7] = (LCMByte) (*pData);
  }
  return (8 * sizeof(LCMByte));

} /* End of function _serialize_LCMWord64() */

LCMUint32 _deserialize_LCMWord64(LCMWord64 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 56) + (pBuff[1] << 48) + (pBuff[2] << 40) + (pBuff[3] << 32) +
             (pBuff[4] << 24) + (pBuff[5] << 16) + (pBuff[6] << 8) + pBuff[7];
  }
  return (8 * sizeof(LCMByte));

} /* End of function _deserialize_LCMWord64() */
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */






/* LCMUint8 */
LCMUint32 _serialize_LCMUint8(LCMByte *pBuff, LCMUint8 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData);
  }
  return (1 * sizeof(LCMByte));

} /* End of function _serialize_LCMUint8() */

LCMUint32 _deserialize_LCMUint8(LCMUint8 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = pBuff[0];
  }
  return (1 * sizeof(LCMByte));

} /* End of function _deserialize_LCMUint8() */



/* LCMUint16 */
LCMUint32 _serialize_LCMUint16(LCMByte *pBuff, LCMUint16 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 8);
    pBuff[1] = (LCMByte) (*pData);
  }
  return (2 * sizeof(LCMByte));

} /* End of function _serialize_LCMUint16() */

LCMUint32 _deserialize_LCMUint16(LCMUint16 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 8) + pBuff[1];
  }
  return (2 * sizeof(LCMByte));

} /* End of function _deserialize_LCMUint16() */



/* LCMUint32 */
LCMUint32 _serialize_LCMUint32(LCMByte *pBuff, LCMUint32 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 24);
    pBuff[1] = (LCMByte) (*pData >> 16);
    pBuff[2] = (LCMByte) (*pData >> 8);
    pBuff[3] = (LCMByte) (*pData);
  }
  return (4 * sizeof(LCMByte));

} /* End of function _serialize_LCMUint32() */

LCMUint32 _deserialize_LCMUint32(LCMUint32 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 24) + (pBuff[1] << 16) + (pBuff[2] << 8) + pBuff[3];
  }
  return (4 * sizeof(LCMByte));

} /* End of function _deserialize_LCMUint32() */



#ifdef ARCH_SUPPORTS_64_BIT_VALUE
/* LCMUint64 */
LCMUint32 _serialize_LCMUint64(LCMByte *pBuff, LCMUint64 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 56);
    pBuff[1] = (LCMByte) (*pData >> 48);
    pBuff[2] = (LCMByte) (*pData >> 40);
    pBuff[3] = (LCMByte) (*pData >> 32);
    pBuff[4] = (LCMByte) (*pData >> 24);
    pBuff[5] = (LCMByte) (*pData >> 16);
    pBuff[6] = (LCMByte) (*pData >> 8);
    pBuff[7] = (LCMByte) (*pData);
  }
  return (8 * sizeof(LCMByte));

} /* End of function _serialize_LCMUint64() */

LCMUint32 _deserialize_LCMUint64(LCMUint64 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 56) + (pBuff[1] << 48) + (pBuff[2] << 40) + (pBuff[3] << 32) +
             (pBuff[4] << 24) + (pBuff[5] << 16) + (pBuff[6] << 8) + pBuff[7];
  }
  return (8 * sizeof(LCMByte));

} /* End of function _deserialize_LCMUint64() */
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */






/* LCMInt8 */
LCMUint32 _serialize_LCMInt8(LCMByte *pBuff, LCMInt8 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData);
  }
  return (1 * sizeof(LCMByte));

} /* End of function _serialize_LCMInt8() */

LCMUint32 _deserialize_LCMInt8(LCMInt8 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = pBuff[0];
  }
  return (1 * sizeof(LCMByte));

} /* End of function _deserialize_LCMInt8() */



/* LCMInt16 */
LCMUint32 _serialize_LCMInt16(LCMByte *pBuff, LCMInt16 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 8);
    pBuff[1] = (LCMByte) (*pData);
  }
  return (2 * sizeof(LCMByte));

} /* End of function _serialize_LCMInt16() */

LCMUint32 _deserialize_LCMInt16(LCMInt16 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 8) + pBuff[1];
  }
  return (2 * sizeof(LCMByte));

} /* End of function _deserialize_LCMInt16() */



/* LCMInt32 */
LCMUint32 _serialize_LCMInt32(LCMByte *pBuff, LCMInt32 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 24);
    pBuff[1] = (LCMByte) (*pData >> 16);
    pBuff[2] = (LCMByte) (*pData >> 8);
    pBuff[3] = (LCMByte) (*pData);
  }
  return (4 * sizeof(LCMByte));

} /* End of function _serialize_LCMInt32() */

LCMUint32 _deserialize_LCMInt32(LCMInt32 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 24) + (pBuff[1] << 16) + (pBuff[2] << 8) + pBuff[3];
  }
  return (4 * sizeof(LCMByte));

} /* End of function _deserialize_LCMInt32() */



#ifdef ARCH_SUPPORTS_64_BIT_VALUE
/* LCMInt64 */
LCMUint32 _serialize_LCMInt64(LCMByte *pBuff, LCMInt64 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*pData >> 56);
    pBuff[1] = (LCMByte) (*pData >> 48);
    pBuff[2] = (LCMByte) (*pData >> 40);
    pBuff[3] = (LCMByte) (*pData >> 32);
    pBuff[4] = (LCMByte) (*pData >> 24);
    pBuff[5] = (LCMByte) (*pData >> 16);
    pBuff[6] = (LCMByte) (*pData >> 8);
    pBuff[7] = (LCMByte) (*pData);
  }
  return (8 * sizeof(LCMByte));

} /* End of function _serialize_LCMInt64() */

LCMUint32 _deserialize_LCMInt64(LCMInt64 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = (pBuff[0] << 56) + (pBuff[1] << 48) + (pBuff[2] << 40) + (pBuff[3] << 32) +
             (pBuff[4] << 24) + (pBuff[5] << 16) + (pBuff[6] << 8) + pBuff[7];
  }
  return (8 * sizeof(LCMByte));

} /* End of function _deserialize_LCMInt64() */
#endif /* ARCH_SUPPORTS_64_BIT_VALUE not defined */






/* LCMFloat32 */
LCMUint32 _serialize_LCMFloat32(LCMByte *pBuff, LCMFloat32 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*(LCMUint32 *)pData >> 24);
    pBuff[1] = (LCMByte) (*(LCMUint32 *)pData >> 16);
    pBuff[2] = (LCMByte) (*(LCMUint32*)pData >> 8);
    pBuff[3] = (LCMByte) (*(LCMUint32 *)pData);
  }
  return (4 * sizeof(LCMByte));

} /* End of function _serialize_LCMFloat32() */

LCMUint32 _deserialize_LCMFloat32(LCMFloat32 *pData, LCMByte *pBuff)
{
  if (pData != NULL) 
  {
    *(LCMUint32 *)pData = (pBuff[0] << 24) + (pBuff[1] << 16) + (pBuff[2] << 8) + pBuff[3];
  }
  return (4 * sizeof(LCMByte));

} /* End of function _deserialize_LCMFloat32() */

/* LCMFloat64 */
LCMUint32 _serialize_LCMFloat64(LCMByte *pBuff, LCMFloat64 *pData)
{
  if (pBuff != NULL)
  {
    pBuff[0] = (LCMByte) (*((LCMUint32 *)pData + 1) >> 24);
    pBuff[1] = (LCMByte) (*((LCMUint32 *)pData + 1) >> 16);
    pBuff[2] = (LCMByte) (*((LCMUint32 *)pData + 1) >> 8);
    pBuff[3] = (LCMByte) (*((LCMUint32 *)pData + 1));
    pBuff[4] = (LCMByte) (*(LCMUint32 *)pData >> 24);
    pBuff[5] = (LCMByte) (*(LCMUint32 *)pData >> 16);
    pBuff[6] = (LCMByte) (*(LCMUint32 *)pData >> 8);
    pBuff[7] = (LCMByte) (*(LCMUint32 *)pData);
  }
  return (8 * sizeof(LCMByte));

} /* End of function _serialize_LCMFloat64() */



LCMUint32 _deserialize_LCMFloat64(LCMFloat64 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *((LCMUint32 *)pData + 1) = (pBuff[0] << 24) + (pBuff[1] << 16) + (pBuff[2] << 8) + pBuff[3];
    *(LCMUint32 *)pData = (pBuff[4] << 24) + (pBuff[5] << 16) + (pBuff[6] << 8) + pBuff[7];
  }
  return (8 * sizeof(LCMByte));

} /* End of function _deserialize_LCMFloat64() */



/* LCMChar8 */
LCMUint32 _serialize_LCMChar8(LCMByte *pBuff, LCMChar8 *pData)
{
  if (pBuff != NULL)
  {
    *((LCMBool *)pBuff) = *pData;
  }
  return (1 * sizeof(LCMBool));

} /* End of function _serialize_LCMChar8() */

LCMUint32 _deserialize_LCMChar8(LCMChar8 *pData, LCMByte *pBuff)
{
  if (pData != NULL)
  {
    *pData = *((LCMChar8 *)pBuff);
  }
  return (1 * sizeof(LCMByte));

} /* End of function _deserialize_LCMBool() */

/* LCM string */
LCMUint32 _serialize_LCMString8(LCMByte *pBuff, LCMString8 *pData)
{
  LCMUint32 nbBytes = 0;
  if (pBuff != NULL)
  {
    for (nbBytes = 0; ( ((pData->content)[nbBytes] != '\0') && (nbBytes < MAX_LCMString8_LENGTH) ); nbBytes++)
    { pBuff[nbBytes] = (pData->content)[nbBytes]; }
    pBuff[nbBytes] = '\0';
    nbBytes = nbBytes + 1;
  }
  else
  {
    nbBytes = MAX_LCMString8_LENGTH;
  }
  return (nbBytes);

} /* End of function _serialize_LCMString8() */

LCMUint32 _deserialize_LCMString8(LCMString8 *pData, LCMByte *pBuff)
{
  LCMUint32 nbBytes = 0;
  if ( (pBuff != NULL) && (pData != NULL) )
  {
    for (nbBytes = 0; ( (pBuff[nbBytes] != '\0') && (nbBytes < MAX_LCMString8_LENGTH) ); nbBytes++)
    { (pData->content)[nbBytes] = pBuff[nbBytes]; }
    pData->content[nbBytes] = '\0';
    nbBytes = nbBytes + 1;
  }
  return (nbBytes);

} /* End of function _deserialize_LCMString8() */





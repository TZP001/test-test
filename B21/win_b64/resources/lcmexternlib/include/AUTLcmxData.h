#ifndef _AUTLCMX_DATA
#define _AUTLCMX_DATA
#include "AUTLciVMExterns.h"
#include "AUTLciVMPredefined.h"


typedef struct {
  int kind;   /* AUTLCMX_TYPE_ARRAY | AUTLCMX_TYPE_RECORD | AUTLCMX_TYPE_TUPLE | AUTLCMX_TYPE_SCALAR | ... */
  void *info; /* AUTLcmxArray* | AUTLcmxRecord* | AUTLcmxTuple* | AUTLcmxScalar* | ...*/
  void *data; /* <type of scalar>* if kind = (Array of) Scalar, AUTLcmxData** otherwise */
  void *reserved;
} AUTLcmxData;

typedef AUTLcmxData *AUTLcmxDataPtr;

#define AUTLCMX_KIND_ARRAY 0
#define AUTLCMX_KIND_RECORD 1
#define AUTLCMX_KIND_TUPLE 2
#define AUTLCMX_KIND_SCALAR 3


typedef struct {
  int dim;
  int *sizes;
  int elem_kind;
  AUTLcmxScalar * scalar_info;
} AUTLcmxArray;

typedef struct {
  int nfields;
  LCMString8 *field_names;
} AUTLcmxRecord;

typedef struct {
  int nfields;
} AUTLcmxTuple;

/* In AUTLciVMPredefinedTypes.h :
typedef struct {
  int size;
  AUTLcmxScalarToText toText;
} AUTLcmxScalar;
*/

typedef AUTLcmxArray *AUTLcmxArrayPtr;
typedef AUTLcmxRecord *AUTLcmxRecordPtr;
typedef AUTLcmxTuple *AUTLcmxTuplePtr;

typedef int AUTLcmxResult;
typedef AUTLcmxResult (*AUTLcmxFunctionPtr)(AUTLcmxDataPtr lhs_data, AUTLcmxDataPtr rhs_data);

typedef LCMInt32 *LCMInt32Ptr;
typedef void *voidPtr;

#define getAdr(X) ((voidPtr)(&X))
#define nullAdr NULL

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxScalarData(voidPtr data, AUTLcmxScalarPtr info);


/* 
 * Generic funs 
 */

ExportedByAUTLciVMExternsC void *AUTLcmxGetData(AUTLcmxData *data);

ExportedByAUTLciVMExternsC void AUTLcmxSetData(AUTLcmxData *data, void *new_data);

ExportedByAUTLciVMExternsC int AUTLcmxIsArray(AUTLcmxData *data);

ExportedByAUTLciVMExternsC int AUTLcmxIsRecord(AUTLcmxData *data);

ExportedByAUTLciVMExternsC int AUTLcmxIsTuple(AUTLcmxData *data);

ExportedByAUTLciVMExternsC int AUTLcmxIsScalar(AUTLcmxData *data);


/*
 * Delete funs
 */

ExportedByAUTLciVMExternsC LCMInt32 AUTLcmxDataDeleteAllLevel(AUTLcmxDataPtr toDelete);
ExportedByAUTLciVMExternsC LCMInt32 AUTLcmxDataDeleteOneLevel(AUTLcmxDataPtr toDelete);

/*
 * Scalar funs 
 */

ExportedByAUTLciVMExternsC int AUTLcmxGetScalarSize(AUTLcmxDataPtr scalar);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxCreateScalar(AUTLcmxScalarPtr scalar_info);


/*
 * Record funs 
 */

ExportedByAUTLciVMExternsC int AUTLcmxGetRecordNumberOfFields(AUTLcmxDataPtr record);

ExportedByAUTLciVMExternsC LCMString8 AUTLcmxGetRecordFieldName(AUTLcmxDataPtr record, LCMInt32 index);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxSetRecordFieldName(AUTLcmxDataPtr record, LCMString8 field_name, LCMInt32 index);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxGetRecordField(AUTLcmxDataPtr record, LCMString8 field_name);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxSetRecordField(AUTLcmxDataPtr record, AUTLcmxDataPtr field, LCMString8 field_name);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxCreateRecord(LCMInt32 nfields);


/*
 * Tuple funs 
 */

ExportedByAUTLciVMExternsC int AUTLcmxGetTupleNumberOfFields(AUTLcmxDataPtr tuple);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxGetTupleField(AUTLcmxDataPtr tuple, LCMInt32 index);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxSetTupleField(AUTLcmxDataPtr tuple, AUTLcmxDataPtr field, LCMInt32 index);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxCreateTuple(LCMInt32 nfields);


/*
 * Array funs 
 */

ExportedByAUTLciVMExternsC int GetArrayAccessNbElem(AUTLcmxArray *info, int dim);
ExportedByAUTLciVMExternsC int GetArrayNbElem(AUTLcmxArray *info);
ExportedByAUTLciVMExternsC int GetArrayAccessSize(AUTLcmxArray *info, int dim);
ExportedByAUTLciVMExternsC int GetArraySize(AUTLcmxArray *info);

ExportedByAUTLciVMExternsC int AUTLcmxGetArrayDimension(AUTLcmxData *array);
ExportedByAUTLciVMExternsC int *AUTLcmxGetArraySizes(AUTLcmxData *array);
ExportedByAUTLciVMExternsC int AUTLcmxGetArrayElemKind(AUTLcmxData *array);
ExportedByAUTLciVMExternsC AUTLcmxScalar *AUTLcmxGetArrayScalarInfo(AUTLcmxData *array);

ExportedByAUTLciVMExternsC voidPtr AUTLcmxGetArrayElem(AUTLcmxDataPtr array, LCMInt32 dim, LCMInt32Ptr sizes);
ExportedByAUTLciVMExternsC voidPtr AUTLcmxGetVectorElem(AUTLcmxDataPtr vector, LCMInt32 index);
ExportedByAUTLciVMExternsC voidPtr AUTLcmxGetMatrixElem(AUTLcmxDataPtr matrix, LCMInt32 i, LCMInt32 j);

ExportedByAUTLciVMExternsC pure AUTLcmxSetArrayElem(AUTLcmxDataPtr array, voidPtr field, LCMInt32 dim, LCMInt32Ptr sizes);
ExportedByAUTLciVMExternsC pure AUTLcmxSetVectorElem(AUTLcmxDataPtr vector, voidPtr field, LCMInt32 i);
ExportedByAUTLciVMExternsC pure AUTLcmxSetMatrixElem(AUTLcmxDataPtr matrix, voidPtr field, LCMInt32 i, LCMInt32 j);

ExportedByAUTLciVMExternsC pure AUTLcmxCopyArrayElem(AUTLcmxDataPtr array, voidPtr field, LCMInt32 dim, LCMInt32Ptr sizes);
ExportedByAUTLciVMExternsC pure AUTLcmxCopyVectorElem(AUTLcmxDataPtr vector, voidPtr field, LCMInt32 i);
ExportedByAUTLciVMExternsC pure AUTLcmxCopyMatrixElem(AUTLcmxDataPtr matrix, voidPtr field, LCMInt32 i, LCMInt32 j);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxCreateArray(LCMInt32 dim, LCMInt32Ptr sizes, LCMInt32 elem_kind, AUTLcmxScalarPtr scalar_info);
ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxCreateVector(LCMInt32 size, LCMInt32 elem_type, AUTLcmxScalarPtr scalar_info);
ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxCreateMatrix(LCMInt32 n1, LCMInt32 n2, LCMInt32 elem_type, AUTLcmxScalarPtr scalar_info);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxFillArrayWithClones(AUTLcmxDataPtr array, AUTLcmxDataPtr elem);
ExportedByAUTLciVMExternsC pure AUTLcmxFillArray(AUTLcmxDataPtr array, voidPtr element);

ExportedByAUTLciVMExternsC LCMInt32Ptr AUTLcmxCreateDim(LCMInt32 dim);
ExportedByAUTLciVMExternsC LCMInt32Ptr AUTLcmxSetDimSize(LCMInt32Ptr dim, LCMInt32 size, LCMInt32 pos);

ExportedByAUTLciVMExternsC AUTLcmxDataPtr AUTLcmxGetElemFromArray(AUTLcmxDataPtr iArray, LCMInt32 index) ; /* bpz */

/* 
 * Copy fun 
 */

ExportedByAUTLciVMExternsC pure AUTLcmxDataPtrCopy(AUTLcmxDataPtr dest, voidPtr data);
ExportedByAUTLciVMExternsC pure AUTLcmxDataPtrCopyArrayData(AUTLcmxDataPtr dest, voidPtr src);

/* Copy in a new memory allocated structure. Return 0 if all ok */
ExportedByAUTLciVMExternsC int AUTLcmxCopyData(AUTLcmxData *src, AUTLcmxData **target);

/*
 * Type funs 
 */

ExportedByAUTLciVMExternsC int Assign_AUTLcmxDataPtr_2(AUTLcmxDataPtr iTarget, AUTLcmxDataPtr iSource) ; 

ExportedByAUTLciVMExternsC void assign_AUTLcmxDataPtr(AUTLcmxDataPtr* left, AUTLcmxDataPtr right);
ExportedByAUTLciVMExternsC char * AUTLcmxDataPtr_to_text(AUTLcmxDataPtr *x);
ExportedByAUTLciVMExternsC void text_to_AUTLcmxDataPtr(AUTLcmxDataPtr *x, char *y);
ExportedByAUTLciVMExternsC unsigned char eq_AUTLcmxDataPtr(AUTLcmxDataPtr lhs_data, AUTLcmxDataPtr rhs_data);
ExportedByAUTLciVMExternsC AUTLcmxScalarPtr info_AUTLcmxDataPtr(void);

#define assign_AUTLcmxArrayPtr(X,Y) ((*X) = (Y))
#define eq_AUTLcmxArrayPtr(X,Y) ((X) == (Y))
ExportedByAUTLciVMExternsC char * AUTLcmxArrayPtr_to_text(AUTLcmxArrayPtr *x);
ExportedByAUTLciVMExternsC void text_to_AUTLcmxArrayPtr(AUTLcmxArrayPtr *x, char *y);
ExportedByAUTLciVMExternsC AUTLcmxScalarPtr info_AUTLcmxArrayPtr(void);

#define assign_AUTLcmxScalarPtr(X,Y) ((*X) = (Y))
#define eq_AUTLcmxScalarPtr(X,Y) ((X) == (Y))
ExportedByAUTLciVMExternsC char * AUTLcmxScalarPtr_to_text(AUTLcmxScalarPtr *x);
ExportedByAUTLciVMExternsC void text_to_AUTLcmxScalarPtr(AUTLcmxScalarPtr *x, char *y);
ExportedByAUTLciVMExternsC AUTLcmxScalarPtr info_AUTLcmxScalarPtr(void);

#define assign_AUTLcmxTuplePtr(X,Y) ((*X) = (Y))
#define eq_AUTLcmxTuplePtr(X,Y) ((X) == (Y))
ExportedByAUTLciVMExternsC char * AUTLcmxTuplePtr_to_text(AUTLcmxTuplePtr *x);
ExportedByAUTLciVMExternsC void text_to_AUTLcmxTuplePtr(AUTLcmxTuplePtr *x, char *y);
ExportedByAUTLciVMExternsC AUTLcmxScalarPtr info_AUTLcmxTuplePtr(void);

#define assign_AUTLcmxRecordPtr(X,Y) ((*X) = (Y))
#define eq_AUTLcmxRecordPtr(X,Y) ((X) == (Y))
ExportedByAUTLciVMExternsC char * AUTLcmxRecordPtr_to_text(AUTLcmxRecordPtr *x);
ExportedByAUTLciVMExternsC void text_to_AUTLcmxRecordPtr(AUTLcmxRecordPtr *x, char *y);
ExportedByAUTLciVMExternsC AUTLcmxScalarPtr info_AUTLcmxRecordPtr(void);

#define assign_voidPtr(X,Y) ((*X) = (Y))
#define eq_voidPtr(X,Y) ((X) == (Y))
ExportedByAUTLciVMExternsC char * voidPtr_to_text(voidPtr *x);
ExportedByAUTLciVMExternsC void text_to_voidPtr(voidPtr *x, char *y);
ExportedByAUTLciVMExternsC AUTLcmxScalarPtr info_voidPtr(void);

#define assign_LCMInt32Ptr(X,Y) ((*X) = (Y))
#define eq_LCMInt32Ptr(X,Y) ((X) == (Y))
ExportedByAUTLciVMExternsC char * LCMInt32Ptr_to_text(LCMInt32Ptr *x);
ExportedByAUTLciVMExternsC void text_to_LCMInt32Ptr(LCMInt32Ptr *x, char *y);
ExportedByAUTLciVMExternsC AUTLcmxScalarPtr info_LCMInt32Ptr(void);

/* Macros added by AZH to manage errors in external functions */
#define AUTLcmxNoError 0
#define AUTLcmxInternalError -1


ExportedByAUTLciVMExternsC char *AUTLcmxErrorMessage(const char *format,...);

#define AUTLcmxReturn(res)																				\
{\
	if(res!=AUTLcmxNoError)																							\
		caml_raise_failure (AUTLcmxErrorMessage("Error with code %d at line %d of file %s",res,__LINE__,__FILE__)); \
	return PURE_VALUE;																										\
}
#define AUTLcmxTry															\
		try {																		\
			
#define AUTLxmCatch(errclass,errobj)		} catch (errclass *errobj) {
    
#define AUTLcmxCatchOthers			} catch (...) {	\
		AUTLcmxReturn(AUTLcmxInternalError);					\
	}

#endif /*_AUTLCMX_DATA*/


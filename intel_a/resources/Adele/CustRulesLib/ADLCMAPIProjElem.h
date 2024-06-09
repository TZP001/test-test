#ifndef ADLCMAPIProjElem_h
#define ADLCMAPIProjElem_h

// ******************** ADLCMAPIProjElem
/* Informations about a piece of a parsed path (ADLCMAPIParsedProjPath):
 * - the name ("File1.cpp")
 *
 * - the SCM object type, and relative informations
 *   +-----------------------+-----------+--------+-------+-------------------+--------------+
 *   ! Type                  ! framework ! module ! data  ! directory element ! file element !
 *   +-----------------------+-----------+--------+-------+-------------------+--------------+
 *   ! Component             ! TRUE      ! TRUE   ! TRUE  ! FALSE             ! FALSE        !
 *   +-----------------------+-----------+--------+-------+-------------------+--------------+
 *   ! Projectable as a file ! FALSE     ! FALSE  ! FALSE ! FALSE             ! TRUE         !
 *   +-----------------------+-----------+--------+-------+-------------------+--------------+
 *
 * - the projection state (not projected, projected as a directory, projected as a file)
 *
 * - if the piece matches a SCM object to be created or an existing SCM object
 */

#include "ADLCMAPIArchi.h"

class ADLCMAPIProjElem
{
public:
	inline virtual ~ADLCMAPIProjElem()
	{
	}
	// * Name the object is projected with or it'll be projected with
	virtual const char * __stdcall GetProjName() const = 0;

	// * SCM object identifier if not to be created
	virtual const char * __stdcall GetSoftObjId() const = 0;

	// * SCM object type
	enum ADLCMAPIProjElemType {ArchiFramework, ArchiModule, ArchiData, ArchiDirectoryElement, ArchiFileElement};

	virtual ADLCMAPIProjElemType __stdcall GetProjElemType() const = 0; // Type
	virtual Boolean __stdcall SoftObjIsComponent() const = 0;           // TRUE -> component, FALSE -> element
	virtual Boolean __stdcall SoftObjIsProjectableAsFile() const = 0;   // TRUE -> projectable as a file, FALSE -> directory

	// * Projection state
	enum ADLCMAPIProjObjectType {NotProjected, ProjectedAsADirectory, ProjectedAsAFile};

	virtual ADLCMAPIProjObjectType __stdcall GetProjObjType() const = 0;

	// * SCM object to be created
	virtual Boolean __stdcall ProjElemToCreate() const = 0; // TRUE -> the SCM object doesn' exist and it'll be created, FALSE -> the SCM object already exists
};

#endif /* ADLCMAPIProjElem_h */

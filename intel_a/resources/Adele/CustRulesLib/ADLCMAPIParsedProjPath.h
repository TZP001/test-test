#ifndef ADLCMAPIParsedProjPath_h
#define ADLCMAPIParsedProjPath_h

// ******************** ADLCMAPIParsedProjPath
/* Path cut into pieces (ADLCMAPIProjElem).
 * The path is always relative to the image directory:
 *      "Fw1/Mod1.m/src/File1.cpp" -> "Fw1", "Mod1.m", "src", "File1.cpp"
 */

#include "ADLCMAPIArchi.h"

class ADLCMAPIProjElem;

class ADLCMAPIParsedProjPath
{
public:
	inline virtual ~ADLCMAPIParsedProjPath()
	{
	}
	// * Any piece of the path
	virtual const ADLCMAPIProjElem & __stdcall GetProjElem(int Idx) const = 0; // 0 <= Idx < GetNbProjElem()
	// +-------------------+-------+----------+-------+-------------+
	// ! Name of the piece ! "Fw1" ! "Mod1.m" ! "src" ! "File1.cpp" !
	// +-------------------+-------+----------+-------+-------------+
	// ! Idx               ! 0     ! 1        ! 2     ! 3           !
	// +-------------------+-------+----------+-------+-------------+

	// * Last piece of the path
	virtual const ADLCMAPIProjElem & __stdcall GetLastProjElem() const = 0;

	// * Number of pieces
	virtual int __stdcall GetNbProjElem() const = 0;

	// * Builds a path to use as an error message argument
	virtual void __stdcall MakeRelativePath(wchar_t *&String, int FirstIdx = 0, int LastIdx = -1) const = 0; // The output string must be destroyed by delete [].
	// Sample:
	//    wchar_t *Path = NULL;
	//    ParsedProjPath.MakeRelativePath(Path); // -> "Fw1/Mod1.m/src/File1.cpp" or "Fw1\Mod1.m\src\File1.cpp"
	//    Error.AddNewParameter(Path);
	//    delete [] Path;
};

#endif /* ADLCMAPIParsedProjPath_h */

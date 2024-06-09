#ifndef _CATANSIIOSFWD_H
#define _CATANSIIOSFWD_H

/* COPYRIGHT DASSAULT SYSTEMES 2004 */

/**
 * @CAA2Level L1
 * @CAA2Usage U1
 */
#include <iosfwd>

using std::ios;
using std::streambuf;
using std::istream;
using std::ostream;
using std::iostream;
using std::stringbuf;
using std::istringstream;
using std::ostringstream;
using std::stringstream;
using std::filebuf;
using std::ifstream;
using std::ofstream;
using std::fstream;

// For classes that are not defined in iosfwd
namespace std{
class strstreambuf;
class istrstream;
class ostrstream;
class strstream;
}
using std::strstreambuf;
using std::istrstream;
using std::ostrstream;
using std::strstream;

#endif

/* */

#ifdef _MKMK_EXTERNAL_FRAMEWORK

/*
#define _MKMK_INCLUDE(D,I)      D include #I
_MKMK_INCLUDE( #,iostream.h )
_MKMK_INCLUDE( #,stdio.h )
_MKMK_INCLUDE( #,stdlib.h )
*/

#ifdef _WINDOWS_SOURCE
__declspec(dllimport) void AbortProcCAA(const char*the_lib);
extern "C" __declspec(dllimport) int _init_lib_const(const char*the_lib, const char*the_mark);
#else /* UNIX */
void AbortProcCAA(const char*the_lib);
extern "C" int _init_lib_const(const char*the_lib, const char*the_mark);
#endif

#define DSCAAV5LICENCE_MARK "DSCAAV5LICENCE_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX_DSCAAV5LICENCE"

#ifndef CAAV5_CLASS_DECLARE_N
#define CAAV5_CLASS_DECLARE_N( N ) \
\
class DASSAULT_SYSTEMES_CAAV5_CLASS_##N\
{\
public:\
  DASSAULT_SYSTEMES_CAAV5_CLASS_##N( const char * ipKey, const char * iplibname );\
  ~DASSAULT_SYSTEMES_CAAV5_CLASS_##N( );\
  const char * DASSAULT_SYSTEMES_CAAV5_LICENCE_KEY() const;\
private:\
  const char * _DASSAULT_SYSTEMES_CAAV5_LICENCE_KEY;\
  const char * _the_lib_name;\
};\
\
DASSAULT_SYSTEMES_CAAV5_CLASS_##N::DASSAULT_SYSTEMES_CAAV5_CLASS_##N( const char * ipKey, const char * iplibname )\
: _DASSAULT_SYSTEMES_CAAV5_LICENCE_KEY( ipKey ), _the_lib_name( iplibname )\
{\
  if ( _init_lib_const( _the_lib_name, _DASSAULT_SYSTEMES_CAAV5_LICENCE_KEY ) != 22 )\
    AbortProcCAA( _the_lib_name );\
}\
\
DASSAULT_SYSTEMES_CAAV5_CLASS_##N::~DASSAULT_SYSTEMES_CAAV5_CLASS_##N() {}\
\
const char * DASSAULT_SYSTEMES_CAAV5_CLASS_##N::DASSAULT_SYSTEMES_CAAV5_LICENCE_KEY() const\
{ return _DASSAULT_SYSTEMES_CAAV5_LICENCE_KEY; }\

#endif


#ifndef CAAV5_EXTERNAL_DECLARE_N

# ifdef _WINDOWS_SOURCE
#	define CAAV5_EXTERNAL_DECLARE_N( N ) \
	 CAAV5_CLASS_DECLARE_N( N )\
    static DASSAULT_SYSTEMES_CAAV5_CLASS_##N\
     DASSAULT_SYSTEMES_CAAV5_LICENCE_##N(DSCAAV5LICENCE_MARK,#N);\
	 extern "C" __declspec(dllexport) int DASSAULT_SYSTEMES_CAA2_LICENSING_##N( void ) { return 1; }

# else /* UNIX */
#  define CAAV5_EXTERNAL_DECLARE_N( N ) \
	 CAAV5_CLASS_DECLARE_N( N )\
    static DASSAULT_SYSTEMES_CAAV5_CLASS_##N\
     DASSAULT_SYSTEMES_CAAV5_LICENCE_##N(DSCAAV5LICENCE_MARK,#N);\
    extern "C" int DASSAULT_SYSTEMES_CAA2_LICENSING_##N( void ) { return 1; }

# endif

#endif

#ifndef CAAV5_EXTERNAL_DECLARE
#define CAAV5_EXTERNAL_DECLARE( N ) CAAV5_EXTERNAL_DECLARE_N( N )
#endif

CAAV5_EXTERNAL_DECLARE( _MK_CONTNAME_ )


#else /* INTERNAL FRAMEWORK */

#ifndef _MKMK_NO_CAAV5LICENSING

#ifndef CAAV5_INTERNAL_DECLARE_N
# ifdef _WINDOWS_SOURCE
#	define CAAV5_INTERNAL_DECLARE_N( N ) \
		extern "C" __declspec(dllexport) int DASSAULT_SYSTEMES_CAA2_INTERNAL_##N( void ) { return 1; }
# else /* UNIX */
#  define CAAV5_INTERNAL_DECLARE_N( N ) \
		extern "C" int DASSAULT_SYSTEMES_CAA2_INTERNAL_##N( void ) { return 1; }
# endif
#endif

#ifndef CAAV5_INTERNAL_DECLARE
#define CAAV5_INTERNAL_DECLARE( N ) CAAV5_INTERNAL_DECLARE_N( N )
#endif

CAAV5_INTERNAL_DECLARE( _MK_CONTNAME_ )

#endif

#endif

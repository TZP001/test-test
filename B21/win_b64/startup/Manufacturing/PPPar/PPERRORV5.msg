/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/ ACHTUNG: NICHT EDITIEREN
/          Diese Datei wird automatisch erzeugt.
/          Original in MONO-Verzeichnis !!!
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/ N3CERRPP
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
N3C030001  4  Parameter &I03 is no number
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             APT-line              :
&             &C02
&             Subprogram            : &C01
&             The value of the &I03. parameter
&                     &C03
&             can not be transformed into a number!
/////////////////////////////////////////////////////////
N3C030010  5  Invalid number of Program parameters
&             Invalid or missing arguments. Check program call.
&             1st Parameter         : PPDef File
&             2nd Parameter         : Input File
&             3rd Parameter         : Output File
&             4th Parameter         : Report File
/////////////////////////////////////////////////////////
N3C030020  5  Invalid Inputtype
&             Type of the inputfile unknown
/////////////////////////////////////////////////////////
N3C030021  5  No access to Inputfile
&             The Inputfile couldn't be read!
&             InputFile : &C01
/////////////////////////////////////////////////////////
N3C030022  5  No access to ISO outputfile
&             The ISO outputfile couldn't be created!
&             ISO outputfile : &C01
/////////////////////////////////////////////////////////
N3C030023  4  No access to reportfile
&             The reportfile couldn't be created!
&             Report will be redirected to stdout.
&             Reportfile : &C01
/////////////////////////////////////////////////////////
N3C030024  4  Fixed record length too small
&             The ISO output string is longer then
&             the fixed record format             
&             ISO string : &C01
&             ISO length   : &I01
&             Fixed length : &I02
/////////////////////////////////////////////////////////
N3C030025  5  New ISO outputfile failed  
&             The ISO outputfile couldn't be created!
&             ISO outputfile : &C01
/////////////////////////////////////////////////////////
N3C030026  4  New ISO outputfile failed  
&             OUTPUT/ISOFILE command is suppressed!   
&             Wrong filename or filemode             
&             Syntax: OUTPUT/ISOFILE,<iso>,<NEW|APPEND>
/////////////////////////////////////////////////////////
N3C030050  5  Error in PP-Parameterfile
&             PP-Parameterfile corrupted: invalid signs
/////////////////////////////////////////////////////////
N3C030051  5  Error in PP-Parameterfile
&             PP-Parameterfile corrupted: checksum error
/////////////////////////////////////////////////////////
N3C030052  3  Error in PP-Definition
&             SETPLN and Machine angle definition not supported
&             on TWO_AXIS_ON_TABLE_MACHINES
&             Command is ignored
/////////////////////////////////////////////////////////
N3C030053  4  Error in PP-Definition
&             internal needed axis for SETPLN command not set
&             supposable wrong Machine selected
&             Command is ignored
/////////////////////////////////////////////////////////
N3C030054  4  Error in PP-Definition
&             Macro name            : &C01
&             Macro name is not allowed. Macro will be suppressed.
/////////////////////////////////////////////////////////
N3C030055  5  Error in PP-Definition
&             Macro name            : &C01
&             Function name         : &C02
&             This function is not supported in this macro.       
/////////////////////////////////////////////////////////
N3C030056  5  Error in PP-Definition
&             #MCE_DLL: defined in header section, but no definitions
&             in ##### MCE_SECTION.
/////////////////////////////////////////////////////////
N3C030057  4  Error in PP-Definition
&             Corrupted Section     : &C01
&             Parametername         : &C02
&             This parameter is defined twice.       
/////////////////////////////////////////////////////////
N3C030099  5  APT Syntaxerror
&             ERROR IN NURBS DEFINITION
/////////////////////////////////////////////////////////
N3C030100  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             APT Syntaxerror
/////////////////////////////////////////////////////////
N3C030101  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Invalid number of parameters
/////////////////////////////////////////////////////////
N3C030102  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             GODLTA without previous GOTO or FROM
/////////////////////////////////////////////////////////
N3C030103  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             TOOLNO - Invalid feedrate unit
/////////////////////////////////////////////////////////
N3C030104  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             TOOLNO - Invalid spindle speed unit
/////////////////////////////////////////////////////////
N3C030105  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             TOOLNO - Invalid spindle direction
/////////////////////////////////////////////////////////
N3C030106  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             TOOLNO - Invalid coolant type
/////////////////////////////////////////////////////////
N3C030107  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             TOOLNO - Invalid toolchange mode
&             Mode                  : &C02
/////////////////////////////////////////////////////////
N3C030108  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             TOOLNO-PPRINT invalid number of arguments
/////////////////////////////////////////////////////////
N3C030109  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             TOOLNO-TPRINT invalid number of arguments
/////////////////////////////////////////////////////////
N3C030110  1  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             ROTABL/INCR,... without previous ROTABL
/////////////////////////////////////////////////////////
N3C030111  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Missing DEFSUB
/////////////////////////////////////////////////////////
N3C030112  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             OPSKIP - Flag must be ON or OFF
/////////////////////////////////////////////////////////
N3C030113  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             MODE/INCR-Flag must be ON or OFF
/////////////////////////////////////////////////////////
N3C030114  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Undefined parameter in this line
/////////////////////////////////////////////////////////
N3C030115  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             MODE/__PLAN - 2nd parameter must be 1 or 2
/////////////////////////////////////////////////////////
N3C030116  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             MODE - Plane is undefined                
/////////////////////////////////////////////////////////
N3C030117  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             CIRCLE - Statement not complete missing INDIRV                
/////////////////////////////////////////////////////////
N3C030118  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             HELICAL- Statement undefined syntax                           
/////////////////////////////////////////////////////////
N3C030119  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             CIRCLE - Statement not complete missing LINE                 
/////////////////////////////////////////////////////////
N3C030120  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             FEDRAT - Invalid feedrate unit
/////////////////////////////////////////////////////////
N3C030121  1  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             FEDRAT/MODIFY without previous FEDRAT
/////////////////////////////////////////////////////////
N3C030122  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             SPINDL - Invalid spindle unit
/////////////////////////////////////////////////////////
N3C030123  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             SPINDL - Invalid rotation direction
/////////////////////////////////////////////////////////
N3C030124  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             COOLNT - Flag must be ON or OFF
/////////////////////////////////////////////////////////
N3C030125  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             FEDRAT - Maximum value exceeded
&             Programmed Value      : &R01(F11.5)
&             Maximum Value         : &R02(F11.5)
/////////////////////////////////////////////////////////
N3C030126  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             FEDRAT - Value below minimum value
&             Programmed Value      : &R01(F11.5)
&             Minimum Value         : &R02(F11.5)
/////////////////////////////////////////////////////////
N3C030127  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             REWIND ID is programmed twice      
&             ID Value              : &I02         
/////////////////////////////////////////////////////////
N3C030128  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             REWIND section with ID is not activated         
&             with ON                                         
&             ID Value              : &I02         
/////////////////////////////////////////////////////////
N3C030129  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Last parameter must be NOW, NEXT or LAST
/////////////////////////////////////////////////////////
N3C030130  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             DEFSUB ID is programmed twice      
&             ID Value              : &I02         
/////////////////////////////////////////////////////////
N3C030131  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             NO DEFSUB with ID programmed               
&             ID Value              : &I02         
/////////////////////////////////////////////////////////
N3C030132  5  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             CUTCOM/LEFT or RIGHT is still active       
/////////////////////////////////////////////////////////
N3C030133  4  Type of cycle unknown
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Unknown type of cycle is called
&             &C02
/////////////////////////////////////////////////////////
N3C030134  4  Cycle approach formula is wrong
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Check cycle formula
&             &C02
&             for cycle             
&             &C03
/////////////////////////////////////////////////////////
N3C030135  5  Miller position not possible
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Miller position not possible
/////////////////////////////////////////////////////////
N3C030136  5  MULTAX error
&             MULTAX position can not be reached.
&             independent axis min  : &F06(13.5)
&             independent axis value: &F02(13.5)
&             independent axis max  : &F04(13.5)
&             dependent axis min    : &F05(13.5)
&             dependent axis value  : &F01(13.5)
&             dependent axis max    : &F03(13.5)
/////////////////////////////////////////////////////////
N3C030137  3  Warning: Check rotary angles
&             Multax position cannot be reached in given direction.
&             1st solution: &F01(13.5)  &F02(13.5)
&             2nd solution: &F03(13.5)  &F04(13.5)
/////////////////////////////////////////////////////////
N3C030138  5  MULTAX error
&             APT-Line              : &C01
&             Line number APT       : &I01
&             MULTAX position can not be reached.
/////////////////////////////////////////////////////////
N3C030139  3  Warning: Check rotary angles
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Multax position cannot be reached in given direction.
/////////////////////////////////////////////////////////
N3C030140  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             DUMP - Pool-Number out of range
/////////////////////////////////////////////////////////
N3C030141  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             SEQNO - Invalid parameter
/////////////////////////////////////////////////////////
N3C030142  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Undefined DELAY option or syntax   
/////////////////////////////////////////////////////////
N3C030143  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             SPINDL/ON - Unknown spindle speed
/////////////////////////////////////////////////////////
N3C030144  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             SPINDL/LOCK,INCR - missing angle value
/////////////////////////////////////////////////////////
N3C030145  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             SPINDL/RANGE - missing range number
/////////////////////////////////////////////////////////
N3C030146  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             CUTTER/... - invalid number of parameters
/////////////////////////////////////////////////////////
N3C030147  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             1st Parameter of CHNGRG command undefined  
/////////////////////////////////////////////////////////
N3C030148  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             2nd Parameter of CHNGRG command undefined  
/////////////////////////////////////////////////////////
N3C030149  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             No linear approach motion                  
/////////////////////////////////////////////////////////
N3C030150  3  Warning: Time limit reached 
&             Tool time limit is reached                           
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Actual tool time      : &F01(13.5)
&             Tool time limit       : &F02(13.5)
/////////////////////////////////////////////////////////
N3C030151  3  Warning: Way limit reached 
&             Tool way limit is reached                           
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Actual tool way       : &F01(13.5)
&             Tool way limit        : &F02(13.5)
/////////////////////////////////////////////////////////
N3C030152  3  Warning: Actual movement longer than way limit
&             Tool way limit is reached in this motion
&             Check is switched off
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Actual tool way       : &F01(13.5)
&             Tool way limit        : &F02(13.5)
/////////////////////////////////////////////////////////
N3C030153  3  Warning: Actual movement time longer than time limit
&             Tool time limit is reached in this motion
&             Check is switched off
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Actual tool time      : &F01(13.5)
&             Tool timelimit        : &F02(13.5)
/////////////////////////////////////////////////////////
N3C030154  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Number of parameters  : &I02
&             Invalid number of parameters
&             Syntax: C_VARPUT/<Name>, <Type>, <Value>
/////////////////////////////////////////////////////////
N3C030155  4  Syntaxerror AV_MOTION
&             Line number APT       : &I01
&             Number of parameters  : &I02
&             AV_MOTION: Invalid number of parameters
/////////////////////////////////////////////////////////
N3C030156  4  Syntaxerror AV_MOTION
&             Line number APT       : &I01
&             AV_MOTION: No linear motion before circle
/////////////////////////////////////////////////////////
N3C030157  4  Syntaxerror AV_MOTION
&             Line number APT       : &I01
&             AV_MOTION: circle direction is undefined
/////////////////////////////////////////////////////////
N3C030158  4  APT Syntaxerror C_VARDEL
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Number of parameters  : &I02
&             Invalid number of parameters
&             Syntax: C_VARDEL/<Name>
/////////////////////////////////////////////////////////
N3C030159  4  APT Syntaxerror CYCLE GOTO
&             Line number APT       : &I01
&             CYCLE Definition not found   
/////////////////////////////////////////////////////////
N3C030160  3  MULTAX error
&             MULTAX position can not be reached with indexable axis.
&             Rotary axis will be set to nearest possible value.
&             dependent axis value  : &F01(13.5)
&             dependent axis step   : &F02(13.5)
&             dependent axis output : &F03(13.5)
/////////////////////////////////////////////////////////
N3C030161  3  MULTAX error
&             MULTAX position can not be reached with indexable axis.
&             Rotary axis will be set to nearest possible value.
&             independent axis value  : &F01(13.5)
&             independent axis step   : &F02(13.5)
&             independent axis output : &F03(13.5)
/////////////////////////////////////////////////////////
N3C030162  3  Warning: Check rotary angles
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Multax position cannot be reached because step of indexable axis
/////////////////////////////////////////////////////////
N3C030163  4  MULTAX error
&             MULTAX position can not be reached.
&             independent axis min  : &F06(13.5)
&             independent axis value: &F02(13.5)
&             independent axis max  : &F04(13.5)
&             dependent axis min    : &F05(13.5)
&             dependent axis value  : &F01(13.5)
&             dependent axis max    : &F03(13.5)
/////////////////////////////////////////////////////////
N3C030164  4  Miller position not possible
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Miller position not possible
/////////////////////////////////////////////////////////
N3C030165  4  MULTAX error
&             Incorrect toolvector - Euler angles cannot be calculated
&             tool vector X:          &F01(13.5)
&             tool vector Y:          &F02(13.5)
&             tool vector Z:          &F03(13.5)
/////////////////////////////////////////////////////////
N3C030166  4  MULTAX error
&             Euler angles calculation failed because of limits
&             1st solution:
&             Euler angle 1st:        &F01(13.5)
&             Euler angle 2nd:        &F02(13.5)
&             Euler angle 3rd:        &F03(13.5)
&             2nd solution:
&             Euler angle 1st:        &F04(13.5)
&             Euler angle 2nd:        &F05(13.5)
&             Euler angle 3rd:        &F06(13.5)
/////////////////////////////////////////////////////////
N3C030167  4  Euler calculation failed
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Cannot calculate Euler angles
/////////////////////////////////////////////////////////
N3C030168  4  Maximal value of a machining axis is exceeded
&             Axis          :  &C01                
&             Maximum value :  &F01(15.6)  
&             Actual   value:  &F02(15.6)  
&             Maximal value of a machining axis is exceeded
&             Cannot reach position because of axis limits
/////////////////////////////////////////////////////////
N3C030169  4  Value of machining axis falls below minimum
&             Axis        :  &C01                
&             Minim value :  &F01(15.6)  
&             Actual value:  &F02(15.6)  
&             Cannot reach position because of axis limits
/////////////////////////////////////////////////////////
N3C030170  4  Position not reachable                      
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Line number ISO       : &I02
&             Cannot reach position because of axis limits
/////////////////////////////////////////////////////////
N3C030171  4  APT Syntaxerror
&             APT line              : &C01
&             Line number APT       : &I01
&             Error in NURBS Definition
/////////////////////////////////////////////////////////
N3C030172  3  PP Definition error
&             Macro for ISO size is undefined
&             Check STR_NCSIZE_LIMIT_MACRO in the Builder
&             Size check is switched off
/////////////////////////////////////////////////////////
N3C030173  4  Wire Approach movement wrong
&             APT line              : &C01
&             Line number APT       : &I01
&             Approach is not perpendicular to first contour element
/////////////////////////////////////////////////////////
N3C030174  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             CIRCLE - Statement wrong                                     
&             Data (Via point, plane, angle,...) calculation failed
/////////////////////////////////////////////////////////
N3C030175  3  Warning: No CUTCOM NORM_PS Data
&             APT-Line              : &C01
&             Line number APT       : &I01
&             No CUTCOM/NORM_PS Data available for intermediate points.
&             CUTCOM is switched off
/////////////////////////////////////////////////////////
N3C030176  4  Undefined Spindle range number  
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Spindle range called  : &I02
&             Nb of spindle ranges  : &I03
&             SPINDL command calls undefined range.                    
/////////////////////////////////////////////////////////
N3C030177  3  Undefined Spindle range values  
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Spindle range called  : &I02
&             No possible spindle speeds of this range defined.                    
/////////////////////////////////////////////////////////
N3C030178  3  Undefined Spindle range variation
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Spindle range called  : &I02
&             Variation of spindle speed is undefined for this range.
/////////////////////////////////////////////////////////
N3C030179  4  Spindle speed lower than minimum 
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Spindle range active  : &I02
&             Spindle range minimum : &F01(15.6)
&             Spindle speed called  : &F02(15.6)
&             Programmed spindle speed is lower than minimum of this range.
/////////////////////////////////////////////////////////
N3C030180  4  Spindle speed greater than maximum 
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Spindle range active  : &I02
&             Spindle range maximum : &F01(15.6)
&             Spindle speed called  : &F02(15.6)
&             Programmed spindle speed is greater than maximum of this range.
/////////////////////////////////////////////////////////
N3C030181  4  Spindle speed values undefined     
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Spindle range called  : &I02
&             No spindle speed steps defined for this range.
/////////////////////////////////////////////////////////
N3C030182  4  Spindle speed not equal to any step
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Spindle range active  : &I02
&             Nearest spindle speed : &F01(15.6)
&             Spindle speed called  : &F02(15.6)
&             Programmed spindle speed is not equal to any possible speed.
&             Best possible speed is set.
/////////////////////////////////////////////////////////
N3C030183  4  Wire Approach movement wrong
&             APT line              : &C01
&             Line number APT       : &I01
&             Approach is a circular movement.
/////////////////////////////////////////////////////////
N3C030184  4  Warning: Undefined CUTCOM NORM_PS Data
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Possible Syntax forms for GOTOS are
&             GOTO/XT,YT,ZT,I,J,K,XC,YC,ZC,XN,YN,ZN or
&             GOTO/XT,YT,ZT,XC,YC,ZC,XN,YN,ZN or
&             GOTO/XC,YC,ZC,I,J,K,XN,YN,ZN or
&             GOTO/XC,YC,ZC,XN,YN,ZN
&             CUTCOM Data output is switched off
/////////////////////////////////////////////////////////
N3C030185  4  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             MODE - Polar plane is undefined                
&             2nd parameter is wrong: &C02
&             Possible planes are XY, XY2, ZX1, ZX2, YZ1, 
&             YZ2 or OFF
/////////////////////////////////////////////////////////
N3C030186  3  APT Syntaxerror
&             APT-Word              : &C01
&             Line number APT       : &I01
&             HEIGHT: part height is set to 0.0              
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
N3C030187  4  Polar mode error
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Polar angle is out of limits.
&             polar angle minimum   : &F02(13.5)
&             polar angle           : &F01(13.5)
&             polar angle maximum   : &F03(13.5)
/////////////////////////////////////////////////////////
N3C030188  1  No previous FEDRAT found
&             APT-Word              : &C01
&             Line number APT       : &I01
&             No previous FEDRAT found.
/////////////////////////////////////////////////////////
N3C030189  1  No previous FEDRAT found
&             APT-Word              : &C01
&             Line number APT       : &I01
&             No previous FEDRAT found. No time    
&             calculation possible.                
/////////////////////////////////////////////////////////
N3C030190  4  Frame definition error
&             Z and X axis is not perpendicular
&             No new frame definition possible 
&             Z axis in X           : &F01(13.5)
&             Z axis in Y           : &F02(13.5)
&             Z axis in Z           : &F03(13.5)
&             X axis in X           : &F04(13.5)
&             X axis in Y           : &F05(13.5)
&             X axis in Z           : &F06(13.5)
/////////////////////////////////////////////////////////
N3C030191  4  Frame definition error
&             Cannot calculate Euler angles for this frame
&             No new frame definition possible 
&             Z axis in X           : &F01(13.5)
&             Z axis in Y           : &F02(13.5)
&             Z axis in Z           : &F03(13.5)
&             X axis in X           : &F04(13.5)
&             X axis in Y           : &F05(13.5)
&             X axis in Z           : &F06(13.5)
/////////////////////////////////////////////////////////
N3C030192  4  Frame definition error
&             Cannot calculate Machine angles for this frame
&             No new frame definition possible 
&             Z axis in X           : &F01(13.5)
&             Z axis in Y           : &F02(13.5)
&             Z axis in Z           : &F03(13.5)
&             X axis in X           : &F04(13.5)
&             X axis in Y           : &F05(13.5)
&             X axis in Z           : &F06(13.5)
/////////////////////////////////////////////////////////
N3C030193  4  Frame definition error
&             Cannot calculate Machine angles for new Z axis
&             No new frame definition possible 
&             Z axis in X           : &F01(13.5)
&             Z axis in Y           : &F02(13.5)
&             Z axis in Z           : &F03(13.5)
/////////////////////////////////////////////////////////
N3C030194  4  Frame definition error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Frame cannot be defined   
/////////////////////////////////////////////////////////
N3C030195  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Invalid APT Syntax for TRACUT
&             Syntax: TRACUT/MATRIX/ <4x3 matrix>
&             Syntax: TRACUT/NOMORE
/////////////////////////////////////////////////////////
N3C030196  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Invalid nesting of TRACUT/MATRIX and TRACUT/NOMORE
&             Command is ignored                          
/////////////////////////////////////////////////////////
N3C030197  4  APT Syntaxerror
&             Invalid nesting of TRACUT/.... and INDEX/COPY
/////////////////////////////////////////////////////////
N3C030198  4  APT Syntaxerror
&             Invalid nesting of TRACUT/MATRIX             
&             TRACUT/NOMORE is missing                     
/////////////////////////////////////////////////////////
N3C030199  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             INDEX - COPY ID       : &I02
&             This ID is used several times
/////////////////////////////////////////////////////////
N3C030200  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             INDEX - COPY ID       : &I02
&             This is not completely defined
&             INDEX/NOMORE is missing for this ID          
/////////////////////////////////////////////////////////
N3C030201  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             INDEX - COPY ID       : &I02
&             This is not completely defined
&             The staring INDEX/       is missing for this ID          
/////////////////////////////////////////////////////////
N3C030202  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             INDEX - COPY ID active: &I02
&             INDEX - COPY ID closed: &I03
&             Invalid nesting of INDEX COPY sections
/////////////////////////////////////////////////////////
N3C030203  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             INDEX - COPY ID       : &I02
&             INDEX/NOMORE is twice defined                
/////////////////////////////////////////////////////////
N3C030204  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             INDEX - COPY ID       : &I02
&             INDEX/NOMORE or COPY missing                 
/////////////////////////////////////////////////////////
N3C030205  4  APT Syntaxerror
&             Error in INDEX COPY command structure        
/////////////////////////////////////////////////////////
N3C030206  4  APT Syntaxerror
&             Error in TRACUT - TRACUT/NOMORE command structure        
/////////////////////////////////////////////////////////
N3C030207  4  APT Syntaxerror
&             Error in INDEX COPY processing               
/////////////////////////////////////////////////////////
N3C030208  4  APT Syntaxerror
&             Error in TRACUT processing               
/////////////////////////////////////////////////////////
N3C030209  4  APT Syntaxerror
&             Error in TRACUT INDEX COPY command structure
/////////////////////////////////////////////////////////
N3C030210  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Invalid nesting of TRACUT/MATRIX and TRACUT/NOMORE
&             and INDEX and INDEX/NOMORE                  
&             Command is ignored                          
/////////////////////////////////////////////////////////
N3C030211  4  Miller position not possible
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Miller position not possible because of kinematics
&             Old Angles are taken for this point
/////////////////////////////////////////////////////////
N3C030212  4  APT Syntaxerror CIRCLE  
&             APT-Line              : &C01
&             Line number APT       : &I01
&             INDIRV vector not tangential
&             Please check circle direction
/////////////////////////////////////////////////////////
N3C030213  4  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Number of parameters  : &I02
&             Invalid number of parameters
&             Syntax: C_VARPUT/<Name>, <POINT|VECTOR>, <Value>,<Value>,<Value>
/////////////////////////////////////////////////////////
N3C030214  3  APT Syntaxerror
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Invalid radius in APT             
&             Radius in APT         : &F01(13.5)
&             Distance center/end   : &F02(13.5)
&             Radius is set to distance
/////////////////////////////////////////////////////////
N3C030215  4  APT Syntaxerror CIRCLE  
&             APT-Line              : &C01
&             Line number APT       : &I01
&             Invalid radius in APT             
&             Radius in APT         : &F01(13.5)
&             Distance center/start : &F02(13.5)
&             Distance center/end   : &F03(13.5)
&             Radius is set to APT radius
/////////////////////////////////////////////////////////
N3C031100  4  Block error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Blockdefinition not found
/////////////////////////////////////////////////////////
N3C031101  4  Block error
&             Error in Blockdefinition with fix text variable 
&              &C01                                   
&             ) is missing at the end of variablename 
/////////////////////////////////////////////////////////
N3C031102  4  Block error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             ORIGIN/MANUAL command part no. &I01     
&              &C01                                   
&             is wrong defined                        
&             ) is missing at the end of variablename 
/////////////////////////////////////////////////////////
N3C031103  4  ORIGIN/MANUAL command 
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Creation of ORIGIN/MANUAL command failed
/////////////////////////////////////////////////////////
N3C031104  5  Block error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Blockname             : &C02
&             Error in Blockinterpretation
/////////////////////////////////////////////////////////
N3C031105  4  Block error
&             Error in Blockinterpretation
&             Functionname          : &C01
&             Wrong number of parameters
/////////////////////////////////////////////////////////
N3C031106  4  Block error
&             Error in Blockinterpretation
&             Functionname          : &C01
&             Macroname             : &C02
&             Macro not found           
/////////////////////////////////////////////////////////
N3C031107  3  Initialisation 
&             Older parameterfile updated  
&             See other error messages   
/////////////////////////////////////////////////////////
N3C031108  4  DOF Macro error
&             Error inserting DOF macro      
&             Functionname          : &C01
&             Macroname             : &C02
&             Macro not found           
/////////////////////////////////////////////////////////
N3C032000  5  Postprocessor filename undefined!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             The Postprocessor filename is a NULL pointer
&             or unset
/////////////////////////////////////////////////////////
N3C032001  5  Reading of PP parameterfile failed!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             The Parameterfile couldn't be read!
/////////////////////////////////////////////////////////
N3C032002  5  Reading of PP parameterfile failed!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             Address Section is corrupted!
/////////////////////////////////////////////////////////
N3C032003  5  Malloc failed!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             Cannot perform malloc!
/////////////////////////////////////////////////////////
N3C032004  5  Reading of PP parameterfile failed!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             Cycle Section is corrupted!
/////////////////////////////////////////////////////////
N3C032005  5  Reading of PP parameterfile failed!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             Integer Section is corrupted!
/////////////////////////////////////////////////////////
N3C032006  5  Reading of PP parameterfile failed!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             Real Section is corrupted!
/////////////////////////////////////////////////////////
N3C032007  5  Reading of PP parameterfile failed!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             String Section is corrupted!
/////////////////////////////////////////////////////////
N3C032008  5  Reading of PP parameterfile failed!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             Subprogram            : &C01
&             Number of sections isn't correct!!
/////////////////////////////////////////////////////////
N3C032019  5  Error writing NC Data
&             NC-Word               : &C01
&             Tabulatorposition for RecNr already allocated
/////////////////////////////////////////////////////////
N3C032020  5  Error writing NC Data
&             Line number APT       : &I01
&             APT-line              :
&             &C01
&             NC-Word               : &C02
&             Tabulatorposition already allocated
/////////////////////////////////////////////////////////
N3C032021  4  Formatting of number failed
&             Value                 : &I02
&             Format                : &C01
&             Empty format definition string
/////////////////////////////////////////////////////////
N3C032022  4  Formatting of number failed
&             Value                 : &I02
&             Format                : &C01
&             Wrong format symbol in definition
/////////////////////////////////////////////////////////
N3C032023  4  Formatting of number failed
&             Value                 : &I02
&             Format                : &C01
&             Position              : &I01
&             Invalid character in format string
/////////////////////////////////////////////////////////
N3C032024  4  Formatting of number failed
&             Value                 : &I02
&             Format                : &C01
&             Min-Value greater than Max-Value
/////////////////////////////////////////////////////////
N3C032025  4  Formatting of number failed
&             Value                 : &I02
&             Format                : &C01
&             Outstr is NULL pointer              
/////////////////////////////////////////////////////////
N3C032026  4  Formatting of number failed
&             Value                 : &R01(F11.5)
&             Format                : &C01
&             Empty format definition string
/////////////////////////////////////////////////////////
N3C032027  4  Formatting of number failed
&             Value                 : &R01(F11.5)
&             Format                : &C01
&             Wrong format symbol in definition
/////////////////////////////////////////////////////////
N3C032028  4  Formatting of number failed
&             Value                 : &R01(F11.5)
&             Format                : &C01
&             Position              : &I01
&             Invalid character in format string
/////////////////////////////////////////////////////////
N3C032029  4  Formatting of number failed
&             Value                 : &R01(F11.5)
&             Format                : &C01
&             Min-Value greater than Max-Value
/////////////////////////////////////////////////////////
N3C032030  4  Formatting of number failed
&             Value                 : &R01(F11.5)
&             Format                : &C01
&             Outstr is NULL pointer              
/////////////////////////////////////////////////////////
N3C032031  4  Error formatting ORIGIN/MANUAL
&             Origin manual number  : &I01
&             Part                  : &I02
&             Command string        : &C01
&             Variable cannot be replaced         
/////////////////////////////////////////////////////////
N3C032032  4  Undefined ORIGIN/MANUAL called
&             Origin manual number  : &I01
&             Part                  : &I02
&             Origin manual number is undefined   
/////////////////////////////////////////////////////////
N3C032033  4  Error formatting pool variable
&             Value                 : &R01
&             Format                : &C01
&             Format parameter name : &C03
&             Variable              : &C02
&             Variable cannot be formatted        
/////////////////////////////////////////////////////////
N3C032034  4  Error formatting pool variable
&             Value                 : &I01
&             Format                : &C01
&             Format parameter name : &C03
&             Variable              : &C02
&             Variable cannot be formatted        
/////////////////////////////////////////////////////////
N3C032035  4  ORIGIN/MANUAL error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Origin manual number  : &I02
&             Cannot create ORIGIN/MANUAL command 
/////////////////////////////////////////////////////////
N3C032036  4  ORIGIN/MANUAL error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Origin manual number  : &I02
&             ORIGIN/Manual defined twice with different
&             values                                    
/////////////////////////////////////////////////////////
N3C032037  4  Error formatting adress value
&             Adress parameter name : &C01
&             Adress definiton      : &C02
&             Format                : &C03
&             Value                 : &R01
&             Adress value cannot be formatted        
/////////////////////////////////////////////////////////
N3C032038  4  Error formatting adress value
&             Adress parameter name : &C01
&             Adress definiton      : &C02
&             Format                : &C03
&             Value                 : &I01
&             Adress value cannot be formatted        
/////////////////////////////////////////////////////////
N3C032039  4  Error creating NC command
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Adress parameter name : &C02
&             Adress definiton      : &C03
&             Format                : &C04
&             Value                 : &R01
&             Adress value cannot be formatted        
/////////////////////////////////////////////////////////
N3C032040  5  Error update variable pool
&             Pool update failed                      
/////////////////////////////////////////////////////////
N3C032041  4  Block error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Block number          : &I02
&             Block                 : &C02
&             Variable assignment in this block failed
/////////////////////////////////////////////////////////
N3C032042  4  Error writing NC Data
&             NC-Word               : &C01
&             Fixed record length too small
/////////////////////////////////////////////////////////
N3C032043  5  Error writing NC Data
&             Line number APT       : &I01
&             APT-line              :
&             &C01
&             NC-Word               : &C02
&             Fixed record length too small
/////////////////////////////////////////////////////////
N3C032044  4  Block error
&             Variable              : &C01
&             Table definiton is wrong                 
&             Table variable index is bigger than 1    
/////////////////////////////////////////////////////////
N3C032045  4  Block error
&             Variable              : &C01
&             Table definiton is wrong                 
&             Table variable has no index            
/////////////////////////////////////////////////////////
N3C032046  4  Block error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Table line number undefined. Index of   
&             table variables can't be determined.    
/////////////////////////////////////////////////////////
N3C032047  4  Undefined SPINDL/RANGE  called
&             Spindl range number  : &I01
&             Spindl range number is undefined   
/////////////////////////////////////////////////////////
N3C032048  4  Block error
&             APT-Word              : &C01
&             Line number APT       : &I01
&             Table line refers undefined variables.  
/////////////////////////////////////////////////////////
N3C032049  4  Formatting of number failed
&             Undefined format      : &C01
&             CF_FMTVAL$ is called with undefined Format
/////////////////////////////////////////////////////////
N3C032100  1  Unknown APT-Command!
&             Line number APT       : &I01
&             Line number Macro-APT : &I02
&             APT-line              :
&             &C02
&             Subprogram            : &C01
&             Unknown APT-Word!
/////////////////////////////////////////////////////////
N3C032101  4  Error on creating NC-Recordnumber
&             Error on creating NC-Recordnumber
/////////////////////////////////////////////////////////
N3C032102  1  NC-Recordnumber overflow
&             NC-Recordnumber overflow
/////////////////////////////////////////////////////////
N3C032103  4  Substring definition is wrong
&             Definition of begin of substring is wrong
&             Term:   &C01
&             String value:  &C02
&             String length: &I02
&             Begin of substring:  &I01
/////////////////////////////////////////////////////////
N3C032104  4  Substring definition is wrong
&             Definition of end of substring is wrong
&             Term:   &C01
&             String value:  &C02
&             String length: &I02
&             End of substring:  &I01
/////////////////////////////////////////////////////////
N3C032105  4  Macrofunction Error
&             Unknown Keyword to function
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Keyword                : &C03
/////////////////////////////////////////////////////////
N3C032106  1  Macro Error (isev=1)
&             Macro Error
&             &C01
/////////////////////////////////////////////////////////
N3C032107  2  Macro Error (isev=2)
&             Macro Error
&             &C01
/////////////////////////////////////////////////////////
N3C032108  3  Macro Error (isev=3)
&             Macro Error
&             &C01
/////////////////////////////////////////////////////////
N3C032109  4  Macro Error (isev=4)
&             Macro Error
&             &C01
/////////////////////////////////////////////////////////
N3C032110  5  Macro Error (isev=5)
&             Macro Error
&             &C01
/////////////////////////////////////////////////////////
N3C032111  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Primary Type           : &C03
&             Syntax Error: Unknown Primary Type
/////////////////////////////////////////////////////////
N3C032112  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Secondary Type         : &C03
&             Syntax Error: Unknown Secondary Type
/////////////////////////////////////////////////////////
N3C032113  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             PP-Identifier          : &C03
&             Syntax Error: Unknown Parameter Identifier
/////////////////////////////////////////////////////////
N3C032114  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Mode                   : &C03
&             Syntax Error: Unknown Command Object Mode
/////////////////////////////////////////////////////////
N3C032115  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Command Object Pointer : &I02
&             Syntax Error: Invalid Command Object Pointer
/////////////////////////////////////////////////////////
N3C032116  4  Macrofunction Error
&             Subprogram : &C01
&             Function   : &C02
&             Variable   : &C03
&             Variable cannot be modified            
/////////////////////////////////////////////////////////
N3C032117  5  AGIEVISION DLL ERROR
&             AGIEVISION DLL ERROR:
&             could not load DLL or get entry points.
&             No output is generated.
/////////////////////////////////////////////////////////
N3C032118  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             PP Id                  : &C03
&             Address parameter id not found         
/////////////////////////////////////////////////////////
N3C032119  5  CENMPMOTIONACCESS DLL ERROR
&             CENMPMOTIONACCESS DLL ERROR:
&             could not load DLL or get entry points.
&             No output is generated.
/////////////////////////////////////////////////////////
N3C032121  4  MO Index failure    
&             Filename              : &C01
&             Can't open File for output       
/////////////////////////////////////////////////////////
N3C032122  4  Temporary ISO Filename failed     
&             Can't create temporary ISO filename
&             for Macro : &C01                       
/////////////////////////////////////////////////////////
N3C032123  4  Temporary ISO Filename failure    
&             Macro :   &C01                        
&             Filename: &C02
&             cannot open file for output before macro call
/////////////////////////////////////////////////////////
N3C032124  4  Temporary ISO Filename failure    
&             Macro :   &C01                        
&             Filename: &C02
&             cannot open file for input after macro call
/////////////////////////////////////////////////////////
N3C032125  3  CF_GETNXTCO Update V1R6 to higher 
&             Macro :    &C01                        
&             Old line:  &C02
&             New line:  &C03
&             Last STYP replaced with "NO_TYPE" due to compatibility
/////////////////////////////////////////////////////////
N3C032126  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             PP-Identifier          : &C03
&             This parameter may not be modified with macro functions.
/////////////////////////////////////////////////////////
N3C032127  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Syntax Error: Wrong number of parameters
&                           Number must be 3, 5, 7 or 9
/////////////////////////////////////////////////////////
N3C032128  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Syntax Error: Rotary axis vector is wrong
/////////////////////////////////////////////////////////
N3C032129  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Syntax Error: Wrong option for CF_ADD_ISOFILE
&                           1st parameter must be "MAIN" or "SUB"   
/////////////////////////////////////////////////////////
N3C032130  5  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Syntax Error: Wrong option for CF_OPEN_ISOFILE
&                           2nd parameter must be "APPEND" or "NEW"
/////////////////////////////////////////////////////////
N3C032131  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Syntax Error: Wrong option for CF_SET_MACSTATE$
&                           2nd parameter must be "ON" or "OFF"
/////////////////////////////////////////////////////////
N3C032132  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             CF_APTTXT not aviable in these special macros  
&             Macro is stopped at this line. Please check this macro.
/////////////////////////////////////////////////////////
N3C032210  4  Macrofunction Error
&             Command                : &C01
&             Sequence               : &C02
&             Linenumber             : &I01
&             Syntax Error: unkown Name -> Macro not found                         
/////////////////////////////////////////////////////////
N3C032678  1  Info PP definied External Editor not valid
&             External Editor could not be found.
&             Trying to use Enviroment Paths
/////////////////////////////////////////////////////////
N3C032679  1  Info External Editor not found in Enviroment
&             External Editor could not be found. 
&             Trying to use System Editor
/////////////////////////////////////////////////////////
N3C032680  1  Info System Editor not available
&             System Editor could not be found or is not defined.
/////////////////////////////////////////////////////////
N3C039988  4  License Error
&             License Error
&             feature name : &C01
&             licensefile  : &C02
&             Expiration time: &I01     
&             Too many days - please contact cenit
/////////////////////////////////////////////////////////
N3C039989  3  License Error
&             License Error
&             feature name : &C01
&             licensefile  : &C02
&             expiration time: &I01     
&             Licenses will be expired soon
/////////////////////////////////////////////////////////
N3C039990  4  License Error
&             License Error
&             Errormessage : &C01
&             feature name : &C02
&             licensefile  : &C03
&             expiration time: permanent
&             Error from FLEXlm Software
/////////////////////////////////////////////////////////
N3C039991  4  License Error
&             License Error:
&             Errormessage : &C01
&             feature name : &C02
&             licensefile  : &C03
&             hostid type  : &I01
&             Error from FLEXlm Software
/////////////////////////////////////////////////////////
N3C039992  4  License Error
&             License Error:
&             Invalid license vendor string: &C01
/////////////////////////////////////////////////////////
N3C039993  4  License Error
&             License Error:
&             Function     : &C01
&             Errormessage : &C02
&             feature name : &C03
&             licensefile  : &C04
&             Error from FLEXlm Software
/////////////////////////////////////////////////////////
N3C039994  4  License Error
&             License Error:
&             Invalid licensetype >&C01< in parameterfile.
/////////////////////////////////////////////////////////
N3C039995  4  License Error 
&             License Error:
&             Invalid user license for this parameterfile.
/////////////////////////////////////////////////////////
N3C039996  4  License Error 
&             License Error:
&             Parameterfile is older than 10 days.
&             Demo License for cPost expired.
/////////////////////////////////////////////////////////
N3C039997  5  License Error 
&             No valid license - limit of 100 lines reached.
&             Output of iso stopped.
/////////////////////////////////////////////////////////
N3C039998  4  License Error
&             License Error:
&             Demo License for cPost parameterfile is out of date.
&             No valid license available.        
/////////////////////////////////////////////////////////
N3C039999  5  Internal Error
&             Internal Error
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
////////////// Fehlerbehandlung Parser///////////////////
// $Revision: 1.2.1.8 $
// $Date: 2008/08/08 16:19:00CEST $
/////////////////////////////////////////////////////////
VIP090501  4  Error in mathematical sequence
&             Subprogram            : &C01
&             Sequence              : &C02
&             Error in mathematical sequence: double sign
/////////////////////////////////////////////////////////
VIP090502  4  Error in mathematical sequence
&             Subprogram            : &C01
&             Sequence              : &C02
&             Error in mathematical sequence: double decimal digit
/////////////////////////////////////////////////////////
VIP090503  4  Error in variable name
&             Subprogram            : &C01
&             Sequence              : &C02
&             Synatx Error: Invalid signs in variablename
/////////////////////////////////////////////////////////
VIP090504  4  Error in mathematical sequence
&             Subprogram            : &C01
&             Sequence              : &C02
&             Error in mathematical sequence: Wrong brackets
/////////////////////////////////////////////////////////
VIP090505  4  Error in mathematical sequence
&             Subprogram            : &C01
&             Variable              : &C02
&             Error in mathematical sequence: variable not found
/////////////////////////////////////////////////////////
VIP090506  4  Error in mathematical sequence
&             Subprogram            : &C01
&             Operator              : &C02
&             Error in mathematical sequence: operator error
/////////////////////////////////////////////////////////
VIP090507  4  Error in mathematical sequence
&             Subprogram            : &C01
&             Sequence              : &C03
&             Error in mathematical sequence: division by zero
/////////////////////////////////////////////////////////
VIP090508  4  Parserstack is full
&             Subprogram            : &C01
&             Term &C02 is too complex.
/////////////////////////////////////////////////////////
VIP090509  4  Internal Error
&             Subprogram            : &C01
&             Term &C02 cannot be calculated.
/////////////////////////////////////////////////////////
VIP090510  4  Error while index variables
&             Subprogram            : &C01
&             Index variable        : &C02
&             Error while index variables: variable with this index
&             not found
/////////////////////////////////////////////////////////
VIP090511  4  Error in mathematical sequence
&             Subprogram : &C01
&             Sequence : &C02
&             Error in mathematical sequence: sign not allowed
/////////////////////////////////////////////////////////
VIP090512  4  Memory error while parser
&             Subprogram            : &C01
&             Input                 : &C02
&             not enough memory for temporary variable
/////////////////////////////////////////////////////////
VIP090513  4  Error while index variables
&             Subprogram            : &C01
&             Variable              : &C02
&             the index depth of a variable is too high
/////////////////////////////////////////////////////////
VIP090514  4  String error while parser
&             Subprogram            : &C01
&             Input                 :
&             &C02
&             the inputstring is too long
/////////////////////////////////////////////////////////
VIP090515  4  String error while parser
&             Subprogram            : &C01
&             the inputstring is a NULL-pointer
/////////////////////////////////////////////////////////
VIP090516  4  Error while parser
&             Subprogram            : &C01
&             Input                 : &C02
&             term is too complex
&             too much temporary variables needed
/////////////////////////////////////////////////////////
VIP090517  4  Error while parser
&             Subprogram            : &C01
&             Input                 : &C02
&             The index is too complex for
&             this subroutine
/////////////////////////////////////////////////////////
VIP090518  4  Error while parser
&             Subprogram            : &C01
&             Input                 : &C02
&             Syntax Error
/////////////////////////////////////////////////////////
VIP090519  4  Error while parser
&             Subprogram            : &C01
&             Function              : &C02
&             Right number          : &I01
&             No arguments for the function
/////////////////////////////////////////////////////////
VIP090520  4  Error while parser
&             Subprogram            : &C01
&             Function              : &C02
&             Wrong number          : &I01
&             Right number          : &I02
&             Number of arguments for function is wrong
/////////////////////////////////////////////////////////
VIP090521  4  Error while parser
&             Subprogram            : &C01
&             Function              : &C02
&             Function is not allowed in parser
/////////////////////////////////////////////////////////
VIP090522  4  Error while parser
&             Subprogram            : &C01
&             Variable              : &C02
&             Character not allowed in variablename
/////////////////////////////////////////////////////////
VIP090523  4  Error in Varpool / Parser
&             CVP Runtime Version   : &C01
&             Requested CVP Version : &C02
&             Future version of Cenit VarPool/Parser requested. Program may fail.
/////////////////////////////////////////////////////////
VIP090530  4  Error in formstr
&             Subprogram            : &C01
&             Initialization for formats failed
/////////////////////////////////////////////////////////
VIP090531  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             Out of Bounds: String to format has too many sub strings. 
/////////////////////////////////////////////////////////
VIP090532  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             Fix string            : &C03
&             Syntax Error: Format for fix string is not allowed. 
/////////////////////////////////////////////////////////
VIP090533  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             Variablename          : &C03
&             Syntax Error: Invalid variable type for substring operator (not a string). 
/////////////////////////////////////////////////////////
VIP090534  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             String                : &C03
&             Syntax Error: Invalid signs in string. 
/////////////////////////////////////////////////////////
VIP090535  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             Format                : &C03
&             Syntax Error: Missing Value/Term for format definition.
/////////////////////////////////////////////////////////
VIP090536  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             String                : &C03
&             Syntax Error: Variable type not supported for format definition.
/////////////////////////////////////////////////////////
VIP090537  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             Variablename          : &C03
&             Syntax error: Invalid signs in variablename. 
/////////////////////////////////////////////////////////
VIP090538  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             Variablename          : &C03
&             Failed to get type of variable (variable may not exist). 
/////////////////////////////////////////////////////////
VIP090539  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             Variable name         : &C03
&             Variable type         : &C04
&             Failed to get value of variable (variable may not exist or has invalid type).
/////////////////////////////////////////////////////////
VIP090540  4  Error in formstr
&             Subprogram            : &C01
&             Input string          : &C02
&             Operator              : &C03
&             Syntax Error: Unknown operation for conditional expression. 
/////////////////////////////////////////////////////////
VIP090550  4  Error while Regexp parser
&             Regular expression    : &C01
&             Regexp errorcode:     : &I01 (see documentation)
&             Error in regular expression
/////////////////////////////////////////////////////////
VIP090551  3  Error in Mapping Table Definition
&             Line number           : &I01
&             Current Map Line      : &C01
&             Complete Map Line     : &C02
&             Syntax Error: No more lines in Mapping Table. 
&                           '$' at end of current line is ignored.
/////////////////////////////////////////////////////////
VIP090552  4  Error in Mapping Table Definition
&             Line number           : &I01
&             Complete Map Line     : &C01
&             Too many regular expression terms in IN-Expression 
&             of mapping table (max. is &I02). 
/////////////////////////////////////////////////////////
VIP090553  4  Error in Mapping Table Definition
&             Line number           : &I01
&             Complete Map Line     : &C01
&             Too many parameters in IN-Expression
&             of mapping table (max. is &I02). 
/////////////////////////////////////////////////////////
VIP090554  4  Error in Mapping Table Definition
&             Expression            : &C01
&             Index used            : &I01
&             Variable index out of range. (Range: 1..999)
/////////////////////////////////////////////////////////
VIP090555  4  Error in Mapping Table Definition
&             Line number           : &I01
&             Complete Map Line     : &C01
&             Error in IN-Expression of mapping definition.
/////////////////////////////////////////////////////////
VIP090556  4  Error in Mapping Table Definition
&             OUT-Expression        : &C01
&             Failed to build OUT-Expression.
/////////////////////////////////////////////////////////
VIP090557  4  Error in Mapping Table Definition
&             Line number           : &I01
&             Complete Map Line     : &C01
&             Syntax error: Closing " missing.
/////////////////////////////////////////////////////////
VIP090558  4  Error in Mapping Table Definition
&             Line number           : &I01
&             Complete Map Line     : &C01
&             Warning: Unknown Flag >&C02< defined.
/////////////////////////////////////////////////////////
VIP090559  4  Error in Mapping Table Definition
&             Line number           : &I01
&             Complete Map Line     : &C01
&             Warning: Empty IN Expression is skipped.
/////////////////////////////////////////////////////////
VIP090560  4  Error in Mapping Table Definition
&             Line number           : &I01
&             Complete Map Line     : &C01
&             Too many lines in OUT-Expression
&             of mapping table (max. is &I02). 
/////////////////////////////////////////////////////////
VIP090561  3  Error in Mapping Table Definition
&             Line number           : &I01
&             Definition Line       : &C01
&             Syntax Error in FORMAT: section of the Mapping Table.
&             Invalid RX Variable definition.
/////////////////////////////////////////////////////////
VIP090562  3  Error in Mapping Table Definition
&             Line number           : &I01
&             Definition Line       : &C01
&             Syntax Error in FORMAT: section of the Mapping Table.
&             Invalid variable format definition.
/////////////////////////////////////////////////////////
VIP090563  4  Error in Mapping Table Definition
&             RXMap Runtime Version : &C01
&             Mapping Table Version : &C02
&             Future version of Mapping Table definitions not supported.
/////////////////////////////////////////////////////////
VIP090564  4  Error in Mapping Table Definition
&             Internal Error: Mapping Table not read yet. No version information available.
/////////////////////////////////////////////////////////
VIP090580  4  Error in number formatter
&             Subprogram            : &C01
&             Format Error: empty format definition string 
/////////////////////////////////////////////////////////
VIP090581  4  Error in number formatter
&             Subprogram            : &C01
&             Symbolic format name  : &C02
&             Format Error: unknown symbolic format name 
/////////////////////////////////////////////////////////
VIP090582  4  Error in number formatter
&             Subprogram            : &C01
&             Format definition     : &C02
&             Format Error: error in integer places definition
/////////////////////////////////////////////////////////
VIP090583  4  Error in number formatter
&             Subprogram            : &C01
&             Format definition     : &C02
&             Format Error: error in decimal places definition
/////////////////////////////////////////////////////////
VIP090584  4  Error in number formatter
&             Subprogram            : &C01
&             Format Error: pointer to output string is NULL. 
/////////////////////////////////////////////////////////
VIP090585  4  Error in number formatter
&             Subprogram            : &C01
&             Format definition     : &C02
&             Format Error: failed to format value. 
/////////////////////////////////////////////////////////
VIP090599  4  Initialisation error
&             Subprogram            : &C01
&             Dimension of variable pool not sufficient
&             Amount of variables not sufficient
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////// Fehlerbehandlung Variablenpool //////////////
// $Revision: 1.2.1.3 $
// $Date: 2008/08/08 16:18:58CEST $
/////////////////////////////////////////////////////////
N3C090001  3  Error in varpool
&             Subprogram            : &C01
&             Invalid name '&C02'
/////////////////////////////////////////////////////////
N3C090003  5  Error in varpool
&             Subprogram            : &C01
&             no active pool
/////////////////////////////////////////////////////////
N3C090004  5  Error in varpool
&             Subprogram            : &C01
&             not enough memory
/////////////////////////////////////////////////////////
N3C090005  3  Error in varpool
&             Subprogram            : &C01
&             Pool                  : &C02
&             Variablename          : &C03
&             variable does not exist
/////////////////////////////////////////////////////////
N3C090006  3  Error in varpool
&             Subprogram            : &C01
&             Pool                  : &C02
&             Variablename          : &C03
&             unknown variabletype  : &I01
/////////////////////////////////////////////////////////
N3C090009  3  Error in varpool
&             Subprogram            : &C01
&             Pool                  : &C02
&             Variablename          : &C03
&             invalid lenght of pool- or variablename
/////////////////////////////////////////////////////////
N3C090010  3  Error in varpool
&             Subprogram            : &C01
&             Pool                  : &C02
&             Variablename          : &C03
&             invalid variabletyp   : &I01
/////////////////////////////////////////////////////////
N3C090011  3  Error in varpool
&             Subprogram            : &C01
&             Pool                  : &C02
&             pool does not exist
/////////////////////////////////////////////////////////
N3C090012  3  Error in varpool
&             Subprogram            : &C01
&             Pool                  : &C02
&             pool already exist
/////////////////////////////////////////////////////////
VIP091100  4  Error in variable assignment
&             Assignment string     : &C01
&             Left side             : &C02
&             Right side            : &C03
&             Assignment failed - 
&             type of variables undefined
/////////////////////////////////////////////////////////
VIP091101  4  Error in variable assignment
&             Assignment string     : &C01
&             Left side             : &C02
&             Right side            : &C03
&             Assignment of text into numerical variable
/////////////////////////////////////////////////////////
VIP091102  4  Error in variable assignment
&             Assignment string     : &C01
&             Left side             : &C02
&             Right side            : &C03
&             Assignment of numerical into text variable
/////////////////////////////////////////////////////////
VIP091103  4  Substring definition impossible
&             Definition            : &C01
&             Possible syntax form: A(2:3), A(:6),A(5:) 
/////////////////////////////////////////////////////////
VIP091104  4  Substring definition impossible
&             Definition            : &C01
&             Substring beginning   : &C02
&             Calculation of substring beginning failed 
/////////////////////////////////////////////////////////
VIP091105  4  Substring definition impossible
&             Definition            : &C01
&             Substring end         : &C02
&             Calculation of substring end failed 
/////////////////////////////////////////////////////////
VIP091106  3  Substring definition impossible
&             Definition            : &C01
&             Substring beginning   : &I01
&             Substring end         : &I02
&             Substring beginning value is bigger than ending value
/////////////////////////////////////////////////////////
VIP091107  3  Substring limit error    
&             String term complete  : &C01
&             Term with error       : &C02
&             Substring limits not correct defined
/////////////////////////////////////////////////////////
VIP091108  4  Error in variable assignment
&             Assignment string     : &C01
&             Left side             : &C02
&             Right side            : &C03
&             Assignment failed - 
&             Error in right side definition 
/////////////////////////////////////////////////////////
VIP091109  4  Error in variable assignment
&             Subprogram            : &C01
&             Expression            : &C02
&             Pool                  : &C03
&             Variablename          : &C04
&             Warning: Variable does not exist in pool.
&             Variable is generated with default type STRING. 
/////////////////////////////////////////////////////////
VIP091110  4  Error in variable assignment
&             Subprogram            : &C01
&             Expression            : &C02
&             Pool                  : &C03
&             Variablename          : &C04
&             Warning: Variable does not exist in pool.
&             Variable is generated with default type NUMBER. 
/////////////////////////////////////////////////////////
VIP091111  4  Error in format initialization
&             Subprogram            : &C01
&             Error: Variable format initialization failed. Program may crash. 
/////////////////////////////////////////////////////////
VIP091112  4  Error in format initialization
&             Subprogram            : &C01
&             Format ID             : &I01
&             Error: Unknown default Variable format ID. 
/////////////////////////////////////////////////////////
VIP091113  4  Error in format initialization
&             Subprogram            : &C01
&             Format ID             : &I01
&             Variable Type         : &I02
&             Error: Requested variable type for format ID unknown.
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
////////////// Fehlerbehandlung Interpreter /////////////
// $Revision: 1.9.1.7 $
// $Date: 2008/08/29 18:55:45CEST $
//
// Sample:
//VIP<Errno> <severity> <Short Message Text>
//&        <Long Message text 1>           
//&        <Long Message text 2>           
//&        ..
//&        <Long Message text 5>           
//
// Variable replacement:
//&             Test String           : &C01
//&             Test Integer          : &I01
//&             Test Real             : &R01
//&             Test Real with format : &R01 (F11.5)
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
VIP090200  5  Error in Interpreter
&             Subprogram            : &C01
&             Identifier            : &C02
&             Core: Failed to allocate memory
/////////////////////////////////////////////////////////
VIP090201  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Unknown command
/////////////////////////////////////////////////////////
VIP090202  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Target not found
/////////////////////////////////////////////////////////
VIP090203  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: no Target specified
/////////////////////////////////////////////////////////
VIP090204  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: RETURN without GOSUB
/////////////////////////////////////////////////////////
VIP090205  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Incomplete statement
/////////////////////////////////////////////////////////
VIP090206  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: ON without GOTO or GOSUB
/////////////////////////////////////////////////////////
VIP090207  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Value is out of range
/////////////////////////////////////////////////////////
VIP090208  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Line number &I02 not found
/////////////////////////////////////////////////////////
VIP090209  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: File cannot be opened. Check filename.
/////////////////////////////////////////////////////////
VIP090210  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Filename missing
/////////////////////////////////////////////////////////
VIP090211  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Invalid Filename. Argument not of type STRING.
/////////////////////////////////////////////////////////
VIP090212  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Runtime Error: Failed to open file:
&             &C03
/////////////////////////////////////////////////////////
VIP090213  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: GOSUB or RESET statement missing
/////////////////////////////////////////////////////////
VIP090214  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Incomplete statement, missing equal sign
/////////////////////////////////////////////////////////
VIP090215  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Runtime Error: Failed to set environment variable
/////////////////////////////////////////////////////////
VIP090216  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: IF without THEN
/////////////////////////////////////////////////////////
VIP090217  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: ELSE without IF
/////////////////////////////////////////////////////////
VIP090218  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: ELSEIF without IF
/////////////////////////////////////////////////////////
VIP090219  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: END IF without IF
/////////////////////////////////////////////////////////
VIP090220  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Multiline IF without END IF
/////////////////////////////////////////////////////////
VIP090221  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: SELECT without CASE
/////////////////////////////////////////////////////////
VIP090222  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: CASE has inexplicable code
/////////////////////////////////////////////////////////
VIP090223  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Number expected
/////////////////////////////////////////////////////////
VIP090224  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: SELECT without END SELECT
/////////////////////////////////////////////////////////
VIP090225  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: END SELECT without SELECT
/////////////////////////////////////////////////////////
VIP090226  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: End of loop without DO or WHILE
/////////////////////////////////////////////////////////
VIP090227  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: WHILE without WEND
/////////////////////////////////////////////////////////
VIP090228  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: DO without LOOP
/////////////////////////////////////////////////////////
VIP090229  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090230  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: FOR without TO
/////////////////////////////////////////////////////////
VIP090231  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: NEXT without FOR
/////////////////////////////////////////////////////////
VIP090232  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: EXIT FOR without FOR
/////////////////////////////////////////////////////////
VIP090233  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: FOR without NEXT
/////////////////////////////////////////////////////////
VIP090234  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable              : &C03
&             Type Mismatch: Number variable required
/////////////////////////////////////////////////////////
VIP090235  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Expression            : &C03
&             Syntax Error: Incomplete statement. Check parenthesis.
/////////////////////////////////////////////////////////
VIP090236  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Expression (truncated): &C03
&             max. Stringsize       : &I02
&             Overflow: String constant exceeds max. stringsize
/////////////////////////////////////////////////////////
VIP090237  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Expression            : &C03
&             Type Mismatch: Expression is not a numerical constant
/////////////////////////////////////////////////////////
VIP090238  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Function name         : &C03
&             Runtime Error: Failed to find function
/////////////////////////////////////////////////////////
VIP090239  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Expression            : &C03
&             Runtime Error: Unknown expression
/////////////////////////////////////////////////////////
VIP090240  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Expression            : &C03
&             Syntax Error: Error detected in parsing expression
/////////////////////////////////////////////////////////
VIP090241  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Expression            : &C03
&             Syntax Error: String concatenation in wrong position
/////////////////////////////////////////////////////////
VIP090242  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Expression            : &C03
&             Syntax Error: Incomplete expression
/////////////////////////////////////////////////////////
VIP090243  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             entry stack level     : &I02
&             exit stack level      : &I03
&             Syntax Error: Stack levels does not match
/////////////////////////////////////////////////////////
VIP090244  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Operationtype         : &I02
&             Syntax Error: Invalid operation type. Operation must be of type &C03.
/////////////////////////////////////////////////////////
VIP090245  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Expressiontype        : &I02
&             Syntax Error: Invalid expression type. Expression must be of type &C03.
/////////////////////////////////////////////////////////
VIP090246  5  Error in Interpreter
&             Command               : &C01
&             Stack                 : &C02
&             Stack counter         : &I01
&             Overflow: Stack limit reached
/////////////////////////////////////////////////////////
VIP090247  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Not enough parameters to function
/////////////////////////////////////////////////////////
VIP090248  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Too many parameters to function
/////////////////////////////////////////////////////////
VIP090249  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Function Argument #&I02 must be of type String
/////////////////////////////////////////////////////////
VIP090250  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Function Argument #&I02 must be of type Number
/////////////////////////////////////////////////////////
VIP090251  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &I02
&             Syntax Error: Invalid device number
/////////////////////////////////////////////////////////
VIP090252  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable Name         : &I03
&             Syntax Error: Variable type conversion failed
/////////////////////////////////////////////////////////
VIP090253  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Line &I02 is not a DATA statement
/////////////////////////////////////////////////////////
VIP090254  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: No comma after #n
/////////////////////////////////////////////////////////
VIP090255  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &I02
&             Syntax Error: Device number is out of range
/////////////////////////////////////////////////////////
VIP090256  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Device #&I02 is not opened
/////////////////////////////////////////////////////////
VIP090257  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &I02
&             Syntax Error: Device is not open for INPUT
/////////////////////////////////////////////////////////
VIP090258  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Expected quotation mark
/////////////////////////////////////////////////////////
VIP090259  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable              : &C03
&             Syntax Error: Variable of unknown type
/////////////////////////////////////////////////////////
VIP090260  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Numerical Term        : &C03
&             Syntax Error: Unexpected character in numerical term
/////////////////////////////////////////////////////////
VIP090261  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: INPUT keyword missing
/////////////////////////////////////////////////////////
VIP090262  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable name         : &C03
&             Type Mismatch: String variable required
/////////////////////////////////////////////////////////
VIP090263  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Not enough parameters to core function
/////////////////////////////////////////////////////////
VIP090264  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Too many parameters to core function
/////////////////////////////////////////////////////////
VIP090265  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: No device name specified
/////////////////////////////////////////////////////////
VIP090266  5  Error in Interpreter
&             Subprogram            : &C01
&             Core: Failed to set precision
/////////////////////////////////////////////////////////
VIP090267  5  Error in Interpreter
&             Operation Type        : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Types does not match for this operation
/////////////////////////////////////////////////////////
VIP090268  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Strings cannot be subtracted
/////////////////////////////////////////////////////////
VIP090269  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Strings cannot be multiplied
/////////////////////////////////////////////////////////
VIP090270  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Strings cannot be divided
/////////////////////////////////////////////////////////
VIP090271  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Math Error: Division by zero
/////////////////////////////////////////////////////////
VIP090272  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Error in Assignment
/////////////////////////////////////////////////////////
VIP090273  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable name         : &C02
&             Type Mismatch: Variable left of assignment operator
&                            has unidentified type
/////////////////////////////////////////////////////////
VIP090274  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: String comparison failed
/////////////////////////////////////////////////////////
VIP090275  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Strings cannot be taken as exponents
/////////////////////////////////////////////////////////
VIP090276  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Strings cannot be compared logically
/////////////////////////////////////////////////////////
VIP090277  5  Error in Interpreter
&             Command               : &C01
&             Core: new Task number requested is already in use
/////////////////////////////////////////////////////////
VIP090278  4  Error in Interpreter
&             CMI Runtime Version   : &C01
&             Requested CMI Version : &C02
&             Future version of Cenit Macro Interpreter requested. Program may fail.
/////////////////////////////////////////////////////////
VIP090279  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &I02
&             Syntax Error: device is not open for OUTPUT
/////////////////////////////////////////////////////////
VIP090280  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Failed to find semicolon after format string.
/////////////////////////////////////////////////////////
VIP090281  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Format string missing
/////////////////////////////////////////////////////////
VIP090282  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Format and output variable are not of same type
/////////////////////////////////////////////////////////
VIP090283  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Unknown Format type
/////////////////////////////////////////////////////////
VIP090284  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Invalid device number
/////////////////////////////////////////////////////////
VIP090285  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: END SUB without SUB
/////////////////////////////////////////////////////////
VIP090286  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Requested width is out of range (1 - &I02)
/////////////////////////////////////////////////////////
VIP090287  5  Error in Interpreter
&             Command               : &C01
&             Description           : &C02
&             Core: (Internal error) call to scan while CURTASK rescan != TRUE
/////////////////////////////////////////////////////////
VIP090288  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Function/Subroutine   : &C03
&             Syntax Error: Failed to find Function or Subroutine
/////////////////////////////////////////////////////////
VIP090289  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: SUB without CALL
/////////////////////////////////////////////////////////
VIP090290  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: SUB without END SUB
/////////////////////////////////////////////////////////
VIP090291  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Label                 : &C03
&             Syntax Error: Failed to find label
/////////////////////////////////////////////////////////
VIP090292  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: LOOP without DO
/////////////////////////////////////////////////////////
VIP090293  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: LOOP without WHILE
/////////////////////////////////////////////////////////
VIP090294  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Nonsense or nothing following &C01
/////////////////////////////////////////////////////////
VIP090295  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: EXIT DO without DO
/////////////////////////////////////////////////////////
VIP090296  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Variables have different type
/////////////////////////////////////////////////////////
VIP090297  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Nb. Arguments         : &I02
&             Overflow: Maximum number of Function Args exceeded
/////////////////////////////////////////////////////////
VIP090298  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Incomplete statement. Missing closing parenthesis.
/////////////////////////////////////////////////////////
VIP090299  5  Error in Interpreter
&             Command               : &C01
&             Line                  : &C02
&             Linenumber            : &I01
&             Core: Failed to link line
/////////////////////////////////////////////////////////
VIP090300  5  Error in Interpreter
&             Command               : &C01
&             Line                  : &C02
&             Linenumber            : &I01
&             Macro Linenumber      : &I02
&             Syntax Error: Linenumber (Label) Overflow
/////////////////////////////////////////////////////////
VIP090301  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Macro Linenumber      : &I02
&             Syntax Error: Linenumber (Label) is below minimum
/////////////////////////////////////////////////////////
VIP090302  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Multi-segmented lines not supported
/////////////////////////////////////////////////////////
VIP090303  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable              : &C03
&             Syntax Error: Invalid variable name
/////////////////////////////////////////////////////////
VIP090304  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             I/O Error: Out of data
/////////////////////////////////////////////////////////
VIP090305  5  Error in Interpreter
&             Command               : &C01
&             Core: Invalid number of arguments.
&                   Program file not specified
/////////////////////////////////////////////////////////
VIP090306  5  Error in Interpreter
&             Command               : &C01
&             Core: Failed to open program file:
&                   &C02
/////////////////////////////////////////////////////////
VIP090307  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             String Constant       : &C03
&             Syntax Error: Incomplete string constant
/////////////////////////////////////////////////////////
VIP090308  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Numerical Sequence    : &C03
&             Character             : &C04
&             Syntax Error: Unexpected character in numerical sequence
/////////////////////////////////////////////////////////
VIP090309  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &C03
&             Type Mismatch: Device number not of type Number
/////////////////////////////////////////////////////////
VIP090310  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Field size not of type Number
/////////////////////////////////////////////////////////
VIP090311  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Missing AS statement
/////////////////////////////////////////////////////////
VIP090312  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variablename          : &C03
&             Local field variable already in use cannot be declared as COMMON
/////////////////////////////////////////////////////////
VIP090313  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &C03
&             Overflow: Record length exceeded
/////////////////////////////////////////////////////////
VIP090314  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Nb. of characters for target string is zero
/////////////////////////////////////////////////////////
VIP090315  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Nb. of Characters     : &I02
&             Syntax Error: Nb. of characters for target string
&                           exceeds min. or max.
/////////////////////////////////////////////////////////
VIP090316  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: Expression for assignment must be of type String
/////////////////////////////////////////////////////////
VIP090317  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Non-contiguous string created
/////////////////////////////////////////////////////////
VIP090318  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Start Position        : &I02
&             Syntax Error: Target string start position out of range
/////////////////////////////////////////////////////////
VIP090319  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable Name         : &C03
&             Type Mismatch: Previous dimensioned variable cannot be re-dimensioned
/////////////////////////////////////////////////////////
VIP090320  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variablename          : &C03
&             Type Mismatch: Variable in use cannot be re-dimensioned
/////////////////////////////////////////////////////////
VIP090321  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variablename          : &C03
&             Syntax Error: Invalid variable dimension
/////////////////////////////////////////////////////////
VIP090322  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Unexpected end of &C01 statement
/////////////////////////////////////////////////////////
VIP090323  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable Name         : &C03
&             Type Mismatch: ERASE only eliminates arrayed variables from the program
/////////////////////////////////////////////////////////
VIP090324  1  Warning in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable Name         : &C03
&             Type Mismatch Warning: Interpreter changes type of variable to String
/////////////////////////////////////////////////////////
VIP090325  1  Warning in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable Name         : &C03
&             Type Mismatch Warning: Interpreter changes type of variable to Number
/////////////////////////////////////////////////////////
VIP090326  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Type Mismatch: String expected for device name
/////////////////////////////////////////////////////////
VIP090327  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Number expected for record length
/////////////////////////////////////////////////////////
VIP090328  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Mode                  : &C03
&             Syntax Error: Invalid device mode for open
/////////////////////////////////////////////////////////
VIP090329  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090330  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Missing equal sign after LEN statement
/////////////////////////////////////////////////////////
VIP090331  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &I02
&             Syntax Error: Device number is already in use
/////////////////////////////////////////////////////////
VIP090332  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device Name           : &C03
&             Syntax Error: Failed to open device
/////////////////////////////////////////////////////////
VIP090333  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Failed to get memory for device buffer
/////////////////////////////////////////////////////////
VIP090334  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device Number         : &I02
&             Syntax Error: Failed to close device
/////////////////////////////////////////////////////////
VIP090335  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Argument to command &C01 must be a string
/////////////////////////////////////////////////////////
VIP090336  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Core: Command failed
/////////////////////////////////////////////////////////
VIP090337  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &I02
&             Record number         : &I03
&             Offset                : &I04
&             I/O Error: Failed to position in file
/////////////////////////////////////////////////////////
VIP090338  2  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Device number         : &I02
&             I/O Warning: Only random-access buffers can be flushed
/////////////////////////////////////////////////////////
VIP090339  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Error number          : &I02
&             Syntax Error: Error number is out of range
/////////////////////////////////////////////////////////
VIP090340  2  Error in Interpreter
&             Command               : &C01
&             Filename              : &C02
&             Device Number         : &I01
&             Warning: Force CLOSE file on macro interpreter exit
/////////////////////////////////////////////////////////
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090342  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090343  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Incorrect sequence of letters for DEF... command
/////////////////////////////////////////////////////////
VIP090344  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Command OPTION BASE after DIM not allowed
/////////////////////////////////////////////////////////
VIP090345  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Statement             : &C03
&             Syntax Error: Value for OPTION BASE must be 1 or 0
/////////////////////////////////////////////////////////
VIP090346  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090347  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Command &C01 not implemented yet
/////////////////////////////////////////////////////////
VIP090348  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090349  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Syntax Error: Invalid argument for function or subroutine definition
/////////////////////////////////////////////////////////
VIP090350  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variable Type         : &C03
&             Syntax Error: Unknown Variable type for DIM AS command
/////////////////////////////////////////////////////////
VIP090351  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Function              : &C03
&             Max. Nb. of Arguments : &I02
&             Syntax Error: Too many arguments to function
/////////////////////////////////////////////////////////
VIP090352  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Function              : &C03
&             Syntax Error: Brackets does not match
/////////////////////////////////////////////////////////
VIP090353  5  Error in Interpreter
&             Command               : &C01
&             Type                  : &I01
&             Core: Unknown variable type in pool
/////////////////////////////////////////////////////////
VIP090354  5  Error in Interpreter
&             Command               : &C01
&             Type                  : &I01
&             Core: Unknown variable-type in interpreter
&                   >>> Program Terminated <<<
&                   (Please call your local support)
/////////////////////////////////////////////////////////
VIP090355  5  Error in Interpreter
&             Core: Internal not allowed NULL string assignment
&                   >>> Program Terminated <<<
&                   (Please call your local support)
/////////////////////////////////////////////////////////
VIP090356  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090357  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090358  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             (free)
/////////////////////////////////////////////////////////
VIP090359  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Variablename          : &C03
&             Syntax Error: Variable not found in scope of application
/////////////////////////////////////////////////////////
VIP090360  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Variablename          : &C03
&             Syntax Error: Function not supported for dimensioned Variables
/////////////////////////////////////////////////////////
VIP090361  5  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Calling variablename  : &C03
&             Function argument     : &C04
&             Syntax Error: Failed to assign calling variable to local function argument
/////////////////////////////////////////////////////////
VIP090362  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Core: Unknown Option Key &C03
/////////////////////////////////////////////////////////
VIP090363  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Core: Invalid Option value >&I02< for Key &C03
/////////////////////////////////////////////////////////
VIP090364  4  Error in Interpreter
&             Command               : &C01
&             Sequence              : &C02
&             Linenumber            : &I01
&             Core: Invalid Option value >&C03< for Key &C04
/////////////////////////////////////////////////////////
///// Fehlerhandling System command errors 1..255 ///////
/////////////////////////////////////////////////////////
SYS092000  4  Error in System Command
&             Command               : &C01
&             System Command        : &C02
&             Linenumber            : &I01
&             Command Returncode    : &I02
&             Command Error message : &C03
&             >>> Error on System Command execution <<<
/////////////////////////////////////////////////////////
// SYS092001..SYS092255 reserved for System RC mapping //
// --> (internal) RC + 92000                           //
/////////////////////////////////////////////////////////

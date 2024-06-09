*****************************************************************
*								*
*	Messages constituant le bilan SAG			*
*								*
*****************************************************************


*****************************************************************
*	Messages dont l'identificateur est "report"		*
*****************************************************************
0	i	I_REP_TITLE
"**      S A G    E X E C U T I O N    R E P O R T    **\n\
	=========================================\n\n\n"

1	i	I_REP_TITLOPT
"Option list :                               Date : %s\n\
-------------                               ------\n\n"

2	i	I_REP_PARM_UTI_READ
"   -  Description read\n\n"

3	i	I_REP_PARM_UTI_ADD
"   -  Description addition\n\n"

4	i	I_REP_PARM_UTI_WRITE
"   -  Description modification\n\n"

5	i	I_REP_PARM_UTI_DELETE
"   -  Description deletion\n\n"

6	i	I_REP_PARM_UTI_XREF
"   -  Calling routines list \n\n"

7	i	I_REP_PARM_UTI_CALL
"   -  Called routines list\n\n"

8	i	I_REP_PARM_UTI_CMP
"   -  Description comparison\n\n"

9	i	I_REP_PARM_REV_ARG
"   -  Argument checking\n\n"

10	i	I_REP_PARM_REV_INIT
"   -  Uninitialized variable checking\n\n"

11	i	I_REP_PARM_REV_MERR
"   ----  multi-path mode\n\n"

12	i	I_REP_PARM_REV_LOOP
"   ----  DO loop mode\n\n"

13	i	I_REP_PARM_GEN_DESC
"   -  Description generation\n\n"

14	i	I_REP_PARM_GEN_CALLS
"   -  References generation\n\n"

15	i	I_REP_PARM_REV_DECL
"   -  Implicit declaration detection\n\n"

16	i	I_REP_TITLRES
"\n\n                    ===================\n\
		       R E S U L T S\n\
		    ===================\n\n\n"


17	i	I_REP_SRC_BEGIN
"Number of analyzed files                       : %4d\n\n"

18	i	I_REP_GOODEND
"Number of succeeded analysies                  : %4d\n\n"

19	i	I_REP_BADEND
"Number of failed analysies                     : %4d\n\n"

20	i	I_REP_READLIB
"Number of descriptions read                    : %4d\n\n"

21	i	I_REP_LIB_BEGIN
"Number of processed descriptions               : %4d\n\n"


*****************************************************************
*	Messages dont l'identificateur est calcule (leur numero *
*	doit etre superieur ou egal a 100)			*
*****************************************************************
100	i	I_REP_LEX
"Number of lexical errors                   : %4d\n\n"

101	i	I_REP_YACC
"Number of syntax errors                    : %4d\n\n"

102	i	I_REP_ENDDO
"Number of END DO statement errors          : %4d\n\n"

103	i	I_REP_ELSE
"Number of ELSE statement errors            : %4d\n\n"

104	i	I_REP_ENDIF
"Number of END IF statement errors          : %4d\n\n"

105	i	I_REP_IF
"Number of IF statement errors              : %4d\n\n"

106	i	I_REP_DO
"Number of DO statement errors              : %4d\n\n"

107	i	I_REP_ELABEL
"Number of undefined labels                 : %4d\n\n"

108	i	I_REP_WLABEL
"Number of unreferenced labels              : %4d\n\n"

109	i	I_REP_IMPL
"Number of implicit declarations            : %4d\n\n"

110	i	I_REP_DEFIMPL
"Number of implicit specified declarations  : %4d\n\n"

111	i	I_REP_UNINIT
"Number of uninitialized variables          : %4d\n\n"

112	i	I_REP_MISDESC
"Number of missing descriptions             : %4d\n\n"

113	i	I_REP_OVERCONST
"Number of overwritten constants            : %4d\n\n"

114	i	I_REP_OVERPARAM
"Number of overwritten parameters           : %4d\n\n"

115	i	I_REP_OVERFUNC
"Number of overwritten functions            : %4d\n\n"

116	i	I_REP_OVEREXPR
"Number of overwritten expressions          : %4d\n\n"

117	i	I_REP_TYPE
"Number of argument type errors             : %4d\n\n"

118	i	I_REP_LENGTH
"Number of argument length of type errors   : %4d\n\n"

119	i	I_REP_DIM
"Number of argument dimension bounds errors : %4d\n\n"

120	i	I_REP_ARRAY
"Number of array errors                     : %4d\n\n"

121	i	I_REP_TOOARG
"Number of too many arguments errors        : %4d\n\n"

122	i	I_REP_LESSARG
"Number of missing argument errors          : %4d\n\n"

123	i	I_REP_TOOLAB
"Number of too many labels errors           : %4d\n\n"

124	i	I_REP_LESSLAB
"Number of missing labels errors            : %4d\n\n"

125	i	I_REP_MODUNDEF
"Number of unused dummy arguments           : %4d\n\n"

126	i	I_REP_NOFUNC
"Number of function call errors             : %4d\n\n"

127	i	I_REP_NOSUB
"Number of subroutine call errors           : %4d\n\n"

128	i	I_REP_OVERDESC
"Number of attempted overwriting of the user description : %4d\n\n"

129	i	I_REP_GENUNDEF
"Number of unused dummy arguments           : %4d\n\n"

130	i	I_REP_GENDESC
"Number of generated descriptions           : %4d\n\n"

131	i	I_REP_MISSLIB
"Number of missing descriptions             : %4d\n\n"

132	i	I_REP_EXISTLIB
"Number of already existing descriptions    : %4d\n\n"

205	e	I_REP_INTER_NAME
"Number of descriptions coming from different units : %d\n"

206	e	I_REP_INTER_UNIT
"Number of descriptions with different kind of program unit : %d\n"

207	e	I_REP_INTER_NARG
"Number of descriptions with different number of arguments : %d\n"

208	e	I_REP_INTER_CLASS
"Number of descriptions with incompatible argument class : %d\n"

209	e	I_REP_INTER_FTYPE
"Number of descriptions with incompatible function type : %d\n"

210	e	I_REP_INTER_FTYPESZ
"Number of descriptions with incompatible function type size : %d\n"

211	e	I_REP_INTER_ATYPE
"Number of incompatibility of argument type : %d\n"

212	e	I_REP_INTER_ATYPESZ
"Number of incompatibility of argument type size : %d\n"

213	e	I_REP_INTER_AMODE
"Number of incompatibility of argument mode : %d\n"

214	e	I_REP_INTER_ANDIM
"Number of incompatibility of number of dimensions : %d\n"

215	e	I_REP_INTER_ADIM
"Number of incompatibility of dimension : %d\n"

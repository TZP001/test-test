
********************************************************************
*                                                                  *
*  MESSAGES CONCERNANT LES CONTROLES D'ARGUMENTS                   *
*                                                                  *
********************************************************************

100     e       E_RDC_ARGS_DESC
"File \"%s\", unit \"%s\",\
  description missing %s \n\n"

110     e       E_RDC_ARGS_OVER_CONST
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  constant \"%s\" will be overwritten by dummy argument \"%s\"\n\n"

120     e       E_RDC_ARGS_OVER_PARAM
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  parameter \"%s\" will be overwritten by dummy argument \"%s\"\n\n"

130     e       E_RDC_ARGS_OVER_FUNC
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  function \"%s\" will be overwritten by dummy argument \"%s\"\n\n"

140     e       E_RDC_ARGS_OVER_EXPR
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  an expression will be overwritten by dummy argument \"%s\"\n\n"

150     e       E_RDC_ARGS_TYPE
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  type difference, \"%s\" (%s) instead of \"%s\" (%s) \n\n"

160     e       E_RDC_ARGS_LENGTH
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  length difference, \"%s\" (%d) instead of \"%s\" (%d) \n\n"

170     e       E_RDC_ARGS_DIM
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  number of dimension bounds difference, \"%s\" (%d) instead of \
\"%s\" (%d) \n\n"

180     e       E_RDC_ARGS_ARRAY
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  declaration of \"%s\" (SCALAR) different from \
that of dummy argument \"%s\" (ARRAY) \n\n"

190     w       E_RDC_ARGS_TOOARG
"File \"%s\", unit \"%s\", line %d, call \"%s\",\
  too many arguments, %d instead of %d\n\n"

200     e       E_RDC_ARGS_LESSARG
"File \"%s\", unit \"%s\", line %d, call \"%s\",\
  arguments missing, %d instead of %d\n\n"

210     e       E_RDC_ARGS_TOOLAB
"File \"%s\", unit \"%s\", line %d, call \"%s\",\
  too many labels, %d instead of %d\n\n"

220     w       E_RDC_ARGS_LESSLAB
"File \"%s\", unit \"%s\", line %d, call \"%s\",\
  labels missing, %d instead of %d\n\n"

230     w       E_RDC_ARGS_MOD_UNDEF
"File \"%s\", unit \"%s\", line %d, call \"%s\", no. %d,\
  dummy argument \"%s\" never used in \"%s\"\n\n"

240     e       E_RDC_ARGS_NOFUNC
"File \"%s\", unit \"%s\", line %d, call \"%s\",\
  \"%s\" is called like a subroutine or an entry whereas \
it is a function\n\n"

250     e       E_RDC_ARGS_NOSUB
"File \"%s\", unit \"%s\", line %d, call \"%s\",\
  \"%s\" is called like a function whereas \
it is a subroutine or an entry\n\n"

260     f       F_RDC_ARGS_NOMEM
"Not enough memory\n"

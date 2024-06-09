/**
 * @quickreview DAR 04:01:26
 * @quickreview FRM 03:09:05
 * @quickreview PFI 03:03:31
 */
#include "OracleGLUE.h"
//#include "iostream.h" // need to remove ???

sword   OracleGLUEobindps(struct cda_def *cursor, ub1 opcode, text *sqlvar, 
	       sb4 sqlvl, ub1 *pvctx, sb4 progvl, 
	       sword ftype, sword scale,
	       sb2 *indp, ub2 *alen, ub2 *arcode, 
	       sb4 pv_skip, sb4 ind_skip, sb4 alen_skip, sb4 rc_skip,
	       ub4 maxsiz, ub4 *cursiz,
	       text *fmt, sb4 fmtl, sword fmtt)
{
return ::obindps(cursor, opcode, sqlvar, 
	       sqlvl, pvctx, progvl, 
	       ftype, scale,
	       indp, alen, arcode, 
	       pv_skip, ind_skip, alen_skip, rc_skip,
	       maxsiz, cursiz,
		 fmt, fmtl, fmtt);

}

sword   OracleGLUEobreak(struct cda_def *lda)
{
  return ::obreak(lda);
}

sword   OracleGLUEocan  (struct cda_def *cursor)
{
  return ::ocan  (cursor);
}

sword   OracleGLUEoclose(struct cda_def *cursor)
{
return ::oclose(cursor);
}
  
sword   OracleGLUEocof  (struct cda_def *lda)
{
  return ocof  (lda);
}  
sword   OracleGLUEocom  (struct cda_def *lda)
{
  return ::ocom  (lda);
}  
sword   OracleGLUEocon  (struct cda_def *lda)
{
  return ::ocon  (lda);
}  


/*
 * Oci DEFINe (Piecewise or with Skips) 
 */
sword   OracleGLUEodefinps(struct cda_def *cursor, ub1 opcode, sword pos,ub1 *bufctx,
		sb4 bufl, sword ftype, sword scale, 
		sb2 *indp, text *fmt, sb4 fmtl, sword fmtt, 
		ub2 *rlen, ub2 *rcode,
		sb4 pv_skip, sb4 ind_skip, sb4 alen_skip, sb4 rc_skip)
{
return ::odefinps(cursor, opcode, pos,bufctx,
		bufl, ftype, scale, 
		indp, fmt, fmtl, fmtt, 
		rlen, rcode,
		pv_skip, ind_skip, alen_skip, rc_skip);
}  

sword   OracleGLUEodessp(struct cda_def *cursor, text *objnam, size_t onlen,
              ub1 *rsv1, size_t rsv1ln, ub1 *rsv2, size_t rsv2ln,
              ub2 *ovrld, ub2 *pos, ub2 *level, text **argnam,
              ub2 *arnlen, ub2 *dtype, ub1 *defsup, ub1* mode,
              ub4 *dtsiz, sb2 *prec, sb2 *scale, ub1 *radix,
              ub4 *spare, ub4 *arrsiz)
{
return ::odessp(cursor, objnam, onlen,
              rsv1, rsv1ln, rsv2, rsv2ln,
              ovrld, pos, level, argnam,
              arnlen, dtype, defsup, mode,
              dtsiz, prec, scale, radix,
              spare, arrsiz);
}
sword   OracleGLUEodescr(struct cda_def *cursor, sword pos, sb4 *dbsize,
                 sb2 *dbtype, sb1 *cbuf, sb4 *cbufl, sb4 *dsize,
                 sb2 *prec, sb2 *scale, sb2 *nullok)
{
return ::odescr(cursor, pos, dbsize,
                dbtype, cbuf, cbufl, dsize,
	       prec, scale, nullok);
}

sword   OracleGLUEoerhms   (struct cda_def *lda, sb2 rcode, text *buf,
                 sword bufsiz)
{
return ::oerhms   (lda, rcode, buf,
		   bufsiz);
}

sword   OracleGLUEoermsg   (sb2 rcode, text *buf)
{
return ::oermsg   ( rcode, buf);
}

sword   OracleGLUEoexec    (struct cda_def *cursor)
{
return ::oexec    (cursor);
}  
sword  OracleGLUEoexfet   (struct cda_def *cursor, ub4 nrows,
                 sword cancel, sword exact)
{
return ::oexfet   (cursor, nrows,
                 cancel, exact);
}

sword   OracleGLUEoexn     (struct cda_def *cursor, sword iters, sword rowoff)
{
  return ::oexn     (cursor, iters, rowoff);
}  
sword   OracleGLUEofen     (struct cda_def *cursor, sword nrows)
{
  return ::ofen     (cursor, nrows);
}

sword   OracleGLUEofetch   (struct cda_def *cursor)
{
  return ::ofetch   (cursor);
}

sword   OracleGLUEoflng    (struct cda_def *cursor, sword pos, ub1 *buf,
                 sb4 bufl, sword dtype, ub4 *retl, sb4 offset)
{
  return ::oflng    (cursor, pos, buf,
		  bufl, dtype, retl, offset);
}

sword   OracleGLUEogetpi   (struct cda_def *cursor, ub1 *piecep, dvoid **ctxpp, 
                 ub4 *iterp, ub4 *indexp)
{
  return ::ogetpi   (cursor, piecep, ctxpp, 
                 iterp, indexp);
}

sword   OracleGLUEoopt     (struct cda_def *cursor, sword rbopt, sword waitopt)
{
  return ::oopt     (cursor, rbopt, waitopt);
}

sword   OracleGLUEopinit   (/* ub4 mode */)
{
//  return ::opinit   (mode);
  return (sword)1;

}

sword   OracleGLUEolog     (struct cda_def *lda, ub1* hda,
                 text *uid, sword uidl,
                 text *pswd, sword pswdl, 
                 text *conn, sword connl, 
                 ub4 mode)
{
return ::olog     (lda, hda,
                 uid, uidl,
                 pswd, pswdl, 
                 conn, connl, 
                 mode);
}
sword   OracleGLUEologof   (struct cda_def *lda)
{
  return ::ologof   (lda);
}

sword   OracleGLUEoopen    (struct cda_def *cursor, struct cda_def *lda,
                 text *dbn, sword dbnl, sword arsize,
                 text *uid, sword uidl)
{
return ::oopen    (cursor, lda,
                 dbn, dbnl, arsize,
                 uid,  uidl);
}

sword   OracleGLUEoparse   (struct cda_def *cursor, text *sqlstm, sb4 sqllen,
                 sword defflg, ub4 lngflg)
{
return ::oparse   (cursor, sqlstm, sqllen,
                 defflg, lngflg);
}

sword   OracleGLUEorol     (struct cda_def *lda)
{
return ::orol     (lda);
}

sword   OracleGLUEosetpi   (struct cda_def *cursor, ub1 piece, dvoid *bufp, ub4 *lenp)
{
return ::osetpi   (cursor, piece, bufp, lenp);

}

/* non-blocking functions */
sword  OracleGLUEonbset    (struct cda_def *lda )
{
  return ::onbset    (lda ); 
}

sword  OracleGLUEonbtst    (struct cda_def *lda )
{
  return ::onbtst    (lda ); 
}

sword  OracleGLUEonbclr    (struct cda_def *lda )
{
  return ::onbclr    (lda );
}

sword OracleGLUEognfd     (/* struct cda_def *lda, dvoid *fdp */)
{
//  return ::ognfd     (lda, fdp);
  return (sword )1;
}



/* 
 * OBSOLETE CALLS 
 */

/* 
 * OBSOLETE BIND CALLS
 */
sword   OracleGLUEobndra(struct cda_def *cursor, text *sqlvar, sword sqlvl,
                 ub1 *progv, sword progvl, sword ftype, sword scale,
                 sb2 *indp, ub2 *alen, ub2 *arcode, ub4 maxsiz,
	      ub4 *cursiz, text *fmt, sword fmtl, sword fmtt)
{
return ::obndra(cursor, sqlvar, sqlvl,
                 progv, progvl, ftype, scale,
                 indp, alen, arcode, maxsiz,
                 cursiz, fmt, fmtl,  fmtt);
}

sword   OracleGLUEobndrn(struct cda_def *cursor, sword sqlvn, ub1 *progv,
                 sword progvl, sword ftype, sword scale, sb2 *indp,
	      text *fmt, sword fmtl, sword fmtt)
{
return ::obndrn(cursor, sqlvn, progv,
                 progvl, ftype, scale, indp,
                 fmt, fmtl, fmtt);
}

sword   OracleGLUEobndrv(struct cda_def *cursor, text *sqlvar, sword sqlvl,
                 ub1 *progv, sword progvl, sword ftype, sword scale,
	      sb2 *indp, text *fmt, sword fmtl, sword fmtt)
{
  return ::obndrv(cursor, sqlvar, sqlvl,
                 progv, progvl, ftype, scale,
		  indp, fmt, fmtl, fmtt);
}

sword  OracleGLUEodefin(struct cda_def *cursor, sword pos, ub1 *buf,
	      sword bufl, sword ftype, sword scale, sb2 *indp,
	     text *fmt, sword fmtl, sword fmtt, ub2 *rlen, ub2 *rcode)
{
return ::odefin(cursor, pos, buf,
	      bufl, ftype, scale, indp,
	      fmt, fmtl, fmtt, rlen, rcode);
}



// ======================================================================
// ======================================================================
// New Glue for Oracle 8
/* ==>
typedef sb4 (*OraGlueOCICallbackInBind)(  dvoid *ictxp, OCIBind *bindp, ub4 iter,
                                   ub4 index, dvoid **bufpp, ub4 *alenp,
					ub1 *piecep, dvoid **indp  )
{
  return (*OCICallbackInBind)(  ictxp, bindp, iter,
                                index, bufpp, alenp,
				     piecep, indp  );
}

 
typedef sb4 (*OraGlueOCICallbackOutBind)(  dvoid *octxp, OCIBind *bindp, ub4 iter,
                                    ub4 index, dvoid **bufpp, ub4 **alenp,
                                    ub1 *piecep, dvoid **indp,
					 ub2 **rcodep  )
{
return (*OCICallbackOutBind)(  octxp, bindp, iter,
                                    index, bufpp, alenp,
                                    piecep, indp,
                                    rcodep  );
}  
 
typedef sb4 (*OraGlueOCICallbackDefine)(  dvoid *octxp, OCIDefine *defnp, ub4 iter,
                                   dvoid **bufpp, ub4 **alenp, ub1 *piecep,
					dvoid **indp, ub2 **rcodep  );
{
return (*OCICallbackDefine)(  octxp, defnp, iter,
                                   bufpp, alenp, piecep,
                                   indp, rcodep  );
}


typedef sb4 (*OraGlueOCICallbackLobRead)(  dvoid *ctxp,
                                      CONST dvoid *bufp,
                                      ub4 len,
					 ub1 piece  )
{
return  (*OCICallbackLobRead)(  ctxp,
                                bufp,
                                len,
				piece  );
}


typedef sb4 (*OraGlueOCICallbackLobWrite)(  dvoid *ctxp,
                                       dvoid *bufp,
                                       ub4 *lenp,
					  ub1 *piece  )
{
return (*OCICallbackLobWrite)(  ctxp,
                                bufp,
                                lenp,
                                piece  );
}


typedef sb4 (*OraGlueOCICallbackFailover)(  dvoid *svcctx, dvoid *envctx,
                                       dvoid *fo_ctx, ub4 fo_type,
					  ub4 fo_event  )
{
return  (*OCICallbackFailover)(  svcctx, envctx,
                                 fo_ctx, fo_type,
                                       fo_event  );
}


==*/


sword   OraGlueOCIInitialize(  ub4 mode, dvoid *ctxp,
                          dvoid *(*malocfp)(dvoid *ctxp, size_t sizet),
                          dvoid *(*ralocfp)(dvoid *ctxp, dvoid *memptr,
                                            size_t newsize),
			     void (*mfreefp)(dvoid *ctxp, dvoid *memptr)  )
{
return OCIInitialize(  mode, ctxp,
                         malocfp,
                          ralocfp,
                           mfreefp );
}

sword   OraGlueOCIHandleAlloc(  CONST dvoid *parenth, dvoid **hndlpp, ub4 type,
size_t xtramem_sz, dvoid **usrmempp  )
{
return OCIHandleAlloc(  parenth, hndlpp, type,
                           xtramem_sz, usrmempp  );
}


sword   OraGlueOCIHandleFree(  dvoid *hndlp, ub4 type  )
{
return OCIHandleFree(  hndlp, type  );
}


sword   OraGlueOCIDescriptorAlloc(  CONST dvoid *parenth, dvoid **descpp, ub4 type,
				  size_t xtramem_sz, dvoid **usrmempp  )
{
return OCIDescriptorAlloc( parenth, descpp, type,
                           xtramem_sz, usrmempp  );
}


sword   OraGlueOCIDescriptorFree(  dvoid *descp, ub4 type  )
{
return OCIDescriptorFree(  descp, type  );
}  

sword   OraGlueOCIEnvInit(  OCIEnv **envp, ub4 mode,
			  size_t xtramem_sz, dvoid **usrmempp  )
{
return OCIEnvInit(  envp, mode,
                       xtramem_sz, usrmempp  );
}


sword   OraGlueOCIServerAttach(  OCIServer *srvhp, OCIError *errhp,
                            CONST text *dblink, sb4 dblink_len, ub4 mode  )
{
return OCIServerAttach(  srvhp, errhp,
			       dblink, dblink_len, mode  );
}


sword   OraGlueOCIServerDetach(  OCIServer *srvhp, OCIError *errhp, ub4 mode  )
{
  return OCIServerDetach(  srvhp, errhp, mode  );
}


sword   OraGlueOCISessionBegin(  OCISvcCtx *svchp, OCIError *errhp,
			       OCISession *usrhp, ub4 credt, ub4 mode  )
{
return OCISessionBegin(  svchp, errhp,
                            usrhp, credt, mode  );
}


sword   OraGlueOCISessionEnd(  OCISvcCtx *svchp, OCIError *errhp,
			     OCISession *usrhp, ub4 mode  )
{
return OCISessionEnd(  svchp, errhp,
			     usrhp, mode  );

}


sword OraGlueOCILogon       (  OCIEnv *envhp, OCIError *errhp, OCISvcCtx **svchp, 
			CONST text *username, ub4 uname_len, 
			CONST text *password, ub4 passwd_len, 
			     CONST text *dbname, ub4 dbname_len  )
{
return OCILogon       (  envhp, errhp, svchp, 
			username, uname_len, 
			password, passwd_len, 
			dbname, dbname_len  );
}


sword OraGlueOCILogoff      (  OCISvcCtx *svchp, OCIError *errhp  )
{
return OCILogoff      (  svchp, errhp  );
}


sword OraGlueOCIPasswordChange (  OCISvcCtx *svchp, OCIError *errhp,
                           CONST text *user_name, ub4 usernm_len,
                           CONST text *opasswd, ub4 opasswd_len,
				CONST text *npasswd, ub4 npasswd_len, ub4 mode  )
{
return OCIPasswordChange (  svchp, errhp,
                           user_name, usernm_len,
                           opasswd, opasswd_len,
                           npasswd, npasswd_len, mode  );

}


sword   OraGlueOCIStmtPrepare(  OCIStmt *stmtp, OCIError *errhp, CONST text *stmt,
			      ub4 stmt_len, ub4 language, ub4 mode  )
{
return OCIStmtPrepare(  stmtp, errhp, stmt,
                           stmt_len, language, mode  );
}


//#ifndef __STDC__
sword OraGlueOCIBindByPos   (  OCIStmt *stmtp, OCIBind **bindp, OCIError *errhp,
			ub4 position, dvoid *valuep, sb4 value_sz,
			ub2 dty, dvoid *indp, ub2 *alenp, ub2 *rcodep,
			     ub4 maxarr_len, ub4 *curelep, ub4 mode  )
{
return OCIBindByPos   ( stmtp, bindp, errhp,
			position, valuep, value_sz,
			dty, indp, alenp, rcodep,
			maxarr_len, curelep, mode  );
}

//#endif /* __STDC__ */

//#ifndef __STDC__
sword OraGlueOCIBindByName  (  OCIStmt *stmtp, OCIBind **bindp, OCIError *errhp,
			CONST text *placeholder, sb4 placeh_len, 
                        dvoid *valuep, sb4 value_sz, ub2 dty, 
                        dvoid *indp, ub2 *alenp, ub2 *rcodep, 
			     ub4 maxarr_len, ub4 *curelep, ub4 mode  )
{
return OCIBindByName  (  stmtp, bindp, errhp,
			placeholder, placeh_len, 
                        valuep, value_sz, dty, 
                        indp, alenp, rcodep, 
                        maxarr_len, curelep, mode  );
}

//#endif /* __STDC__ */

sword   OraGlueOCIBindObject(  OCIBind *bindp, OCIError *errhp,
                          CONST OCIType *type, dvoid **pgvpp,
			     ub4 *pvszsp, dvoid **indpp, ub4 *indszp  )
{
return OCIBindObject(  bindp, errhp,
                          type, pgvpp,
                          pvszsp, indpp, indszp  );
}


sword   OraGlueOCIBindDynamic(  OCIBind *bindp, OCIError *errhp,
                           dvoid *ictxp, OCICallbackInBind icbfp,
			      dvoid *octxp, OCICallbackOutBind ocbfp  )
{
return OCIBindDynamic(  bindp, errhp,
                           ictxp, icbfp,
                           octxp, ocbfp  );
}
sword   OraGlueOCIBindArrayOfStruct(  OCIBind *bindp, OCIError *errhp, ub4 pvskip,
				    ub4 indskip, ub4 alskip, ub4 rcskip  )
{
return OCIBindArrayOfStruct(  bindp, errhp, pvskip,
				    indskip, alskip, rcskip  );
}

sword   OraGlueOCIStmtGetPieceInfo(  OCIStmt *stmtp, OCIError *errhp,
                                dvoid **hndlpp, ub4 *typep, ub1 *in_outp,
				   ub4 *iterp, ub4 *idxp, ub1 *piecep  )
{
return OCIStmtGetPieceInfo( stmtp, errhp,
                                hndlpp, typep, in_outp,
                                iterp, idxp, piecep  );
}  

//#ifndef __STDC__
sword   OraGlueOCIStmtSetPieceInfo(  dvoid *hndlp, ub4 type, OCIError *errhp,
                                CONST dvoid *bufp, ub4 *alenp, ub1 piece,
				   CONST dvoid *indp, ub2 *rcodep  )
{
return OCIStmtSetPieceInfo(  hndlp, type, errhp,
                                bufp, alenp, piece,
                                indp, rcodep  );
}  
//#endif /* __STDC__ */

sword   OraGlueOCIStmtExecute(  OCISvcCtx *svchp, OCIStmt *stmtp, OCIError *errhp,
                           ub4 iters, ub4 rowoff, CONST OCISnapshot *snap_in,
			      OCISnapshot *snap_out, ub4 mode  )
{
return OCIStmtExecute( svchp, stmtp, errhp,
                           iters, rowoff, snap_in,
                           snap_out, mode  );

}  

//#ifndef __STDC__
sword OraGlueOCIDefineByPos (  OCIStmt *stmtp, OCIDefine **defnp, OCIError *errhp,
			ub4 position, dvoid *valuep, sb4 value_sz, ub2 dty,
			     dvoid *indp, ub2 *rlenp, ub2 *rcodep, ub4 mode  )
{
return OCIDefineByPos (  stmtp, defnp, errhp,
			position, valuep, value_sz, dty,
			indp, rlenp, rcodep, mode  );
}

//#endif /* __STDC__ */

sword   OraGlueOCIDefineObject(  OCIDefine *defnp, OCIError *errhp,
                            CONST OCIType *type, dvoid **pgvpp,
			       ub4 *pvszsp, dvoid **indpp, ub4 *indszp  )
{
return OCIDefineObject(  defnp, errhp,
                            type, pgvpp,
                            pvszsp, indpp, indszp  );
}


sword   OraGlueOCIDefineDynamic(  OCIDefine *defnp, OCIError *errhp,
				dvoid *octxp, OCICallbackDefine ocbfp  )
{
return OCIDefineDynamic(  defnp, errhp,
                             octxp, ocbfp  );
}

sword   OraGlueOCIDefineArrayOfStruct(  OCIDefine *defnp, OCIError *errhp, 
                                 ub4 pvskip, ub4 indskip, ub4 rlskip, 
				      ub4 rcskip  )
{
return OCIDefineArrayOfStruct(  defnp, errhp, 
                                 pvskip, indskip, rlskip, 
			      rcskip  );
}


//#ifndef __STDC__
sword   OraGlueOCIStmtFetch(  OCIStmt *stmtp, OCIError *errhp,
			    ub4 nrows, ub2 orientation, ub4 mode  )
{
return OCIStmtFetch(  stmtp, errhp,
                         nrows, orientation, mode  );
}

//#endif /* __STDC__ */

sword   OraGlueOCIStmtGetBindInfo(  OCIStmt *stmtp, OCIError *errhp, ub4 size, 
                               ub4 startloc, sb4 *found, 
                               text *bvnp[], ub1 bvnl[], text *invp[],
				  ub1 inpl[], ub1 dupl[], OCIBind *hndl[]  )
{
return OCIStmtGetBindInfo(  stmtp, errhp, size, 
                               startloc, found, 
                               bvnp, bvnl, invp,
                               inpl, dupl, hndl  );
}


//#ifndef __STDC__
sword   OraGlueOCIDescribeAny(  OCISvcCtx *svchp, OCIError *errhp,
                           dvoid *objptr, ub4 objnm_len, ub1 objptr_typ,
			      ub1 info_level, ub1 objtyp, OCIDescribe *dschp  )
{
return OCIDescribeAny(  svchp, errhp,
                           objptr, objnm_len, objptr_typ,
		      info_level, objtyp, dschp  );
}

//#endif /* __STDC__ */

sword   OraGlueOCIParamGet(  CONST dvoid *hndlp, ub4 htype, OCIError *errhp,
			   dvoid **parmdpp, ub4 pos  )
{
return OCIParamGet( hndlp, htype, errhp,
                        parmdpp, pos  );
}

sword   OraGlueOCIParamSet(  dvoid *hdlp, ub4 htyp, OCIError *errhp,
			   CONST dvoid *dscp, ub4 dtyp, ub4 pos  ) 
{
return OCIParamSet(  hdlp, htyp, errhp,
                        dscp, dtyp, pos  );

}


sword   OraGlueOCITransStart(  OCISvcCtx *svchp, OCIError *errhp,
			     uword timeout, ub4 flags  )
{
  return OCITransStart(  svchp, errhp,
                          timeout, flags  );

}  

sword   OraGlueOCITransDetach(  OCISvcCtx *svchp, OCIError *errhp, ub4 flags  )
{
  return OCITransDetach(  svchp, errhp, flags  );
}

sword   OraGlueOCITransCommit(  OCISvcCtx *svchp, OCIError *errhp, ub4 flags  )
{
  return OCITransCommit(  svchp, errhp, flags  );
}


sword   OraGlueOCITransRollback(  OCISvcCtx *svchp, OCIError *errhp, ub4 flags  )
{
return OCITransRollback(  svchp, errhp, flags  );
}  

sword   OraGlueOCITransPrepare (  OCISvcCtx *svchp, OCIError *errhp, ub4 flags  )
{
return OCITransPrepare (  svchp, errhp, flags  );
}


sword   OraGlueOCITransForget (   OCISvcCtx *svchp, OCIError *errhp, ub4 flags  )
{
  return OCITransForget (  svchp, errhp, flags  );
}


sword   OraGlueOCIErrorGet   (   dvoid *hndlp, ub4 recordno, text *sqlstate,
			    sb4 *errcodep, text *bufp, ub4 bufsiz, 
			      ub4 type   )
{
return OCIErrorGet   (  hndlp, recordno, sqlstate,
			    errcodep, bufp, bufsiz, 
		      type   );
}


sword   OraGlueOCILobAppend  (   OCISvcCtx *svchp, OCIError *errhp, 
                            OCILobLocator *dst_locp,
			      OCILobLocator *src_locp   )
{
  return OCILobAppend  (   svchp, errhp, 
                           dst_locp,
                           src_locp   );
}  

sword   OraGlueOCILobAssign  (   OCIEnv *envhp, OCIError *errhp, 
                            CONST OCILobLocator *src_locp, 
			      OCILobLocator **dst_locpp   )
{
return OCILobAssign  (   envhp, errhp, 
                            src_locp, 
                            dst_locpp   );
}


sword   OraGlueOCILobCharSetForm  (   OCIEnv *envhp, OCIError *errhp, 
                                 CONST OCILobLocator *locp, 
				   ub1 *csfrm   )
{
return OCILobCharSetForm  (  envhp, errhp, 
                                 locp, 
			   csfrm   );
}

sword   OraGlueOCILobCharSetId (   OCIEnv *envhp, OCIError *errhp, 
				CONST OCILobLocator *locp, ub2 *csid   )
{
return OCILobCharSetId (   envhp, errhp, 
                              locp, csid   );
}


sword   OraGlueOCILobCopy  (   OCISvcCtx *svchp, OCIError *errhp, 
                          OCILobLocator *dst_locp,
		          OCILobLocator *src_locp, 
                          ub4 amount, ub4 dst_offset, 
			    ub4 src_offset   )
{
return OCILobCopy  (   svchp, errhp, 
                       dst_locp,
	               src_locp, 
                       amount, dst_offset, 
		       src_offset   );
}


sword   OraGlueOCILobDisableBuffering (   OCISvcCtx      *svchp,
                                     OCIError       *errhp,
				       OCILobLocator  *locp   )
{
return OCILobDisableBuffering (   svchp,
                                  errhp,
				  locp   );
}

sword   OraGlueOCILobEnableBuffering (   OCISvcCtx      *svchp,
                                    OCIError       *errhp,
				      OCILobLocator  *locp   )
{
return OCILobEnableBuffering (   svchp,
                                 errhp,
				 locp   );
}


sword   OraGlueOCILobErase  (   OCISvcCtx *svchp, OCIError *errhp, 
                           OCILobLocator *locp,
			     ub4 *amount, ub4 offset   )
{
return OCILobErase  (   svchp, errhp, 
                        locp,
			amount, offset   );
}


sword   OraGlueOCILobFileClose  (   OCISvcCtx *svchp, OCIError *errhp, 
				 OCILobLocator *filep   )
{
return OCILobFileClose  (   svchp, errhp, 
				 filep   );
}


sword   OraGlueOCILobFileCloseAll (  OCISvcCtx *svchp, OCIError *errhp  )
{
return OCILobFileCloseAll (  svchp, errhp  );
}  

sword   OraGlueOCILobFileExists   (  OCISvcCtx *svchp, OCIError *errhp, 
			      OCILobLocator *filep,
				   boolean *flag  )
{
return OCILobFileExists   ( svchp, errhp, 
			      filep,
				flag  );
}

 
sword   OraGlueOCILobFileGetName  (   OCIEnv *envhp, OCIError *errhp, 
                                 CONST OCILobLocator *filep,
                                 text *dir_alias, ub2 *d_length, 
				   text *filename, ub2 *f_length   )
{
return OCILobFileGetName  (   envhp, errhp, 
                                 filep,
                                 dir_alias, d_length, 
				   filename, f_length   );
}
                            
                            
sword   OraGlueOCILobFileIsOpen  (  OCISvcCtx *svchp, OCIError *errhp, 
                               OCILobLocator *filep,
				  boolean *flag  )
{
return OCILobFileIsOpen  (  svchp, errhp, 
                               filep,
                               flag  );
}


//#ifndef __STDC__
sword   OraGlueOCILobFileOpen  (   OCISvcCtx *svchp, OCIError *errhp, 
				OCILobLocator *filep, ub1 mode   )
{
return OCILobFileOpen  (   svchp, errhp, 
				filep, mode   );
}

//#endif /* __STDC__ */

//#ifndef __STDC__
sword   OraGlueOCILobFileSetName  (   OCIEnv *envhp, OCIError *errhp, 
                                 OCILobLocator **filepp, 
                                 CONST text *dir_alias, ub2 d_length, 
				   CONST text *filename, ub2 f_length   )
{
return OCILobFileSetName  (  envhp, errhp, 
                                 filepp, 
                                 dir_alias, d_length, 
			   filename, f_length   );
}

//#endif /* __STDC__ */

sword   OraGlueOCILobFlushBuffer (   OCISvcCtx       *svchp,
                                OCIError        *errhp,
                                OCILobLocator   *locp,
				  ub4              flag   )
{
return OCILobFlushBuffer (   svchp,
                             errhp,
                             locp,
		             flag   );
}

sword   OraGlueOCILobGetLength  (   OCISvcCtx *svchp, OCIError *errhp, 
                               OCILobLocator *locp,
				 ub4 *lenp   )
{
return OCILobGetLength  (   svchp, errhp, 
                               locp,
		               lenp   );
}


sword   OraGlueOCILobIsEqual  (   OCIEnv *envhp, CONST OCILobLocator *x, 
			       CONST OCILobLocator *y, boolean *is_equal   )
{
return OCILobIsEqual  (   envhp, x, 
                             y, is_equal   );
}


sword   OraGlueOCILobLoadFromFile  (   OCISvcCtx *svchp, OCIError *errhp, 
                                  OCILobLocator *dst_locp,
       	                          OCILobLocator *src_filep, 
                                  ub4 amount, ub4 dst_offset, 
				    ub4 src_offset   )
{
return OCILobLoadFromFile  (   svchp, errhp, 
                                  dst_locp,
       	                          src_filep, 
                                  amount, dst_offset, 
                                  src_offset   );
}


sword   OraGlueOCILobLocatorIsInit (   OCIEnv *envhp, OCIError *errhp, 
                                CONST OCILobLocator *locp, 
				    boolean *is_initialized   )
{
return OCILobLocatorIsInit (  envhp, errhp, 
                              locp, 
			      is_initialized   );
}


//#ifndef __STDC__
sword   OraGlueOCILobRead  (   OCISvcCtx *svchp, OCIError *errhp, 
                          OCILobLocator *locp,
                          ub4 *amtp, ub4 offset, dvoid *bufp, ub4 bufl, 
                          dvoid *ctxp, 
                          sb4 (*cbfp)( dvoid *ctxp, 
                                       CONST dvoid *bufp, 
                                       ub4 len, 
                                       ub1 piece),
			    ub2 csid, ub1 csfrm   )
{
return OCILobRead  (   svchp, errhp, 
                          locp,
                          amtp, offset, bufp, bufl, 
                          ctxp, 
                          cbfp,
		    csid, csfrm   );
}
//#endif /* __STDC__ */

sword   OraGlueOCILobTrim  (   OCISvcCtx *svchp, OCIError *errhp, 
                          OCILobLocator *locp,
			    ub4 newlen   )
{
return OCILobTrim  (   svchp, errhp, 
                          locp,
		    newlen   );
}


//#ifndef __STDC__
sword   OraGlueOCILobWrite  (   OCISvcCtx *svchp, OCIError *errhp, 
                         OCILobLocator *locp,
                         ub4 *amtp, ub4 offset, dvoid *bufp, ub4 buflen, 
                         ub1 piece, dvoid *ctxp, 
                         sb4 (*cbfp)(dvoid *ctxp, 
                                     dvoid *bufp, 
                                     ub4 *len, 
                                     ub1 *piece),
			     ub2 csid, ub1 csfrm  )
{
return OCILobWrite  (   svchp, errhp, 
                         locp,
                         amtp, offset, bufp, buflen, 
                         piece, ctxp, 
                         cbfp,
                         csid, csfrm  );
}

//#endif /* __STDC__ */

sword   OraGlueOCIBreak (   dvoid *hndlp, OCIError *errhp   )
{
return OCIBreak (   hndlp, errhp   );
}


//#ifndef __STDC__
sword   OraGlueOCIServerVersion  (   dvoid *hndlp, OCIError *errhp, text *bufp, 
				  ub4 bufsz, ub1 hndltype   )
{
return OCIServerVersion  (  hndlp, errhp, bufp, 
					 bufsz, hndltype   );
}

//#endif /* __STDC__ */

sword   OraGlueOCIAttrGet (   CONST dvoid *trgthndlp, ub4 trghndltyp, 
                         dvoid *attributep, ub4 *sizep, ub4 attrtype, 
			   OCIError *errhp   )
{
return OCIAttrGet (   trgthndlp, trghndltyp, 
                      attributep, sizep,  attrtype, 
                      errhp   );
}


sword   OraGlueOCIAttrSet (   dvoid *trgthndlp, ub4 trghndltyp, dvoid *attributep,
			   ub4 size, ub4 attrtype, OCIError *errhp   )
{
return OCIAttrSet (   trgthndlp, trghndltyp, attributep,
                      size, attrtype, errhp   );
}


sword   OraGlueOCISvcCtxToLda (   OCISvcCtx *svchp, OCIError *errhp, 
			       Lda_Def *ldap   )
{
return OCISvcCtxToLda (  svchp, errhp, 
			       ldap   );
}

sword   OraGlueOCILdaToSvcCtx (   OCISvcCtx **svchpp, OCIError *errhp, 
			       Lda_Def *ldap   )
{
return OCILdaToSvcCtx (   svchpp, errhp, 
                             ldap   );
}


sword   OraGlueOCIResultSetToStmt (   OCIResult *rsetdp, OCIError *errhp   )
{
return OCIResultSetToStmt (   rsetdp, errhp   );
}

sword   OraGlueOCISecurityInitialize (  OCISecurity *osshandle,
				      OCIError *error_handle  )
{
return OCISecurityInitialize (  osshandle,
                                error_handle  );
}


sword   OraGlueOCISecurityTerminate (  OCISecurity *osshandle,
				     OCIError *error_handle  )
{
return OCISecurityTerminate (  osshandle,
			     error_handle  );
}


sword OraGlueOCISecurityOpenWallet(  OCISecurity *osshandle,
			      OCIError *error_handle,
			      size_t wrllen,
			      text *wallet_resource_locator,
			      size_t pwdlen,
			      text *password,
				   nzttWallet *wallet  )
{
return OCISecurityOpenWallet( osshandle,
			      error_handle,
			      wrllen,
			      wallet_resource_locator,
			      pwdlen,
			      password,
			      wallet  );
}


sword OraGlueOCISecurityCloseWallet(  OCISecurity *osshandle,
			       OCIError *error_handle,
				    nzttWallet *wallet  )
{
return OCISecurityCloseWallet( osshandle,
			       error_handle,
			       wallet  );
}


sword OraGlueOCISecurityCreateWallet(  OCISecurity *osshandle,
				OCIError *error_handle,
				size_t wrllen,
				text *wallet_resource_locator,
				size_t pwdlen,
				text *password,
				     nzttWallet *wallet  )
{
return OCISecurityCreateWallet( osshandle,
				error_handle,
				wrllen,
				wallet_resource_locator,
				pwdlen,
				password,
				wallet  );
}


sword OraGlueOCISecurityDestroyWallet(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 size_t wrllen,
				 text *wallet_resource_locator,
				 size_t pwdlen,
				      text *password  )
{
return OCISecurityDestroyWallet( osshandle,
				 error_handle,
				 wrllen,
				 wallet_resource_locator,
				 pwdlen,
				 password  );
}


sword OraGlueOCISecurityStorePersona(  OCISecurity *osshandle,
				OCIError *error_handle,
				nzttPersona **persona,
				     nzttWallet *wallet  )
{
return OCISecurityStorePersona( osshandle,
				error_handle,
				persona,
				wallet  );
}


sword OraGlueOCISecurityOpenPersona(  OCISecurity *osshandle,
			       OCIError *error_handle,
				    nzttPersona *persona  )
{
return OCISecurityOpenPersona( osshandle,
			       error_handle,
			       persona  );

}


sword OraGlueOCISecurityClosePersona(  OCISecurity *osshandle,
				OCIError *error_handle,
				     nzttPersona *persona  )
{
return OCISecurityClosePersona( osshandle,
				error_handle,
				persona  );
}


sword OraGlueOCISecurityRemovePersona(  OCISecurity *osshandle,
				 OCIError *error_handle,
				      nzttPersona **persona  )
{
return OCISecurityRemovePersona( osshandle,
				 error_handle,
				 persona  );
}


sword OraGlueOCISecurityCreatePersona(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttIdentType identity_type,
				 nzttCipherType cipher_type,
				 nzttPersonaDesc *desc,
				      nzttPersona **persona  )
{
return OCISecurityCreatePersona( osshandle,
				 error_handle,
				 identity_type,
				 cipher_type,
				 desc,
				 persona  );
}


sword OraGlueOCISecuritySetProtection(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona *persona,
				 nzttcef crypto_engine_function,
				 nztttdufmt data_unit_format,
				      nzttProtInfo *protection_info  )
{
return OCISecuritySetProtection( osshandle,
				 error_handle,
				 persona,
				 crypto_engine_function,
				 data_unit_format,
				 protection_info  );
}


sword OraGlueOCISecurityGetProtection(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona *persona,
				 nzttcef crypto_engine_function,
				 nztttdufmt * data_unit_format_ptr,
				      nzttProtInfo *protection_info  )
{
return OCISecurityGetProtection( osshandle,
				 error_handle,
				 persona,
				 crypto_engine_function,
				 data_unit_format_ptr,
				 protection_info  );
}


sword OraGlueOCISecurityRemoveIdentity(  OCISecurity *osshandle,
				  OCIError *error_handle,
				       nzttIdentity **identity_ptr  )
{
return OCISecurityRemoveIdentity( osshandle,
				  error_handle,
				  identity_ptr  );
}


sword OraGlueOCISecurityCreateIdentity(  OCISecurity *osshandle,
				  OCIError *error_handle,
				  nzttIdentType type,
				  nzttIdentityDesc *desc,
				       nzttIdentity **identity_ptr  )
{
return OCISecurityCreateIdentity( osshandle,
				  error_handle,
				  type,
				  desc,
				  identity_ptr  );
}


sword OraGlueOCISecurityAbortIdentity(  OCISecurity *osshandle,
				 OCIError *error_handle,
				      nzttIdentity **identity_ptr  )
{
return OCISecurityAbortIdentity( osshandle,
				 error_handle,
				 identity_ptr  );
}


sword OraGlueOCISecurityFreeIdentity(  OCISecurity *osshandle,
			       	  OCIError *error_handle,
				     nzttIdentity **identity_ptr  )
{
return OCISecurityFreeIdentity(  osshandle,
			       	 error_handle,
				 identity_ptr  );
}


sword OraGlueOCISecurityStoreTrustedIdentity(  OCISecurity *osshandle,
					OCIError *error_handle,
					nzttIdentity **identity_ptr,
					     nzttPersona *persona  )
{
return OCISecurityStoreTrustedIdentity( osshandle,
					error_handle,
					identity_ptr,
					persona  );
}


sword OraGlueOCISecuritySign(  OCISecurity *osshandle,
			OCIError *error_handle,
			nzttPersona *persona,
			nzttces signature_state,
			size_t input_length,
			ub1 *input,
			     nzttBufferBlock *buffer_block  )
{
return OCISecuritySign( osshandle,
			error_handle,
			persona,
			signature_state,
			input_length,
			input,
			buffer_block  );
}


sword OraGlueOCISecuritySignExpansion(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona *persona,
				 size_t inputlen,
				      size_t *signature_length  )
{
return OCISecuritySignExpansion( osshandle,
				 error_handle,
				 persona,
				 inputlen,
				 signature_length  );
}


sword OraGlueOCISecurityVerify(  OCISecurity *osshandle,
			  OCIError *error_handle,
			  nzttPersona *persona,
			  nzttces signature_state,
			  size_t siglen,
			  ub1 *signature,
			  nzttBufferBlock *extracted_message,
			  boolean *verified,
			  boolean *validated,
			       nzttIdentity **signing_party_identity  )
{
return OCISecurityVerify( osshandle,
			  error_handle,
			  persona,
			  signature_state,
			  siglen,
			  signature,
			  extracted_message,
			  verified,
			  validated,
			  signing_party_identity  );
}


sword OraGlueOCISecurityValidate(  OCISecurity *osshandle,
			    OCIError *error_handle,
			    nzttPersona *persona,
			    nzttIdentity *identity,
				 boolean *validated  )
{
return OCISecurityValidate( osshandle,
			    error_handle,
			    persona,
			    identity,
			    validated  );
}


sword OraGlueOCISecuritySignDetached(  OCISecurity *osshandle,
				OCIError *error_handle,
				nzttPersona *persona,
				nzttces signature_state,
				size_t input_length,
				ub1 * input,
				     nzttBufferBlock *signature  )
{
return OCISecuritySignDetached( osshandle,
				error_handle,
				persona,
				signature_state,
				input_length,
				input,
				signature  );
}


sword OraGlueOCISecuritySignDetExpansion(  OCISecurity *osshandle,
				    OCIError    *error_handle,
				    nzttPersona *persona,
				    size_t       input_length,
					 size_t *required_buffer_length  )
{
return OCISecuritySignDetExpansion( osshandle,
				    error_handle,
				    persona,
				    input_length,
				    required_buffer_length  );
}


sword OraGlueOCISecurityVerifyDetached(  OCISecurity *osshandle,
				  OCIError *error_handle,
				  nzttPersona *persona,
				  nzttces signature_state,
				  size_t data_length,
				  ub1 *data,
				  size_t siglen,
				  ub1 *signature,
				  boolean *verified,
				  boolean *validated,
				       nzttIdentity **signing_party_identity  )
{
return OCISecurityVerifyDetached( osshandle,
				  error_handle,
				  persona,
				  signature_state,
				  data_length,
				  data,
				  siglen,
				  signature,
				  verified,
				  validated,
				  signing_party_identity  );
}


sword OraGlueOCISecurity_PKEncrypt(  OCISecurity *osshandle,
			      OCIError *error_handle,
			      nzttPersona *persona,
			      size_t number_of_recipients,
			      nzttIdentity *recipient_list,
			      nzttces encryption_state,
			      size_t input_length,
			      ub1 *input,
				   nzttBufferBlock *encrypted_data  )
{
return OCISecurity_PKEncrypt( osshandle,
			      error_handle,
			      persona,
			      number_of_recipients,
			      recipient_list,
			      encryption_state,
			      input_length,
			      input,
			      encrypted_data  );
}


sword OraGlueOCISecurityPKEncryptExpansion(  OCISecurity *osshandle,
				      OCIError *error_handle,
				      nzttPersona *persona,
				      size_t number_recipients,
				      size_t input_length,
					   size_t *buffer_length_required  )
{
return OCISecurityPKEncryptExpansion( osshandle,
				      error_handle,
				      persona,
				      number_recipients,
				      input_length,
				      buffer_length_required  );
}


sword OraGlueOCISecurityPKDecrypt(  OCISecurity *osshandle,
			     OCIError *error_handle,
			     nzttPersona *persona,
			     nzttces encryption_state,
			     size_t input_length,
			     ub1 *input,
				  nzttBufferBlock *encrypted_data  )
{
return OCISecurityPKDecrypt( osshandle,
			     error_handle,
			     persona,
			     encryption_state,
			     input_length,
			     input,
			     encrypted_data  );
}


sword OraGlueOCISecurityEncrypt(  OCISecurity *osshandle,
			   OCIError *error_handle,
			   nzttPersona *persona,
			   nzttces encryption_state,
			   size_t input_length,
			   ub1 *input,
				nzttBufferBlock *encrypted_data  )
{
return OCISecurityEncrypt( osshandle,
			   error_handle,
			   persona,
			   encryption_state,
			   input_length,
			   input,
			   encrypted_data  );
}


sword OraGlueOCISecurityEncryptExpansion(  OCISecurity *osshandle,
				    OCIError *error_handle,
				    nzttPersona *persona,
				    size_t input_length,
					 size_t *encrypted_data_length  )
{
return OCISecurityEncryptExpansion( osshandle,
				    error_handle,
				    persona,
				    input_length,
				    encrypted_data_length  );
}


sword OraGlueOCISecurityDecrypt(  OCISecurity *osshandle,
			   OCIError *error_handle,
			   nzttPersona *persona,
			   nzttces decryption_state,
			   size_t input_length,
			   ub1 *input,
				nzttBufferBlock *decrypted_data  )
{
return OCISecurityDecrypt( osshandle,
			   error_handle,
			   persona,
			   decryption_state,
			   input_length,
			   input,
			   decrypted_data  );
}


sword OraGlueOCISecurityEnvelope(  OCISecurity *osshandle,
			    OCIError *error_handle,
			    nzttPersona *persona,
			    size_t number_of_recipients,
			    nzttIdentity *identity,
			    nzttces encryption_state,
			    size_t input_length,
			    ub1 *input,
				 nzttBufferBlock *enveloped_data  )
{
return OCISecurityEnvelope( osshandle,
			    error_handle,
			    persona,
			    number_of_recipients,
			    identity,
			    encryption_state,
			    input_length,
			    input,
			    enveloped_data  );
}


sword OraGlueOCISecurityDeEnvelope(  OCISecurity *osshandle,
                                OCIError *error_handle,
                                nzttPersona *persona,
                                nzttces decryption_state,
                                size_t input_length,
                                ub1 *input,
                                nzttBufferBlock *output_message,
                                boolean *verified,
                                boolean *validated,
				   nzttIdentity **sender_identity  )
{
return OCISecurityDeEnvelope(   osshandle,
                                error_handle,
                                persona,
                                decryption_state,
                                input_length,
                                input,
                                output_message,
                                verified,
                                validated,
                                sender_identity  );
}


sword OraGlueOCISecurityKeyedHash(  OCISecurity *osshandle,
			     OCIError *error_handle,
			     nzttPersona *persona,
			     nzttces hash_state,
			     size_t input_length,
			     ub1 *input,
				  nzttBufferBlock *keyed_hash  )
{
return OCISecurityKeyedHash( osshandle,
			     error_handle,
			     persona,
			     hash_state,
			     input_length,
			     input,
			     keyed_hash  );
}


sword OraGlueOCISecurityKeyedHashExpansion(  OCISecurity *osshandle,
				      OCIError *error_handle,
				      nzttPersona *persona,
				      size_t input_length,
					   size_t *required_buffer_length  )
{
return OCISecurityKeyedHashExpansion( osshandle,
				      error_handle,
				      persona,
				      input_length,
				      required_buffer_length  );
}


sword OraGlueOCISecurityHash(  OCISecurity *osshandle,
			OCIError *error_handle,
			nzttPersona *persona,
			nzttces hash_state,
			size_t input,
			ub1 *input_length,
			     nzttBufferBlock *hash  )
{
return OCISecurityHash( osshandle,
			error_handle,
			persona,
			hash_state,
			input,
			input_length,
			hash  );
}

sword OraGlueOCISecurityHashExpansion(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona *persona,
				 size_t input_length,
				      size_t *required_buffer_length  )
{
return OCISecurityHashExpansion( osshandle,
				 error_handle,
				 persona,
				 input_length,
				 required_buffer_length  );
}


sword OraGlueOCISecuritySeedRandom(  OCISecurity *osshandle,
			      OCIError *error_handle,
			      nzttPersona *persona,
			      size_t seed_length,
				   ub1 *seed  )
{
return OCISecuritySeedRandom( osshandle,
			      error_handle,
			      persona,
			      seed_length,
			      seed  );
}


sword OraGlueOCISecurityRandomBytes(  OCISecurity *osshandle,
			       OCIError *error_handle,
			       nzttPersona *persona,
			       size_t number_of_bytes_desired,
				    nzttBufferBlock *random_bytes  )
{
return OCISecurityRandomBytes( osshandle,
			       error_handle,
			       persona,
			       number_of_bytes_desired,
			       random_bytes  );
}


sword OraGlueOCISecurityRandomNumber(  OCISecurity *osshandle,
				OCIError *error_handle,
				nzttPersona *persona,
				     uword *random_number_ptr  )
{
return OCISecurityRandomNumber( osshandle,
				error_handle,
				persona,
				random_number_ptr  );
}


sword OraGlueOCISecurityInitBlock(  OCISecurity *osshandle,
			     OCIError *error_handle,
				  nzttBufferBlock *buffer_block  )
{
return OCISecurityInitBlock( osshandle,
			     error_handle,
			     buffer_block  );
}


sword OraGlueOCISecurityReuseBlock(  OCISecurity *osshandle,
			      OCIError *error_handle,
				   nzttBufferBlock *buffer_block  )
{
return OCISecurityReuseBlock( osshandle,
			      error_handle,
			      buffer_block  );
}


sword OraGlueOCISecurityPurgeBlock(  OCISecurity *osshandle,
			      OCIError *error_handle,
				   nzttBufferBlock *buffer_block  )
{
return OCISecurityPurgeBlock( osshandle,
			      error_handle,
			      buffer_block  );
}


sword OraGlueOCISecuritySetBlock(  OCISecurity *osshandle,
			    OCIError *error_handle,
			    uword flags_to_set,
			    size_t buffer_length,
			    size_t used_buffer_length,
			    ub1 *buffer,
				 nzttBufferBlock *buffer_block  )
{
return OCISecuritySetBlock( osshandle,
			    error_handle,
			    flags_to_set,
			    buffer_length,
			    used_buffer_length,
			    buffer,
			    buffer_block  );
}


sword OraGlueOCISecurityGetIdentity(  OCISecurity  *osshandle,
			       OCIError       *error_handle,
			       size_t          namelen,
			       text           *distinguished_name,
				    nzttIdentity  **identity  )
{
return OCISecurityGetIdentity( osshandle,
			       error_handle,
			       namelen,
			       distinguished_name,
			       identity  );
}


sword OraGlueOCIAQEnq(  OCISvcCtx *svchp, OCIError *errhp, text *queue_name,
                     OCIAQEnqOptions *enqopt, OCIAQMsgProperties *msgprop, 
                     OCIType *payload_tdo,dvoid **payload, dvoid **payload_ind,
		      OCIRaw **msgid, ub4 flags  )
{
return OCIAQEnq(  svchp, errhp, queue_name,
                     enqopt, msgprop, 
                     payload_tdo,payload, payload_ind,
		     msgid, flags  );
}


sword OraGlueOCIAQDeq(  OCISvcCtx *svchp, OCIError *errhp, text *queue_name,
                     OCIAQDeqOptions *deqopt, OCIAQMsgProperties *msgprop, 
                     OCIType *payload_tdo,dvoid **payload, dvoid **payload_ind,
		      OCIRaw **msgid, ub4 flags  )
{
return OCIAQDeq(  svchp, errhp, queue_name,
                     deqopt, msgprop, 
                     payload_tdo,payload, payload_ind,
		     msgid, flags  );
}


/*-------------------------- Extensions to XA interface ---------------------*/
/* ------------------------- xaosvch ----------------------------------------*/
#ifdef _oracle_XA
// DAR 18/07/03
// Oracle 9.0.1 et plus: .xaosvch undefined symbol.
// xaosvch ne fait plus partie de libclntsh.a
//OCISvcCtx *OraGluexaosvch(  text *dbname  )
//{
//return xaosvch(  dbname  );
//}
//
//
OCISvcCtx *OraGluexaoSvcCtx(  text *dbname  )
{
  return xaoSvcCtx(  dbname  );
}


/* ------------------------- xaoEnv -----------------------------------------*/
OCIEnv *OraGluexaoEnv(  text *dbname  )
{
  return xaoEnv(  dbname  );
}


/* ------------------------- xaosterr ---------------------------------------*/
int OraGluexaosterr(  OCISvcCtx *svch, sb4 error  )
{
return xaosterr(  svch, error  );
}

#endif


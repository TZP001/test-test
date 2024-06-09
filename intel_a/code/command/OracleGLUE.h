#ifdef _WINDOWS_SOURCE 
#ifdef __OracleGLUE
#define ExportedByOracleGLUE  __declspec(dllexport) 
#else
#define ExportedByOracleGLUE  __declspec(dllimport) 
#endif
#else
#define ExportedByOracleGLUE
#endif

// to force typedef unsigned int ub
#ifdef _WINDOWS_SOURCE
#else
#define A_OSF
#endif

#ifndef _OracleGLUE_h
#define _OracleGLUE_h
//#undef  _WINDOWS_SOURCE
#ifdef _HPUX_SOURCE 
#define OCIKPR
#define OCIKP_ORACLE
extern "C" {
#include <ociapr.h>
#include <ociap.h>
}
#else
//#define OCIKPR
//#define OCIKP_ORACLE
#include <oci.h>
//extern "C" {
//#include <ociapr.h>
//#include <ociap.h>
//}
#endif
//typedef unsigned int ub4_DS ;

sword ExportedByOracleGLUE OracleGLUEobindps(struct cda_def *cursor, ub1 opcode, text *sqlvar, 
	       sb4 sqlvl, ub1 *pvctx, sb4 progvl, 
	       sword ftype, sword scale,
	       sb2 *indp, ub2 *alen, ub2 *arcode, 
	       sb4 pv_skip, sb4 ind_skip, sb4 alen_skip, sb4 rc_skip,
	       ub4 maxsiz, ub4 *cursiz,
	       text *fmt, sb4 fmtl, sword fmtt);
sword ExportedByOracleGLUE OracleGLUEobreak(struct cda_def *lda);
sword ExportedByOracleGLUE OracleGLUEocan  (struct cda_def *cursor);
sword ExportedByOracleGLUE OracleGLUEoclose(struct cda_def *cursor);
sword ExportedByOracleGLUE OracleGLUEocof  (struct cda_def *lda);
sword ExportedByOracleGLUE OracleGLUEocom  (struct cda_def *lda);
sword ExportedByOracleGLUE OracleGLUEocon  (struct cda_def *lda);


/*
 * Oci DEFINe (Piecewise or with Skips) 
 */
sword ExportedByOracleGLUE OracleGLUEodefinps(struct cda_def *cursor, ub1 opcode, sword pos,ub1 *bufctx,
		sb4 bufl, sword ftype, sword scale, 
		sb2 *indp, text *fmt, sb4 fmtl, sword fmtt, 
		ub2 *rlen, ub2 *rcode,
		sb4 pv_skip, sb4 ind_skip, sb4 alen_skip, sb4 rc_skip);
sword ExportedByOracleGLUE  OracleGLUEodessp(struct cda_def *cursor, text *objnam, size_t onlen,
              ub1 *rsv1, size_t rsv1ln, ub1 *rsv2, size_t rsv2ln,
              ub2 *ovrld, ub2 *pos, ub2 *level, text **argnam,
              ub2 *arnlen, ub2 *dtype, ub1 *defsup, ub1* mode,
              ub4 *dtsiz, sb2 *prec, sb2 *scale, ub1 *radix,
              ub4 *spare, ub4 *arrsiz);
sword ExportedByOracleGLUE  OracleGLUEodescr(struct cda_def *cursor, sword pos, sb4 *dbsize,
                 sb2 *dbtype, sb1 *cbuf, sb4 *cbufl, sb4 *dsize,
                 sb2 *prec, sb2 *scale, sb2 *nullok);
sword ExportedByOracleGLUE  OracleGLUEoerhms   (struct cda_def *lda, sb2 rcode, text *buf,
                 sword bufsiz);
sword ExportedByOracleGLUE  OracleGLUEoermsg   (sb2 rcode, text *buf);
sword ExportedByOracleGLUE  OracleGLUEoexec    (struct cda_def *cursor);
sword ExportedByOracleGLUE  OracleGLUEoexfet   (struct cda_def *cursor, ub4 nrows,
                 sword cancel, sword exact);
sword ExportedByOracleGLUE  OracleGLUEoexn     (struct cda_def *cursor, sword iters, sword rowoff);
sword ExportedByOracleGLUE  OracleGLUEofen     (struct cda_def *cursor, sword nrows);
sword ExportedByOracleGLUE  OracleGLUEofetch   (struct cda_def *cursor);
sword ExportedByOracleGLUE  OracleGLUEoflng    (struct cda_def *cursor, sword pos, ub1 *buf,
                 sb4 bufl, sword dtype, ub4 *retl, sb4 offset);
sword ExportedByOracleGLUE  OracleGLUEogetpi   (struct cda_def *cursor, ub1 *piecep, dvoid **ctxpp, 
                 ub4 *iterp, ub4 *indexp);
sword ExportedByOracleGLUE  OracleGLUEoopt     (struct cda_def *cursor, sword rbopt, sword waitopt);
sword ExportedByOracleGLUE  OracleGLUEopinit   (ub4 mode);
sword ExportedByOracleGLUE  OracleGLUEolog     (struct cda_def *lda, ub1* hda,
                 text *uid, sword uidl,
                 text *pswd, sword pswdl, 
                 text *conn, sword connl, 
                 ub4 mode);
sword ExportedByOracleGLUE  OracleGLUEologof   (struct cda_def *lda);
sword ExportedByOracleGLUE  OracleGLUEoopen    (struct cda_def *cursor, struct cda_def *lda,
                 text *dbn, sword dbnl, sword arsize,
                 text *uid, sword uidl);
sword ExportedByOracleGLUE  OracleGLUEoparse   (struct cda_def *cursor, text *sqlstm, sb4 sqllen,
                 sword defflg, ub4 lngflg);
sword ExportedByOracleGLUE  OracleGLUEorol     (struct cda_def *lda);
sword ExportedByOracleGLUE  OracleGLUEosetpi   (struct cda_def *cursor, ub1 piece, dvoid *bufp, ub4 *lenp);

void ExportedByOracleGLUE  OracleGLUEsqlld2     (struct cda_def *lda, text *cname, sb4 *cnlen);
void ExportedByOracleGLUE  OracleGLUEsqllda     (struct cda_def *lda);

/* non-blocking functions */
sword ExportedByOracleGLUE  OracleGLUEonbset    (struct cda_def *lda ); 
sword ExportedByOracleGLUE  OracleGLUEonbtst    (struct cda_def *lda ); 
sword ExportedByOracleGLUE  OracleGLUEonbclr    (struct cda_def *lda ); 
sword ExportedByOracleGLUE  OracleGLUEognfd     (struct cda_def *lda, dvoid *fdp);


/* 
 * OBSOLETE CALLS 
 */

/* 
 * OBSOLETE BIND CALLS
 */
sword ExportedByOracleGLUE  OracleGLUEobndra(struct cda_def *cursor, text *sqlvar, sword sqlvl,
                 ub1 *progv, sword progvl, sword ftype, sword scale,
                 sb2 *indp, ub2 *alen, ub2 *arcode, ub4 maxsiz,
                 ub4 *cursiz, text *fmt, sword fmtl, sword fmtt);
sword ExportedByOracleGLUE  OracleGLUEobndrn(struct cda_def *cursor, sword sqlvn, ub1 *progv,
                 sword progvl, sword ftype, sword scale, sb2 *indp,
                 text *fmt, sword fmtl, sword fmtt);
sword ExportedByOracleGLUE  OracleGLUEobndrv(struct cda_def *cursor, text *sqlvar, sword sqlvl,
                 ub1 *progv, sword progvl, sword ftype, sword scale,
                 sb2 *indp, text *fmt, sword fmtl, sword fmtt);

sword ExportedByOracleGLUE  OracleGLUEodefin(struct cda_def *cursor, sword pos, ub1 *buf,
	      sword bufl, sword ftype, sword scale, sb2 *indp,
	      text *fmt, sword fmtl, sword fmtt, ub2 *rlen, ub2 *rcode);

// ======================================================================
// ======================================================================
// New Glue for Oracle 8

/* 
typedef sb4 (*OraGlueOCICallbackInBind)(  dvoid *ictxp, OCIBind *bindp, ub4 iter,
                                   ub4 index, dvoid **bufpp, ub4 *alenp,
                                   ub1 *piecep, dvoid **indp  );
 
typedef sb4 (*OraGlueOCICallbackOutBind)(  dvoid *octxp, OCIBind *bindp, ub4 iter,
                                    ub4 index, dvoid **bufpp, ub4 **alenp,
                                    ub1 *piecep, dvoid **indp,
                                    ub2 **rcodep  );
 
typedef sb4 (*OraGlueOCICallbackDefine)(  dvoid *octxp, OCIDefine *defnp, ub4 iter,
                                   dvoid **bufpp, ub4 **alenp, ub1 *piecep,
                                   dvoid **indp, ub2 **rcodep  );

typedef sb4 (*OraGlueOCICallbackLobRead)(  dvoid *ctxp,
                                      CONST dvoid *bufp,
                                      ub4 len,
                                      ub1 piece  );

typedef sb4 (*OraGlueOCICallbackLobWrite)(  dvoid *ctxp,
                                       dvoid *bufp,
                                       ub4 *lenp,
                                       ub1 *piece  );

typedef sb4 (*OraGlueOCICallbackFailover)(  dvoid *svcctx, dvoid *envctx,
                                       dvoid *fo_ctx, ub4 fo_type,
                                       ub4 fo_event  );
-- */




sword ExportedByOracleGLUE   OraGlueOCIInitialize(  ub4 mode, dvoid *ctxp,
                          dvoid *(*malocfp)(dvoid *ctxp, size_t size),
                          dvoid *(*ralocfp)(dvoid *ctxp, dvoid *memptr,
                                            size_t newsize),
                          void (*mfreefp)(dvoid *ctxp, dvoid *memptr)  );
sword ExportedByOracleGLUE   OraGlueOCIHandleAlloc(  CONST dvoid *parenth, dvoid **hndlpp, ub4 type,
                           size_t xtramem_sz, dvoid **usrmempp  );

sword ExportedByOracleGLUE   OraGlueOCIHandleFree(  dvoid *hndlp, ub4 type  );

sword ExportedByOracleGLUE   OraGlueOCIDescriptorAlloc(  CONST dvoid *parenth, dvoid **descpp, ub4 type,
                         size_t xtramem_sz, dvoid **usrmempp  );

sword ExportedByOracleGLUE   OraGlueOCIDescriptorFree(  dvoid *descp, ub4 type  );

sword ExportedByOracleGLUE   OraGlueOCIEnvInit(  OCIEnv **envp, ub4 mode,
                       size_t xtramem_sz, dvoid **usrmempp  );

sword ExportedByOracleGLUE   OraGlueOCIServerAttach(  OCIServer *srvhp, OCIError *errhp,
                            CONST text *dblink, sb4 dblink_len, ub4 mode  );

sword ExportedByOracleGLUE   OraGlueOCIServerDetach(  OCIServer *srvhp, OCIError *errhp, ub4 mode  );

sword ExportedByOracleGLUE   OraGlueOCISessionBegin(  OCISvcCtx *svchp, OCIError *errhp,
                            OCISession *usrhp, ub4 credt, ub4 mode  );

sword ExportedByOracleGLUE   OraGlueOCISessionEnd(  OCISvcCtx *svchp, OCIError *errhp,
                          OCISession *usrhp, ub4 mode  );

sword ExportedByOracleGLUE OraGlueOCILogon       (  OCIEnv *envhp, OCIError *errhp, OCISvcCtx **svchp, 
			CONST text *username, ub4 uname_len, 
			CONST text *password, ub4 passwd_len, 
			CONST text *dbname, ub4 dbname_len  );

sword ExportedByOracleGLUE OraGlueOCILogoff      (  OCISvcCtx *svchp, OCIError *errhp  );

sword ExportedByOracleGLUE OraGlueOCIPasswordChange (  OCISvcCtx *svchp, OCIError *errhp,
                           CONST text *user_name, ub4 usernm_len,
                           CONST text *opasswd, ub4 opasswd_len,
                           CONST text *npasswd, ub4 npasswd_len, ub4 mode  );

sword ExportedByOracleGLUE   OraGlueOCIStmtPrepare(  OCIStmt *stmtp, OCIError *errhp, CONST text *stmt,
                           ub4 stmt_len, ub4 language, ub4 mode  );

 
sword ExportedByOracleGLUE OraGlueOCIBindByPos   (  OCIStmt *stmtp, OCIBind **bindp, OCIError *errhp,
			ub4 position, dvoid *valuep, sb4 value_sz,
			ub2 dty, dvoid *indp, ub2 *alenp, ub2 *rcodep,
			ub4 maxarr_len, ub4 *curelep, ub4 mode  );
 

 
sword ExportedByOracleGLUE OraGlueOCIBindByName  (  OCIStmt *stmtp, OCIBind **bindp, OCIError *errhp,
			CONST text *placeholder, sb4 placeh_len, 
                        dvoid *valuep, sb4 value_sz, ub2 dty, 
                        dvoid *indp, ub2 *alenp, ub2 *rcodep, 
                        ub4 maxarr_len, ub4 *curelep, ub4 mode  );
 

sword ExportedByOracleGLUE   OraGlueOCIBindObject(  OCIBind *bindp, OCIError *errhp,
                          CONST OCIType *type, dvoid **pgvpp,
                          ub4 *pvszsp, dvoid **indpp, ub4 *indszp  );

sword ExportedByOracleGLUE   OraGlueOCIBindDynamic(  OCIBind *bindp, OCIError *errhp,
                           dvoid *ictxp, OCICallbackInBind icbfp,
                           dvoid *octxp, OCICallbackOutBind ocbfp  );

sword ExportedByOracleGLUE   OraGlueOCIBindArrayOfStruct(  OCIBind *bindp, OCIError *errhp, ub4 pvskip,
                                 ub4 indskip, ub4 alskip, ub4 rcskip  );

sword ExportedByOracleGLUE   OraGlueOCIStmtGetPieceInfo(  OCIStmt *stmtp, OCIError *errhp,
                                dvoid **hndlpp, ub4 *typep, ub1 *in_outp,
                                ub4 *iterp, ub4 *idxp, ub1 *piecep  );

 
sword ExportedByOracleGLUE   OraGlueOCIStmtSetPieceInfo(  dvoid *hndlp, ub4 type, OCIError *errhp,
                                CONST dvoid *bufp, ub4 *alenp, ub1 piece,
                                CONST dvoid *indp, ub2 *rcodep  );
 

sword ExportedByOracleGLUE   OraGlueOCIStmtExecute(  OCISvcCtx *svchp, OCIStmt *stmtp, OCIError *errhp,
                           ub4 iters, ub4 rowoff, CONST OCISnapshot *snap_in,
                           OCISnapshot *snap_out, ub4 mode  );

 
sword ExportedByOracleGLUE OraGlueOCIDefineByPos (  OCIStmt *stmtp, OCIDefine **defnp, OCIError *errhp,
			ub4 position, dvoid *valuep, sb4 value_sz, ub2 dty,
			dvoid *indp, ub2 *rlenp, ub2 *rcodep, ub4 mode  );
 

sword ExportedByOracleGLUE   OraGlueOCIDefineObject(  OCIDefine *defnp, OCIError *errhp,
                            CONST OCIType *type, dvoid **pgvpp,
                            ub4 *pvszsp, dvoid **indpp, ub4 *indszp  );

sword ExportedByOracleGLUE   OraGlueOCIDefineDynamic(  OCIDefine *defnp, OCIError *errhp,
                             dvoid *octxp, OCICallbackDefine ocbfp  );

sword ExportedByOracleGLUE   OraGlueOCIDefineArrayOfStruct(  OCIDefine *defnp, OCIError *errhp, 
                                 ub4 pvskip, ub4 indskip, ub4 rlskip, 
                                 ub4 rcskip  );

 
sword ExportedByOracleGLUE   OraGlueOCIStmtFetch(  OCIStmt *stmtp, OCIError *errhp,
                         ub4 nrows, ub2 orientation, ub4 mode  );
 

sword ExportedByOracleGLUE   OraGlueOCIStmtGetBindInfo(  OCIStmt *stmtp, OCIError *errhp, ub4 size, 
                               ub4 startloc, sb4 *found, 
                               text *bvnp[], ub1 bvnl[], text *invp[],
                               ub1 inpl[], ub1 dupl[], OCIBind *hndl[]  );

 
sword ExportedByOracleGLUE   OraGlueOCIDescribeAny(  OCISvcCtx *svchp, OCIError *errhp,
                           dvoid *objptr, ub4 objnm_len, ub1 objptr_typ,
                           ub1 info_level, ub1 objtyp, OCIDescribe *dschp  );
 

sword ExportedByOracleGLUE   OraGlueOCIParamGet(  CONST dvoid *hndlp, ub4 htype, OCIError *errhp,
                        dvoid **parmdpp, ub4 pos  );

sword ExportedByOracleGLUE   OraGlueOCIParamSet(  dvoid *hdlp, ub4 htyp, OCIError *errhp,
                        CONST dvoid *dscp, ub4 dtyp, ub4 pos  );

sword ExportedByOracleGLUE   OraGlueOCITransStart(  OCISvcCtx *svchp, OCIError *errhp,
                          uword timeout, ub4 flags  );

sword ExportedByOracleGLUE   OraGlueOCITransDetach(  OCISvcCtx *svchp, OCIError *errhp, ub4 flags  );

sword ExportedByOracleGLUE   OraGlueOCITransCommit(  OCISvcCtx *svchp, OCIError *errhp, ub4 flags  );

sword ExportedByOracleGLUE   OraGlueOCITransRollback(  OCISvcCtx *svchp, OCIError *errhp, ub4 flags  );

sword ExportedByOracleGLUE   OraGlueOCITransPrepare (  OCISvcCtx *svchp, OCIError *errhp, ub4 flags  );

sword ExportedByOracleGLUE   OraGlueOCITransForget (   OCISvcCtx *svchp, OCIError *errhp, ub4 flags  );

sword ExportedByOracleGLUE   OraGlueOCIErrorGet   (   dvoid *hndlp, ub4 recordno, text *sqlstate,
			    sb4 *errcodep, text *bufp, ub4 bufsiz, 
			    ub4 type   );

sword ExportedByOracleGLUE   OraGlueOCILobAppend  (   OCISvcCtx *svchp, OCIError *errhp, 
                            OCILobLocator *dst_locp,
                            OCILobLocator *src_locp   );

sword ExportedByOracleGLUE   OraGlueOCILobAssign  (   OCIEnv *envhp, OCIError *errhp, 
                            CONST OCILobLocator *src_locp, 
                            OCILobLocator **dst_locpp   );

sword ExportedByOracleGLUE   OraGlueOCILobCharSetForm  (   OCIEnv *envhp, OCIError *errhp, 
                                 CONST OCILobLocator *locp, 
                                 ub1 *csfrm   );

sword ExportedByOracleGLUE   OraGlueOCILobCharSetId (   OCIEnv *envhp, OCIError *errhp, 
                              CONST OCILobLocator *locp, ub2 *csid   );

sword ExportedByOracleGLUE   OraGlueOCILobCopy  (   OCISvcCtx *svchp, OCIError *errhp, 
                          OCILobLocator *dst_locp,
		          OCILobLocator *src_locp, 
                          ub4 amount, ub4 dst_offset, 
                          ub4 src_offset   );

sword ExportedByOracleGLUE   OraGlueOCILobDisableBuffering (   OCISvcCtx      *svchp,
                                     OCIError       *errhp,
                                     OCILobLocator  *locp   );

sword ExportedByOracleGLUE   OraGlueOCILobEnableBuffering (   OCISvcCtx      *svchp,
                                    OCIError       *errhp,
                                    OCILobLocator  *locp   );

sword ExportedByOracleGLUE   OraGlueOCILobErase  (   OCISvcCtx *svchp, OCIError *errhp, 
                           OCILobLocator *locp,
                           ub4 *amount, ub4 offset   );

sword ExportedByOracleGLUE   OraGlueOCILobFileClose  (   OCISvcCtx *svchp, OCIError *errhp, 
                               OCILobLocator *filep   );

sword ExportedByOracleGLUE   OraGlueOCILobFileCloseAll (  OCISvcCtx *svchp, OCIError *errhp  );

sword ExportedByOracleGLUE   OraGlueOCILobFileExists   (  OCISvcCtx *svchp, OCIError *errhp, 
			      OCILobLocator *filep,
			      boolean *flag  );
 
sword ExportedByOracleGLUE   OraGlueOCILobFileGetName  (   OCIEnv *envhp, OCIError *errhp, 
                                 CONST OCILobLocator *filep,
                                 text *dir_alias, ub2 *d_length, 
                                 text *filename, ub2 *f_length   );
                            
sword ExportedByOracleGLUE   OraGlueOCILobFileIsOpen  (  OCISvcCtx *svchp, OCIError *errhp, 
                               OCILobLocator *filep,
                               boolean *flag  );

 
sword ExportedByOracleGLUE   OraGlueOCILobFileOpen  (   OCISvcCtx *svchp, OCIError *errhp, 
                            OCILobLocator *filep, ub1 mode   );
 

 
sword ExportedByOracleGLUE   OraGlueOCILobFileSetName  (   OCIEnv *envhp, OCIError *errhp, 
                                 OCILobLocator **filepp, 
                                 CONST text *dir_alias, ub2 d_length, 
                                 CONST text *filename, ub2 f_length   );
 

sword ExportedByOracleGLUE   OraGlueOCILobFlushBuffer (   OCISvcCtx       *svchp,
                                OCIError        *errhp,
                                OCILobLocator   *locp,
                                ub4              flag   );

sword ExportedByOracleGLUE   OraGlueOCILobGetLength  (   OCISvcCtx *svchp, OCIError *errhp, 
                               OCILobLocator *locp,
		               ub4 *lenp   );

sword ExportedByOracleGLUE   OraGlueOCILobIsEqual  (   OCIEnv *envhp, CONST OCILobLocator *x, 
                             CONST OCILobLocator *y, boolean *is_equal   );

sword ExportedByOracleGLUE   OraGlueOCILobLoadFromFile  (   OCISvcCtx *svchp, OCIError *errhp, 
                                  OCILobLocator *dst_locp,
       	                          OCILobLocator *src_filep, 
                                  ub4 amount, ub4 dst_offset, 
                                  ub4 src_offset   );

sword ExportedByOracleGLUE   OraGlueOCILobLocatorIsInit (   OCIEnv *envhp, OCIError *errhp, 
                                CONST OCILobLocator *locp, 
                                boolean *is_initialized   );

 
sword ExportedByOracleGLUE   OraGlueOCILobRead  (   OCISvcCtx *svchp, OCIError *errhp, 
                          OCILobLocator *locp,
                          ub4 *amtp, ub4 offset, dvoid *bufp, ub4 bufl, 
                          dvoid *ctxp, 
                          sb4 (*cbfp)( dvoid *ctxp, 
                                       CONST dvoid *bufp, 
                                       ub4 len, 
                                       ub1 piece),
                          ub2 csid, ub1 csfrm   );
 

sword ExportedByOracleGLUE   OraGlueOCILobTrim  (   OCISvcCtx *svchp, OCIError *errhp, 
                          OCILobLocator *locp,
                          ub4 newlen   );

 
sword ExportedByOracleGLUE   OraGlueOCILobWrite  (   OCISvcCtx *svchp, OCIError *errhp, 
                         OCILobLocator *locp,
                         ub4 *amtp, ub4 offset, dvoid *bufp, ub4 buflen, 
                         ub1 piece, dvoid *ctxp, 
                         sb4 (*cbfp)(dvoid *ctxp, 
                                     dvoid *bufp, 
                                     ub4 *len, 
                                     ub1 *piece),
                         ub2 csid, ub1 csfrm  );
 

sword ExportedByOracleGLUE   OraGlueOCIBreak (   dvoid *hndlp, OCIError *errhp   );

 
sword ExportedByOracleGLUE   OraGlueOCIServerVersion  (   dvoid *hndlp, OCIError *errhp, text *bufp, 
                                ub4 bufsz, ub1 hndltype   );


sword ExportedByOracleGLUE   OraGlueOCIAttrGet (   CONST dvoid *trgthndlp, ub4 trghndltyp, 
                         dvoid *attributep, ub4 *sizep, ub4 attrtype, 
                         OCIError *errhp   );

sword ExportedByOracleGLUE   OraGlueOCIAttrSet (   dvoid *trgthndlp, ub4 trghndltyp, dvoid *attributep,
                         ub4 size, ub4 attrtype, OCIError *errhp   );

sword ExportedByOracleGLUE   OraGlueOCISvcCtxToLda (   OCISvcCtx *svchp, OCIError *errhp, 
                             Lda_Def *ldap   );

sword ExportedByOracleGLUE   OraGlueOCILdaToSvcCtx (   OCISvcCtx **svchpp, OCIError *errhp, 
                             Lda_Def *ldap   );

sword ExportedByOracleGLUE   OraGlueOCIResultSetToStmt (   OCIResult *rsetdp, OCIError *errhp   );





sword ExportedByOracleGLUE   OraGlueOCISecurityInitialize (  OCISecurity *osshandle,
                                 OCIError *error_handle  );

sword ExportedByOracleGLUE   OraGlueOCISecurityTerminate (  OCISecurity *osshandle,
				OCIError *error_handle  );

sword ExportedByOracleGLUE OraGlueOCISecurityOpenWallet(  OCISecurity *osshandle,
			      OCIError *error_handle,
			      size_t wrllen,
			      text *wallet_resource_locator,
			      size_t pwdlen,
			      text *password,
			      nzttWallet *wallet  );

sword ExportedByOracleGLUE OraGlueOCISecurityCloseWallet(  OCISecurity *osshandle,
			       OCIError *error_handle,
			       nzttWallet *wallet  );

sword ExportedByOracleGLUE OraGlueOCISecurityCreateWallet(  OCISecurity *osshandle,
				OCIError *error_handle,
				size_t wrllen,
				text *wallet_resource_locator,
				size_t pwdlen,
				text *password,
				nzttWallet *wallet  );

sword ExportedByOracleGLUE OraGlueOCISecurityDestroyWallet(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 size_t wrllen,
				 text *wallet_resource_locator,
				 size_t pwdlen,
				 text *password  );

sword ExportedByOracleGLUE OraGlueOCISecurityStorePersona(  OCISecurity *osshandle,
				OCIError *error_handle,
				nzttPersona **persona,
				nzttWallet *wallet  );

sword ExportedByOracleGLUE OraGlueOCISecurityOpenPersona(  OCISecurity *osshandle,
			       OCIError *error_handle,
			       nzttPersona *persona  );

sword ExportedByOracleGLUE OraGlueOCISecurityClosePersona(  OCISecurity *osshandle,
				OCIError *error_handle,
				nzttPersona *persona  );

sword ExportedByOracleGLUE OraGlueOCISecurityRemovePersona(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona **persona  );

sword ExportedByOracleGLUE OraGlueOCISecurityCreatePersona(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttIdentType identity_type,
				 nzttCipherType cipher_type,
				 nzttPersonaDesc *desc,
				 nzttPersona **persona  );

sword ExportedByOracleGLUE OraGlueOCISecuritySetProtection(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona *persona,
				 nzttcef crypto_engine_function,
				 nztttdufmt data_unit_format,
				 nzttProtInfo *protection_info  );

sword ExportedByOracleGLUE OraGlueOCISecurityGetProtection(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona *persona,
				 nzttcef crypto_engine_function,
				 nztttdufmt * data_unit_format_ptr,
				 nzttProtInfo *protection_info  );

sword ExportedByOracleGLUE OraGlueOCISecurityRemoveIdentity(  OCISecurity *osshandle,
				  OCIError *error_handle,
				  nzttIdentity **identity_ptr  );

sword ExportedByOracleGLUE OraGlueOCISecurityCreateIdentity(  OCISecurity *osshandle,
				  OCIError *error_handle,
				  nzttIdentType type,
				  nzttIdentityDesc *desc,
				  nzttIdentity **identity_ptr  );

sword ExportedByOracleGLUE OraGlueOCISecurityAbortIdentity(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttIdentity **identity_ptr  );

sword ExportedByOracleGLUE OraGlueOCISecurityFreeIdentity(  OCISecurity *osshandle,
			       	  OCIError *error_handle,
				  nzttIdentity **identity_ptr  );

sword ExportedByOracleGLUE OraGlueOCISecurityStoreTrustedIdentity(  OCISecurity *osshandle,
					OCIError *error_handle,
					nzttIdentity **identity_ptr,
					nzttPersona *persona  );

sword ExportedByOracleGLUE OraGlueOCISecuritySign(  OCISecurity *osshandle,
			OCIError *error_handle,
			nzttPersona *persona,
			nzttces signature_state,
			size_t input_length,
			ub1 *input,
			nzttBufferBlock *buffer_block  );

sword ExportedByOracleGLUE OraGlueOCISecuritySignExpansion(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona *persona,
				 size_t inputlen,
				 size_t *signature_length  );

sword ExportedByOracleGLUE OraGlueOCISecurityVerify(  OCISecurity *osshandle,
			  OCIError *error_handle,
			  nzttPersona *persona,
			  nzttces signature_state,
			  size_t siglen,
			  ub1 *signature,
			  nzttBufferBlock *extracted_message,
			  boolean *verified,
			  boolean *validated,
			  nzttIdentity **signing_party_identity  );

sword ExportedByOracleGLUE OraGlueOCISecurityValidate(  OCISecurity *osshandle,
			    OCIError *error_handle,
			    nzttPersona *persona,
			    nzttIdentity *identity,
			    boolean *validated  );

sword ExportedByOracleGLUE OraGlueOCISecuritySignDetached(  OCISecurity *osshandle,
				OCIError *error_handle,
				nzttPersona *persona,
				nzttces signature_state,
				size_t input_length,
				ub1 * input,
				nzttBufferBlock *signature  );

sword ExportedByOracleGLUE OraGlueOCISecuritySignDetExpansion(  OCISecurity *osshandle,
				    OCIError    *error_handle,
				    nzttPersona *persona,
				    size_t       input_length,
				    size_t *required_buffer_length  );

sword ExportedByOracleGLUE OraGlueOCISecurityVerifyDetached(  OCISecurity *osshandle,
				  OCIError *error_handle,
				  nzttPersona *persona,
				  nzttces signature_state,
				  size_t data_length,
				  ub1 *data,
				  size_t siglen,
				  ub1 *signature,
				  boolean *verified,
				  boolean *validated,
				  nzttIdentity **signing_party_identity  );

sword ExportedByOracleGLUE OraGlueOCISecurity_PKEncrypt(  OCISecurity *osshandle,
			      OCIError *error_handle,
			      nzttPersona *persona,
			      size_t number_of_recipients,
			      nzttIdentity *recipient_list,
			      nzttces encryption_state,
			      size_t input_length,
			      ub1 *input,
			      nzttBufferBlock *encrypted_data  );

sword ExportedByOracleGLUE OraGlueOCISecurityPKEncryptExpansion(  OCISecurity *osshandle,
				      OCIError *error_handle,
				      nzttPersona *persona,
				      size_t number_recipients,
				      size_t input_length,
				      size_t *buffer_length_required  );

sword ExportedByOracleGLUE OraGlueOCISecurityPKDecrypt(  OCISecurity *osshandle,
			     OCIError *error_handle,
			     nzttPersona *persona,
			     nzttces encryption_state,
			     size_t input_length,
			     ub1 *input,
			     nzttBufferBlock *encrypted_data  );

sword ExportedByOracleGLUE OraGlueOCISecurityEncrypt(  OCISecurity *osshandle,
			   OCIError *error_handle,
			   nzttPersona *persona,
			   nzttces encryption_state,
			   size_t input_length,
			   ub1 *input,
			   nzttBufferBlock *encrypted_data  );

sword ExportedByOracleGLUE OraGlueOCISecurityEncryptExpansion(  OCISecurity *osshandle,
				    OCIError *error_handle,
				    nzttPersona *persona,
				    size_t input_length,
				    size_t *encrypted_data_length  );

sword ExportedByOracleGLUE OraGlueOCISecurityDecrypt(  OCISecurity *osshandle,
			   OCIError *error_handle,
			   nzttPersona *persona,
			   nzttces decryption_state,
			   size_t input_length,
			   ub1 *input,
			   nzttBufferBlock *decrypted_data  );

sword ExportedByOracleGLUE OraGlueOCISecurityEnvelope(  OCISecurity *osshandle,
			    OCIError *error_handle,
			    nzttPersona *persona,
			    size_t number_of_recipients,
			    nzttIdentity *identity,
			    nzttces encryption_state,
			    size_t input_length,
			    ub1 *input,
			    nzttBufferBlock *enveloped_data  );

sword ExportedByOracleGLUE OraGlueOCISecurityDeEnvelope(  OCISecurity *osshandle,
                                OCIError *error_handle,
                                nzttPersona *persona,
                                nzttces decryption_state,
                                size_t input_length,
                                ub1 *input,
                                nzttBufferBlock *output_message,
                                boolean *verified,
                                boolean *validated,
                                nzttIdentity **sender_identity  );

sword ExportedByOracleGLUE OraGlueOCISecurityKeyedHash(  OCISecurity *osshandle,
			     OCIError *error_handle,
			     nzttPersona *persona,
			     nzttces hash_state,
			     size_t input_length,
			     ub1 *input,
			     nzttBufferBlock *keyed_hash  );

sword ExportedByOracleGLUE OraGlueOCISecurityKeyedHashExpansion(  OCISecurity *osshandle,
				      OCIError *error_handle,
				      nzttPersona *persona,
				      size_t input_length,
				      size_t *required_buffer_length  );

sword ExportedByOracleGLUE OraGlueOCISecurityHash(  OCISecurity *osshandle,
			OCIError *error_handle,
			nzttPersona *persona,
			nzttces hash_state,
			size_t input,
			ub1 *input_length,
			nzttBufferBlock *hash  );

sword ExportedByOracleGLUE OraGlueOCISecurityHashExpansion(  OCISecurity *osshandle,
				 OCIError *error_handle,
				 nzttPersona *persona,
				 size_t input_length,
				 size_t *required_buffer_length  );

sword ExportedByOracleGLUE OraGlueOCISecuritySeedRandom(  OCISecurity *osshandle,
			      OCIError *error_handle,
			      nzttPersona *persona,
			      size_t seed_length,
			      ub1 *seed  );

sword ExportedByOracleGLUE OraGlueOCISecurityRandomBytes(  OCISecurity *osshandle,
			       OCIError *error_handle,
			       nzttPersona *persona,
			       size_t number_of_bytes_desired,
			       nzttBufferBlock *random_bytes  );

sword ExportedByOracleGLUE OraGlueOCISecurityRandomNumber(  OCISecurity *osshandle,
				OCIError *error_handle,
				nzttPersona *persona,
				uword *random_number_ptr  );

sword ExportedByOracleGLUE OraGlueOCISecurityInitBlock(  OCISecurity *osshandle,
			     OCIError *error_handle,
			     nzttBufferBlock *buffer_block  );

sword ExportedByOracleGLUE OraGlueOCISecurityReuseBlock(  OCISecurity *osshandle,
			      OCIError *error_handle,
			      nzttBufferBlock *buffer_block  );

sword ExportedByOracleGLUE OraGlueOCISecurityPurgeBlock(  OCISecurity *osshandle,
			      OCIError *error_handle,
			      nzttBufferBlock *buffer_block  );

sword ExportedByOracleGLUE OraGlueOCISecuritySetBlock(  OCISecurity *osshandle,
			    OCIError *error_handle,
			    uword flags_to_set,
			    size_t buffer_length,
			    size_t used_buffer_length,
			    ub1 *buffer,
			    nzttBufferBlock *buffer_block  );

sword ExportedByOracleGLUE OraGlueOCISecurityGetIdentity(  OCISecurity  *osshandle,
			       OCIError       *error_handle,
			       size_t          namelen,
			       text           *distinguished_name,
			       nzttIdentity  **identity  );

sword ExportedByOracleGLUE OraGlueOCIAQEnq(  OCISvcCtx *svchp, OCIError *errhp, text *queue_name,
                     OCIAQEnqOptions *enqopt, OCIAQMsgProperties *msgprop, 
                     OCIType *payload_tdo,dvoid **payload, dvoid **payload_ind,
		     OCIRaw **msgid, ub4 flags  );

sword ExportedByOracleGLUE OraGlueOCIAQDeq(  OCISvcCtx *svchp, OCIError *errhp, text *queue_name,
                     OCIAQDeqOptions *deqopt, OCIAQMsgProperties *msgprop, 
                     OCIType *payload_tdo,dvoid **payload, dvoid **payload_ind,
		     OCIRaw **msgid, ub4 flags  );

/*-------------------------- Extensions to XA interface ---------------------*/
/* ------------------------- xaosvch ----------------------------------------*/
#ifdef _oracle_XA
OCISvcCtx * ExportedByOracleGLUE  OraGluexaosvch(  text *dbname  );

OCISvcCtx * ExportedByOracleGLUE OraGluexaoSvcCtx(  text *dbname  );

/* ------------------------- xaoEnv -----------------------------------------*/
OCIEnv * ExportedByOracleGLUE OraGluexaoEnv(  text *dbname  );

/* ------------------------- xaosterr ---------------------------------------*/
int ExportedByOracleGLUE OraGluexaosterr(  OCISvcCtx *svch, sb4 error  );
#endif

#endif


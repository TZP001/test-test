@if not DEFINED ADL_DEBUG @echo off
@rem ##### checks the SCM environment : Oracle / iBox / Db2 
@rem ##### 

sh +C -K %~dp0adl_chk_env %*

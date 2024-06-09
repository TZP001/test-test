@if not DEFINED ADL_DEBUG @echo off
@rem ##### Checkout of all files modified by frontpage out of
@rem ##### to execute before promoting 
@rem ##### 

sh +C -K %~dp0adl_doc_co %*

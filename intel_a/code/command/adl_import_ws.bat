@if not DEFINED ADL_DEBUG @echo off
@rem ##### Import all changes from an origin workspace to the current one
@rem ##### 

sh +C -K %~dp0adl_import_ws %*

@if not DEFINED ADL_DEBUG @echo off
@rem ##### Import frameworks from an origin workspace to the current one
@rem ##### 

sh +C -K %~dp0adl_populate_tree %*

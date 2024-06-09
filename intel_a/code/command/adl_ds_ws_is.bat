@if not DEFINED ADL_DEBUG @echo off
@rem ***************************** Multi-site transfer command ***************************
@rem This command requires Mks

sh +C -K %~dp0adl_ds_ws_is %*

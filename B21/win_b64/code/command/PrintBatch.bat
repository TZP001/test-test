@echo off
rem
rem                                                     
rem Execution of CATPrintBatch utility  
rem                                                                        
rem %1 ----> Optional XML Print File Parameters  
rem

set PATH=..\bin;%PATH%

if "%1"=="" CATPrintBatchUI

if not "%1"=="" CNEXT -batch -e CATPrintBatchUtility %1 -e FileExit




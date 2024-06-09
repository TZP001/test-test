@echo off
rem
rem %1 = path de tck_init a executer
rem %2 = fichier pour recuperer l environnement apres tck_init
rem
call %1
set > %2

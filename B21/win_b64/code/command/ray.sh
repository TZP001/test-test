#!/bin/ksh

ROOT=$1
OS=`uname`

if [ $OS = 'IRIX64' -o $OS = 'IRIX' ]
then
  export LD_LIBRARY_PATH=.:$ROOT

elif [ $OS = 'AIX' ]
then
  export LIBPATH=.:$ROOT

elif [ $OS = 'HP-UX' ]
then
  export SHLIB_PATH=.:$ROOT

elif [ $OS = 'SunOS' ]
then
  export LD_LIBRARY_PATH=.:$ROOT

fi

$ROOT/CATRdgSatellite


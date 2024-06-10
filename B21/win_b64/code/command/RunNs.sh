#!/bin/ksh
#set -x
# ================================================
#
#  This shell starts mozilla with an URL
#  If mozilla is not found it starts Netscape with an URL
#  Its input argument is the URL
#
#  Return codes    : 0 if OK
#                    1 if Netscape cannot be found
#                    2 if too long to start
#
# ================================================

unset ENV
unset export

#test mozilla access
whence mozilla >/dev/null 2>&1
if [ $? = 0 ]
then
    mozilla -remote 'openURL('$1')' >/dev/null 2>&1
    if [ $? != 0 ]
    then
        if [ "`uname`" = "HP-UX" ] && type dtterm >/dev/null 2>&1 ;
        then
            dtterm -iconic -geometry 1x1+0+0 -e mozilla "$1" &
        else
            mozilla "$1" &
        fi
    fi
    exit 0
fi

#test netscape access
whence netscape >/dev/null 2>&1
if [ $? != 0 ]
then
 exit 1
fi

netscape_install () {
  if [ "`uname`" = "HP-UX" ] && type dtterm >/dev/null 2>&1 ;
  then
    dtterm -iconic -geometry 1x1+0+0 -e netscape -install &
  else
    netscape -install &
  fi
}

#send the URL and test if netscape is running
netscape -remote 'openURL('$1')' >/dev/null 2>&1

if [ $? != 0 ]
then
#try to start netscape
  netscape_install
  typeset -i ret
  ret=1
#try to send the URL
  while [ $ret != 0 ]
  do
    netscape -remote 'openURL('$1')' >/dev/null 2>&1
    if [ $? = 0 ]
    then
#success netscape is started and the URL has been sent
      ret=0
    else
#try 60 seconds
      if [ $ret = 60 ]
      then
        exit 2
      else
        ret=$ret+1
        sleep 1
      fi
    fi
  done
fi


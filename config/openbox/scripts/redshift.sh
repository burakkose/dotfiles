#!/bin/bash

#check if redshift is running
if pgrep redshift >/dev/null 2>&1
  then
    redshift -x &&  killall -9 redshift
  else
     redshift
fi

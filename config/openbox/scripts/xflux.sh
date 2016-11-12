#!/bin/bash

#check if xflux is running
if pgrep xflux >/dev/null 2>&1
  then
     auto-xflux && killall -9 xflux
  else
     auto-xflux
fi

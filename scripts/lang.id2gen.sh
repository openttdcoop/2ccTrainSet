#!/bin/bash

GIDDEC=`let x=0x$1+0x80; echo $x`
printf '%X\n' $GIDDEC
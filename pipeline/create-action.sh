#!/bin/bash
APP=$1
SRC=$2
if ! bx cloud-functions action get ${APP}; then  
    bx cloud-functions action create ${APP} ${SRC} --kind nodejs:8 -m 128 $3 $4 $5 $6
else
    bx cloud-functions action update ${APP} ${SRC} --kind nodejs:8 -m 128 $3 $4 $5 $6
fi
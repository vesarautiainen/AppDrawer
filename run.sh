#!/bin/bash

sizeparam=10

if [ "$1" = "small" ]; then
  sizeparam=8
fi

if [ "$1" = "large" ]; then
  sizeparam=16
fi


GRID_UNIT_PX=${sizeparam} qmlscene -I prototype-toolkit Main.qml


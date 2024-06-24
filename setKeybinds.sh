#!/bin/bash

mice=$(xinput list | grep Evoluent | awk '{split($0,a,"id=");split(a[2],b," ");print b[1]}' | sort | uniq)

for mouse in $mice;
do
	xinput set-button-map $mouse 1 3 2 4 5 6 7 8 9 10
done


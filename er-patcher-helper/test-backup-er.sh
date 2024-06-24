#!/bin/bash

if [ "$#" -ne 1 ]; then
        >&2 echo "Please provide a path to the executables."
        exit 1
fi

if [ ! -f "$1/eldenring.exe" ]; then
        >&2 echo "eldenring.exe not found"
        exit 2
fi

if [ ! -f "$1/start_protected_game.exe" ]; then
        >&2 echo "eldenring.exe not found"
        exit 3
fi

echo "mv \"$1/elden_ring.exe\" \"$1/elden_ring.exe.bak\""
echo "cp \"$1/elden_ring.exe.bak\" ./backup/"
echo "mv \"$1/start_protected_game.exe\" \"$1/start_protected_game.exe\""
echo "cp \"$1/start_protected_game.exe\" ./backup/"

echo "python3 ./er-patcher --rate 240 --remove-60hz-fullscreen --ultrawide --increase-animation-distance --skip-intro -o \"$1/start_protected_game.exe\" -e \"$1/eldenring.exe\""
echo "chmod +x \"$1/start_protected_game.exe\""



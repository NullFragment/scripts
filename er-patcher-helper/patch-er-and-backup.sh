#!/bin/bash

GAME_DIR="${HOME}/Games/SteamLibrary/steamapps/common/ELDEN RING/Game"
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
BACKUP_DIR="$SCRIPTPATH/backup"

if [ "$#" -gt 1 ]; then
        >&2 echo "Please only provide a path to the executables or use the default (~/Games/SteamLibrary/steamapps/common/ELDEN\ RING/Game)."
        exit 1
elif [ "$1" == "-r" ]; then
    if [ ! -f "$BACKUP_DIR/eldenring.exe.bak" ]; then
            >&2 echo "eldenring.exe.bak not found"
            exit 2
    else
        cp "$BACKUP_DIR/eldenring.exe.bak" "$GAME_DIR/eldenring.exe"
        echo "Restored original eldenring.exe"
    fi

    if [ ! -f "$BACKUP_DIR/start_protected_game.exe.bak" ]; then
            >&2 echo "start_protected_game.exe.bak not found"
            exit 2
    else
        cp "$BACKUP_DIR/start_protected_game.exe.bak" "$GAME_DIR/start_protected_game.exe"
        echo "Restored original start_protected_game.exe"
    fi
    
    exit 0

elif [ "$#" -eq 1 ]; then
        GAME_DIR="$1"
fi

if [ ! -f "$GAME_DIR/eldenring.exe" ]; then
        >&2 echo "eldenring.exe not found"
        exit 2
fi

if [ ! -f "$GAME_DIR/start_protected_game.exe" ]; then
        >&2 echo "eldenring.exe not found"
        exit 3
fi

mkdir -p "$BACKUP_DIR"

cp "$GAME_DIR/eldenring.exe" "$BACKUP_DIR/eldenring.exe.bak"
cp "$GAME_DIR/start_protected_game.exe" "$BACKUP_DIR/start_protected_game.exe.bak"

python3 ./er-patcher --rate 240 --remove-60hz-fullscreen --ultrawide --increase-animation-distance --skip-intro -o "$GAME_DIR/start_protected_game.exe" -e "$GAME_DIR/eldenring.exe"
chmod +x "$GAME_DIR/start_protected_game.exe"



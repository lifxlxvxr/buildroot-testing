#!/bin/bash
cleanup() {
    for pid in $(ps -e -o pid= -o comm= | awk '$2=="openbox"{print $1}'); do
        kill "$pid" 2>/dev/null
    done
    for pid in $(ps -e -o pid= -o comm= | awk '$2=="fluxbox"{print $1}'); do
        kill "$pid" 2>/dev/null
    done
    for pid in $(ps -e -o pid= -o comm= | awk '$2=="x11vnc"{print $1}'); do
        kill "$pid" 2>/dev/null
    done
}
trap cleanup EXIT

WM="openbox"
NOWARN=0

for arg in "$@"; do
        case "$arg" in
         openbox|fluxbox)
                WM="$arg"
                ;;
        --nowarn)
                NOWARN=1
                ;;
        esac
done

export DISPLAY=:0

if [ "$NOWARN" -eq 1 ]; then
        $WM 2> /dev/null &
else
        $WM &
fi

sleep 2

x11vnc -display :0 -forever -nopw


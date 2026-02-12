#!/bin/sh
# S80settime - set system time fallback from build-date

LOGFILE="/etc/init.d/settime.log"

YEAR=$(date +%Y)
if [ "$YEAR" -ge 2026 ]; then
    exit 0
fi

NTP_SERVER="pool.ntp.org"
ping -c1 -W1 $NTP_SERVER >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Network available, NTP will sync later." > $LOGFILE
    
else
    if [ -f /etc/build-date ]; then
        BUILD_DATE=$(cat /etc/build-date)
        echo "No network, setting build-time fallback: $BUILD_DATE" > $LOGFILE
        date -s "$BUILD_DATE"
    fi
fi


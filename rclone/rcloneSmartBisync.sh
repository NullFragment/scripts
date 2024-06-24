#!/bin/bash

INITIAL_TIME=8
MAX_TIME=4096
MULTIPLIER=2

DRIVE_LOCATION="/home/nullified/Storage/Drive/"
RCLONE_REMOTE="protonDrive:"
OUTPUT_TEXT_LOCATION="/home/nullified/Storage/.smartsync/"
NOTIFY_TEXT_FILE="fsnotifyOutput.txt"
CHANGED_DIRECTORIES_FILE="changedFiles.txt"
INOTIFY_EVENTS="modify,move,create,delete"


CURRENT_TIME=$((INITIAL_TIME))
NOTIFY_ENABLE=true

SYNC_SCRIPT=$(realpath "$0")

notify() {
  MESSAGE=$1
  if test ${NOTIFY_ENABLE} = "true"; then
      notify-send "rclone ${RCLONE_REMOTE}" "${MESSAGE}"
  fi
}

rclone_bisync() {
  notify "Starting sync..."
  mkdir -p $OUTPUT_TEXT_LOCATION

  while true
  do
    notify "Watching for $CURRENT_TIME seconds"

    fsnotifywatch -I --recursive --event "$INOTIFY_EVENTS" -t "$CURRENT_TIME" "$DRIVE_LOCATION" > "${OUTPUT_TEXT_LOCATION}${NOTIFY_TEXT_FILE}"
    tail -n+2 "${OUTPUT_TEXT_LOCATION}${NOTIFY_TEXT_FILE}" | awk '{split($0, a, " "); print a[4]}' | sort | uniq > "${OUTPUT_TEXT_LOCATION}${CHANGED_DIRECTORIES_FILE}"
    
    changeCount=$(cat ${OUTPUT_TEXT_LOCATION}${CHANGED_DIRECTORIES_FILE} | wc -l)
    if [[ $changeCount -gt 0 ]]; then
      notify "Found $changeCount directories with changes..."
      rclone bisync $DRIVE_LOCATION protonDrive: \
        -MvP \
        --max-depth 1 \
        --create-empty-src-dirs \
        --compare size,modtime,checksum \
        --slow-hash-sync-only \
        --resilient \
        --drive-skip-gdocs \
        --fix-case \
        --files-from ${OUTPUT_TEXT_LOCATION}${CHANGED_DIRECTORIES_FILE}

      CURRENT_TIME=$((INITIAL_TIME))
      notify "Done syncing..."
      continue
    fi

    if [ "$CURRENT_TIME" -lt "$MAX_TIME" ]; then
      CURRENT_TIME=$((CURRENT_TIME*MULTIPLIER))
    fi
  
    echo "$CURRENT_TIME"
  done
}

systemd_setup() {
    set -x
    if loginctl show-user "${USER}" | grep "Linger=no"; then
	    echo "User account does not allow systemd Linger."
	    echo "To enable lingering, run as root: loginctl enable-linger $USER"
	    echo "Then try running this command again."
	    exit 1
    fi
    mkdir -p "${HOME}"/.config/systemd/user
    SERVICE_FILE=${HOME}/.config/systemd/user/rclone_bisync.${RCLONE_REMOTE}.service
    if test -f "${SERVICE_FILE}"; then
	    echo "Unit file already exists: ${SERVICE_FILE} - Not overwriting."
    else
	    cat <<EOF > "${SERVICE_FILE}"
[Unit]
Description=rclone_bisync ${RCLONE_REMOTE}

[Service]
ExecStart=${SYNC_SCRIPT}
ExecStop=$(killall -15 ${SYNC_SCRIPT})

[Install]
WantedBy=default.target
EOF
    fi
    systemctl --user daemon-reload
    systemctl --user enable --now rclone_bsync.${RCLONE_REMOTE}
    systemctl --user status rclone_bisync.${RCLONE_REMOTE}
    echo "You can watch the logs with this command:"
    echo "   journalctl --user --unit rclone_bisync.${RCLONE_REMOTE}"
}

if test $# = 0; then
    rclone_sync
else
    CMD=$1; shift;
    ${CMD} "$@"
fi
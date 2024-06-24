#!/bin/bash

INITIAL_TIME=8
MAX_TIME=4096
MULTIPLIER=2

REFERENCE_FILE_1="/home/nullified/Storage/.smartsync/refFile1"
REFERENCE_FILE_2="/home/nullified/Storage/.smartsync/refFile2"
FOUND_CHANGES_FILE="/home/nullified/Storage/.smartsync/foundFiles"
TRUNCATED_CHANGES_FILE="/home/nullified/Storage/.smartsync/foundFilesTruncated"

DRIVE_PATH="/home/nullified/Storage/Drive/"
RCLONE_REMOTE="protonDrive:"


CURRENT_TIME=$((INITIAL_TIME))
touch ${REFERENCE_FILE_1}


notify() {
  MESSAGE=$1
  if test ${NOTIFY_ENABLE} = "true"; then
      notify-send "rclone ${RCLONE_REMOTE}" "${MESSAGE}"
  fi
}

rclone_watch_sync(){
	while true
	do
		notify "Watching for $CURRENT_TIME seconds"
		sleep $WAIT_TIME
	

		touch ${REFERENCE_FILE_2} # Used to catch changes that happen after finding
		
		find ${DRIVE_PATH} -type f -newer ${REFERENCE_FILE_1} > ${FOUND_CHANGES_FILE}
	
		if [ -s ${FOUND_CHANGES_FILE} ]; then
			sed "s|${DRIVE_PATH}||g" ${FOUND_CHANGES_FILE} > ${TRUNCATED_CHANGES_FILE}
			
			notify "Found $(cat ${TRUNCATED_CHANGES_FILE} | wc -l) changed files. Attempting to sync..."
			rclone sync ${DRIVE_PATH} ${RCLONE_REMOTE} -MvvP --create-empty-src-dirs --fix-case --files-from ${TRUNCATED_CHANGES_FILE}
			
			CURRENT_TIME=$((INITIAL_TIME))
		else
			if [ "$CURRENT_TIME" -lt "$MAX_TIME" ]; then
				CURRENT_TIME=$((CURRENT_TIME*MULTIPLIER))
			fi
		fi
	
		temp=${REFERENCE_FILE_1}
		REFERENCE_FILE_1=${REFERENCE_FILE_2}
		REFERENCE_FILE_2=${temp}
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
    SERVICE_FILE=${HOME}/.config/systemd/user/rclone_watch_sync.${RCLONE_REMOTE}.service
    if test -f "${SERVICE_FILE}"; then
	    echo "Unit file already exists: ${SERVICE_FILE} - Not overwriting."
    else
	    cat <<EOF > "${SERVICE_FILE}"
[Unit]
Description=rclone_watch_sync ${RCLONE_REMOTE}

[Service]
ExecStart=${SYNC_SCRIPT}
ExecStop=$(killall -15 ${SYNC_SCRIPT})

[Install]
WantedBy=default.target
EOF
    fi
    systemctl --user daemon-reload
    systemctl --user enable --now rclone_watch_sync.${RCLONE_REMOTE}
    systemctl --user status rclone_watch_sync.${RCLONE_REMOTE}
    echo "You can watch the logs with this command:"
    echo "   journalctl --user --unit rclone_watch_sync.${RCLONE_REMOTE}"
}

if test $# = 0; then
    rclone_watch_sync
else
    CMD=$1; shift;
    ${CMD} "$@"
fi
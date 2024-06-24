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

rclone_watch_sync
